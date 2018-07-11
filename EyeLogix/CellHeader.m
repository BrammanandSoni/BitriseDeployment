//
//  CellHeader.m
//  EyeLogix
//
//  Created by Smriti on 4/21/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "CellHeader.h"

@implementation CellHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.camCountLabel.layer.cornerRadius = self.camCountLabel.frame.size.width/2;
    self.camCountLabel.layer.borderWidth = 1.0;
    self.camCountLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
