//
//  DVRUserDetails.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/16/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVRListBaseModel.h"

@interface DVRUserDetails : DVRListBaseModel

@property (nonatomic, strong) NSString *operatorName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *operatorStatus;
@property (nonatomic, strong) NSString *operatorId;
@property (nonatomic, strong) NSString *operatorType;
@property (nonatomic, strong) NSString *operatorIP;

- (id)initWithDict:(NSDictionary *)dict;

@end
