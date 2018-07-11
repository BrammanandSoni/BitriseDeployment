//
//  LeftEyeLogixVC.h
//  EyeLogix
//
//  Created by Smriti on 4/26/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CamListingVC;

@interface LeftEyeLogixVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

{
    
    NSMutableArray *arrCategory;
    NSMutableArray *arrImages;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;

// keep the instance of Cam List VC to avoid the repeated server calls. The same instance will be reused to show cam list when opened from Left Menu
@property(nonatomic, strong)CamListingVC *camListVC;



@end
