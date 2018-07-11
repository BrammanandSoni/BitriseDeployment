//
//  DVRCategoryListView.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/18/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstants.h"

@class DVRCategoryListView;

@protocol DVRCategoryListViewDelegate <NSObject>

- (void)categoryListView:(DVRCategoryListView *)catListView didSelectCategoryAtIndex:(NSInteger)index;
- (void)categoryListViewDidSelectAll:(DVRCategoryListView *)catListView;

@end

@interface DVRCategoryListView : UIView

@property (nonatomic, weak) id <DVRCategoryListViewDelegate> delegate;
@property (nonatomic, strong) NSArray *listArray;

+ (DVRCategoryListView *)loadCategoryListView;
- (void)configureListViewWithHeaderTitle:(NSString *)headerTitle andListTitle:(NSString *)listTitle;
- (void)configureImage:(NSString *)imageName;
- (void)showOnlyCloseButton;

@end
