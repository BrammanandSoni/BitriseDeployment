//
//  CategoryTableCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/19/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "CategoryTableCell.h"

@interface CategoryTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;

@end

@implementation CategoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setThumbImage:(NSString *)image
{
    self.thumbImageView.image = [UIImage imageNamed:image];
}

@end
