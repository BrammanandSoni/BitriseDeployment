//
//  DDDDTableCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DDDDTableCell.h"

@interface DDDDTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;

@end

@implementation DDDDTableCell

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
    self.leftTitleLabel.text = @"Time Zone";
    self.leftTextField.placeholder = @"Select Time Zone";
    self.leftTextField.text = userDetails.timeZone;
    
    self.rightTitleLabel.text = @"Access Type";
    self.rightTextField.placeholder = @"Select Access Type";
    self.rightTextField.text = userDetails.access;
}

- (IBAction)leftDropDownClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ddddTableCellDidClickOnLeftDropDown:)]) {
        [self.delegate ddddTableCellDidClickOnLeftDropDown:self];
    }
}

- (IBAction)rightDropDownClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ddddTableCellDidClickOnRightDropDown:)]) {
        [self.delegate ddddTableCellDidClickOnRightDropDown:self];
    }
}

@end
