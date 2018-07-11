//
//  SettingELVC.h
//  EyeLogix
//
//  Created by Smriti on 5/24/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingELVC : UIViewController {
    
    
    __weak IBOutlet UITextField *alertTxt;
    __weak IBOutlet UITextField *notificationTxt;
    __weak IBOutlet UITextField *loginTxt;
    __weak IBOutlet UITextField *helpTxt;
    __weak IBOutlet UITextField *passTxt;

}

- (IBAction)tabHelp: (id)sender;
- (IBAction)tabChangePassword: (id)sender;

@end


