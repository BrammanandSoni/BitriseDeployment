//
//  SettingELVC.m
//  EyeLogix
//
//  Created by Smriti on 5/24/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "SettingELVC.h"
#import "HelpVC.h"
#import "ChangePasswordVC.h"
#import "SlideNavigationController.h"
#import "Utils.h"
#import "ServiceManger.h"

@interface SettingELVC ()<SlideNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *alertSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;

@end

@implementation SettingELVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"Settings";
    
//    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu"]
//                                                         style:UIBarButtonItemStylePlain
//                                                        target:self
//                                                        action:@selector(backbtn:)];
//    
//    self.navigationItem.leftBarButtonItem = btn;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    


    alertTxt.layer.borderWidth = 1;
    alertTxt.layer.borderColor = [[UIColor lightGrayColor]CGColor];

    notificationTxt.layer.borderWidth = 1;
    notificationTxt.layer.borderColor = [[UIColor lightGrayColor]CGColor];

    loginTxt.layer.borderWidth = 1;
     loginTxt.layer.borderColor = [[UIColor lightGrayColor]CGColor];

      helpTxt.layer.borderWidth = 1;
     helpTxt.layer.borderColor = [[UIColor lightGrayColor]CGColor];

     passTxt.layer.borderWidth = 1;
     passTxt.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    [self.autoLoginSwitch setOn:[Utils getAutoLoginFlag]];
    

    [self getNotificationSwitchStatus];
    
}
//    -(void) backbtn:(id)sender {
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network Calls

- (void)getNotificationSwitchStatus
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service getPushNotificationStatusWithCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        
        if ([response[@"Status"] isEqualToString:@"OK"]) {
            if (response && error == nil) {
                if ([response[@"Response"][@"IsEnable"] boolValue]) {
                    self.alertSwitch.on = YES;
                }
                else {
                    self.alertSwitch.on = NO;
                }
            }
        }
        else {
            [Utils showToastWithMessage:[response valueForKeyPath:@"Response.ShowMessage"]];
        }
    }];
}

- (void)setNotificationSwitchStatus:(BOOL)enable
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service setPushNotificationStatus:enable WithCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if ([response[@"Status"] isEqualToString:@"OK"]) {
            NSString *message = enable ? @"Notification enabled" : @"Notification disabled";
            [Utils showToastWithMessage:message];
        }
        else {
            self.alertSwitch.on = !self.alertSwitch.on;
            [Utils showToastWithMessage:[response valueForKeyPath:@"Response.ShowMessage"]];
        }
    }];
}

#pragma mark - IBActions

- (IBAction)alertSwitch:(UISwitch *)sender {
    
    NSString *message = sender.isOn ? @"Do you want to enable notification?" : @"Do you want to disable notification?";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        sender.on = !sender.on;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setNotificationSwitchStatus:sender.on];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [[SlideNavigationController sharedInstance] presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)notificationSwitch:(UISwitch *)sender {
}

- (IBAction)autoLoginSwitch:(UISwitch *)sender {
    [Utils setAutoLoginFlag:sender.isOn];
}

- (IBAction)tabHelp: (id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HelpVC *helpVC = [storyboard instantiateViewControllerWithIdentifier:@"HelpVC"];
    [self.navigationController pushViewController:helpVC animated:YES];
}

- (IBAction)tabChangePassword: (id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChangePasswordVC *changePassVC = [storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordVC"];
    [self.navigationController pushViewController:changePassVC animated:YES];
}

#pragma mark - SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
