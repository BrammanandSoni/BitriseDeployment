//
//  DashboardVC.m
//  EyeLogix
//
//  Created by Smriti on 4/19/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "DashboardVC.h"
#import "LoginVC.h"
#import "LocationVC.h"
#import "LeftDVRVC.h"
#import "CamListingVC.h"
#import "SlideNavigationController.h"
#import "LeftEyeLogixVC.h"
#import "TutorialsViewController.h"
#import "Utils.h"

@interface DashboardVC ()

@property (nonatomic, strong) TutorialsViewController *tutVC;

@end

@implementation DashboardVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tutVC = (TutorialsViewController *)[Utils getViewControllerWithIdentifier:@"TutorialsViewController"];
    self.tutVC.view.frame = self.view.frame;
    [self.view addSubview:self.tutVC.view];
    [self addChildViewController:self.tutVC];
    [self.tutVC didMoveToParentViewController:self];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
//    self.navigationController.navigationBarHidden = YES;
}

#pragma marks - Button

-(IBAction)clickDVR: (id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginVC *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    
    [self.navigationController pushViewController:loginVC animated:YES];
    
}



-(IBAction)clickEyeLogix: (id)sender{
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    CamListingVC *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"CamListingVC"];
//    
//    LeftEyeLogixVC *leftVC = (LeftEyeLogixVC *)[SlideNavigationController sharedInstance].leftMenu;
//    leftVC.camListVC = loginVC;
//    
//    [self.navigationController pushViewController:loginVC animated:YES];
    
}



@end
