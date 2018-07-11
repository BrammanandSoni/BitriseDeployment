//
//  DVRInputTableCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/17/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVRStoreDetails.h"
#import "DVRAllocationDetails.h"
#import "ChangePasswordDetails.h"

@interface DVRInputTableCell : UITableViewCell

- (void)disableEditing:(BOOL)disable;
- (void)enableSecureEntry:(BOOL)enable;

- (void)configureCellWithStoreDetails:(DVRStoreDetails *)stroreDetails;
- (void)configureCellWithDVRAllocationDetails:(DVRAllocationDetails *)dvrAllocationDetails;
- (void)configureCellWithChangePasswordDetails:(ChangePasswordDetails *)changePasswordDetails;

@end
