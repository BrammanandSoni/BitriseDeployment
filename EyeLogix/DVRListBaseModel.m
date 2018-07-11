//
//  DVRListBaseModel.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/16/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRListBaseModel.h"

@implementation DVRListBaseModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isExpanded = NO;
    }
    return self;
}

@end
