//
//  DVRCamListTableCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/22/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVRCamDetails.h"

@class DVRCamListTableCell;

@protocol DVRCamListTableCellDelegate <NSObject>

- (void)camListTableCellDidClickOnTitleView:(DVRCamListTableCell *)cell;

@end

@interface DVRCamListTableCell : UITableViewCell

@property (nonatomic, weak) id <DVRCamListTableCellDelegate> delegate;

- (void)configureCellWithCamDetails:(DVRCamDetails *)camDetails;

@end
