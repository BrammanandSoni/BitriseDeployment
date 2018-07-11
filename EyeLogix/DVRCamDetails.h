//
//  DVRCamDetails.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/21/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVRCamDetails : NSObject

@property (nonatomic, strong) NSString *camId;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *camTitle;
@property (nonatomic, strong) NSString *package;
@property (nonatomic, strong) NSString *validity;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *amount;

- (id)initWithDict:(NSDictionary *)dict;

@end
