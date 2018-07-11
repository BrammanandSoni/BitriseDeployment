//
//  ViewController.h
//  EyeLogix
//
//  Created by Smriti on 4/19/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController {
    
    __weak IBOutlet UITextField *userTxt;
    __weak IBOutlet UITextField *passTxt;
    __weak IBOutlet UIButton *btRemeber;
}

- (IBAction)tabLogin: (id)sender;

- (IBAction)forgetBtn: (id)sender;

@end

