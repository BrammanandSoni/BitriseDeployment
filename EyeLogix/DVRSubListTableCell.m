//
//  DVRSubListTableCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/16/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRSubListTableCell.h"

@interface DVRSubListTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DVRSubListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithTitle:(NSString *)title andImage:(NSString *)image
{
    self.titleLabel.text = title;
    self.thumbImageView.image = [UIImage imageNamed:image];
}

- (void)configureCellWithAttributedTitle:(NSAttributedString *)attributedTitle andImage:(NSString *)image
{
    self.titleLabel.attributedText = attributedTitle;
    self.thumbImageView.image = [UIImage imageNamed:image];
}

@end
