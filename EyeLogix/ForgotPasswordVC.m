//
//  ForgotPasswordVCViewController.m
//  EyeLogix
//
//  Created by Ashwani Hundwani on 19/08/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "Utils.h"
#import "ServiceManger.h"
#import "MBProgressHUD.h"

typedef enum EForgotPasswordCase {
    
    profile,
    resetPassword,
    
    
} ForgotPasswordCase;

@interface ForgotPasswordVC ()

@property(nonatomic, weak)IBOutlet UITextField *txtProfile;
@property(nonatomic, weak)IBOutlet UITextField *txtOTP;
@property(nonatomic, weak)IBOutlet UITextField *txtPassword;
@property(nonatomic, weak)IBOutlet UITextField *txtConfirmPassword;
@property(nonatomic, weak)IBOutlet UIView *profileView;
@property(nonatomic, weak)IBOutlet UIView *resetView;
@property(nonatomic)ForgotPasswordCase forgotCase;

@end

@implementation ForgotPasswordVC

-(BOOL)validateProfile {
    
    BOOL valid = true;
    
    if([self.txtProfile.text isEqualToString:@""]) {
        
        valid = false;
    }
    
    return valid;
    
}

-(BOOL)validateResetPasswordFields:(NSString **)message {
    
    BOOL valid = true;
    
    if([self.txtPassword.text isEqualToString:@""]) {
        
        valid = false;
        *message = @"Password cannot be blank";
    }
    else if([self.txtOTP.text isEqualToString:@""]) {
        
        valid = false;
        *message = @"Please enter OTP";
    }
    else  if([self.txtConfirmPassword.text isEqualToString:@""]) {
        
        valid = false;
        *message = @"Confirm Password cannot be blank";
    }
    else if(![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
        
        valid = false;
        *message = @"Password and confirm password do not match.";
    }
    
    return valid;
    
}


-(void) hideKeyBoard {
    [self.view endEditing:YES];
}

-(void)popVCWithDelay {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSubmitForResetClicked:(id)sender {
    
    NSString *strErrorMessage = nil;
    
    BOOL isValid = [self validateResetPasswordFields:&strErrorMessage];
    
    if(isValid) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Please wait...";
        
        ServiceManger *service = [ServiceManger sharedInstance];
        
        NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary *dictPara = [[NSMutableDictionary alloc] init];
        [dictPara setObject:self.txtProfile.text forKey:@"usr"];
        [dictPara setObject:self.txtConfirmPassword.text
                     forKey:@"npwd"];
        [dictPara setObject:self.txtOTP.text
                     forKey:@"pin"];
        
        [service setPasswordService:dictPara withCallback:^(NSDictionary *dictResponse) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(dictResponse) {
                
                NSString *status = [[dictResponse objectForKey:@"Status"] objectForKey:@"Message"];
                
                if([status isEqualToString:@"OK"]) {
                    
                    [Utils showToastWithMessage:[[dictResponse objectForKey:@"Response"] objectForKey:@"ShowMessage"] ];
                    
                    self.profileView.hidden = true;
                    self.resetView.hidden = false;
                    
                    [self performSelector:@selector(popVCWithDelay) withObject:nil afterDelay:1];
                    
                    
                }
                else {
                    
                    [Utils showToastWithMessage:@"Error in changing password."];
                    
                }
                
            }
            else {
                
                
                [Utils showToastWithMessage:@"Invalid Response"];
                
            }
            NSLog(@"response : >>>>>> %@", dictResponse);
        }];
    }
    else {
        
        [Utils showToastWithMessage:strErrorMessage];
    }
}



-(IBAction)btnSubmitClicked {
    
    if([self validateProfile]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Please wait...";
        
        ServiceManger *service = [ServiceManger sharedInstance];
        
        NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary *dictPara = [[NSMutableDictionary alloc] init];
        //[dictPara setObject:[userPref valueForKey:@"UserName"] forKey:@"usr"];
        //[dictPara setObject:[userPref valueForKey:@"ProfileId"] forKey:@"pid"];
         
         [dictPara setObject:self.txtProfile.text forKey:
          @"data"];
        
        [dictPara setObject:self.txtProfile.text forKey:@"usr"];
         
        //    [dictPara setObject:[userPref valueForKey:@"Token"] forKey:@"Token"];
        
        [service ForgetPasswordService:dictPara withCallback:^(NSDictionary *dictResponse) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(dictResponse) {
                
                NSString *status = [[dictResponse objectForKey:@"Status"] objectForKey:@"Message"];
                
                if([status isEqualToString:@"OK"]) {
                    
                    [Utils showToastWithMessage:[[dictResponse objectForKey:@"Response"] objectForKey:@"ShowMessage"] ];
                    
                    self.profileView.hidden = true;
                    self.resetView.hidden = false;
                }
                else {
                    
                    [Utils showToastWithMessage:@"Invalid Username / Profile Id"];
                    
                }
                
            }
            else {
                
                
                [Utils showToastWithMessage:@"Invalid Response"];
                
            }
            
            NSLog(@"response : >>>>>> %@", dictResponse);
        }];
    }
    else {
        
        [Utils showToastWithMessage:@"Invalid Profile"];
        
    }
}

-(void) backbtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)doInitialConfiguration {
    
    
    UITapGestureRecognizer *single_tap_recognizer;
    single_tap_recognizer = [[UITapGestureRecognizer alloc] initWithTarget : self action: @selector(hideKeyBoard)];
    [single_tap_recognizer setNumberOfTouchesRequired : 1];
    [self.view addGestureRecognizer : single_tap_recognizer];
    
    
    
    self.forgotCase = profile;
    
    self.profileView.hidden = false;
    self.resetView.hidden = true;
}

- (void)configureNavigationBar
{
    
    
    self.navigationController.navigationBarHidden = FALSE;
    
    self.title = @"Forgot Password";
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu_1"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backbtn:)];
    
    self.navigationItem.leftBarButtonItem = btn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self doInitialConfiguration];
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
