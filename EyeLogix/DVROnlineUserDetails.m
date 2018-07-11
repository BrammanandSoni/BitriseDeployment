//
//  DVROnlineUserDetails.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/16/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVROnlineUserDetails.h"

@implementation DVROnlineUserDetails

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.loginIp = [dict objectForKey:@"LoginIp"];
        self.loginTime = [dict objectForKey:@"LoginTime"];
        self.userName = [dict objectForKey:@"UserName"];
        self.userType = [dict objectForKey:@"UserType"];
        self.name = [dict objectForKey:@"Name"];
    }
    
    return self;
}

@end
