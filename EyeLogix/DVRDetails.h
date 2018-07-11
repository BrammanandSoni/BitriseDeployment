//
//  DVRDetails.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/20/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVRDetails : NSObject

@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *storeTitle;

- (id)initWithDict:(NSDictionary *)dict;

@end
