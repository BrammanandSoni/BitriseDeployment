//
//  ChangePasswordDetails.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/23/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangePasswordDetails : NSObject

@property (nonatomic, strong) NSString *oldPassword;
@property (nonatomic, strong) NSString *newpassword;
@property (nonatomic, strong) NSString *confirmPassword;

@end
