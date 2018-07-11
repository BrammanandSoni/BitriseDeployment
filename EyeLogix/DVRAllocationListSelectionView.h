//
//  DVRAllocationListSelectionView.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/19/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVRUser.h"
#import "DVRDetails.h"

typedef enum : NSUInteger {
    UserList,
    DVRList,
} DVRAllocationListType;

@class DVRAllocationListSelectionView;

@protocol DVRAllocationListSelectionViewDelegate <NSObject>

- (void)listSelectionView:(DVRAllocationListSelectionView *)listSelectionView didSelectUser:(DVRUser *)user;
- (void)listSelectionView:(DVRAllocationListSelectionView *)listSelectionView didSelectDVR:(DVRDetails *)dvrDetails;
- (void)listSelectionViewDidSelectAll:(DVRAllocationListSelectionView *)listSelectionView;

@end

@interface DVRAllocationListSelectionView : UIView

@property (nonatomic, weak) id <DVRAllocationListSelectionViewDelegate> delegate;

@property (nonatomic) DVRAllocationListType listType;

@property (nonatomic, strong) NSArray <DVRUser *> *userListArray;
@property (nonatomic, strong) NSArray <DVRDetails *> *dvrListArray;

+ (DVRAllocationListSelectionView *)loadDVRAllocationListSelectionView;
- (void)setHeaderTitle:(NSString *)headerTitle andListTitle:(NSString *)listTitle;
- (void)showOnlyCloseButton;

@end
