//
//  NoResultView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/14/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "NoResultView.h"

@interface NoResultView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation NoResultView

-(void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - Public Methods

- (void)setImage:(UIImage *)image andTitle:(NSString *)title
{
    self.imageView.image = image;
    self.titleLabel.text = title;
}

@end
