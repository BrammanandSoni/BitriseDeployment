//
//  LeftDVRVC.h
//  EyeLogix
//
//  Created by Smriti on 4/26/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftDVRVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

{
    
    NSMutableArray *arrCategory;
    NSMutableArray *arrImages;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;



@end
