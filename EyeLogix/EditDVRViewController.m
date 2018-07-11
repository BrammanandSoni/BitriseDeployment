//
//  EditDVRViewController.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/17/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "EditDVRViewController.h"
#import "DVRInputTableCell.h"
#import "DVRCTATableCell.h"
#import "DVRDropDownTableCell.h"
#import "ServiceManger.h"
#import "Utils.h"
#import "DVRCategoryListView.h"
#import "DVRAllocationListSelectionView.h"
#import "DVRDetails.h"

@interface EditDVRViewController () <UITableViewDataSource, UITableViewDelegate, DVRCTATableCellDelegate, DVRDropDownTableCellDelegate, DVRCategoryListViewDelegate, DVRAllocationListSelectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <DVRDetails *> *dvrListArray;

@property (nonatomic, strong) DVRUser *selectedUser;
@property (nonatomic, strong) DVRDetails *selectedDVR;
@property (nonatomic, strong) ChangePasswordDetails *changePasswordDetails;

@end

@implementation EditDVRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self doInitialConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)doInitialConfiguration
{
    switch (self.editType) {
        case EditDVRMgmt:
            self.title = @"Edit DVR";
            break;
            
        case EditDVRAllocation:
            self.title = @"Edit Allocated DVR";
            // Call service to get DVR list with store id and operator id;
            [self gerDVRListWithOperatorId:self.dvrAllocationDetails.operatorId];
            break;
            
        case AllocateDVR:
            self.title = @"DVR Allocation";
            break;
            
        case ChangePassword:
            self.title = @"Change Password";
            self.changePasswordDetails = [[ChangePasswordDetails alloc] init];
            [self getOperatorPasswordWithOperatorId:self.userDetails.operatorId];
            break;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DVRInputTableCell" bundle:nil] forCellReuseIdentifier:@"DVRInputTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DVRCTATableCell" bundle:nil] forCellReuseIdentifier:@"DVRCTATableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DVRDropDownTableCell" bundle:nil] forCellReuseIdentifier:@"DVRDropDownTableCell"];
}

- (void)updateDVRInfo
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    [service updateDVRDetails:self.storeDetailsToEdit withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            [Utils showToastWithMessage:response[@"Response"]];
        }
    }];
}

- (void)updateAllocatedDVR
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service updateAlocatedDVRWith:self.dvrAllocationDetails andChangedDVRDetails:self.selectedDVR withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            [Utils showToastWithMessage:response[@"Response"]];
        }
    }];
}

- (void)callAllocateDVRService
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    [service allocateDVRWithOperatorId:self.selectedUser.operatorId andStoreId:self.selectedDVR.storeId withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            [Utils showToastWithMessage:response[@"Response"]];
        }
    }];
}

- (void)gerDVRListWithOperatorId:(NSString *)operatorId
{
    [self.dvrListArray removeAllObjects];
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service getDVRListWithOperatorId:operatorId withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        self.dvrListArray = [NSMutableArray array];
        
        NSArray *dvrListArray = [Utils getArrayFromDictionary:response];
        for (NSDictionary *dvrDict in dvrListArray) {
            [self.dvrListArray addObject:[[DVRDetails alloc] initWithDict:dvrDict]];
        }
        
        [self.tableView reloadData];
    }];
}

- (void)getOperatorPasswordWithOperatorId:(NSString *)operatorId
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    [service getOperatorPasswordWithOperatorId:operatorId withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        NSString *oldPassword = [response objectForKey:@"oldPassword"];
        if (oldPassword) {
            self.changePasswordDetails.oldPassword = oldPassword;
        }
        
        [self.tableView reloadData];
    }];
}

- (void)updatePassword
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    [service updatePasswordWithOperatorId:self.userDetails.operatorId userName:self.userDetails.userName currentPassword:self.changePasswordDetails.oldPassword andNewPassword:self.changePasswordDetails.newpassword withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            [Utils showToastWithMessage:response[@"Response"]];
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.editType) {
        case EditDVRMgmt: {
            if (section == 0) {
                return 5;
            }
            
            return 1; // CTA
        }
            
            break;
            
        case EditDVRAllocation: {
            if (section == 0) {
                return 3;
            }
            
            return 1; // CTA
        }
            
            break;
            
        case AllocateDVR: {
            if (section == 0) {
                return 2;
            }
            
            return 1; // CTA
        }
            
            break;
            
        case ChangePassword: {
            if (section == 0) {
                return 2;
            }
            
            return 1; // CTA
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (self.editType) {
        case EditDVRMgmt: {
            if (indexPath.section == 0) {
                if (indexPath.row == 4) {
                    DVRDropDownTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRDropDownTableCell"];
                    [cell configureWithTitle:@"Category" andPlaceHolder:@""];
                    [cell configureCellWithStoreDetails:self.storeDetailsToEdit];
                    cell.delegate = self;
                    return cell;
                }
                
                DVRInputTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRInputTableCell"];
                cell.tag = indexPath.row;
                [cell configureCellWithStoreDetails:self.storeDetailsToEdit];
                [cell disableEditing: indexPath.row == 1 || indexPath.row == 3];
                
                return cell;
            }
            else if (indexPath.section == 1) {
                DVRCTATableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRCTATableCell"];
                cell.delegate = self;
                [cell setTitle:@"Submit"];
                
                return cell;
            }
        }
            
            break;
            
        case EditDVRAllocation: {
            if (indexPath.section == 0) {
                if (indexPath.row == 2) {
                    DVRDropDownTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRDropDownTableCell"];
                    cell.delegate = self;
                    if (self.selectedDVR) {
                        [cell configureCellWithDVRDetails:self.selectedDVR];
                    }
                    else {
                        
                        [cell configureWithTitle:@"Select DVR" andPlaceHolder:@"Select DVR"];
                    }
                    return cell;
                }
                
                DVRInputTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRInputTableCell"];
                cell.tag = indexPath.row;
                [cell configureCellWithDVRAllocationDetails:self.dvrAllocationDetails];
                [cell disableEditing: YES];
                
                return cell;
            }
            else if (indexPath.section == 1) {
                DVRCTATableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRCTATableCell"];
                cell.delegate = self;
                [cell setTitle:@"Update DVR"];
                
                return cell;
            }
        }
            
            break;
            
        case AllocateDVR: {
            if (indexPath.section == 0) {
                DVRDropDownTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRDropDownTableCell"];
                cell.delegate = self;
                
                if (indexPath.row == 0) {
                    if (self.selectedUser) {
                        [cell configureCellWithDVRUser:self.selectedUser];
                    }
                    else {
                        [cell configureWithTitle:@"User ID" andPlaceHolder:@"Select User ID"];
                    }
                }
                else if (indexPath.row == 1) {
                    if (self.selectedDVR) {
                        [cell configureCellWithDVRDetails:self.selectedDVR];
                    }
                    else {
                        [cell configureWithTitle:@"Select DVR" andPlaceHolder:@"Select DVR"];
                    }
                }
                
                return cell;
            }
            else if (indexPath.section == 1) {
                DVRCTATableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRCTATableCell"];
                cell.delegate = self;
                [cell setTitle:@"Allocate DVR"];
                
                return cell;
            }
        }
            break;
            
        case ChangePassword: {
            if (indexPath.section == 0) {
                DVRInputTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRInputTableCell"];
                cell.tag = indexPath.row;
                [cell enableSecureEntry:YES];
                [cell configureCellWithChangePasswordDetails:self.changePasswordDetails];
                return cell;
            }
            else if (indexPath.section == 1) {
                DVRCTATableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRCTATableCell"];
                cell.delegate = self;
                [cell setTitle:@"Update"];
                
                return cell;
            }
        }
            break;
    }
    
    return [[UITableViewCell alloc] init];
}

#pragma mark - DVRCTATableCellDelegate

- (void)didClickOnCTAButtonInDVRCTATableCell:(DVRCTATableCell *)cell
{
    switch (self.editType) {
        case EditDVRMgmt:
            [self updateDVRInfo];
            break;
            
        case EditDVRAllocation:
            [self updateAllocatedDVR];
            break;
            
        case AllocateDVR: {
            if (self.selectedUser == nil) {
                [Utils showToastWithMessage:@"Please select User"];
                return;
            }
            
            if (self.selectedDVR == nil) {
                [Utils showToastWithMessage:@"Please select DVR"];
                return;
            }
            
            [self callAllocateDVRService];
            
        }
            break;
            
        case ChangePassword: {
            // Call Change password API
            
            if (![self.changePasswordDetails.newpassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
                [Utils showToastWithMessage:@"Enter New Password"];
                return;
            }
            
            if (![self.changePasswordDetails.confirmPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
                [Utils showToastWithMessage:@"Enter Confirm Password"];
                return;
            }
            
            if (![self.changePasswordDetails.newpassword isEqualToString:self.changePasswordDetails.confirmPassword]) {
                [Utils showToastWithMessage:@"Password Mismatch"];
                return;
            }
            
            [self updatePassword];
        }
            break;
    }
}

#pragma mark - DVRDropDownTableCellDelegate

- (void)didClickOnDropDownInDropDownTableCell:(DVRDropDownTableCell *)cell
{
    switch (self.editType) {
        case EditDVRMgmt: {
            DVRCategoryListView *catListView = [DVRCategoryListView loadCategoryListView];
            catListView.listArray = [Utils dvrCategoryList];
            catListView.delegate = self;
            catListView.frame = self.view.bounds;
            
            [self.view addSubview:catListView];
        }
            
            break;
            
        case EditDVRAllocation: {
            DVRAllocationListSelectionView *listView = [DVRAllocationListSelectionView loadDVRAllocationListSelectionView];
            listView.delegate = self;
            listView.frame = self.view.bounds;
            listView.listType = DVRList;
            listView.dvrListArray = self.dvrListArray;
            [listView setHeaderTitle:@"Select DVR List" andListTitle:@"Select DVR"];
            [self.view addSubview:listView];
        }
            
            break;
            
        case AllocateDVR: {
            
            DVRAllocationListSelectionView *listView = [DVRAllocationListSelectionView loadDVRAllocationListSelectionView];
            listView.delegate = self;
            listView.frame = self.view.bounds;
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            if (indexPath.row == 0) {
                // User List
                listView.listType = UserList;
                listView.userListArray = self.userListArray;
                [listView setHeaderTitle:@"User List" andListTitle:@"Select User"];
            }
            else if (indexPath.row == 1) {
                // DVR List
                if (self.dvrListArray.count == 0) {
                    return;
                }
                
                listView.listType = DVRList;
                listView.dvrListArray = self.dvrListArray;
                [listView setHeaderTitle:@"Select DVR List" andListTitle:@"Select DVR"];
            }
            
            [self.view addSubview:listView];
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - DVRCategoryListViewDelegate

- (void)categoryListView:(DVRCategoryListView *)catListView didSelectCategoryAtIndex:(NSInteger)index
{
    self.storeDetailsToEdit.categoryId = [NSString stringWithFormat:@"%ld", (long)index];
    self.storeDetailsToEdit.category = [Utils dvrCategoryList][index];
    
    [self.tableView reloadData];
}

- (void)categoryListViewDidSelectAll:(DVRCategoryListView *)catListView
{
    [self categoryListView:catListView didSelectCategoryAtIndex:0];
}

#pragma mark - DVRAllocationListSelectionViewDelegate

- (void)listSelectionView:(DVRAllocationListSelectionView *)listSelectionView didSelectUser:(DVRUser *)user
{
    self.selectedUser = user;
    [self.dvrListArray removeAllObjects];
    self.selectedDVR = nil;
    [self.tableView reloadData];
    
    [self gerDVRListWithOperatorId:self.selectedUser.operatorId];
}

- (void)listSelectionView:(DVRAllocationListSelectionView *)listSelectionView didSelectDVR:(DVRDetails *)dvrDetails
{
    self.selectedDVR = dvrDetails;
    [self.tableView reloadData];
}

@end
