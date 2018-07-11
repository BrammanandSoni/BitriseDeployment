//
//  DVRListHeaderView.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/16/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVRStoreDetails.h"
#import "DVRUserDetails.h"
#import "DVROnlineUserDetails.h"
#import "DVRAllocationDetails.h"

@class DVRListHeaderView;

@protocol DVRListHeaderViewDelegate <NSObject>

- (void)didTapOnDVRListHeaderView:(DVRListHeaderView *)headerView;

@end

@interface DVRListHeaderView : UIView

@property (nonatomic, weak) id <DVRListHeaderViewDelegate> delegate;

+ (DVRListHeaderView *)loadDVRListHeaderView;

- (void)showActiveImage:(BOOL)show;
- (void)configureViewWithStoreDetails:(DVRStoreDetails *)storeDetails;
- (void)configureViewWithDVRAllocationDetails:(DVRAllocationDetails *)dvrAllocationDetails;
- (void)configureViewWithUserDetails:(DVRUserDetails *)userDetails;
- (void)configureViewWithOnlineUserDetails:(DVROnlineUserDetails *)onlineUserDetails;
@end
