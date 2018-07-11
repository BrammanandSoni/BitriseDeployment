//
//  GallerySlideCollectionCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/13/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GallerySlideCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)showImage:(NSString *)imagePath;

@end
