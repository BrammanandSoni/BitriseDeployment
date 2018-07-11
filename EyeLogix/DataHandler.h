//
//  DataHandler.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/22/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandler : NSObject

@property (nonatomic, strong) NSArray *camListArray;
@property (nonatomic) BOOL reloadCamList;

+ (instancetype)sharedInstance;

@end
