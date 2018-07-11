//
//  LeftEyeLogixVC.m
//  EyeLogix
//
//  Created by Smriti on 4/26/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "LeftEyeLogixVC.h"
#import "EyeLogixCell.h"
#import "FavouriteELVC.h"
#import "PlayBackELVC.h"
#import "AlertELVC.h"
#import "GalleryELVC.h"
#import "SettingELVC.h"
#import "SlideNavigationController.h"
#import "CustomNavigationController.h"
#import "CamListingVC.h"
#import "LiveFootageVC.h"
#import "LoginVC.h"
#import "Utils.h"
#import "DataHandler.h"
#import "UIColor+CustomColor.h"

@interface LeftEyeLogixVC ()

@end

@implementation LeftEyeLogixVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:193.0f/255.0f green:52.0f/255.0f blue:44.0f/255.0f alpha:1]];
    

    self.automaticallyAdjustsScrollViewInsets = NO;
      arrCategory=  [[NSMutableArray alloc] initWithObjects:@"Location", @"Favourite", @"PlayBack", @"Alerts", @"Gallery", @"Settings", @"Admin", @"Logout", nil];
    
    arrImages = [[NSMutableArray alloc] initWithObjects:@"Location", @"Favourite", @"PlayBackYellow", @"Alerts", @"Gallery", @"Settings", @"Gallery", @"Logout", nil];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = [UIColor sideBackgroudColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
    
    return [super initWithCoder:aDecoder];
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrCategory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EyeLogixCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EyeLogixCell" forIndexPath:indexPath];
    [cell.lblTitle setTextAlignment:NSTextAlignmentLeft];
    [cell.lblTitle setText:[arrCategory objectAtIndex:indexPath.row]];
    [cell.imgIcon setImage:[UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.backgroundColor = [UIColor sideBackgroudColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadData];
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController;
    [SlideNavigationController sharedInstance].navigationBarHidden = NO;
    
    if (indexPath.row == 0) {
        
        if(self.camListVC) {
            
            viewController = self.camListVC;
        }
        else {
            
            viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CamListingVC"];
            self.camListVC = (CamListingVC *)viewController;
        }
        

    }
    
    else if (indexPath.row == 1)
    {
        NSMutableArray *favouritesAray = [NSMutableArray array];
        for (NSDictionary *storeDict in [[DataHandler sharedInstance] camListArray]) {
            NSArray *camsArray = [storeDict objectForKey:@"Cams"];
            for (NSDictionary *camsDict in camsArray) {
                if ([[camsDict objectForKey:@"IsFavourite"] boolValue]) {
                    [favouritesAray addObject:camsDict];
                }
            }
        }
        
        if (favouritesAray.count > 0) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LiveFootageVC *moviewvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LiveFootageVC"];
            moviewvc.screenType = ScreenTypeFavourite;
            [moviewvc showSelectedCamsArray:favouritesAray];
            viewController = moviewvc;
        }
        else {
            [Utils showToastWithMessage:@"No cam available in the favourite list"];
            return;
        }
    }
    
     else if (indexPath.row == 2)
     {

         viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PlayBackELVC"];
         
     }
     else if (indexPath.row == 3)
     {

         viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AlertELVC"];
         
     }
     else if (indexPath.row == 4)
     {
         viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GalleryELVC"];
         
         CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:viewController];
         nav.navigationBar.barTintColor = [SlideNavigationController sharedInstance].navigationBar.barTintColor;
         
         [[SlideNavigationController sharedInstance] presentViewController:nav animated:NO completion:nil];
         return;
     }
     else if (indexPath.row == 5)
     {
         viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SettingELVC"];
     }
     else if (indexPath.row == 6)
     {
         viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AdminViewController"];
         CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:viewController];
         nav.navigationBar.barTintColor = [SlideNavigationController sharedInstance].navigationBar.barTintColor;
         
         [[SlideNavigationController sharedInstance] presentViewController:nav animated:NO completion:nil];
         return;
     }
     else if (indexPath.row == 7)
     {
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Do you really want to logout?" preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
         UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [SlideNavigationController sharedInstance].navigationBarHidden = YES;
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             LoginVC *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
             
             [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:loginVC
                                                                      withSlideOutAnimation:NO
                                                                              andCompletion:nil];
             [Utils setAutoLoginFlag:NO];
             
             //[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController  withSlideOutAnimation:NO andCompletion:nil];
             
         }];
         [alertController addAction:cancelAction];
         [alertController addAction:okAction];
         
         [[SlideNavigationController sharedInstance] presentViewController:alertController animated:YES completion:nil];
         return;
     }
    

    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];
    
    
    //[[SlideNavigationController sharedInstance] pushViewController:viewController animated:NO];
    
}




@end
