//
//  TopHeaderCollectionViewCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/14/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopHeaderCollectionViewCell : UICollectionViewCell

- (void)configureCellWithTitle:(NSString *)title;
- (void)showSelection:(BOOL)show;

@end
