//
//  DateTimeFilterView.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/25/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateTimeFilterView;

@protocol DateTimeFilterViewDelegate <NSObject>

- (void)dateTimeFilterView:(DateTimeFilterView *)view didSelectDate:(NSString *)dateString startTime:(NSString *)startTimeString endTime:(NSString *)endTimeString;
- (void)didCancelDateTimeFilterView:(DateTimeFilterView *)view;

@end

@interface DateTimeFilterView : UIView

@property (nonatomic, weak) id<DateTimeFilterViewDelegate> delegate;

@end
