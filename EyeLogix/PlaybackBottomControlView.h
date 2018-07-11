//
//  PlaybackBottomControlView.h
//  EyeLogix
//
//  Created by Brammanand Soni on 8/2/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderView.h"

@class PlaybackBottomControlView;

@protocol PlaybackBottomControlViewDelegate <NSObject>

- (void)didClickOnScreenshotButton:(PlaybackBottomControlView *)playbackControlView;

@end

@interface PlaybackBottomControlView : UIView

@property (nonatomic, strong) NSString *timeText;
@property (nonatomic) int sliderValue;
@property (nonatomic, strong) NSDictionary *recordingHoursDict;

@property (nonatomic, weak) id <PlaybackBottomControlViewDelegate> delegate;
@property (nonatomic, weak) id <SliderViewDelegate> sliderViewDelegate;

@end
