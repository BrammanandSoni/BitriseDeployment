//
//  DVRAllocationDetails.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/19/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRListBaseModel.h"

@interface DVRAllocationDetails : DVRListBaseModel

@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *storeTitle;
@property (nonatomic, strong) NSString *storeAddress;
@property (nonatomic, strong) NSString *operatorId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *timeZone;

- (id)initWithDict:(NSDictionary *)dict;

@end
