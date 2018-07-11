//
//  AddNewUserViewController.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NewUserDetails.h"
#import "AppConstants.h"

@interface AddNewUserViewController : BaseViewController

@property (nonatomic) UserType userType;
@property (nonatomic, strong) NewUserDetails *userDetails;
@property (nonatomic, strong) NSString *operatorId;

@end
