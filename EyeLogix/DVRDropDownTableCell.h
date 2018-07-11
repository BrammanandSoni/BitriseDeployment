//
//  DVRDropDownTableCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/17/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVRStoreDetails.h"
#import "DVRUser.h"
#import "DVRDetails.h"

@class DVRDropDownTableCell;

@protocol DVRDropDownTableCellDelegate <NSObject>

- (void)didClickOnDropDownInDropDownTableCell:(DVRDropDownTableCell *)cell;

@end

@interface DVRDropDownTableCell : UITableViewCell

@property (nonatomic, weak) id <DVRDropDownTableCellDelegate> delegate;

- (void)alignTextFieldInCenter:(BOOL)align;
- (void)configureWithTitle:(NSString *)title andPlaceHolder:(NSString *)placeHolder;
- (void)configureCellWithStoreDetails:(DVRStoreDetails *)storeDetails;
- (void)configureCellWithDVRUser:(DVRUser *)user;
- (void)configureCellWithDVRDetails:(DVRDetails *)dvrDetails;
- (void)configureCellWithUserType:(NSString *)userType;

@end
