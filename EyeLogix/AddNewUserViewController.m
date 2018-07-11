//
//  AddNewUserViewController.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "AddNewUserViewController.h"
#import "TwoInputTableCell.h"
#import "DDInputTableCell.h"
#import "DDDDTableCell.h"
#import "AlertsTableViewCell.h"
#import "DVRDropDownTableCell.h"
#import "DVRCTATableCell.h"
#import "NewUserDetails.h"
#import "DVRCategoryListView.h"
#import "Utils.h"
#import "ServiceManger.h"

@interface AddNewUserViewController () <UITableViewDataSource, UITableViewDelegate, DVRCTATableCellDelegate, DVRCategoryListViewDelegate, DVRDropDownTableCellDelegate, DDInputTableCellDelegate, DDDDTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *rowsArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableBottomSpace;

@end

@implementation AddNewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self doInitialConfiguration];
    [self setupTableRows];
    [self addKeyBoardObservers];
    
    if (self.userType == UserUpdate) {
        [self getUserInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)doInitialConfiguration
{
    if (self.userType == UserUpdate) {
        self.title = @"Edit User";
    }
    else if (self.userType == UserCreate) {
        self.title = @"Add New User";
    }
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:@"DVRDropDownTableCell" bundle:nil] forCellReuseIdentifier:@"DVRDropDownTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DVRCTATableCell" bundle:nil] forCellReuseIdentifier:@"DVRCTATableCell"];
}

- (void)setupTableRows
{
    self.rowsArray = [NSMutableArray array];
    if (self.userType == UserCreate) {
        [self.rowsArray addObject:@(ANUUserType)];
    }
    
    [self.rowsArray addObject:@(ANUUserNameAndName)];
    [self.rowsArray addObject:@(ANUPassAndContact)];
    [self.rowsArray addObject:@(ANUEmailAndAddress)];
    [self.rowsArray addObject:@(ANUCountryAndState)];
    [self.rowsArray addObject:@(ANUCityAndPinCode)];
    [self.rowsArray addObject:@(ANUTimeZoneAndAccessType)];
    [self.rowsArray addObject:@(ANUAlerts)];
    [self.rowsArray addObject:@(ANUCTA)];
    
    [self.tableView reloadData];
}

- (void)addKeyBoardObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect bounds =  [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.constraintTableBottomSpace.constant = bounds.size.height;
}

- (void)keyBoardWillHide
{
    [self.view endEditing:YES];
    self.constraintTableBottomSpace.constant = 0.0f;
}

#pragma mark - Network Calls

- (void)getUserInfo
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service getoperatorInfoWithOperatorId:self.operatorId withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        
        if (response) {
            self.userDetails = [[NewUserDetails alloc] initWithDict:response];
        }
        
        [self.tableView reloadData];
    }];
}

- (void)createUser
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service createUserWithNewUserDetails:self.userDetails withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            [Utils showToastWithMessage:response[@"Response"]];
        }
    }];
}

- (void)updateUser
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service updateUserWithNewUserDetails:self.userDetails withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            [Utils showToastWithMessage:response[@"Response"]];
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddNewUserRowType rowType = [self.rowsArray[indexPath.row] integerValue];
    switch (rowType) {
        case ANUUserType: {
            DVRDropDownTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRDropDownTableCell"];
            [cell alignTextFieldInCenter:YES];
            cell.delegate = self;
            [cell configureWithTitle:@"" andPlaceHolder:@"Select User Type"];
            [cell configureCellWithUserType:self.userDetails.operatorType];
            
            return cell;
        }
            break;
            
        case ANUUserNameAndName:
        case ANUPassAndContact:
        case ANUEmailAndAddress:
        case ANUCityAndPinCode: {
            TwoInputTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwoInputTableCell"];
            cell.rowType = rowType;
            cell.userType = self.userType;
            [cell configureCellWithNewUserDetails:self.userDetails];
            
            return cell;
        }
            break;
            
        case ANUCountryAndState: {
            DDInputTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDInputTableCell"];
            cell.delegate = self;
            [cell configureCellWithNewUserDetails:self.userDetails];
            return cell;
        }
            break;
            
        case ANUTimeZoneAndAccessType: {
            DDDDTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDDDTableCell"];
            cell.delegate = self;
            [cell configureCellWithNewUserDetails:self.userDetails];
            return cell;
        }
            break;
            
        case ANUAlerts: {
            AlertsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertsTableViewCell"];
            [cell configureCellWithNewUserDetails:self.userDetails];
            return cell;
        }
            break;
            
        case ANUCTA: {
            DVRCTATableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRCTATableCell"];
            cell.delegate = self;
            [cell setTitle:@"OK"];
            [cell setTitleColor:[UIColor blackColor]];
            [cell setActionBackgroundColor:[UIColor colorWithRed:214.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1]];
            
            return cell;
        }
            break;
            
            
        default:
            break;
    }
    
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - DVRCTATableCellDelegate

- (void)didClickOnCTAButtonInDVRCTATableCell:(DVRCTATableCell *)cell
{
    if (![self.userDetails.operatorType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Select User Type"];
        return;
    }
    
    if (![self.userDetails.userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Select User Name"];
        return;
    }
    
    if (![self.userDetails.operatorName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Select Name"];
        return;
    }
    
    if (self.userType != UserUpdate) {
        if (![self.userDetails.password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
            [Utils showToastWithMessage:@"Enter Password"];
            return;
        }
    }
    
    if (![self.userDetails.mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Enter Mobile"];
        return;
    }
    
    if (![self.userDetails.email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Enter Email ID"];
        return;
    }
    
    if (![self.userDetails.address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Enter Address"];
        return;
    }
    
    if (![self.userDetails.country stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Select Country"];
        return;
    }
    
    if (![self.userDetails.state stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Enter State"];
        return;
    }
    
    if (![self.userDetails.city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Enter City"];
        return;
    }
    
    if (![self.userDetails.pincode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Enter Pin Code"];
        return;
    }
    
    if (![self.userDetails.timeZone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Select Time Zone"];
        return;
    }
    
    if (![self.userDetails.access stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Select Access Type"];
        return;
    }
    
    if (![self.userDetails.access stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [Utils showToastWithMessage:@"Select Access Type"];
        return;
    }
    
    if (self.userType == UserCreate) {
        [self createUser];
    }
    else if (self.userType == UserUpdate) {
        [self updateUser];
    }
}

#pragma mark - DVRCategoryListViewDelegate

- (void)categoryListView:(DVRCategoryListView *)catListView didSelectCategoryAtIndex:(NSInteger)index
{
    // Check for view tag to identify
    if (catListView.tag == 0) { // User Type
        NSString *userType = [Utils getUserTypeList][index];
        self.userDetails.operatorType = userType;
    }
    else if (catListView.tag == 1) { // Country List
        NSString *country = [Utils getCountryList][index];
        self.userDetails.country = country;
    }
    else if (catListView.tag == 2) { // Time Zone
        NSString *timeZone = [Utils getTimeZoneList][index];
        self.userDetails.timeZone = timeZone;
    }
    else if (catListView.tag == 3) { // Access Type
        NSString *accessType = [Utils getAccessTypeList][index];
        self.userDetails.access = accessType;
    }
    
    [self.tableView reloadData];
}

- (void)categoryListViewDidSelectAll:(DVRCategoryListView *)catListView
{
    [self categoryListView:catListView didSelectCategoryAtIndex:0];
}

#pragma mark - DVRDropDownTableCellDelegate

- (void)didClickOnDropDownInDropDownTableCell:(DVRDropDownTableCell *)cell
{
    DVRCategoryListView *userTypeListView = [DVRCategoryListView loadCategoryListView];
    [userTypeListView showOnlyCloseButton];
    userTypeListView.tag = 0;
    userTypeListView.listArray = [Utils getUserTypeList];
    [userTypeListView configureListViewWithHeaderTitle:@"User Type" andListTitle:@"Select User Type"];
    userTypeListView.delegate = self;
    userTypeListView.frame = self.view.bounds;
    
    [self.view addSubview:userTypeListView];
}

#pragma mark - DDInputTableCellDelegate

- (void)ddInputTableCellDidClickOnDropDown:(DDInputTableCell *)cell
{
    DVRCategoryListView *countryListView = [DVRCategoryListView loadCategoryListView];
    [countryListView showOnlyCloseButton];
    countryListView.tag = 1;
    countryListView.listArray = [Utils getCountryList];
    [countryListView configureListViewWithHeaderTitle:@"Country List" andListTitle:@"Select Country"];
    countryListView.delegate = self;
    countryListView.frame = self.view.bounds;
    
    [self.view addSubview:countryListView];
}

#pragma mark - DDDDTableCellDelegate

- (void)ddddTableCellDidClickOnLeftDropDown:(DDDDTableCell *)cell
{
    DVRCategoryListView *timeZoneListView = [DVRCategoryListView loadCategoryListView];
    [timeZoneListView showOnlyCloseButton];
    timeZoneListView.tag = 2;
    timeZoneListView.listArray = [Utils getTimeZoneList];
    [timeZoneListView configureListViewWithHeaderTitle:@"Time Zones" andListTitle:@"Select Time Zone"];
    timeZoneListView.delegate = self;
    timeZoneListView.frame = self.view.bounds;
    
    [self.view addSubview:timeZoneListView];
}

- (void)ddddTableCellDidClickOnRightDropDown:(DDDDTableCell *)cell
{
    DVRCategoryListView *accessTypeListView = [DVRCategoryListView loadCategoryListView];
    [accessTypeListView showOnlyCloseButton];
    accessTypeListView.tag = 3;
    accessTypeListView.listArray = [Utils getAccessTypeList];
    [accessTypeListView configureListViewWithHeaderTitle:@"Access Type" andListTitle:@"Select Access Type"];
    accessTypeListView.delegate = self;
    accessTypeListView.frame = self.view.bounds;
    
    [self.view addSubview:accessTypeListView];
}

@end