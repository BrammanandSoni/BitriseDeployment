//
//  LoginService.h
//  Houserie
//
//  Created by JITENDER on 03/02/14.
//  Copyright (c) 2014 GSLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpService.h"



@interface WebService : NSObject
{
    int httpstatuscode;
    HTTPService *httpService;
}

+ (id)sharedInstance;
+ (void)cancelRequest;

typedef void(^GetNearByCallback) (NSArray *arrayResponse);
typedef void(^GetPropertyCallback) (NSArray *arrayResponse);


- (void) GetNearBy: (NSString *)strURL
   withCallback: (GetNearByCallback)callback;

- (void) GetPropertyDetails: (NSDictionary *)dictPara
    withCallback: (GetPropertyCallback)callback;





@end
