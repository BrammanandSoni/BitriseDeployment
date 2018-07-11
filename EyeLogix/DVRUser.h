//
//  DVRUser.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/19/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVRUser : NSObject

@property (nonatomic, strong) NSString *operatorId;
@property (nonatomic, strong) NSString *userName;

- (id)initWithDict:(NSDictionary *)dict;

@end
