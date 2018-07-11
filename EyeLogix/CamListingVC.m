//
//  VideoPlayerVC.m
//  EyeLogix
//
//  Created by Smriti on 4/21/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "CamListingVC.h"
#import "LivePreviewVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppConstants.h"
#import "ServiceManger.h"
#import "LeftEyeLogixVC.h"
#import "SlideNavigationController.h"
#import "MBProgressHUD.h"
#import "LiveFootageVC.h"
#import "Utils.h"
#import "CellHeader.h"
#import "CellCustom.h"
#import "DataHandler.h"

//@interface CellCustom : UITableViewCell
//@property(nonatomic, weak) IBOutlet UILabel *lbTitle;
//@property(nonatomic, weak) IBOutlet UIButton *btCheckBox;
//@end
//
//@implementation CellCustom
//@end
//
//@interface CellHeader : UITableViewCell
//@property(nonatomic, weak) IBOutlet UIButton *btBackground;
//@property(nonatomic, weak) IBOutlet UILabel *lbTitle;
//@property(nonatomic, weak) IBOutlet UILabel *lbSubTitle;
//@property(nonatomic, weak) IBOutlet UIButton *btCheckBox;
//@end
//
//@implementation CellHeader
//@end


@interface CamListingVC ()<SlideNavigationControllerDelegate, UISearchBarDelegate>
{
    
    //NSMutableArray *_remoteMovies;
    //NSMutableArray *arraySelectedIndex;
    //NSMutableArray *arraySelectedSection;
    //NSMutableArray *arraySelectedVideos;
    
    //NSString *_current_path;
    //int count_local_files;
    int selectedCamsCount;
    LivePreviewVC *vc;
    //NSString *_last_entered_url;
    
    NSMutableSet* _collapsedSections;
    
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIButton *btSelected;
}

@property(nonatomic, strong) NSArray *storeList;
@property(nonatomic, strong) NSArray *filteredList;

@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, assign) BOOL isFilterApplied;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarHeightConstraint;

@end


@implementation CamListingVC


//- (BOOL)prefersStatusBarHidden { return YES; }

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:188.0f/255.0f green:16.0f/255.0f blue:15.0f/255.0f alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.title = @"Location";
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag: 0];
    
    //_last_entered_url = nil;
    //count_local_files = 0;
    //countPlayers = 1;
    
    //_remoteMovies = [NSMutableArray array];
    [self callService];
    
    _collapsedSections = [NSMutableSet new];
//    arraySelectedIndex = [[NSMutableArray alloc] init];
//    arraySelectedVideos = [[NSMutableArray alloc] init];
//    arraySelectedSection = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBarHidden = NO;
    
     self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:self.refreshControl];
    
    self.searchBar.layer.borderWidth = 1.0;
    self.searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.searchBar.clipsToBounds = YES;
    self.searchBar.layer.cornerRadius = self.searchBar.frame.size.height / 2;
    
}

- (void)handleRefresh:(UIRefreshControl*)refreshControl
{
    [self callService];
}

- (void)addSearchButton
{
    if (!self.searchButton) {
        self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        self.searchButton.frame = CGRectMake(self.view.frame.size.width - 35, 27, 30, 30);
        [self.searchButton addTarget:self action:@selector(onClickSearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [[Utils appDelegate].window addSubview:self.searchButton];
}

- (void)removeSearchButton
{
    [self.searchButton removeFromSuperview];
    self.searchButton = nil;
}

- (void)onClickSearch:(UIButton *)sender
{
    self.searchBarHeightConstraint.constant = 60;
    [self.view layoutIfNeeded];
}

-(void) callService {
    
    ServiceManger *service = [ServiceManger sharedInstance];
    
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dictPara = [[NSMutableDictionary alloc] init];
    [dictPara setObject:[userPref valueForKey:@"UserName"] forKey:@"UserName"];
    [dictPara setObject:[userPref valueForKey:@"ProfileId"] forKey:@"ProfileId"];
    [dictPara setObject:[userPref valueForKey:@"Token"] forKey:@"Token"];
    if (![self.refreshControl isRefreshing]) {
        [Utils showProgressInView:self.view text:@"Loading..."];
    }
    
    [service GetVideoLinks:dictPara withCallback:^(NSArray *arrayResponse) {
        [Utils hideProgressInView:self.view];
        [self.refreshControl endRefreshing];
        
        if (arrayResponse) {
            [DataHandler sharedInstance].reloadCamList = NO;
            [DataHandler sharedInstance].camListArray = arrayResponse;
            
            NSMutableArray *storeArray = [NSMutableArray array];
            for (NSDictionary *storeDict in arrayResponse) {
                NSMutableDictionary *storeUpdateDict = [NSMutableDictionary dictionaryWithDictionary:storeDict];
                
                NSMutableArray *camDetailsArray = [NSMutableArray array];
                for (NSDictionary *camDetails in storeUpdateDict[@"Cams"]) {
                    NSMutableDictionary *camUpdateDict = [NSMutableDictionary dictionaryWithDictionary:camDetails];
                    camUpdateDict[@"selected"] = @(NO);
                    camUpdateDict[@"StoreId"] = storeUpdateDict[@"StoreId"];
                    [camDetailsArray addObject:camUpdateDict];
                }
                
                storeUpdateDict[@"Cams"] = camDetailsArray;
                [storeArray addObject:storeUpdateDict];
            }
            
            self.storeList = storeArray;
            
            //_remoteMovies = [arrayResponse mutableCopy];
            for (int i = 0; i < self.storeList.count; i++) {
                [_collapsedSections addObject:@(i)];
            }
            
            [_tableView reloadData];
        }
        else {
            [DataHandler sharedInstance].reloadCamList = YES;
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([DataHandler sharedInstance].reloadCamList) {
        [self callService];
    }
    
    [self addSearchButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeSearchButton];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isFilterApplied ? self.filteredList.count : self.storeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [NSArray arrayWithArray:[[self.isFilterApplied ? self.filteredList : self.storeList objectAtIndex:section] valueForKey:@"Cams"]];
    return [_collapsedSections containsObject:@(section)] ? 0 : array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section   {
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *cellIdentifier = @"CellHeader";
    CellHeader *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CellHeader alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellIdentifier];
    }
    
    [cell.btBackground addTarget:self action:@selector(tapCollaps:) forControlEvents:UIControlEventTouchUpInside];
    NSString  *strTitle = [[self.isFilterApplied ? self.filteredList : self.storeList objectAtIndex:section] valueForKey:@"StoreTitle"];
    cell.lbTitle.text = strTitle;
    cell.lbSubTitle.text = @"9510 BEECHNUT ST SUTE G Houston";
    cell.btBackground.tag = section;
    
    [cell.btCheckBox addTarget:self action:@selector(selectAllSection:) forControlEvents:UIControlEventTouchUpInside];
    cell.btCheckBox.tag = section;
    
    NSArray *array = [NSArray arrayWithArray:[[self.isFilterApplied ? self.filteredList : self.storeList objectAtIndex:section] valueForKey:@"Cams"]];
    
    BOOL showCross = YES;
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"IsConnected"] boolValue]) {
            showCross = NO;
            break;
        }
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:cell.crossLabel.text];
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(0.5) range:NSMakeRange(0, [cell.crossLabel.text length])];
    cell.crossLabel.attributedText = attributedString;
    
    cell.crossLabel.hidden = !showCross;
    
    BOOL selectButton = NO;
    for (NSDictionary *camsDict in array) {
        if ([camsDict[@"selected"] boolValue]) {
            selectButton = YES;
            break;
        }
    }
    
    cell.btCheckBox.selected = selectButton;
    
    //[arraySelectedIndex addObject:@(intTag)];
    return cell.contentView;
}

-(NSArray*) indexPathsForSection:(int)section withNumberOfRows:(int)numberOfRows {
    
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (int i = 0; i < numberOfRows; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellCustom";
    CellCustom *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CellCustom alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellIdentifier];
    }
    
    //NSString *path;
    NSArray *array = [NSArray arrayWithArray:[[self.isFilterApplied ? self.filteredList : self.storeList objectAtIndex:indexPath.section] valueForKey:@"Cams"]];
    
    NSString *camTitle = [array[indexPath.row] valueForKey:@"CamTitle"];
    cell.lbTitle.text = camTitle;
    
    int intTag = (int)(indexPath.section + 1) * 100 + (int)indexPath.row;
    
    cell.btCheckBox.tag = intTag;
    [cell.btCheckBox addTarget:self action:@selector(checkBoxSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btCheckBox.selected = [[array[indexPath.row] valueForKey:@"selected"] boolValue];
    
    //cell.btCheckBox.tag = intTag;
    
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     if (indexPath.row >= _remoteMovies.count) return;
     NSArray *array = [NSArray arrayWithArray:[[_remoteMovies objectAtIndex:indexPath.section] valueForKey:@"Cams"]];
     
     _current_path = [array[indexPath.row] valueForKey:@"IP_Url"];
     
     
     countPlayers = 1;
     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
     MoviePlayerVC *moviewvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MoviePlayerVC"];
     
     [moviewvc movieViewControllerWithContentPath:_current_path hw:1 countInstances:countPlayers];
     
     //    [self presentViewController:moviewvc animated:YES completion:nil];
     LoggerStream(1, @"Stream opened: %d", 1);
     
     [self presentViewController:moviewvc animated:YES completion:nil];
     
     
     
     //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Select the number of players"
     //                                                   message: nil
     //                                                  delegate: self
     //                                         cancelButtonTitle:@"Select"
     //                                         otherButtonTitles: nil];
     //
     //    //    [alert addButtonWithTitle:[NSString stringWithFormat:@"1"]];
     //    //    [alert addButtonWithTitle:[NSString stringWithFormat:@"2"]];
     //    //    [alert addButtonWithTitle:[NSString stringWithFormat:@"3"]];
     //    //    [alert addButtonWithTitle:[NSString stringWithFormat:@"4"]];
     //    //    [alert addButtonWithTitle:[NSString stringWithFormat:@"5"]];
     //    //    [alert addButtonWithTitle:[NSString stringWithFormat:@"6"]];
     //    //    [alert addButtonWithTitle:[NSString stringWithFormat:@"7"]];
     //    //    [alert addButtonWithTitle:[NSString stringWithFormat:@"8"]];
     //
     //    alert.alertViewStyle = UIAlertViewStyleDefault;
     //
     //    //countryCodePickedView
     //    UIPickerView *countryCodePickedView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
     //    [countryCodePickedView setDataSource: self];
     //    [countryCodePickedView setDelegate: self];
     //    countryCodePickedView.showsSelectionIndicator = YES;
     //
     //    [alert setValue:countryCodePickedView forKey:@"accessoryView"];
     //    alert.tag = 111;
     //    [alert show];
     
     LoggerApp(1, @"Playing a movie: %@", _current_path);
     */
}


-(void)tapCollaps:(UIButton*)sender {
    
    [_tableView beginUpdates];
    UIButton *btTemp = (UIButton *)sender;
    int section = (int)btTemp.tag;
    bool shouldCollapse = ![_collapsedSections containsObject:@(section)];
    if (shouldCollapse) {
        btTemp.selected = YES;
        int numOfRows = (int)[_tableView numberOfRowsInSection:section];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [_collapsedSections addObject:@(section)];
    }
    else {
        btTemp.selected = NO;
        NSArray *array = [NSArray arrayWithArray:[[self.isFilterApplied ? self.filteredList : self.storeList objectAtIndex:section] valueForKey:@"Cams"]];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:(int)array.count];
        [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [_collapsedSections removeObject:@(section)];
    }
    [_tableView endUpdates];
}

- (IBAction)selectAllSection:(id)sender{
    
    UIButton *btTemp = (UIButton *)sender;
    int intSection = (int)btTemp.tag;
    
    NSArray *array = [NSArray arrayWithArray:[[self.isFilterApplied ? self.filteredList : self.storeList objectAtIndex:intSection] valueForKey:@"Cams"]];
    
    if (btTemp.selected == NO) {
        for (NSMutableDictionary *camsDict in array) {
            camsDict[@"selected"] = @(YES);
        }
        btTemp.selected = YES;
    }
    else {
        for (NSMutableDictionary *camsDict in array) {
            camsDict[@"selected"] = @(NO);
        }
        btTemp.selected = NO;
    }
    
    
    
//    if (btTemp.selected == NO) {
//        
//        for (int i = 0; i < array.count; i++) {
//            int intTag = (intSection + 1) * 100 + i;
//            NSString *path = [array[i] valueForKey:@"IP_Url"];
//            [arraySelectedVideos addObject:path];
//            [arraySelectedIndex addObject:@(intTag)];
//        }
//        btTemp.selected = YES;
//        [arraySelectedSection addObject:@(intSection)];
//    }
//    else    {
//        for (int i = 0; i < array.count; i++) {
//            int intTag = (intSection + 1) * 100 + i;
//            NSString *path = [array[i] valueForKey:@"IP_Url"];
//            [arraySelectedVideos removeObjectIdenticalTo:path];
//            [arraySelectedIndex removeObjectIdenticalTo:@(intTag)];
//        }
//        btTemp.selected = NO;
//        [arraySelectedSection removeObjectIdenticalTo:@(intSection)];
//        
//    }
//    
    [self updatedSelectedButtonTitle];
    
    [_tableView reloadData];
}

-(void)checkBoxSelected:(UIButton *) checkButton {
    
    int intRow = (int)checkButton.tag % 100;
    int intSection = (int)checkButton.tag / 100;
    
    NSArray *array = [NSArray arrayWithArray:[[self.isFilterApplied ? self.filteredList : self.storeList objectAtIndex:intSection - 1] valueForKey:@"Cams"]];
    NSMutableDictionary *dict = array[intRow];
    
    if (checkButton.selected == NO) {
        dict[@"selected"] = @(YES);
        //[_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:intRow inSection:intSection - 1]] withRowAnimation:UITableViewRowAnimationNone];
        
    }else{
        dict[@"selected"] = @(NO);
        
        //[_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:intRow inSection:intSection - 1]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [_tableView reloadData];
    [self updatedSelectedButtonTitle];
    
}

-(void)updatedSelectedButtonTitle {
    
    int count = 0;
    for (NSDictionary *dict in self.isFilterApplied ? self.filteredList : self.storeList) {
        
        for (NSDictionary *camDetails in dict[@"Cams"]) {
            if ([camDetails[@"selected"] boolValue]) {
                count++;
            }
        }
    }
    
    selectedCamsCount = count;
    
    if (selectedCamsCount == 0) {
        btSelected.hidden = YES;
    }
    else    {
        btSelected.hidden = NO;
        [btSelected setTitle:[NSString stringWithFormat:@"%d Cam Selected", count] forState:UIControlStateNormal];
    }
}

- (IBAction)PlayVideos:(id)sender {
    
    //countPlayers = (int)arraySelectedVideos.count;
    
    if (selectedCamsCount == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert!"
                                      message:@"Please select at least 1 video!"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        [alert addAction:ok];
        
    }
    
    else    {
        
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        LiveFootageVC *moviewvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LiveFootageVC"];
        moviewvc.screenType = ScreenTypeLocation;
        
        NSMutableArray *selectedCamsArray = [NSMutableArray array];
        
        for (NSDictionary *dict in self.isFilterApplied ? self.filteredList : self.storeList) {
            
            for (NSDictionary *camDetails in dict[@"Cams"]) {
                if ([camDetails[@"selected"] boolValue]) {
                    NSMutableDictionary *mutableCamDetails = [NSMutableDictionary dictionaryWithDictionary:camDetails];
                    
                    [mutableCamDetails setObject:[dict objectForKey:@"StoreTitle"] forKey:@"StoreTitle"];
                    
                    [selectedCamsArray addObject:mutableCamDetails];
                }
            }
        }
        
        [moviewvc showSelectedCamsArray:selectedCamsArray];
        [self.navigationController pushViewController:moviewvc animated:YES];
        
        /*
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        LivePreviewVC *moviewvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LivePreviewVC"];
        
        NSMutableArray *selectedCamsArray = [NSMutableArray array];
        
        for (NSDictionary *dict in self.storeList) {
            
            for (NSDictionary *camDetails in dict[@"Cams"]) {
                if ([camDetails[@"selected"] boolValue]) {
                    [selectedCamsArray addObject:camDetails];
                }
            }
        }
        
        [moviewvc showSelectedCamsArray:selectedCamsArray];
        [self.navigationController pushViewController:moviewvc animated:YES];
         */
    }
    
}

#pragma mark - SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

//#pragma mark - IBActions -
//
//- (IBAction)bounceMenu:(id)sender
//{
//    static Menu menu = MenuLeft;
//    
//    [[SlideNavigationController sharedInstance] bounceMenu:menu withCompletion:nil];
//    
//    menu = (menu == MenuLeft) ? MenuRight : MenuLeft;
//}
//
//- (IBAction)slideOutAnimationSwitchChanged:(UISwitch *)sender
//{
//    ((LeftEyeLogixVC *)[SlideNavigationController sharedInstance].leftMenu).slideOutAnimationEnabled = sender.isOn;
//}
//
//- (IBAction)limitPanGestureSwitchChanged:(UISwitch *)sender
//{
//    [SlideNavigationController sharedInstance].panGestureSideOffset = (sender.isOn) ? 50 : 0;
//}
//
//- (IBAction)changeAnimationSelected:(id)sender
//{
//    [[SlideNavigationController sharedInstance] openMenu:MenuRight withCompletion:nil];
//}
//
//- (IBAction)shadowSwitchSelected:(UISwitch *)sender
//{
//    [SlideNavigationController sharedInstance].enableShadow = sender.isOn;
//}
//
//- (IBAction)enablePanGestureSelected:(UISwitch *)sender
//{
//    [SlideNavigationController sharedInstance].enableSwipeGesture = sender.isOn;
//}
//
//- (IBAction)portraitSlideOffsetChanged:(UISegmentedControl *)sender
//{
//    [SlideNavigationController sharedInstance].portraitSlideOffset = [self pixelsFromIndex:sender.selectedSegmentIndex];
//}
//
//- (IBAction)landscapeSlideOffsetChanged:(UISegmentedControl *)sender
//{
//    [SlideNavigationController sharedInstance].landscapeSlideOffset = [self pixelsFromIndex:sender.selectedSegmentIndex];
//}

//#pragma mark - Helpers -
//
//- (NSInteger)indexFromPixels:(NSInteger)pixels
//{
//    if (pixels == 60)
//        return 0;
//    else if (pixels == 120)
//        return 1;
//    else
//        return 2;
//}
//
//- (NSInteger)pixelsFromIndex:(NSInteger)index
//{
//    switch (index)
//    {
//        case 0:
//            return 60;
//            
//        case 1:
//            return 120;
//            
//        case 2:
//            return 200;
//            
//        default:
//            return 0;
//    }
//}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.isFilterApplied = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0;
    self.filteredList = [self.storeList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary *storeDetails, NSDictionary *bindings) {
        return [[[storeDetails objectForKey:@"StoreTitle"] lowercaseString] containsString:[searchText lowercaseString]];
    }]];

    [_tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBarHeightConstraint.constant = 0;
    [self.view layoutIfNeeded];
    [self.view endEditing:YES];
    
    self.isFilterApplied = NO;
    [_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

@end
