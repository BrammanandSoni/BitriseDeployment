//
//  DVRCTATableCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/17/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVRCTATableCell;

@protocol DVRCTATableCellDelegate <NSObject>

- (void)didClickOnCTAButtonInDVRCTATableCell:(DVRCTATableCell *)cell;

@end

@interface DVRCTATableCell : UITableViewCell

@property (nonatomic, weak) id <DVRCTATableCellDelegate> delegate;

- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)color;
- (void)setActionBackgroundColor:(UIColor *)color;
- (void)setBackgroundColor:(UIColor *)color;

@end
