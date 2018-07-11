//
//  DVRListViewController.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/15/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRListViewController.h"
#import "ServiceManger.h"
#import "Utils.h"
#import "DVRStoreDetails.h"
#import "DVRListHeaderView.h"
#import "DVRSubListTableCell.h"
#import "UIColor+CustomColor.h"
#import "DVRUserDetails.h"
#import "DVRListBaseModel.h"
#import "DVROnlineUserDetails.h"
#import "EditDVRViewController.h"
#import "DVRAllocationDetails.h"
#import "DVRUser.h"
#import "AddNewUserViewController.h"
#import "NewUserDetails.h"
#import "DVRCategoryListView.h"
#import "DVRAllocationListSelectionView.h"

@interface DVRListViewController () <UITableViewDataSource, UITableViewDelegate, DVRListHeaderViewDelegate, DVRCategoryListViewDelegate, DVRAllocationListSelectionViewDelegate>
{
    NSMutableSet* _collapsedSections;
    NSInteger numberOfRows;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<DVRStoreDetails *> *dvrStoreListArray;
@property (nonatomic, strong) NSMutableArray<DVRAllocationDetails *> *dvrAllocationListArray;
@property (nonatomic, strong) NSMutableArray<DVRUserDetails *> *dvrUserListArray;
@property (nonatomic, strong) NSMutableArray<DVROnlineUserDetails *> *dvrOnlineUserListArray;

@property (nonatomic, strong) NSArray <DVRUserDetails *> *filteredUserArray;
@property (nonatomic, assign) BOOL isUserFilterApplied;

@property (nonatomic, strong) NSArray <DVRAllocationDetails *> *filteredDvrAllocationArray;
@property (nonatomic, assign) BOOL isDvrAllocationFilterApplied;

@property (nonatomic, strong) NSMutableArray<DVRUser *> *usersArray;
@property (weak, nonatomic) IBOutlet UIView *actionContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *actionImageView;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation DVRListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self doInitialConfiguration];
    [self setupListItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.dvrMgmtType == DVRAllocation || self.dvrMgmtType == User) {
        [self addSearchButton];
    }
    else {
        [self removeSearchButton];
    }
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

#pragma mark - Private Methods

- (void)doInitialConfiguration
{
    _collapsedSections = [NSMutableSet new];
    numberOfRows = 0;
    [Utils addTapGestureToView:self.actionContainerView target:self selector:@selector(onTapActionView:)];
}

- (void)setupListItem
{
    self.errorLabel.hidden = YES;
    self.errorLabel.text = @"";
    self.actionContainerView.hidden = YES;
    switch (self.dvrMgmtType) {
        case DVRMgmt:
            self.dvrStoreListArray = [NSMutableArray array];
            [self getDVRStoreList];
            break;
            
        case DVRAllocation:
            self.dvrAllocationListArray = [NSMutableArray array];
            self.usersArray = [NSMutableArray array];
            [self getDVRAllocationList];
            self.actionContainerView.hidden = NO;
            self.actionImageView.image = [UIImage imageNamed:@"addAllocation"];
            break;
            
        case User:
            self.dvrUserListArray = [NSMutableArray array];
            [self getDVRUserList];
            self.actionContainerView.hidden = NO;
            self.actionImageView.image = [UIImage imageNamed:@"addAllocation"]; // Need to change image name once get it.
            break;
            
        case OnlineUser:
            self.dvrOnlineUserListArray = [NSMutableArray array];
            [self getDVROnlineUserList];
            break;
            
        default:
            break;
    }
}

- (void)onTapActionView:(UITapGestureRecognizer *)recognizer
{
    if (self.dvrMgmtType == DVRAllocation) {
        EditDVRViewController *editDVRVC = (EditDVRViewController *)[Utils getViewControllerWithIdentifier:@"EditDVRViewController"];
        editDVRVC.editType = AllocateDVR;
        editDVRVC.userListArray = self.usersArray;
        [self.navigationController pushViewController:editDVRVC animated:YES];
    }
    else if (self.dvrMgmtType == User) {
        AddNewUserViewController *userVC = (AddNewUserViewController *)[Utils getViewControllerWithIdentifier:@"AddNewUserViewController"];
        userVC.userDetails = [[NewUserDetails alloc] init];
        userVC.userType = UserCreate;
        [self.navigationController pushViewController:userVC animated:YES];
    }
}

-(NSArray*) indexPathsForSection:(NSInteger)section withNumberOfRows:(NSInteger)noOfRows {
    
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (int i = 0; i < noOfRows; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (NSAttributedString *)getActionAttributedStringWithString:(NSString *)string withColor:(UIColor *)color
{
    NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] initWithString:@"Action: "];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color};
    [finalString appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:attrs]];
    
    return finalString;
}

- (void)reloadTabelAndScrollToTop
{
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
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
    if (self.dvrMgmtType == DVRAllocation) {
        // Show a popup for Allocation
        DVRAllocationListSelectionView *listView = [DVRAllocationListSelectionView loadDVRAllocationListSelectionView];
        listView.delegate = self;
        [listView showOnlyCloseButton];
        listView.frame = self.view.bounds;
        listView.listType = UserList;
        listView.userListArray = [self.usersArray sortedArrayUsingComparator:^NSComparisonResult(DVRUser *obj1, DVRUser *obj2) {
            return [obj1.userName localizedCaseInsensitiveCompare:obj2.userName];
        }];
        [listView setHeaderTitle:@"User List" andListTitle:@"Select User"];
        [self.view addSubview:listView];
    }
    else if (self.dvrMgmtType == User) {
        DVRCategoryListView *userTypeListView = [DVRCategoryListView loadCategoryListView];
        userTypeListView.listArray = [Utils getUserTypeList];
        [userTypeListView showOnlyCloseButton];
        [userTypeListView configureImage:@"user"];
        [userTypeListView configureListViewWithHeaderTitle:@"User Type" andListTitle:@"Select User Type"];
        userTypeListView.delegate = self;
        userTypeListView.frame = self.view.bounds;
        
        [self.view addSubview:userTypeListView];
    }
}

#pragma mark - Service calls

- (void)getDVRStoreList
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    [service getDVRStoreListWithCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        [self.dvrStoreListArray removeAllObjects];
        NSArray *dvrListArray = [Utils getArrayFromDictionary:response];
        for (NSDictionary *storeDict in dvrListArray) {
            [self.dvrStoreListArray addObject:[[DVRStoreDetails alloc] initWithDict:storeDict]];
        }
        
        for (int i = 0; i < self.dvrStoreListArray.count; i++) {
            [_collapsedSections addObject:@(i)];
        }
        
        numberOfRows = 4; // Will vary on the basis of dvr list type
        
        [self reloadTabelAndScrollToTop];
    }];
}

- (void)getDVRAllocationList
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    [service getDVRAlocationListWithCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        [self.dvrAllocationListArray removeAllObjects];
        NSArray *dvrListArray = [Utils getArrayFromDictionary:[response valueForKeyPath:@"Response"]];
        for (NSDictionary *storeDict in dvrListArray) {
            [self.dvrAllocationListArray addObject:[[DVRAllocationDetails alloc] initWithDict:storeDict]];
        }
        
        [self.usersArray removeAllObjects];
        NSArray *usersArray = [Utils getArrayFromDictionary:[response valueForKeyPath:@"UserId"]];
        for (NSDictionary *userDict in usersArray) {
            [self.usersArray addObject:[[DVRUser alloc] initWithDict:userDict]];
        }
        
        for (int i = 0; i < self.dvrAllocationListArray.count; i++) {
            [_collapsedSections addObject:@(i)];
        }
        
        numberOfRows = 5; // Will vary on the basis of dvr list type
        
        [self reloadTabelAndScrollToTop];
    }];
}

- (void)getDVRUserList
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    [service getDVRUserListWithCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        [self.dvrUserListArray removeAllObjects];
        NSArray *dvrListArray = [Utils getArrayFromDictionary:response];
        for (NSDictionary *storeDict in dvrListArray) {
            [self.dvrUserListArray addObject:[[DVRUserDetails alloc] initWithDict:storeDict]];
        }
        
        for (int i = 0; i < self.dvrUserListArray.count; i++) {
            [_collapsedSections addObject:@(i)];
        }
        
        numberOfRows = 5; // Will vary on the basis of dvr list type
        self.isUserFilterApplied = NO;
        [self reloadTabelAndScrollToTop];
    }];
}

- (void)getDVROnlineUserList
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    [service getDVROnlineUserListWithCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        [self.dvrOnlineUserListArray removeAllObjects];
        if (error) {
            self.errorLabel.text = error.localizedDescription;
            self.errorLabel.hidden = NO;
            return;
        }
        
        NSArray *dvrListArray = [Utils getArrayFromDictionary:response];
        for (NSDictionary *storeDict in dvrListArray) {
            [self.dvrOnlineUserListArray addObject:[[DVROnlineUserDetails alloc] initWithDict:storeDict]];
        }
        
        for (int i = 0; i < self.dvrOnlineUserListArray.count; i++) {
            [_collapsedSections addObject:@(i)];
        }
        
        numberOfRows = 3; // Will vary on the basis of dvr list type
        
        [self reloadTabelAndScrollToTop];
    }];
}


- (void)deleteDVRWithStoreId:(NSString *)storeId operatorId:(NSString *)operatorId andOperatorUserName:(NSString *)userName
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service deleteDVRWithStoreId:storeId operatorId:operatorId andOperatorUserName:userName withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            [Utils showToastWithMessage:response[@"Response"]];
            [self getDVRAllocationList];
        }
    }];
}

- (void)deleteOperatorWithOperatorId:(NSString *)operatorId andOperatorName:(NSString *)operatorName
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service deleteOperatorWithOperatorId:operatorId andOperatorName:operatorName withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            [Utils showToastWithMessage:response[@"Response"]];
            [self getDVRUserList];
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSection = 0;
    switch (self.dvrMgmtType) {
        case DVRMgmt:
            numberOfSection = self.dvrStoreListArray.count;
            break;
            
        case DVRAllocation:
            numberOfSection = self.isDvrAllocationFilterApplied ? self.filteredDvrAllocationArray.count : self.dvrAllocationListArray.count;
            break;
            
        case User:
            numberOfSection = self.isUserFilterApplied ? self.filteredUserArray.count : self.dvrUserListArray.count;
            break;
            
        case OnlineUser:
            numberOfSection = self.dvrOnlineUserListArray.count;
            break;
            
        default:
            break;
    }
    
    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_collapsedSections containsObject:@(section)] ? 0 : numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DVRSubListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRSubListTableCell"];
    
    switch (self.dvrMgmtType) {
        case DVRMgmt: {
            DVRStoreDetails *storeDetails = self.dvrStoreListArray[indexPath.section];
            switch (indexPath.row) {
                case 0:
                    [cell configureCellWithTitle: [NSString stringWithFormat:@"DVR IP: %@", storeDetails.storeIP] andImage:@"ip"];
                    break;
                    
                case 1:
                    [cell configureCellWithTitle: [NSString stringWithFormat:@"DVR TimeZone: %@", storeDetails.storeTimeZone] andImage:@"timezone"];
                    break;
                    
                case 2:
                    [cell configureCellWithTitle: [NSString stringWithFormat:@"Category: %@", storeDetails.category] andImage:@"category"];
                    break;
                    
                case 3:
                    [cell configureCellWithAttributedTitle:[self getActionAttributedStringWithString:@"Edit DVR" withColor:[UIColor blueColor]] andImage:@"category"];
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
            
        case DVRAllocation: {
            DVRAllocationDetails *dvrAllocationDetails = self.isDvrAllocationFilterApplied ? self.filteredDvrAllocationArray[indexPath.section] : self.dvrAllocationListArray[indexPath.section];
            switch (indexPath.row) {
                case 0:
                    [cell configureCellWithTitle: [NSString stringWithFormat:@"Allocated On: %@", dvrAllocationDetails.userName] andImage:@"user"];
                    break;
                    
                case 1:
                    [cell configureCellWithTitle: [NSString stringWithFormat:@"Name: %@", dvrAllocationDetails.name] andImage:@"user"];
                    break;
                    
                case 2:
                    [cell configureCellWithTitle: [NSString stringWithFormat:@"Allocation Time: %@", dvrAllocationDetails.dateTime] andImage:@"timezone"];
                    break;
                    
                case 3:
                    [cell configureCellWithAttributedTitle:[self getActionAttributedStringWithString:@"Edit DVR" withColor:[UIColor blueColor]] andImage:@"category"];
                    break;
                    
                case 4:
                    [cell configureCellWithAttributedTitle:[self getActionAttributedStringWithString:@"Delete DVR" withColor:[UIColor appRedColor]] andImage:@"deleteblack"];
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case User: {
            
            DVRUserDetails *userDetails = self.isUserFilterApplied ? self.filteredUserArray[indexPath.section] : self.dvrUserListArray[indexPath.section];
            switch (indexPath.row) {
                case 0:
                    [cell configureCellWithTitle: [NSString stringWithFormat:@"User Name: %@", userDetails.userName] andImage:@"user"];
                    break;
                    
                case 1:
                    [cell configureCellWithTitle: [NSString stringWithFormat:@"IP: %@", userDetails.operatorIP] andImage:@"ip"];
                    break;
                    
                case 2:
                    [cell configureCellWithAttributedTitle:[self getActionAttributedStringWithString:@"Edit User" withColor:[UIColor blueColor]] andImage:@"category"];
                    break;
                    
                case 3:
                    [cell configureCellWithAttributedTitle:[self getActionAttributedStringWithString:@"Delete User" withColor:[UIColor appRedColor]] andImage:@"deleteblack"];
                    break;
                    
                case 4:
                    [cell configureCellWithAttributedTitle:[self getActionAttributedStringWithString:@"Change Password" withColor:[UIColor orangeColor]] andImage:@"changepassword"];
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case OnlineUser: {
            DVROnlineUserDetails *onlineUserDetails = self.dvrOnlineUserListArray[indexPath.section];
            switch (indexPath.row) {
                case 0:
                    [cell configureCellWithTitle: [NSString stringWithFormat:@"User Name: %@", onlineUserDetails.userName] andImage:@"Notification"];
                    break;
                    
                case 1:
                    [cell configureCellWithTitle: [NSString stringWithFormat:@"Login Time: %@", onlineUserDetails.loginTime] andImage:@"Notification"];
                    break;
                    
                case 2:
                    [cell configureCellWithTitle: [NSString stringWithFormat:@"Login IP: %@", onlineUserDetails.loginIp] andImage:@"Notification"];
                    break;
                    
                default:
                    break;
            }
        }
            break;            
            
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DVRListHeaderView *headerView = [DVRListHeaderView loadDVRListHeaderView];
    [headerView showActiveImage:NO];
    headerView.tag = section;
    headerView.delegate = self;
    
    switch (self.dvrMgmtType) {
        case DVRMgmt:
            [headerView showActiveImage:YES];
            [headerView configureViewWithStoreDetails:self.dvrStoreListArray[section]];
            break;
            
        case DVRAllocation:
            [headerView configureViewWithDVRAllocationDetails: self.isDvrAllocationFilterApplied ? self.filteredDvrAllocationArray[section] : self.dvrAllocationListArray[section]];
            break;
            
        case User:
            [headerView showActiveImage:YES];
            [headerView configureViewWithUserDetails: self.isUserFilterApplied ? self.filteredUserArray[section] : self.dvrUserListArray[section]];
            break;
            
        case OnlineUser:
            [headerView configureViewWithOnlineUserDetails:self.dvrOnlineUserListArray[section]];
            break;
            
        default:
            break;
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.dvrMgmtType) {
        case DVRMgmt:
            
            if (indexPath.row == 3) { // Edit DVR
                EditDVRViewController *editDVRVC = (EditDVRViewController *)[Utils getViewControllerWithIdentifier:@"EditDVRViewController"];
                editDVRVC.editType = EditDVRMgmt;
                editDVRVC.storeDetailsToEdit = self.dvrStoreListArray[indexPath.section];
                [self.navigationController pushViewController:editDVRVC animated:YES];
            }
            
            break;
            
        case DVRAllocation: {
            if (indexPath.row == 3) { // Edit DVR
                
                EditDVRViewController *editDVRVC = (EditDVRViewController *)[Utils getViewControllerWithIdentifier:@"EditDVRViewController"];
                editDVRVC.editType = EditDVRAllocation;
                editDVRVC.dvrAllocationDetails = self.isDvrAllocationFilterApplied ? self.filteredDvrAllocationArray[indexPath.section] : self.dvrAllocationListArray[indexPath.section];
                [self.navigationController pushViewController:editDVRVC animated:YES];
            }
            else if (indexPath.row == 4) { // Delete DVR
                DVRAllocationDetails *dvrAllocationDetails = self.isDvrAllocationFilterApplied ? self.filteredDvrAllocationArray[indexPath.section] : self.dvrAllocationListArray[indexPath.section];
                [Utils showAlertInController:self withTitle:[NSString stringWithFormat:@"Delete %@", dvrAllocationDetails.storeTitle] message:@"Really want to delete ?" buttonTitles:@[@"No", @"Yes"] withCompletionBlock:^(NSInteger clickedIndex) {
                    if (clickedIndex == 1) {
                        [self deleteDVRWithStoreId:dvrAllocationDetails.storeId operatorId:dvrAllocationDetails.operatorId andOperatorUserName:dvrAllocationDetails.userName];
                    }
                }];
            }
        }
            
            break;
            
        case User: {
            DVRUserDetails *userDetails = self.isUserFilterApplied ? self.filteredUserArray[indexPath.section] : self.dvrUserListArray[indexPath.section];
            if (indexPath.row == 2) { // Edit User
                AddNewUserViewController *userVC = (AddNewUserViewController *)[Utils getViewControllerWithIdentifier:@"AddNewUserViewController"];
                userVC.operatorId = userDetails.operatorId;
                userVC.userType = UserUpdate;
                [self.navigationController pushViewController:userVC animated:YES];
            }
            else if (indexPath.row == 3) { // Delete User
                [Utils showAlertInController:self withTitle:[NSString stringWithFormat:@"Delete %@", userDetails.operatorName] message:@"Really want to delete ?" buttonTitles:@[@"No", @"Yes"] withCompletionBlock:^(NSInteger clickedIndex) {
                    
                    if (clickedIndex == 1) {
                        // Call Delete Operator API
                        [self deleteOperatorWithOperatorId:userDetails.operatorId andOperatorName:userDetails.userName];
                    }
                }];
            }
            else if (indexPath.row == 4) { // Change Password
                EditDVRViewController *editDVRVC = (EditDVRViewController *)[Utils getViewControllerWithIdentifier:@"EditDVRViewController"];
                editDVRVC.editType = ChangePassword;
                editDVRVC.userDetails = userDetails;
                [self.navigationController pushViewController:editDVRVC animated:YES];
            }
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - DVRListHeaderViewDelegate

- (void)didTapOnDVRListHeaderView:(DVRListHeaderView *)headerView
{
    switch (self.dvrMgmtType) {
        case DVRMgmt: {
            DVRStoreDetails *tappedStoreDetails = self.dvrStoreListArray[headerView.tag];
            tappedStoreDetails.isExpanded = !tappedStoreDetails.isExpanded;
        }
            break;
            
        case DVRAllocation: {
            DVRAllocationDetails *dvrAllocationDetails = self.isDvrAllocationFilterApplied ? self.filteredDvrAllocationArray[headerView.tag] : self.dvrAllocationListArray[headerView.tag];
            dvrAllocationDetails.isExpanded = !dvrAllocationDetails.isExpanded;
        }
            break;
            
        case User: {
            DVRUserDetails *userDetails = self.isUserFilterApplied ? self.filteredUserArray[headerView.tag] : self.dvrUserListArray[headerView.tag];
            userDetails.isExpanded = !userDetails.isExpanded;
            
        }
            break;
            
        case OnlineUser: {
            DVROnlineUserDetails *onlineUserDetails = self.dvrOnlineUserListArray[headerView.tag];
            onlineUserDetails.isExpanded = !onlineUserDetails.isExpanded;
        }
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:headerView.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [_tableView beginUpdates];
    NSInteger section = headerView.tag;
    bool shouldCollapse = ![_collapsedSections containsObject:@(section)];
    if (shouldCollapse) {
        int numOfRows = (int)[_tableView numberOfRowsInSection:section];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [_collapsedSections addObject:@(section)];
    }
    else {
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numberOfRows];
        [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [_collapsedSections removeObject:@(section)];
    }
    [_tableView endUpdates];
}

#pragma mark - DVRCategoryListViewDelegate

- (void)categoryListView:(DVRCategoryListView *)catListView didSelectCategoryAtIndex:(NSInteger)index
{
    if (self.dvrMgmtType == User) {
        self.isUserFilterApplied = YES;
        NSString *userType = [Utils getUserTypeList][index];
        self.filteredUserArray = [self.dvrUserListArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DVRUserDetails *userDetailsObj, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [userDetailsObj.operatorType caseInsensitiveCompare:userType] == NSOrderedSame;
        }]];
        
        [self.tableView reloadData];
    }
}

- (void)categoryListViewDidSelectAll:(DVRCategoryListView *)catListView
{
    self.isUserFilterApplied = NO;
    [self.tableView reloadData];
}

#pragma mark - DVRAllocationListSelectionViewDelegate

- (void)listSelectionView:(DVRAllocationListSelectionView *)listSelectionView didSelectUser:(DVRUser *)user
{
    if (self.dvrMgmtType == DVRAllocation) {
        self.isDvrAllocationFilterApplied = YES;
        
        self.filteredDvrAllocationArray = [self.dvrAllocationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DVRAllocationDetails *dvrDetailsObj, NSDictionary<NSString *,id> * _Nullable bindings) {
            return dvrDetailsObj.operatorId == user.operatorId;
        }]];
        
        [self.tableView reloadData];
    }
}

- (void)listSelectionViewDidSelectAll:(DVRAllocationListSelectionView *)listSelectionView
{
    self.isDvrAllocationFilterApplied = NO;
    [self.tableView reloadData];
}

@end
