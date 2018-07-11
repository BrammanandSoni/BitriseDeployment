//
//  EditDVRViewController.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/17/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DVRStoreDetails.h"
#import "AppConstants.h"
#import "DVRUser.h"
#import "DVRAllocationDetails.h"
#import "ChangePasswordDetails.h"
#import "DVRUserDetails.h"

@interface EditDVRViewController : BaseViewController

@property (nonatomic) EditDVRType editType;
@property (nonatomic, copy) DVRStoreDetails *storeDetailsToEdit;

@property (nonatomic, strong) DVRAllocationDetails *dvrAllocationDetails; // Used for edit DVR allocation
@property (nonatomic, strong) DVRUserDetails *userDetails; // Used for Change password

@property (nonatomic, strong) NSArray <DVRUser *> *userListArray;

@end
