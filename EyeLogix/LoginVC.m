//
//  ViewController.m
//  EyeLogix
//
//  Created by Smriti on 4/19/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "LoginVC.h"
#import "ServiceManger.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "CamListingVC.h"
#import "LeftEyeLogixVC.h"
#import "Utils.h"
#import "TutorialsViewController.h"

@interface LoginVC ()
@property (nonatomic, strong) TutorialsViewController *tutVC;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:188.0f/255.0f green:16.0f/255.0f blue:15.0f/255.0f alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
  
    
    self.navigationController.navigationBarHidden = YES;
    
    UITapGestureRecognizer *single_tap_recognizer;
    single_tap_recognizer = [[UITapGestureRecognizer alloc] initWithTarget : self action: @selector(hideKeyBoard)];
    [single_tap_recognizer setNumberOfTouchesRequired : 1];
    [self.view addGestureRecognizer : single_tap_recognizer];
    
    
    
    userTxt.layer.cornerRadius = 10;
    userTxt.layer.borderColor = [[UIColor whiteColor]CGColor];
    userTxt.layer.borderWidth = 2;
    
    passTxt.layer.cornerRadius = 10;
    passTxt.layer.borderColor = [[UIColor whiteColor]CGColor];
    passTxt.layer.borderWidth = 2;
    
    if ([Utils getRememberMeFlag]) {
        btRemeber.selected = YES;
        
        userTxt.text = [Utils getUserName];
        passTxt.text = [Utils getPassword];
    }
    else {
        btRemeber.selected = NO;
        userTxt.text = nil;
        passTxt.text = nil;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isTutorialShown"]) {
        [self addTutorialVC];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void) hideKeyBoard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTutorialVC
{
    self.tutVC = (TutorialsViewController *)[Utils getViewControllerWithIdentifier:@"TutorialsViewController"];
    self.tutVC.view.frame = self.view.frame;
    [self.view addSubview:self.tutVC.view];
    [self addChildViewController:self.tutVC];
    [self.tutVC didMoveToParentViewController:self];
}

#pragma mark - Button

- (IBAction)tabLogin: (id)sender {
    
    if (!userTxt.text.length) {
        [Utils showToastWithMessage:@"Please enter user name"];
        return;
    }
    
    if (!passTxt.text.length) {
        [Utils showToastWithMessage:@"Please enter password"];
        return;
    }
    
    NSDictionary *parameter = @{@"usr":userTxt.text,
                                @"pwd":passTxt.text,
                                };
    
    ServiceManger *service  = [ServiceManger sharedInstance];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait...";
    
    [service LoginService:parameter withCallback:^(NSDictionary *dictResponse) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!dictResponse) {
            return;
        }
        
        NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
        [userPref setValue:[[dictResponse valueForKey:@"Response"] valueForKey:@"UserName"] forKey:@"UserName"];
        [userPref setValue:[[dictResponse valueForKey:@"Response"] valueForKey:@"ProfileId"] forKey:@"ProfileId"];
        [userPref setValue:[[dictResponse valueForKey:@"Response"] valueForKey:@"Token"] forKey:@"Token"];
        [userPref setValue:passTxt.text forKey:@"Password"];
        
        [userPref synchronize];
        
        if ([Utils getDeviceToken]) {
            [service registerDeviceToken:[Utils getDeviceToken] withCompletionBlock:^(NSDictionary *response, NSError *error) {
                
                
            }];
            
        }

        
        int statusCode = (int)[[[dictResponse valueForKey:@"Status"] valueForKey:@"Code"] integerValue];
        
        if (statusCode == 1) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CamListingVC *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"CamListingVC"];
            [self.navigationController pushViewController:loginVC animated:YES];
            
            if ([Utils getRememberMeFlag]) {
                [Utils savePassword:passTxt.text];
            }
            else {
                [Utils removePassword];
            }
        }
        else    {
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Error!"
                                          message:[[dictResponse valueForKey:@"Response"] valueForKey:@"ShowMessage"]
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            [alert addAction:ok];
        }
    }];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender    {
    
//    if ([identifier isEqualToString:@"loginIdentifier"]) {
//        return YES;
//    }
    
    return NO;
}


- (IBAction)forgetBtn: (id)sender {

    [self.navigationController pushViewController:[Utils getViewControllerWithIdentifier:@"ForgotPasswordVC"] animated:true];
}
- (IBAction)rememberMePressed: (id)sender {
    
    UIButton *btTemp = (UIButton *)sender;
    btTemp.selected = !btTemp.selected;
    
    [Utils setRememberMeFlag:btTemp.selected];
}
@end
