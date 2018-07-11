//
//  DDInputTableCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DDInputTableCell.h"

@interface DDInputTableCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;

@property (nonatomic, strong) NewUserDetails *userDetails;

@end

@implementation DDInputTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithNewUserDetails:(NewUserDetails *)userDetails
{
    self.userDetails = userDetails;
    
    self.leftTitleLabel.text = @"Country";
    self.leftTextField.placeholder = @"Select Country";
    self.leftTextField.text = userDetails.country;
    
    self.rightTitleLabel.text = @"State";
    self.rightTextField.placeholder = @"Enter State";
    self.rightTextField.text = userDetails.state;
}

- (IBAction)leftDropDownClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ddInputTableCellDidClickOnDropDown:)]) {
        [self.delegate ddInputTableCellDidClickOnDropDown:self];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.userDetails.state = inputString;
    
    return YES;
}

@end
