//
//  GalleryELVCCollectionCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/13/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "GalleryELVCCollectionCell.h"
#import "Utils.h"

@interface GalleryELVCCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@end


@implementation GalleryELVCCollectionCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self doInitialConfiguration];
}

#pragma mark - Public Methods

- (void)showDetails:(NSDictionary *)details
{
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", [Utils getGalleryDirectoryPath], details[@"imageName"]];
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    
    if ([details[@"selected"] boolValue]) {
        self.selectImageView.hidden = NO;
    }
    else {
        self.selectImageView.hidden = YES;
    }
}

#pragma mark - Private Methods

- (void)doInitialConfiguration
{
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
