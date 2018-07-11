//
//  DDInputTableCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "NewUserDetails.h"

@class DDInputTableCell;

@protocol DDInputTableCellDelegate <NSObject>

- (void)ddInputTableCellDidClickOnDropDown:(DDInputTableCell *)cell;

@end

@interface DDInputTableCell : UITableViewCell

@property (nonatomic, weak) id <DDInputTableCellDelegate> delegate;

- (void)configureCellWithNewUserDetails:(NewUserDetails *)userDetails;

@end
