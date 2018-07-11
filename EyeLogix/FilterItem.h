//
//  FilterItem.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterItem : NSObject

@property(nonatomic, strong) NSString *storeId;
@property(nonatomic, strong) NSString *startDateTime;
@property(nonatomic, strong) NSString *endDateTime;
@property(nonatomic, strong) NSString *eventType;
@property(nonatomic, strong) NSString *eventId;
@property(nonatomic, strong) NSString *storeNCamId;
@property(nonatomic) NSInteger pageNo;

@end
