//
//  AlertELVC.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/8/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "AlertELVC.h"
#import "SlideNavigationController.h"
#import "AlertELVCTableCell.h"
#import "FilterItem.h"
#import "ServiceManger.h"
#import "Utils.h"
#import "DateTimeFilterView.h"
#import "PopupListView.h"
#import "DataHandler.h"
#import "EventPlayBackVC.h"
#import "NoResultView.h"
#import "UISearchBar+InputAccessory.h"
#import "AppDelegate.h"
#import "SlideNavigationController.h"

@interface AlertELVC ()<SlideNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, DateTimeFilterViewDelegate, PopupListViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *alertsList;
@property (nonatomic, strong) NSArray *eventsList;
@property (nonatomic, strong) NSArray *storeList;

@property (nonatomic, strong) NSString *storeNCamData;

@property (nonatomic, strong) DateTimeFilterView *dateTimeFiletrView;
@property (nonatomic, strong) PopupListView *popupListView;
@property (nonatomic, strong) NoResultView *emptyView;

@property (nonatomic, strong) FilterItem *currentFilterItem;

@end

@implementation AlertELVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    [self doInitialConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return self.screenType != ASType_Cam;
}

#pragma mark - Public Methods

- (void)setStoreId:(NSString *)storeId andCamId:(NSString *)camId
{
    self.storeNCamData = [NSString stringWithFormat:@"%@,%@", storeId, camId];
}


-(void)openEventPlayWithEventId:(NSString *)eventId
                       andCamId:(NSString *)camId
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EventPlayBackVC *eventPlaybackVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"EventPlayBackVC"];
    [eventPlaybackVC setEventId:eventId andCamId:camId];
    [self.navigationController pushViewController:eventPlaybackVC animated:YES];
}

#pragma mark - Private Methods

- (void)doInitialConfiguration
{
    self.alertsList = [NSMutableArray array];
    
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    FilterItem *filterItem = [[FilterItem alloc] init];
    NSString *dateString = [Utils stringFromDate:[NSDate date] inFormat:@"yyyy-MM-dd"];
    filterItem.startDateTime = [NSString stringWithFormat:@"%@ 00:00:00", dateString];
    filterItem.endDateTime = [NSString stringWithFormat:@"%@ 23:59:59", dateString];
    filterItem.pageNo = 1;
    
    if (self.screenType == ASType_Cam) {
        filterItem.storeNCamId = self.storeNCamData;
    }
    else {
        filterItem.storeId = @"0";
    }
    
    self.currentFilterItem = filterItem;
    
    [self getAlertsWithLoader:YES];
}

- (void)setupNavigationBar
{
    UIView *calenderView = [Utils getCustomButtonWithImage:[UIImage imageNamed:@"Calender"] selector:@selector(calenderPressed:) target:self andSize:CGSizeMake(24, 24)];
    UIBarButtonItem *calenderButton = [[UIBarButtonItem alloc] initWithCustomView:calenderView];
    
    UIView *eventView = [Utils getCustomButtonWithImage:[UIImage imageNamed:@"Filter"] selector:@selector(eventPressed:) target:self andSize:CGSizeMake(21, 21)];
    UIBarButtonItem *eventButton = [[UIBarButtonItem alloc] initWithCustomView:eventView];
    
    if (self.screenType == ASType_Cam) {
        self.title = @"Alert";
        self.navigationItem.rightBarButtonItems = @[calenderButton, eventButton];
        
        UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu_1"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(backbtn:)];
        
        self.navigationItem.leftBarButtonItem = btn;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    else {
        self.title = @"Alerts";
        
        UIView *storeView = [Utils getCustomButtonWithImage:[UIImage imageNamed:@"White_DVR"] selector:@selector(storePressed:) target:self andSize:CGSizeMake(27, 27)];
        UIBarButtonItem *storeButton = [[UIBarButtonItem alloc] initWithCustomView:storeView];
        self.navigationItem.rightBarButtonItems = @[calenderButton, eventButton, storeButton];
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:188.0f/255.0f green:16.0f/255.0f blue:15.0f/255.0f alpha:1]];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
    
    }
}

- (void)calenderPressed:(id)sender
{
    [self.searchBar setText:nil];
    [self.searchBar resignFirstResponder];
    [self openDateTimePickerView];
}

- (void)eventPressed:(id)sender
{
    [self.searchBar setText:nil];
    [self.searchBar resignFirstResponder];
    
    if (self.eventsList.count > 0) {
        [self openPopupListViewWithTitle:@"Select Event" tag:101 actionButtonTitle:@"Yes" andListItem:self.eventsList];
    }
}

- (void)storePressed:(id)sender
{
    [self.searchBar setText:nil];
    [self.searchBar resignFirstResponder];
    
    NSMutableArray *storeListArray = [NSMutableArray array];
    for (NSDictionary *dict in self.storeList) {
        [storeListArray addObject:[dict objectForKey:@"StoreTitle"]];
    }
    
    if (storeListArray.count > 0) {
        [self openPopupListViewWithTitle:@"Select Store" tag:102 actionButtonTitle:@"All" andListItem:storeListArray];
    }
}

- (void)backbtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openDateTimePickerView
{
    if (self.dateTimeFiletrView == nil) {
        self.dateTimeFiletrView = [[NSBundle mainBundle] loadNibNamed:@"DateTimeFilterView" owner:self options:nil].lastObject;
    }
    
    self.dateTimeFiletrView.delegate = self;
    self.dateTimeFiletrView.frame = self.view.frame;
    [self.view addSubview:self.dateTimeFiletrView];
}

- (void)openPopupListViewWithTitle:(NSString *)title tag:(NSInteger)tag actionButtonTitle:(NSString *)actionButtonTitle andListItem:(NSArray *)listItem
{
    if (self.popupListView == nil) {
        self.popupListView = [[NSBundle mainBundle] loadNibNamed:@"PopupListView" owner:self options:nil].lastObject;
    }
    
    self.popupListView.tag = tag;
    self.popupListView.delegate = self;
    self.popupListView.frame = self.view.bounds;
    [self.view addSubview:self.popupListView];
    [self.popupListView setTitle:title actionButtonTitle:actionButtonTitle withListItem:listItem];
}

- (void)loadEmptyAlertView
{
    if (self.emptyView == nil) {
        self.emptyView = [[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil].lastObject;
    }
    
    [self.emptyView setImage:[UIImage imageNamed:@"empty"] andTitle:@"No Alerts Found \n Alerts unavailable for given date"];
    [self.emptyView setFrame:self.view.bounds];
    [self.view addSubview:self.emptyView];
}

- (void)removeEmptyAlertView
{
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
}

#pragma mark - Overridden Methods

- (void)loadNextPageResults
{
    
    self.currentFilterItem.pageNo += 1;
    [self getAlertsWithLoader:NO];
}

#pragma mark - Network Call

- (void)getAlertsWithLoader:(BOOL)showLoader
{
    ServiceManger *service = [ServiceManger sharedInstance];
    
    if (showLoader) {
        [Utils showProgressInView:self.view text:@"Loading..."];
    }
    
    [service getAlertsWithFilterItem:self.currentFilterItem withCompletionBlock:^(NSDictionary *response, NSError *error) {
        
        [Utils hideProgressInView:self.view];
        self.isLoadingNextPageResults = NO;
        
        if (response && error == nil) {
            [self removeEmptyAlertView];
            
            if ([[response objectForKey:@"Status"] isEqualToString:@"OK"]) {
                self.searchBar.hidden = NO;
                
                NSArray *alertsArray = [Utils getArrayFromDictionary:[response objectForKey:@"Response"]];
                
                self.isNextPageResultsAvailable = !(alertsArray.count < kResultPerPage);
                
                [self.alertsList addObjectsFromArray:alertsArray] ;
                self.eventsList = [Utils getArrayFromDictionary:[response objectForKey:@"Titles"]];
                self.storeList = [[DataHandler sharedInstance] camListArray];
                
                [self.tableView reloadData];
            }
            else {
                
                if (showLoader) {
                    self.searchBar.hidden = YES;
                    [self loadEmptyAlertView];
                    
                    if (self == [SlideNavigationController sharedInstance].topViewController){
                        NSString *message = [response valueForKeyPath:@"Response.0.ShowMessage"];
                        [Utils showToastWithMessage:message];
                    }
                    
                }
                else {
                    self.isNextPageResultsAvailable = NO;
                }
            }
        }
        else {
            if (!showLoader) {
                self.currentFilterItem.pageNo -= 1;
            }
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alertsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertELVCTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertELVCTableCell"];
    [cell configureCellWithDetails:self.alertsList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.alertsList[indexPath.row];
    
    [self openEventPlayWithEventId:dict[@"AlertId"] andCamId:dict[@"CamId"]];
}

#pragma mark - DateTimeFilterViewDelegate

- (void)dateTimeFilterView:(DateTimeFilterView *)view didSelectDate:(NSString *)dateString startTime:(NSString *)startTimeString endTime:(NSString *)endTimeString
{
    FilterItem *filterItem = [[FilterItem alloc] init];
    filterItem.startDateTime = [NSString stringWithFormat:@"%@ %@:00", dateString, startTimeString];
    filterItem.endDateTime = [NSString stringWithFormat:@"%@ %@:00", dateString, endTimeString];
    filterItem.storeId = @"0";
    filterItem.pageNo = 1;
    
    self.currentFilterItem = filterItem;
    
    [self.alertsList removeAllObjects];
    [self getAlertsWithLoader:YES];
    
    [self.dateTimeFiletrView removeFromSuperview];
    self.dateTimeFiletrView = nil;
}

- (void)didCancelDateTimeFilterView:(DateTimeFilterView *)view
{
    [self.dateTimeFiletrView removeFromSuperview];
    self.dateTimeFiletrView = nil;
}

#pragma mark - PopupListViewDelegate

- (void)popupListView:(PopupListView *)popupListView didSelectItemAtIndex:(NSInteger)index
{
    FilterItem *filterItem = [[FilterItem alloc] init];
    filterItem.startDateTime = self.currentFilterItem.startDateTime;
    filterItem.endDateTime = self.currentFilterItem.endDateTime;
    filterItem.storeId = @"0";
    filterItem.pageNo = 1;
    
    if (popupListView.tag == 101) {
        NSString *event = self.eventsList[index];
        filterItem.eventType = event;
        
        self.currentFilterItem = filterItem;
        
        [self.alertsList removeAllObjects];
        [self getAlertsWithLoader:YES];
    }
    else if (popupListView.tag == 102) {
        NSDictionary *details = self.storeList[index];
        filterItem.storeId = details[@"StoreId"];
        
        self.currentFilterItem = filterItem;
        
        [self.alertsList removeAllObjects];
        [self getAlertsWithLoader:YES];
    }
    
    [self.popupListView removeFromSuperview];
    self.popupListView = nil;
}

- (void)actionButtonClicked:(PopupListView *)popupListView
{
    if (popupListView.tag == 102) {
        FilterItem *filterItem = [[FilterItem alloc] init];
        filterItem.startDateTime = self.currentFilterItem.startDateTime;
        filterItem.endDateTime = self.currentFilterItem.endDateTime;
        filterItem.storeId = @"0";
        filterItem.pageNo = 1;
        
        self.currentFilterItem = filterItem;
        
        [self.alertsList removeAllObjects];
        [self getAlertsWithLoader:YES];
    }
    
    [self.popupListView removeFromSuperview];
    self.popupListView = nil;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar showAccessoryViewWithButtonTitle:@"Done"];
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    FilterItem *filterItem = [[FilterItem alloc] init];
    filterItem.startDateTime = self.currentFilterItem.startDateTime;
    filterItem.endDateTime = self.currentFilterItem.endDateTime;
    filterItem.eventId = searchBar.text;
    filterItem.storeId = @"0";
    filterItem.pageNo = 1;
    
    self.currentFilterItem = filterItem;
    
    [self.alertsList removeAllObjects];
    [self getAlertsWithLoader:YES];
}

@end
