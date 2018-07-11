//
//  PlayBackStreamVC.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/19/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayBackStreamVC;

@protocol PlayBackStreamVCDelegate <NSObject>

- (void)playBackVC:(PlayBackStreamVC *)playbackVC didUpdateDateTime:(NSString *)dateTime;

@end

@interface PlayBackStreamVC : UIViewController

//@property (weak, nonatomic) id<PlayBackStreamVCDelegate> delegate;

- (void)setDate:(NSDate *)date stoteName:(NSString *)storeName andCamDetails:(NSDictionary *)camDetails;

//- (void)streamCamWithCamDetails:(NSDictionary *)camDetails playbackURL:(NSString *)playbackURL recordingHoursDetails:(NSDictionary *)details andDate:(NSDate *)date;

@end
