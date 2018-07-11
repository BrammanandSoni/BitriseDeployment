//
//  DDDDTableCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewUserDetails.h"

@class DDDDTableCell;

@protocol DDDDTableCellDelegate <NSObject>

- (void)ddddTableCellDidClickOnLeftDropDown:(DDDDTableCell *)cell;
- (void)ddddTableCellDidClickOnRightDropDown:(DDDDTableCell *)cell;

@end

@interface DDDDTableCell : UITableViewCell

@property (nonatomic, weak) id <DDDDTableCellDelegate> delegate;

- (void)configureCellWithNewUserDetails:(NewUserDetails *)userDetails;

@end
