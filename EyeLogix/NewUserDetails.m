//
//  NewUserDetails.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/25/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "NewUserDetails.h"

@implementation NewUserDetails

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.operatorId = [dict objectForKey:@"OperatorId"];
        self.userName = [dict objectForKey:@"UserName"];
        self.operatorName = [dict objectForKey:@"OperatorName"];
        self.mobile = [dict objectForKey:@"Mobile"];
        self.email = [dict objectForKey:@"Email"];
        self.address = [dict objectForKey:@"Address"];
        self.country = [dict objectForKey:@"Country"];
        self.state = [dict objectForKey:@"State"];
        self.city = [dict objectForKey:@"City"];
        self.pincode = [dict objectForKey:@"Pincode"];
        self.timeZone = [dict objectForKey:@"TimeZone"];
        self.access = [dict objectForKey:@"Access"];
        self.smsAlert = [[dict objectForKey:@"SmsAlert"] boolValue];
        self.emailAlert = [[dict objectForKey:@"EmailAlert"] boolValue];
        self.appAlert = [[dict objectForKey:@"AppAlert"] boolValue];
        self.operatorType = [dict objectForKey:@"OperatorType"];
        self.presence = [dict objectForKey:@"Presence"];
        self.sendMail = [dict objectForKey:@"SendMail"];
    }
    
    return self;
}

@end
