//
//  TwoInputTableCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewUserDetails.h"
#import "AppConstants.h"

@interface TwoInputTableCell : UITableViewCell

@property (nonatomic) AddNewUserRowType rowType;
@property (nonatomic) UserType userType;

- (void)configureCellWithNewUserDetails:(NewUserDetails *)userDetails;

@end
