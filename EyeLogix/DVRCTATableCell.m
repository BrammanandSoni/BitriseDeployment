//
//  DVRCTATableCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/17/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRCTATableCell.h"

@interface DVRCTATableCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *ctaButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;

@end

@implementation DVRCTATableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title
{
    [self.ctaButton setTitle:title forState:UIControlStateNormal];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: self.ctaButton.titleLabel.font}];
    self.buttonWidthConstraint.constant = size.width + 50;
    
    [self layoutIfNeeded];
}

- (void)setTitleColor:(UIColor *)color
{
    [self.ctaButton setTitleColor:color forState:UIControlStateNormal];
}

- (void)setActionBackgroundColor:(UIColor *)color
{
    [self.ctaButton setBackgroundColor:color];
}

- (void)setBackgroundColor:(UIColor *)color
{
    [self.bgView setBackgroundColor:color];
}

#pragma mark - Private Methods

- (IBAction)ctaButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCTAButtonInDVRCTATableCell:)]) {
        [self.delegate didClickOnCTAButtonInDVRCTATableCell:self];
    }
}

@end
