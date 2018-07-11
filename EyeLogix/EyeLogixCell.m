//
//  EyeLogixCell.m
//  EyeLogix
//
//  Created by Smriti on 4/26/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "EyeLogixCell.h"

@implementation EyeLogixCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lblTitle.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
