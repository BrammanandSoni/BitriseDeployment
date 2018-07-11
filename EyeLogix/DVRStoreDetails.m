//
//  DVRStoreDetails.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/16/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRStoreDetails.h"

@implementation DVRStoreDetails

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.storeId = [dict objectForKey:@"StoreId"];
        self.storeTitle = [dict objectForKey:@"StoreTitle"];
        self.storeAddress = [dict objectForKey:@"StoreAddress"];
        self.storeIP = [dict objectForKey:@"StoreIp"];
        self.storeTimeZone = [dict objectForKey:@"StoreTimeZone"];
        self.category = [dict objectForKey:@"Categoary"];
        self.status = [dict objectForKey:@"Status"];
        
        NSString *category = [dict objectForKey:@"Categoary"];
        if (![category isKindOfClass:[NSNull class]] && [category isEqualToString:@"Retail Store"]) {
            self.categoryId = [NSString stringWithFormat:@"%d", 1];
        }
        else if (![category isKindOfClass:[NSNull class]] && [category isEqualToString:@"Gas Station"]) {
            self.categoryId = [NSString stringWithFormat:@"%d", 2];
        }
        else if (![category isKindOfClass:[NSNull class]] && [category isEqualToString:@"Grocery Shop"]) {
            self.categoryId = [NSString stringWithFormat:@"%d", 3];
        }
        else {
            self.categoryId = [NSString stringWithFormat:@"%d", 0]; // Default Selected Category
        }
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    DVRStoreDetails *storeDetails = [[DVRStoreDetails alloc] init];
    
    storeDetails.storeId = self.storeId;
    storeDetails.storeTitle = self.storeTitle;
    storeDetails.storeAddress = self.storeAddress;
    storeDetails.storeIP = self.storeIP;
    storeDetails.storeTimeZone = self.storeTimeZone;
    storeDetails.category = self.category;
    storeDetails.status = self.status;
    
    storeDetails.categoryId = self.categoryId;
    
    return storeDetails;
}


@end
