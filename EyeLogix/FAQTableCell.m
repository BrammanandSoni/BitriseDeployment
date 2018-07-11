//
//  FAQTableCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 8/23/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "FAQTableCell.h"
#import "Utils.h"

@interface FAQTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *expandCollapseImage;


@end

@implementation FAQTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)configureCellWithDetails:(NSDictionary *)details forCellType:(FAQCellType)cellType selected:(BOOL)selected
{
    if (cellType == FAQCellTypeQuestion) {
        self.detailsLabel.text = details[@"Question"];
        self.contentView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        self.detailsLabel.font = [Utils helveticaFontWithSize:14.0];
        self.expandCollapseImage.hidden = false;
        if (selected) {
            
            self.expandCollapseImage.image = [UIImage imageNamed:@"Minus"];
            
        }
        else {
            
            self.expandCollapseImage.image = [UIImage imageNamed:@"Plus"];
        }
    }
    else if (cellType == FAQCellTypeAnswere) {
        self.detailsLabel.text = details[@"Answer"];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.detailsLabel.font = [Utils helveticaFontWithSize:12.0];
        self.expandCollapseImage.hidden = true;
    }
}

@end
