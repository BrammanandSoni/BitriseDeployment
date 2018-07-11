//
//  DVRAllocationDetails.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/19/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRAllocationDetails.h"

@implementation DVRAllocationDetails

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.storeId = [dict objectForKey:@"StoreId"];
        self.storeTitle = [dict objectForKey:@"StoreTitle"];
        self.storeAddress = [dict objectForKey:@"StoreAddress"];
        self.operatorId = [dict objectForKey:@"OperatorId"];
        self.userName = [dict objectForKey:@"UserName"];
        self.dateTime = [dict objectForKey:@"DateTime"];
        self.name = [dict objectForKey:@"Name"];
        self.timeZone = [dict objectForKey:@"TimeZone"];
    }
    
    return self;
}

@end
