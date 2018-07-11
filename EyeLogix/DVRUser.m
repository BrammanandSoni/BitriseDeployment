//
//  DVRUser.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/19/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRUser.h"

@implementation DVRUser

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.operatorId = [dict objectForKey:@"OperatorId"];
        self.userName = [dict objectForKey:@"UserName"];
    }
    
    return self;
}

@end
