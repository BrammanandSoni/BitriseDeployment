//
//  BottomControlView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/31/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "BottomControlView.h"

@interface BottomControlView ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

- (IBAction)favouriteButtonPressed:(UIButton *)sender;
- (IBAction)screenshotButtonPressed:(UIButton *)sender;

@end

@implementation BottomControlView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - Public Methods

- (void)setCountText:(NSString *)countText andScreenType:(ScreenType)type
{
    self.countLabel.text = countText;
    if (type == ScreenTypeFavourite) {
        [self.favouriteButton setImage:[UIImage imageNamed:@"DeleteFavouriteGray"] forState:UIControlStateNormal];
    }
}

#pragma mark - IBActions

- (IBAction)favouriteButtonPressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedFavourite:)]) {
        [self.delegate didClickedFavourite:self];
    }
}

- (IBAction)screenshotButtonPressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedScreenshot:)]) {
        [self.delegate didClickedScreenshot:self];
    }
}

@end
