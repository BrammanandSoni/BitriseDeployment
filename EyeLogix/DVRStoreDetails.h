//
//  DVRStoreDetails.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/16/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVRListBaseModel.h"

@interface DVRStoreDetails : DVRListBaseModel <NSCopying>

@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *storeTitle;
@property (nonatomic, strong) NSString *storeAddress;
@property (nonatomic, strong) NSString *storeIP;
@property (nonatomic, strong) NSString *storeTimeZone;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *categoryId;

- (id)initWithDict:(NSDictionary *)dict;

@end
