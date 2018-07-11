//
//  ForgetPasswordVC.h
//  EyeLogix
//
//  Created by Smriti on 5/13/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordVC : UIViewController{
    
    __weak IBOutlet UITextField *newpassTxt;
    __weak IBOutlet UITextField *confirmpassTxt;
}

- (IBAction)tabSubmit: (id)sender;


@end
