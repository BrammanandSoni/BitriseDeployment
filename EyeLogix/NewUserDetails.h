//
//  NewUserDetails.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/25/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewUserDetails : NSObject

@property (nonatomic, strong) NSString *operatorId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *operatorName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *pincode;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, strong) NSString *access;
@property (nonatomic) BOOL smsAlert;
@property (nonatomic) BOOL emailAlert;
@property (nonatomic) BOOL appAlert;
@property (nonatomic, strong) NSString *operatorType;
@property (nonatomic, strong) NSString *presence;
@property (nonatomic, strong) NSString *sendMail;

@property (nonatomic, strong) NSString *password;

- (id)initWithDict:(NSDictionary *)dict;

@end
