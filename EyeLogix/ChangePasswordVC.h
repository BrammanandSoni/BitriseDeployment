//
//  ChangePasswordVC.h
//  EyeLogix
//
//  Created by Smriti on 5/24/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordVC : UIViewController {
    
    __weak IBOutlet UITextField *currentpassTxt;
    __weak IBOutlet UITextField *newpassTxt;
    __weak IBOutlet UITextField *confirmpassTxt;

}

- (IBAction)tabSubmit: (id)sender;


@end
