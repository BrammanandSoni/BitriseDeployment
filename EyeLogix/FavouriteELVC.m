//
//  FavouriteELVC.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/8/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "FavouriteELVC.h"
#import "SlideNavigationController.h"

@interface FavouriteELVC ()<SlideNavigationControllerDelegate>

@end

@implementation FavouriteELVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Favourite Preview";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
