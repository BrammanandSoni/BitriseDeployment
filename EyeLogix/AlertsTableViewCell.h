//
//  AlertsTableViewCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewUserDetails.h"

@interface AlertsTableViewCell : UITableViewCell

- (void)configureCellWithNewUserDetails:(NewUserDetails *)userDetails;

@end
