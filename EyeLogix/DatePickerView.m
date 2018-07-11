//
//  DatePickerView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/20/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)closeButtonPressed:(UIButton *)sender;
- (IBAction)okButtonPressed:(UIButton *)sender;

@end

@implementation DatePickerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //WORKAROUND - bug in date picker, not displaying hours.
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title andDatePickerMode:(UIDatePickerMode)datePickerMode
{
    self.titleLabel.text = title;
    self.datePicker.datePickerMode = datePickerMode;
}


#pragma mark - IBActions

- (IBAction)closeButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didCancelDatePickerView:)]) {
        [self.delegate didCancelDatePickerView:self];
    }
}

- (IBAction)okButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(datePickerView:didSelectDate:)]) {
        [self.delegate datePickerView:self didSelectDate:self.datePicker.date];
    }
}

@end
