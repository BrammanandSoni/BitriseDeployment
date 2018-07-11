//
//  PopupListView.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/25/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupListView;

@protocol PopupListViewDelegate <NSObject>

- (void)popupListView:(PopupListView *)popupListView didSelectItemAtIndex:(NSInteger)index;
- (void)actionButtonClicked:(PopupListView *)popupListView;

@end

@interface PopupListView : UIView

@property (nonatomic, strong) id<PopupListViewDelegate> delegate;

- (void)setTitle:(NSString *)title actionButtonTitle:(NSString *)actionButtonTitle withListItem:(NSArray *)listItem;

@end
