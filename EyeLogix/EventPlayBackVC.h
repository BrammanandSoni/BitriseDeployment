//
//  EventPlayBackVC.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/25/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventPlayBackVC : UIViewController

@property(nonatomic)BOOL showCross;

- (void)setEventId:(NSString *)eventId andCamId:(NSString *)camId;

@end
