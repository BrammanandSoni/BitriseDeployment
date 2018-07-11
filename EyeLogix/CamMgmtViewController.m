//
//  CamMgmtViewController.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/15/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "CamMgmtViewController.h"
#import "ServiceManger.h"
#import "Utils.h"
#import "DVRCamDetails.h"
#import "DVRCamListTableCell.h"
#import "DVRCamListHeaderView.h"
#import "DVRCategoryListView.h"
#import "CamTitleView.h"

@interface CamMgmtViewController () <UITableViewDataSource, UITableViewDelegate, DVRCategoryListViewDelegate, DVRCamListTableCellDelegate, CamTitleViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSArray <DVRCamDetails *> *> *locationCamListArray;

@property (nonatomic, strong) NSMutableArray <NSArray <DVRCamDetails *> *> *filteredLocationCamArray;

@property (nonatomic, strong) NSArray <NSString *> *locationsNameArray;
@property (nonatomic, strong) NSArray <DVRCamDetails *> *camListArrayToFilter;
@property (nonatomic, assign) BOOL isFilterApplied;

@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation CamMgmtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self doInitialConfiguration];
    [self getCamList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addSearchButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeSearchButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doInitialConfiguration
{
    self.locationCamListArray = [NSMutableArray array];
}

- (void)addSearchButton
{
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    self.searchButton.frame = CGRectMake(self.view.frame.size.width - 35, 27, 30, 30);
    [self.searchButton addTarget:self action:@selector(onClickSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    [[Utils appDelegate].window addSubview:self.searchButton];
}

- (void)removeSearchButton
{
    [self.searchButton removeFromSuperview];
}

- (void)onClickSearch:(UIButton *)sender
{
    DVRCategoryListView *userTypeListView = [DVRCategoryListView loadCategoryListView];
    userTypeListView.listArray = self.locationsNameArray;
    [userTypeListView configureListViewWithHeaderTitle:@"Locations List" andListTitle:@"Select Location"];
    userTypeListView.delegate = self;
    [userTypeListView showOnlyCloseButton];
    userTypeListView.frame = self.view.bounds;
    
    [self.view addSubview:userTypeListView];
}

- (void)getCamList
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    [service getCamListWithCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        [self.locationCamListArray removeAllObjects];
        NSArray *camListDictArray = [Utils getArrayFromDictionary:response];
        
        NSMutableArray *camListArray = [NSMutableArray array];
        for (NSDictionary *camDict in camListDictArray) {
            [camListArray addObject:[[DVRCamDetails alloc] initWithDict:camDict]];
        }
        
        self.camListArrayToFilter = camListArray;
        
        NSMutableArray <NSString *> *locationsArray = [NSMutableArray array];
        for (DVRCamDetails *details in camListArray) {
            if (![locationsArray containsObject:details.location]) {
                [locationsArray addObject:details.location];
            }
        }
        
        self.locationsNameArray = locationsArray;
        
        for (NSString *location in locationsArray) {
            NSArray <DVRCamDetails *> *camsArray = [camListArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DVRCamDetails *camDetails, NSDictionary *bindings) {
                return [camDetails.location isEqualToString:location];
            }]];
            
            [self.locationCamListArray addObject:camsArray];
        }
        
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isFilterApplied ? self.filteredLocationCamArray.count : self.locationCamListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isFilterApplied ? self.filteredLocationCamArray[section].count : self.locationCamListArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DVRCamListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRCamListTableCell"];
    cell.delegate = self;
    DVRCamDetails *camDetails = self.isFilterApplied ? self.filteredLocationCamArray[indexPath.section][indexPath.row] : self.locationCamListArray[indexPath.section][indexPath.row];
    [cell configureCellWithCamDetails:camDetails];
    NSInteger tag = (indexPath.section + 1) * 100 + indexPath.row;
    cell.tag = tag;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DVRCamListHeaderView *headerView = [DVRCamListHeaderView loadCamListHeaderView];
    NSString *title = self.isFilterApplied ? [self.filteredLocationCamArray[section].firstObject location] : [self.locationCamListArray[section].firstObject location];
    [headerView configureHeaderViewWithTitle:title];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - DVRCategoryListViewDelegate

- (void)categoryListView:(DVRCategoryListView *)catListView didSelectCategoryAtIndex:(NSInteger)index
{
    self.isFilterApplied = YES;
    NSString *location = self.locationsNameArray[index];
    self.filteredLocationCamArray = [NSMutableArray array];
    
    NSArray <DVRCamDetails *> *camsArray = [self.camListArrayToFilter filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DVRCamDetails *camDetails, NSDictionary *bindings) {
        return [camDetails.location isEqualToString:location];
    }]];
    
    [self.filteredLocationCamArray addObject:camsArray];
    [self.tableView reloadData];
}

- (void)categoryListViewDidSelectAll:(DVRCategoryListView *)catListView
{
    self.isFilterApplied = NO;
    [self.tableView reloadData];
}

#pragma mark - DVRCamListTableCellDelegate

- (void)camListTableCellDidClickOnTitleView:(DVRCamListTableCell *)cell
{
    NSInteger section = cell.tag / 100;
    NSInteger row = cell.tag % 100;
    DVRCamDetails *camDetails = self.isFilterApplied ? self.filteredLocationCamArray[section-1][row] : self.locationCamListArray[section-1][row];
    
    CamTitleView *titleView = [CamTitleView loadCamTitleView];
    titleView.delegate = self;
    [titleView configureViewWithCamDetails:camDetails];
    UIWindow *wondow = [Utils appDelegate].window;
    titleView.frame = wondow.bounds;
    [wondow addSubview:titleView];
}

#pragma mark - CamTitleViewDelegate

- (void)camTitleViewDidClickOnYesButton:(CamTitleView *)camTitleView withTitle:(NSString *)title andCamDetails:(DVRCamDetails *)camDetails
{
    [camTitleView removeFromSuperview];
    
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service updateCamTitle:title withCamId:camDetails.camId withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            [Utils showToastWithMessage:response[@"Response"]];
            [self getCamList];
        }
    }];
}

@end
