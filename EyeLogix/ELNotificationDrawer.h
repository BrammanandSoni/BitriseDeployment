//
//  ELNotificationDrawer.h
//  EyeLogix
//
//  Created by Ashwani Hundwani on 30/08/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELNotificationDrawer;

@protocol ELNotificationDrawerDelegate <NSObject>

-(void)didTapView:(ELNotificationDrawer *)sender;

@end

@interface ELNotificationDrawer : UIView

@property(nonatomic, strong)NSDictionary *notification;

+(void)showNotification:(NSDictionary *)notification
               delegate:(id<ELNotificationDrawerDelegate>)delegate;

@end
