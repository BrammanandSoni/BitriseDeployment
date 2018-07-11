//
//  ChangePasswordVC.m
//  EyeLogix
//
//  Created by Smriti on 5/24/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "ServiceManger.h"
#import "MBProgressHUD.h"
#import "Utils.h"


@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC


-(BOOL)validateResetPasswordFields:(NSString **)message {
    
    BOOL valid = true;
    
    if([currentpassTxt.text isEqualToString:@""]) {
        
        valid = false;
        *message = @"Please enter Current Password.";
    }
    else if([newpassTxt.text isEqualToString:@""]) {
        
        valid = false;
        *message = @"Please enter New Password";
    }
    else  if([confirmpassTxt.text isEqualToString:@""]) {
        
        valid = false;
        *message = @"Please enter Confirm Password";
    }
    else if (![currentpassTxt.text isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"Password"]]) {
        
        valid = false;
        *message = @"Current password is incorrect.";
    }
    
    else if(![newpassTxt.text isEqualToString:confirmpassTxt.text]) {
        
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

-(void) backbtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)doInitialConfiguration {
    
    
    UITapGestureRecognizer *single_tap_recognizer;
    single_tap_recognizer = [[UITapGestureRecognizer alloc] initWithTarget : self action: @selector(hideKeyBoard)];
    [single_tap_recognizer setNumberOfTouchesRequired : 1];
    [self.view addGestureRecognizer : single_tap_recognizer];
}

- (void)configureNavigationBar
{
    
    
    self.navigationController.navigationBarHidden = FALSE;
    
    self.title = @"Change Password";
    
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

#pragma marks -Button

- (IBAction)tabSubmit: (id)sender {

    NSString *strErrorMessage = nil;
    
    BOOL isValid = [self validateResetPasswordFields:&strErrorMessage];
    
    if(isValid) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        
        
        hud.labelText = @"Please wait...";
        NSDictionary *parameter = @{@"pwd":currentpassTxt.text,@"npwd":newpassTxt.text,@"usr":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"], @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"], @"pid":[[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileId"]
                                    };
        
        ServiceManger *service  = [ServiceManger sharedInstance];
        
        
        
        [service ChangePasswordService:parameter withCallback:^(NSDictionary *dictResponse) {
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(dictResponse) {
                
                NSString *status = [[dictResponse objectForKey:@"Status"] objectForKey:@"Message"];
                
                if([status isEqualToString:@"OK"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:confirmpassTxt.text forKey:@"Password"];
                    [self popVCWithDelay];
                }
                
                [Utils showToastWithMessage:[[dictResponse objectForKey:@"Response"] objectForKey:@"ShowMessage"] ];
            }
            else {
 
                [Utils showToastWithMessage:@"Invalid Response"];
                
            }

        }];
 
    }
    else {
        
        [Utils showToastWithMessage:strErrorMessage];
    }

    


}

@end
