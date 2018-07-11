//
//  GallerySlideShowELVC.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/13/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GallerySlideShowELVC;


@protocol GallerySlideShowELVCDelegate <NSObject>

-(void)didDeleteImage:(NSString *)imageDict
               sender:(GallerySlideShowELVC *)sender;

@end

@interface GallerySlideShowELVC : UIViewController

@property (nonatomic) NSInteger currentSelectedIndex;
@property(nonatomic, weak)id<GallerySlideShowELVCDelegate> delegate;

@end
