//
//  DataHandler.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/22/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "DataHandler.h"
#import "ServiceManger.h"
#import "Utils.h"

@implementation DataHandler

+ (instancetype)sharedInstance {
    static DataHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (void)setReloadCamList:(BOOL)reloadCamList
{
    if (reloadCamList) {
        [self callService];
    }
}

-(void) callService {
    
    ServiceManger *service = [ServiceManger sharedInstance];
    NSDictionary *params = @{@"UserName": [Utils getUserName], @"ProfileId": [Utils getProfileId], @"Token": [Utils getToken]};
    
    [service GetVideoLinks:params withCallback:^(NSArray *arrayResponse) {
        
        if (arrayResponse) {
            [DataHandler sharedInstance].camListArray = arrayResponse;
        }
    }];
}

@end
