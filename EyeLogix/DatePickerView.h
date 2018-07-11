//
//  DatePickerView.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/20/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerView;

@protocol DatePickerViewDelegate <NSObject>

- (void)datePickerView:(DatePickerView *)pickerView didSelectDate:(NSDate *)date;
- (void)didCancelDatePickerView:(DatePickerView *)pickerView;

@end

@interface DatePickerView : UIView

@property (weak, nonatomic) id<DatePickerViewDelegate> delegate;

- (void)setTitle:(NSString *)title andDatePickerMode:(UIDatePickerMode)datePickerMode;

@end
