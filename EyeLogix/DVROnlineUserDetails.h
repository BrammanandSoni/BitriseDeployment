//
//  DVROnlineUserDetails.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/16/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVRListBaseModel.h"

@interface DVROnlineUserDetails : DVRListBaseModel

@property (nonatomic, strong) NSString *loginIp;
@property (nonatomic, strong) NSString *loginTime;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *name;

- (id)initWithDict:(NSDictionary *)dict;

@end
