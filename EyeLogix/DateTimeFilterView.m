//
//  DateTimeFilterView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/25/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "DateTimeFilterView.h"
#import "DatePickerView.h"
#import "Utils.h"

typedef enum eDateType {
    Date,
    StartTime,
    EndTime
}DateType;

@interface DateTimeFilterView ()<DatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (nonatomic, strong) DatePickerView *datePickerView;
@property (nonatomic) DateType datetype;

@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *startTimeString;
@property (nonatomic, strong) NSString *endTimeString;

- (IBAction)dateSelectionPressed:(UIButton *)sender;
- (IBAction)startTimePressed:(UIButton *)sender;
- (IBAction)endTimePressed:(UIButton *)sender;

- (IBAction)closeButtonPressed:(UIButton *)sender;
- (IBAction)okButtonPressed:(UIButton *)sender;


@end

@implementation DateTimeFilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self doInitialConfiguration];
}

#pragma mark - Private Methods

- (void)doInitialConfiguration
{
    self.dateString = [Utils stringFromDate:[NSDate date] inFormat:@"yyyy-MM-dd"];
    self.startTimeString = @"00:00";
    self.endTimeString = [Utils stringFromDate:[NSDate date] inFormat:@"HH:mm"];
    
    [self refreshDateAndTime];
}

- (void)refreshDateAndTime
{
    self.dateLabel.text = self.dateString;
    self.startTimeLabel.text = self.startTimeString;
    self.endTimeLabel.text = self.endTimeString;
}

#pragma mark - Public Methods

- (void)openDatePickerViewWithTitle:(NSString *)title andMode:(UIDatePickerMode)mode
{
    if (self.datePickerView == nil) {
        self.datePickerView = [[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil].lastObject;
    }
    
    self.datePickerView.delegate = self;
    self.datePickerView.frame = self.bounds;
    [self addSubview:self.datePickerView];
    [self.datePickerView setTitle:title andDatePickerMode:mode];
}

#pragma mark - IBAction

- (IBAction)dateSelectionPressed:(UIButton *)sender {
    self.datetype = Date;
    [self openDatePickerViewWithTitle:@"Select Date" andMode:UIDatePickerModeDate];
}

- (IBAction)startTimePressed:(UIButton *)sender {
    self.datetype = StartTime;
    [self openDatePickerViewWithTitle:@"Select Start Time" andMode:UIDatePickerModeTime];
}

- (IBAction)endTimePressed:(UIButton *)sender {
    self.datetype = EndTime;
    [self openDatePickerViewWithTitle:@"Select End Time" andMode:UIDatePickerModeTime];
}

- (IBAction)closeButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didCancelDateTimeFilterView:)]) {
        [self.delegate didCancelDateTimeFilterView:self];
    }
}

- (IBAction)okButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(dateTimeFilterView:didSelectDate:startTime:endTime:)]) {
        [self.delegate dateTimeFilterView:self didSelectDate:self.dateString startTime:self.startTimeString endTime:self.endTimeString ];
    }
}

#pragma mark - DatePickerViewDelegate

- (void)datePickerView:(DatePickerView *)pickerView didSelectDate:(NSDate *)date
{
    if (self.datetype == Date) {
        self.dateString = [Utils stringFromDate:date inFormat:@"yyyy-MM-dd"];
    }
    else if (self.datetype == StartTime) {
        self.startTimeString = [Utils stringFromDate:date inFormat:@"HH:mm"];
    }
    else if (self.datetype == EndTime) {
        self.endTimeString = [Utils stringFromDate:date inFormat:@"HH:mm"];
    }
    
    [self refreshDateAndTime];
    
    [self.datePickerView removeFromSuperview];
    self.datePickerView = nil;
}

- (void)didCancelDatePickerView:(DatePickerView *)pickerView
{
    [self.datePickerView removeFromSuperview];
    self.datePickerView = nil;
}

@end
