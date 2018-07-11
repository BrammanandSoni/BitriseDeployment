//
//  DVRInputTableCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/17/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRInputTableCell.h"

@interface DVRInputTableCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *inputTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (nonatomic, strong) DVRStoreDetails *stroreDetails;
@property (nonatomic, strong) ChangePasswordDetails *changePasswordDetails;

@end

@implementation DVRInputTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)configureCellWithStoreDetails:(DVRStoreDetails *)stroreDetails
{
    self.stroreDetails = stroreDetails;
    
    if (self.tag == 0) {
        self.inputTitleLabel.text = @"DVR Title";
        self.inputTextField.text = stroreDetails.storeTitle;
    }
    else if (self.tag == 1) {
        self.inputTitleLabel.text = @"DVR IP";
        self.inputTextField.text = stroreDetails.storeIP;
    }
    else if (self.tag == 2) {
        self.inputTitleLabel.text = @"DVR Address";
        self.inputTextField.text = stroreDetails.storeAddress;
    }
    else if (self.tag == 3) {
        self.inputTitleLabel.text = @"DVR Time Zone";
        self.inputTextField.text = stroreDetails.storeTimeZone;
    }
}

- (void)configureCellWithDVRAllocationDetails:(DVRAllocationDetails *)dvrAllocationDetails
{
    if (self.tag == 0) {
        self.inputTitleLabel.text = @"Allocated By";
        self.inputTextField.text = dvrAllocationDetails.userName;
    }
    else if (self.tag == 1) {
        self.inputTitleLabel.text = @"DVR Title";
        self.inputTextField.text = dvrAllocationDetails.storeTitle;
    }
}

- (void)configureCellWithChangePasswordDetails:(ChangePasswordDetails *)changePasswordDetails
{
    self.changePasswordDetails = changePasswordDetails;
    if (self.tag == 0) {
        self.inputTitleLabel.text = @"New Password";
        self.inputTextField.placeholder = @"Enter New Password";
        self.inputTextField.text = changePasswordDetails.newpassword;
    }
    else if (self.tag == 1) {
        self.inputTitleLabel.text = @"Confirm Password";
        self.inputTextField.placeholder = @"Enter Confirm Password";
        self.inputTextField.text = changePasswordDetails.confirmPassword;
    }
}

- (void)disableEditing:(BOOL)disable
{
    self.inputTextField.userInteractionEnabled = !disable;
}

- (void)enableSecureEntry:(BOOL)enable
{
    self.inputTextField.secureTextEntry = enable;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.stroreDetails) {
        if (self.tag == 0) {
            self.stroreDetails.storeTitle = inputString;
        }
        else if (self.tag == 2) {
            self.stroreDetails.storeAddress = inputString;
        }
    }
    else if (self.changePasswordDetails) {
        if (self.tag == 0) {
            self.changePasswordDetails.newpassword = inputString;
        }
        else if (self.tag == 1) {
            self.changePasswordDetails.confirmPassword = inputString;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
