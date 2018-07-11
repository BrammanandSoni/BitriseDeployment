//
//  SliderView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/23/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "SliderView.h"

#define slot self.frame.size.width/24.0

@interface SliderView ()
{
    CGPoint thumbnailCenter;
    int currectSliderValue;
}

@property (weak, nonatomic) IBOutlet UIView *thumbnailView;

@end

@implementation SliderView

-(void)drawRect:(CGRect)rect {
    float xOffset = 0;
    for (int index = 0; index < 24; index++) {
        
        if ([[self.recordingHoursDict objectForKey:[NSString stringWithFormat:@"%d", index]] integerValue] == 1) {
            CGRect fillRect = CGRectMake(xOffset, 0, slot, self.frame.size.height);
            [[UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0] set];
            UIRectFill(fillRect);
        }
        else {
            CGRect fillRect = CGRectMake(xOffset, 0, slot, self.frame.size.height);
            [[UIColor lightGrayColor] set];
            UIRectFill(fillRect);
        }
        
        xOffset += slot;
    }
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self doInitialConfiguration];
}

- (void)setSliderValue:(int)value
{
    if (value > 0) {
        float ratio = self.bounds.size.width/1440;
        int currentXValue = (value * ratio);
        thumbnailCenter = CGPointMake(currentXValue, self.thumbnailView.center.y);
        currectSliderValue = value;
        
        [self performSelector:@selector(updateThumnailFrame) withObject:nil afterDelay:0.1];
    }
}

- (void)updateThumnailFrame
{
    self.thumbnailView.center = thumbnailCenter;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:didChangeSliderValue:)]) {
        [self.delegate sliderView:self didChangeSliderValue:currectSliderValue];
    }
}

#pragma mark - Private Methods

- (void)doInitialConfiguration
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.thumbnailView addGestureRecognizer:panGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    
    if (point.x < self.bounds.origin.x) {
        point.x = self.bounds.origin.x;
    }
    else if (point.x > self.bounds.size.width) {
        point.x = self.bounds.size.width;
    }
    
    point.y = self.frame.size.height/2;
    
    recognizer.view.center = point;
    
    [self updateSliderValueWithXValue:point.x];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:didEndDraggingWithValue:)]) {
            [self.delegate sliderView:self didEndDraggingWithValue:currectSliderValue];
        }
    }
}

- (void)updateSliderValueWithXValue:(float)xValue
{
    float ratio = self.bounds.size.width/1440;
    currectSliderValue = xValue/ratio;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:didChangeSliderValue:)]) {
        [self.delegate sliderView:self didChangeSliderValue:currectSliderValue];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (point.y < -self.thumbnailView.frame.size.height/2 || point.y > self.thumbnailView.frame.size.height/2) {
        return nil;
    }
    
    return self.thumbnailView;
}

@end
