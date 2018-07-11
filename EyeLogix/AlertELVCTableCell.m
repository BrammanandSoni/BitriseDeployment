//
//  AlertELVCTableCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/17/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "AlertELVCTableCell.h"

@interface AlertELVCTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation AlertELVCTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)configureCellWithDetails:(NSDictionary *)details
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", details[@"StoreTitle"], details[@"CamTitle"]];
    self.subTitleLabel.text = [NSString stringWithFormat:@"%@ (%@)", details[@"AlertTitle"], details[@"AlertId"]];
    self.dateLabel.text = details[@"AlertDateTime"];
    self.descriptionLabel.text = details[@"AlertMessage"];
}

@end
