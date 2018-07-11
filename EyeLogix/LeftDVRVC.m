//
//  LeftDVRVC.m
//  EyeLogix
//
//  Created by Smriti on 4/26/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "LeftDVRVC.h"
#import "DVRCell.h"

#import "LocationVC.h"
#import "FavouriteVC.h"
#import "PlayBackVC.h"
#import "GalleryVC.h"
#import "SettingVC.h"

 


@interface LeftDVRVC ()

@end

@implementation LeftDVRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:193.0f/255.0f green:52.0f/255.0f blue:44.0f/255.0f alpha:1]];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    arrCategory=  [[NSMutableArray alloc] initWithObjects:@"Location",@"Favourite",@"PlayBack", @"Gallery",  @"Settings", @"Logout", nil];
    
    arrImages = [[NSMutableArray alloc] initWithObjects:@"Location",@"Favourite",@"PlayBack", @"Gallery",  @"Settings", @"Logout", nil];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrCategory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DVRCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVRCell" forIndexPath:indexPath];
    [cell.lblTitle setTextAlignment:NSTextAlignmentLeft];
    [cell.lblTitle setText:[arrCategory objectAtIndex:indexPath.row]];
    [cell.imgIcon setImage:[UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (indexPath.row == 0) {
        LocationVC *vc;
        vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LocationVC"];
        
//        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:self.slideOutAnimationEnabled andCompletion:nil];
        
    }
    
    else if (indexPath.row == 1)
    {
        
        FavouriteVC *vc;
        vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FavouriteVC"];
        
//        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:self.slideOutAnimationEnabled andCompletion:nil];
        
    }
    
     else if (indexPath.row == 2)
     {
     PlayBackVC *vc;
     vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PlayBackVC"];
     
//     [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:self.slideOutAnimationEnabled andCompletion:nil];
     
     }
     else if (indexPath.row == 3)
     {
     GalleryVC *vc;
     vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GalleryVC"];
     
//     [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:self.slideOutAnimationEnabled andCompletion:nil];
     
     }
     else if (indexPath.row == 4)
     {
     SettingVC *vc;
     vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SettingVC"];
     
//     [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:self.slideOutAnimationEnabled andCompletion:nil];
     
     }
}

@end

    
    
    
    
    
    
    
    
    
    
    
    
    
