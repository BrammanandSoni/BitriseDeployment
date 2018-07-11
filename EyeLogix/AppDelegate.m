//
//  AppDelegate.m
//  EyeLogix
//
//  Created by Smriti on 4/19/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "LeftEyeLogixVC.h"
#import "Utils.h"
#import "CamListingVC.h"
#import "ELNotificationDrawer.h"
#import "ELNotificationHandler.h"

@interface AppDelegate ()<ELNotificationDrawerDelegate>


@end

@implementation AppDelegate
+(AppDelegate*)sharedAppdelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
                                                                                         | UIUserNotificationTypeBadge
                                                                                         | UIUserNotificationTypeSound) categories:nil];
    [application registerUserNotificationSettings:settings];
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [SlideNavigationController sharedInstance].leftBarButtonItem = leftBarButtonItem;
    [SlideNavigationController sharedInstance].enableShadow = YES;
    
    LeftEyeLogixVC *leftMenu = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                instantiateViewControllerWithIdentifier:@"LeftEyeLogixVC"];
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
    if ([Utils getAutoLoginFlag]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CamListingVC *loginVC = (CamListingVC *)[storyboard instantiateViewControllerWithIdentifier:@"CamListingVC"];
        
        [[SlideNavigationController sharedInstance] pushViewController:loginVC animated:NO];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Closed %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Opened %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Revealed %@", menu);
    }];

    if(launchOptions && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]){
        [ELNotificationHandler handleNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];

    }
   
    return YES;
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if([application applicationState] == UIApplicationStateInactive)
    {
        //application was running in the background
        [ELNotificationHandler handleNotification:userInfo];
    }
    else {
        [ELNotificationDrawer showNotification:userInfo delegate:self];
        
    }
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSString *tokenStr = [devToken description];
    
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"\n\n\n\n\n\n\n\n\n\n\ndevice token = %@ \n\n\n\n\n\n\n\n\n\n\n\n\n\n", tokenStr);
    
    [Utils setDeviceToken:tokenStr];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = err.localizedDescription;
    
    NSLog(@"%@", str);
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }
    //register to receive notifications
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark Notification Drawer Delegate Methods
-(void)didTapView:(ELNotificationDrawer *)sender {
    
    
    [ELNotificationHandler handleNotification:sender.notification];
    [sender removeFromSuperview];
}



@end
