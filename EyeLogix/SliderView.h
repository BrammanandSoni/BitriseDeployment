//
//  SliderView.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/23/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SliderView;

@protocol SliderViewDelegate <NSObject>

- (void)sliderView:(SliderView *)sliderView didChangeSliderValue:(int)value;
- (void)sliderView:(SliderView *)sliderView didEndDraggingWithValue:(int)value;

@end

@interface SliderView : UIView

@property (weak, nonatomic) id<SliderViewDelegate> delegate;
@property (nonatomic, strong) NSDictionary *recordingHoursDict;

- (void)setSliderValue:(int)value;

@end
