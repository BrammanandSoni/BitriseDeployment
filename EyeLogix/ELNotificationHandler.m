//
//  ELNotificationHandler.m
//  EyeLogix
//
//  Created by Ashwani Hundwani on 27/08/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "ELNotificationHandler.h"
#import "SlideNavigationController.h"
#import "AlertELVC.h"
#import "Utils.h"
#import "EventPlayBackVC.h"
#import "DashboardVC.h"
#import "LoginVC.h"

typedef enum ENotificationCase{
    
    eventPlay
    
} NotificationCase;

@implementation ELNotificationHandler

+(void)handleNotification:(NSDictionary *)notification
{
    NotificationCase notificationCase = eventPlay;
    switch (notificationCase) {
            
        case eventPlay:
        {
            
            /*
             {"aps":{"alert":"There is motion detected at TCL Noida - Reception 2016-08-10 21:06:29","badge":1,"sound":"default","storeId":"5","storeTitle":"TCL Noida","camId":"432","camTitle":"Reception","alertDateTime":"2016-08-10 21:06:29","alertId":"146580"}}
             */
            
            UIViewController *controller = [[SlideNavigationController sharedInstance] topViewController];
            
            
            if([controller isKindOfClass:[DashboardVC class]]
               || [controller isKindOfClass:[LoginVC class]]) {
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                EventPlayBackVC *eventPlaybackVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"EventPlayBackVC"];
                
                eventPlaybackVC.showCross = true;
                
                [eventPlaybackVC setEventId:notification[@"aps"][@"alertId"] andCamId:notification[@"aps"][@"camId"]];
                
                [[[[SlideNavigationController sharedInstance] topViewController] navigationController] pushViewController:eventPlaybackVC animated:NO];
                
            }
            else {
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                AlertELVC *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"AlertELVC"];
                
                
                [SlideNavigationController sharedInstance].avoidSwitchingToSameClassViewController = false;
                
                [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:viewController withCompletion:^{
                    [SlideNavigationController sharedInstance].avoidSwitchingToSameClassViewController = true;
                    [viewController openEventPlayWithEventId:notification[@"aps"][@"alertId"] andCamId:notification[@"aps"][@"camId"]];
                    
                }];
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

@end
