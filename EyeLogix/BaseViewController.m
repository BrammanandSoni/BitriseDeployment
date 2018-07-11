//
//  BaseViewController.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/17/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar
{
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu_1"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backbtn:)];
    
    self.navigationItem.leftBarButtonItem = btn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void) backbtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
