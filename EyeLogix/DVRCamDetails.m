//
//  DVRCamDetails.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/21/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRCamDetails.h"

@implementation DVRCamDetails

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.camId = [dict objectForKey:@"CamId"];
        self.location = [dict objectForKey:@"Location"];
        self.camTitle = [dict objectForKey:@"CamTitle"];
        self.package = [dict objectForKey:@"Package"];
        self.validity = [dict objectForKey:@"Validity"];
        self.status = [dict objectForKey:@"Status"];
        self.amount = [dict objectForKey:@"Amount"];
    }
    
    return self;
}

@end
