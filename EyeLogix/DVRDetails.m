//
//  DVRDetails.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/20/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRDetails.h"

@implementation DVRDetails

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.storeId = [dict objectForKey:@"StoreId"];
        self.storeTitle = [dict objectForKey:@"StoreTitle"];
    }
    
    return self;
}

@end
