//
//  TopHeaderCollectionViewCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/14/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "TopHeaderCollectionViewCell.h"

@interface TopHeaderCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@end

@implementation TopHeaderCollectionViewCell

- (void)configureCellWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)showSelection:(BOOL)show
{
    self.separatorView.hidden = !show;
    
    if (show) {
        self.titleLabel.textColor = [UIColor whiteColor];
        //UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
    }
    else {
        self.titleLabel.textColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.6];
    }
}

@end
