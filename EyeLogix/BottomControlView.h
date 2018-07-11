//
//  BottomControlView.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/31/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveFootageVC.h"

@class BottomControlView;

@protocol BottomControlViewDelegate <NSObject>

- (void)didClickedScreenshot:(BottomControlView *)bottomComtrolView;
- (void)didClickedFavourite:(BottomControlView *)bottomComtrolView;

@end

@interface BottomControlView : UIView

@property (nonatomic, weak) id <BottomControlViewDelegate> delegate;

- (void)setCountText:(NSString *)countText andScreenType:(ScreenType)type;

@end
