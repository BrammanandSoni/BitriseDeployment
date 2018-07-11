//
//  PlaybackBottomControlView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 8/2/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "PlaybackBottomControlView.h"

@interface PlaybackBottomControlView ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet SliderView *sliderView;

- (IBAction)screenShotButtonPressed:(UIButton *)sender;


@end

@implementation PlaybackBottomControlView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setTimeText:(NSString *)timeText
{
    self.timeLabel.text = timeText;
}

- (void)setSliderValue:(int)sliderValue
{
    [self.sliderView setSliderValue:sliderValue];
}

- (void)setRecordingHoursDict:(NSDictionary *)recordingHoursDict
{
    self.sliderView.recordingHoursDict = recordingHoursDict;
    [self.sliderView setNeedsDisplay];
}

- (void)setSliderViewDelegate:(id<SliderViewDelegate>)sliderViewDelegate
{
    self.sliderView.delegate = sliderViewDelegate;
}

- (IBAction)screenShotButtonPressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnScreenshotButton:)]) {
        [self.delegate didClickOnScreenshotButton:self];
    }
}

@end
