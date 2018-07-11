//
//  FilterItem.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "FilterItem.h"

@implementation FilterItem

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.storeId = nil;
        self.startDateTime = nil;
        self.endDateTime = nil;
        self.eventType = nil;
        self.eventId = nil;
        self.pageNo = 1;
    }
    
    return self;
}

@end
