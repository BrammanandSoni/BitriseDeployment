//
//  LiveFootageCollectionCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/6/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "LiveFootageCollectionCell.h"

@interface LiveFootageCollectionCell()
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@end

@implementation LiveFootageCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor colorWithRed:71.0 / 255.0 green:71.0 / 255.0 blue:71.0 / 255.0 alpha:1];
    self.captionLabel.backgroundColor = [UIColor colorWithRed:61.0 / 255.0 green:61.0 / 255.0 blue:61.0 / 255.0 alpha:1];
    self.captionLabel.textColor = [UIColor whiteColor];
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)prepareForReuse
{
    [super prepareForReuse];    
    [[self.contentView viewWithTag:1001] removeFromSuperview];
    [[self.contentView viewWithTag:111] removeFromSuperview];
}

- (void)setCamCaption:(NSString*)title
{
    [self.contentView bringSubviewToFront:self.captionLabel];
    self.captionLabel.text = title;
}

@end
