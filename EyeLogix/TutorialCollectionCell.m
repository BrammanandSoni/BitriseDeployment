//
//  TutorialCollectionCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 8/3/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "TutorialCollectionCell.h"

@interface TutorialCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *tutImageView;

@end

@implementation TutorialCollectionCell

- (void)configureCellWithImage:(NSString *)imageName
{
    self.tutImageView.image = [UIImage imageNamed:imageName];
}

@end
