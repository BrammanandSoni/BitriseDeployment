//
//  TwoInputTableCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "TwoInputTableCell.h"

@interface TwoInputTableCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;

@property (nonatomic, strong) NewUserDetails *userDetails;

@end

@implementation TwoInputTableCell

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
    if (self.rowType == ANUUserNameAndName) {
        self.leftTitleLabel.text = @"User Name";
        self.leftTextField.placeholder = @"Enter User Name";
        self.rightTitleLabel.text = @"Name";
        self.rightTextField.placeholder = @"Enter Name";
        
        self.leftTextField.text = userDetails.userName;
        self.rightTextField.text = userDetails.operatorName;
        
        self.leftTextField.userInteractionEnabled = self.userType != UserUpdate;
    }
    else if (self.rowType == ANUPassAndContact) {
        if (self.userType == UserUpdate) {
            self.leftTitleLabel.text = @"Status";
            self.leftTextField.placeholder = @"Status";
            
            self.leftTextField.text = @"Active"; // Need to change once get it in response, currently there is no key for status
        }
        else {
            self.leftTitleLabel.text = @"Password";
            self.leftTextField.placeholder = @"Enter Password";
        }
        
        self.rightTitleLabel.text = @"Contact Number";
        self.rightTextField.placeholder = @"Enter Mobile";
        
        self.rightTextField.text = userDetails.mobile;
        
        self.leftTextField.userInteractionEnabled = self.userType != UserUpdate;
    }
    else if (self.rowType == ANUEmailAndAddress) {
        self.leftTitleLabel.text = @"Email ID";
        self.leftTextField.placeholder = @"Enter Email ID";
        self.rightTitleLabel.text = @"Address";
        self.rightTextField.placeholder = @"Enter Address";
        
        self.leftTextField.text = userDetails.email;
        self.rightTextField.text = userDetails.address;
    }
    else if (self.rowType == ANUCityAndPinCode) {
        self.leftTitleLabel.text = @"City";
        self.leftTextField.placeholder = @"Enter City";
        self.rightTitleLabel.text = @"Pin Code";
        self.rightTextField.placeholder = @"Enter Pin";
        
        self.leftTextField.text = userDetails.city;
        self.rightTextField.text = userDetails.pincode;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.rowType == ANUUserNameAndName) {
        if (textField == self.leftTextField) {
            self.userDetails.userName = inputString;
        }
        else if (textField == self.rightTextField) {
            self.userDetails.operatorName = inputString;
        }
    }
    else if (self.rowType == ANUPassAndContact) {
        if (textField == self.leftTextField) {
            self.userDetails.password = inputString;
        }
        else if (textField == self.rightTextField) {
            self.userDetails.mobile = inputString;
        }
    }
    else if (self.rowType == ANUEmailAndAddress) {
        if (textField == self.leftTextField) {
            self.userDetails.email = inputString;
        }
        else if (textField == self.rightTextField) {
            self.userDetails.address = inputString;
        }
    }
    else if (self.rowType == ANUCityAndPinCode) {
        if (textField == self.leftTextField) {
            self.userDetails.city = inputString;
        }
        else if (textField == self.rightTextField) {
            self.userDetails.pincode = inputString;
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
