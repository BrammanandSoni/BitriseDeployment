//
//  CamTitleView.h
//  EyeLogix
//
//  Created by Brammanand Soni on 8/14/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVRCamDetails.h"

@class CamTitleView;

@protocol CamTitleViewDelegate <NSObject>

- (void)camTitleViewDidClickOnYesButton:(CamTitleView *)camTitleView withTitle:(NSString *)title andCamDetails:(DVRCamDetails *)camDetails;

@end

@interface CamTitleView : UIView

@property (nonatomic, weak) id <CamTitleViewDelegate> delegate;

- (void)configureViewWithCamDetails:(DVRCamDetails *)camDetails;
+ (CamTitleView *)loadCamTitleView;

@end
