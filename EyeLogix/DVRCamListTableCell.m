//
//  DVRCamListTableCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/22/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRCamListTableCell.h"
#import "Utils.h"

@interface DVRCamListTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *camTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *validityAmtLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *camTitleView;

@end

@implementation DVRCamListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [Utils addTapGestureToView:self.camTitleView target:self selector:@selector(onTapTitleView:)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithCamDetails:(DVRCamDetails *)camDetails
{
    self.camTitleLabel.text = camDetails.camTitle;
    self.packageLabel.text = camDetails.package;
    self.validityAmtLabel.text = [NSString stringWithFormat:@"%@/%@", camDetails.validity, camDetails.amount];
    self.statusLabel.text = camDetails.status;
}

- (void)onTapTitleView:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(camListTableCellDidClickOnTitleView:)]) {
        [self.delegate camListTableCellDidClickOnTitleView:self];
    }
}

@end
