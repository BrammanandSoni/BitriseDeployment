//
//  GallerySlideCollectionCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/13/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "GallerySlideCollectionCell.h"

@interface GallerySlideCollectionCell()



@end

@implementation GallerySlideCollectionCell

#pragma mark - Public Methods

- (void)showImage:(NSString *)imagePath
{
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
}

@end
