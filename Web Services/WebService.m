//
//  LoginService.m
//  Houserie
//
//  Created by JITENDER on 03/02/14.
//  Copyright (c) 2014 GSLab. All rights reserved.
//

#import "WebService.h"
#import "Constants.h"

@implementation WebService

+ (id)sharedInstance {
    static WebService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)cancelRequest
{
    HTTPService *service = [[HTTPService alloc] init];
    [service cancelService];
}

#pragma mark - Web Services

- (void) GetNearBy: (NSString *)strURL
      withCallback: (GetNearByCallback)callback {
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:strURL]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
                NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response : >>>>>>>> %@", strResponse);
        
        
        if (status != 200) {
//            [self showAlert:ERRORNETWORK title:@"Error"];
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
            callback([dictResponse valueForKey:@"results"]);
        
    } errorCallback:^(int status, NSError *error) {
        if (error != nil) {
            [self showAlert:error.description  title:@"Error"];
        }
    }];
}

- (void) GetPropertyDetails: (NSDictionary *)dictPara
               withCallback: (GetPropertyCallback)callback  {
    
    NSString *strURL = [NSString stringWithFormat:@"%@getProperty", BASE_URL];

    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:strURL]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:[self getJSONBody:dictPara]
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response : >>>>>>>> %@", strResponse);
        
        
        if (status != 200) {
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        callback([dictResponse valueForKey:@"data"]);
        
    } errorCallback:^(int status, NSError *error) {
        if (error != nil) {
            [self showAlert:error.description  title:@"Error"];
        }
    }];
}

#pragma mark - Other Methods

-(NSString *)getJSONBody : (NSDictionary *)dictPara {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictPara
                                                       options:0
                                                         error:&error];
    
    //NSString *strJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *strJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"strJSON : %@", strJSON);
    
    return strJSON;
}

-(void)showAlert : (NSString *)alertMessage title : (NSString *) paraTitle {
    
//    SingletonClass *singletonObj = [SingletonClass sharedInstance];
//    [singletonObj hideActivityIndicator];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:paraTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    
}


@end

