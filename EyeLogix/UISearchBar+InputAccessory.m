//
//  UISearchBar+InputAccessory.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/26/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "UISearchBar+InputAccessory.h"

@implementation UISearchBar (InputAccessory)

- (void)showAccessoryViewWithButtonTitle:(NSString *)title
{
    CGFloat width = [[UIApplication sharedApplication]  keyWindow].bounds.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [view.layer setBorderWidth:0.5f];
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(width - 80, 5, 70, 30)];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [button.layer setCornerRadius:5.0f];
    
    [button addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    
    self.inputAccessoryView = view;
    [self reloadInputViews];
}

- (void)hideKeyBoard
{
    [self resignFirstResponder];
}

@end
