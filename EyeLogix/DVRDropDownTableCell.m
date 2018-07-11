//
//  DVRDropDownTableCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/17/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRDropDownTableCell.h"

@interface DVRDropDownTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *dropDownTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYConstraint;

@end

@implementation DVRDropDownTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)configureWithTitle:(NSString *)title andPlaceHolder:(NSString *)placeHolder
{
    self.titleLabel.text = title;
    self.dropDownTextField.text = @"";
    self.dropDownTextField.placeholder = placeHolder;
}

- (void)alignTextFieldInCenter:(BOOL)align
{
    self.centerYConstraint.constant = 5;
    [self layoutIfNeeded];
}

- (void)configureCellWithStoreDetails:(DVRStoreDetails *)storeDetails
{
    self.dropDownTextField.text = storeDetails.category;
}

- (void)configureCellWithDVRUser:(DVRUser *)user
{
    self.dropDownTextField.text = user.userName;
}

- (void)configureCellWithDVRDetails:(DVRDetails *)dvrDetails
{
    self.dropDownTextField.text = dvrDetails.storeTitle;
}

- (void)configureCellWithUserType:(NSString *)userType
{
    self.dropDownTextField.text = userType;
}

#pragma mark - IBAction

- (IBAction)dropDownButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnDropDownInDropDownTableCell:)]) {
        [self.delegate didClickOnDropDownInDropDownTableCell:self];
    }
}

@end
