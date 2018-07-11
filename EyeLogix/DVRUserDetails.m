//
//  DVRUserDetails.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/16/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRUserDetails.h"

@implementation DVRUserDetails

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.operatorName = [dict objectForKey:@"OperatorName"];
        self.userName = [dict objectForKey:@"UserName"];
        self.operatorStatus = [dict objectForKey:@"OperatorStatus"];
        self.operatorId = [dict objectForKey:@"OperatorId"];
        self.operatorType = [dict objectForKey:@"OperatorType"];
        self.operatorIP = [dict objectForKey:@"OperatorIP"];
    }
    
    return self;
}

@end
