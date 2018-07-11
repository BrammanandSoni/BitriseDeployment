//
//  ServiceManger.m
//  EyeLogix
//
//  Created by Smriti on 4/24/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "ServiceManger.h"
#import "AppConstants.h"
#import "Utils.h"

@implementation ServiceManger
+ (id)sharedInstance {
    static ServiceManger *sharedInstance = nil;
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


- (void) LoginService: (NSDictionary *)dictPara
         withCallback: (LoginCallback)callback  {

    NSString *strURL = [NSString stringWithFormat:@"%@getvalidity.php?usr=%@&pwd=%@",BASE_URL, [dictPara valueForKey:@"usr"], [dictPara valueForKey:@"pwd"]];

    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:strURL]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        if (status != 200) {
            //            [self showAlert:ERRORNETWORK title:@"Error"];
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        callback(dictResponse);
        
    } errorCallback:^(int status, NSError *error) {
        
        callback(nil);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}


- (void) ForgetPasswordService: (NSDictionary *)dictPara
         withCallback: (ForgetPasswordCallback)callback {
    
//    NSString *strURL = [NSString stringWithFormat:@"%@forgetpassword.php?data=%@&sourceid=%@",BASE_URL, [dictPara valueForKey:@"ProfileId"], [dictPara valueForKey:@"sourceid"]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@forgetpassword.php?data=%@&sourceid=%@&usr=%@",BASE_URL,[dictPara objectForKey:@"data"], @"axsdrfesdg1254", [dictPara objectForKey:@"usr"]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:strURL]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:[self getJSONBody:dictPara]
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        if (status != 200) {
            //            [self showAlert:ERRORNETWORK title:@"Error"];
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        callback(dictResponse);
        
    } errorCallback:^(int status, NSError *error) {
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void) GetVideoLinks: (NSDictionary *)dictPara
          withCallback: (VideoLinkCallback)callback {
    
    
    NSString *strURL = [NSString stringWithFormat:@"%@getcamlist.php?usr=%@&pid=%@&token=%@",BASE_URL, [dictPara valueForKey:@"UserName"], [dictPara valueForKey:@"ProfileId"], [dictPara valueForKey:@"Token"]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:strURL]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        if (status != 200) {
            //            [self showAlert:ERRORNETWORK title:@"Error"];
            NSLog(@"Network error");
            return;
        }
        else    {
            
            NSDictionary *dictResponse = [[NSDictionary alloc] init];
            NSError * error = nil;
            dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if ([[[dictResponse valueForKey:@"Status"] valueForKey:@"Code"] integerValue] == 1) {
                callback([dictResponse valueForKey:@"Response"]);
            }
            else {
                [Utils showToastWithMessage:[dictResponse valueForKeyPath:@"Response.ShowMessage"]];
                callback(nil);
            }
        }
    } errorCallback:^(int status, NSError *error) {
        callback(nil);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}


- (void) GetCamFavList: (NSDictionary *)dictPara
          withCallback: (CamFavListCallback)callback {
   
    NSString *strURL = [NSString stringWithFormat:@"%@setfavourite.php?usr=%@&pid=%@&token=%@&alertid=%@",BASE_URL, [dictPara valueForKey:@"UserName"], [dictPara valueForKey:@"ProfileId"], [dictPara valueForKey:@"Token"], [dictPara valueForKey:@"AlertId"]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:strURL]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        if (status != 200) {
            //            [self showAlert:ERRORNETWORK title:@"Error"];
            NSLog(@"Network error");
            return;
        }
        else    {
            
            NSDictionary *dictResponse = [[NSDictionary alloc] init];
            NSError * error = nil;
            dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if ([[[dictResponse valueForKey:@"Status"] valueForKey:@"Code"] boolValue]) {
                callback([dictResponse valueForKey:@"Response"]);
            }
            
            
        }
        
        
    } errorCallback:^(int status, NSError *error) {
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void) ChangePasswordService: (NSDictionary *)dictPara
                  withCallback: (ChangePasswordCallback)callback {
    
    
    NSString *strURL = [NSString stringWithFormat:@"%@changepassword.php?usr=%@&pid=%@&token=%@&pwd=%@&npwd=%@",BASE_URL, [dictPara valueForKey:@"usr"], [dictPara valueForKey:@"pid"], [dictPara valueForKey:@"token"], [dictPara valueForKey:@"pwd"], [dictPara valueForKey:@"npwd"]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:strURL]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        if (status != 200) {
            //            [self showAlert:ERRORNETWORK title:@"Error"];
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        callback(dictResponse);
        
    } errorCallback:^(int status, NSError *error) {
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
    
}


- (void)setPasswordService:(NSDictionary *)dictPara
              withCallback:(SetPasswordCallback)callback {

    
    NSString *strURL = [NSString stringWithFormat:@"%@setpassword.php?usr=%@&npwd=%@&pin=%@",BASE_URL, [dictPara valueForKey:@"usr"], [dictPara valueForKey:@"npwd"], [dictPara valueForKey:@"pin"]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:strURL]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        if (status != 200) {
            //            [self showAlert:ERRORNETWORK title:@"Error"];
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        callback(dictResponse);
        
    } errorCallback:^(int status, NSError *error) {
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];

}

- (void)favouriteServiveWithURL:(NSString *)url andParams:(NSDictionary *)params
                   withCallback: (FavouriteCallback)callback
{
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:url]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        callback(dictResponse);
        
    } errorCallback:^(int status, NSError *error) {
        callback(nil);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)addToFavouriteServie:(NSDictionary *)params
                withCallback: (FavouriteCallback)callback
{
    NSString *strURL = [NSString stringWithFormat:@"%@setfavourite.php?usr=%@&pid=%@&token=%@&camid=%@&act=set",BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], [params valueForKey:@"camid"]];
    
    [self favouriteServiveWithURL:strURL andParams:params withCallback:callback];
}

- (void)deleteFromFavouriteServie:(NSDictionary *)params
                     withCallback: (FavouriteCallback)callback
{
    NSString *strURL = [NSString stringWithFormat:@"%@setfavourite.php?usr=%@&pid=%@&token=%@&camid=%@&act=unset",BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], [params valueForKey:@"camid"]];
    
    [self favouriteServiveWithURL:strURL andParams:params withCallback:callback];
}

- (void)getRecordingHoursWithParams:(NSDictionary *)params
                withCompletionBlock: (CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@getrecordinghours.php?usr=%@&pid=%@&token=%@&camid=%@&sdate=%@",BASE_URL1, [Utils getUserName], [Utils getProfileId], [Utils getToken], [params valueForKey:@"camid"], [params valueForKey:@"date"]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:strURL]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        completionBlock([dictResponse valueForKeyPath:@"0.Response"], nil);
        
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getPlaybackURLWithParams:(NSDictionary *)params
             withCompletionBlock: (CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@getplaybackurl2.php?usr=%@&pid=%@&token=%@&camid=%@&dtt=%@",BASE_URL1, [Utils getUserName], [Utils getProfileId], [Utils getToken], [params valueForKey:@"camid"], [params valueForKey:@"datetime"]];
    
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        completionBlock([dictResponse valueForKeyPath:@"0.Response"], nil);
        
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getAlertsWithFilterItem:(FilterItem *)filterItem
            withCompletionBlock:(CompletionBlock)completionBlock
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@getalerts.php?usr=%@&pid=%@&token=%@", BASE_URL1, [Utils getUserName], [Utils getProfileId], [Utils getToken]];
    
    if (filterItem.storeId) {
        [urlString appendFormat:@"&store=%@", filterItem.storeId];
    }
    
    if (filterItem.startDateTime) {
        [urlString appendFormat:@"&stt=%@", filterItem.startDateTime];
    }
    
    if (filterItem.endDateTime) {
        [urlString appendFormat:@"&ett=%@", filterItem.endDateTime];
    }
    
    if (filterItem.eventType) {
        [urlString appendFormat:@"&title=%@", filterItem.eventType];
    }
    
    if (filterItem.eventId) {
        [urlString appendFormat:@"&eventid=%@", filterItem.eventId];
    }
    
    if (filterItem.storeNCamId) {
        [urlString appendFormat:@"&data=%@", filterItem.storeNCamId];
    }
    
    if (filterItem.pageNo) {
        [urlString appendFormat:@"&page=%ld", (long)filterItem.pageNo];
    }
    
    [urlString appendFormat:@"&count=%d", kResultPerPage];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        completionBlock([dictResponse valueForKeyPath:@"0"], nil);
        
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getEventUrlWithEventId:(NSString *)eventId andCamId:(NSString *)camId
           withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@geteventurl2.php?usr=%@&pid=%@&token=%@&eventid=%@&camid=%@",BASE_URL1, [Utils getUserName], [Utils getProfileId], [Utils getToken], eventId, camId];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        completionBlock([dictResponse valueForKeyPath:@"0.Response"], nil);
        
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)registerDeviceToken:(NSString *)deviceToken
        withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *dataString = [NSString stringWithFormat:@"%@^%@^ios%@", deviceToken, [Utils deviceModel], [Utils iOSVersion]];
    NSString *strURL = [NSString stringWithFormat:@"%@appregistration.php?usr=%@&pid=%@&token=%@&act=set&imei=UCID&data=%@",BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], dataString];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        completionBlock([dictResponse valueForKeyPath:@"Response"], nil);
        
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getPushNotificationStatusWithCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@getpushnotificationbit.php?usr=%@&pid=%@&token=%@&imei=%@&act=get",BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], [Utils getDeviceToken]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        completionBlock(dictResponse, nil);
        
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)setPushNotificationStatus:(BOOL)enable
              WithCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@getpushnotificationbit.php?usr=%@&pid=%@&token=%@&imei=%@&act=set&bit=%d",BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], [Utils getDeviceToken], enable];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        completionBlock(dictResponse, nil);
        
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getFAQWithCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@getdvrfaqs.php?usr=%@&pid=%@&token=%@",BASE_URL1, [Utils getUserName], [Utils getProfileId], [Utils getToken]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodPOST];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            NSLog(@"Network error");
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        completionBlock([dictResponse valueForKeyPath:@"0.Response"], nil);
        
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

#pragma mark - DVR Mgmt Service calls

- (void)getDVRStoreListWithCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@gtstorelist?usr=%@&uid=%@&token=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock([dictResponse valueForKeyPath:@"Response"], nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getDVRAlocationListWithCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@vwstorealoc?usr=%@&uid=%@&token=%@&usrtype=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], @"admin"];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock(dictResponse, nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getCamListWithCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@gtcamlit?usr=%@&uid=%@&token=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock([dictResponse valueForKeyPath:@"Response"], nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getDVRUserListWithCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@gtoptlit?usr=%@&uid=%@&token=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock([dictResponse valueForKeyPath:@"Response"], nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
        
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getDVROnlineUserListWithCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@gtcurroptlit?usr=%@&uid=%@&token=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken]];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock([dictResponse valueForKeyPath:@"Response"], nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            //[self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)updateDVRDetails:(DVRStoreDetails *)storeDetails withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@doupdstore?usr=%@&uid=%@&token=%@&sid=%@&title=%@&cat=%@&add=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], storeDetails.storeId, storeDetails.storeTitle, storeDetails.categoryId, storeDetails.storeAddress];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock(dictResponse, nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)updateAlocatedDVRWith:(DVRAllocationDetails *)allocationDetails andChangedDVRDetails:(DVRDetails *)dvrdetails withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@dochgallocatedstore?usr=%@&uid=%@&token=%@&sid=%@&psid=%@&pstrtitle=%@&opid=%@&usrname=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], dvrdetails.storeId, allocationDetails.storeId, allocationDetails.storeTitle, allocationDetails.operatorId, allocationDetails.userName];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock(dictResponse, nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getDVRListWithOperatorId:(NSString *)operatorId withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@dogtstore?usr=%@&uid=%@&token=%@&opid=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], operatorId];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock([dictResponse valueForKeyPath:@"Response"], nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)allocateDVRWithOperatorId:(NSString *)operatorId andStoreId:(NSString *)storeId withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@doalocstorepro?usr=%@&uid=%@&token=%@&sid=%@&opid=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], storeId, operatorId];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock(dictResponse, nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)deleteDVRWithStoreId:(NSString *)storeId operatorId:(NSString *)operatorId andOperatorUserName:(NSString *)userName withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@dodelallocatedstore?usr=%@&uid=%@&token=%@&sid=%@&opid=%@&usrname=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], storeId, operatorId, userName];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock(dictResponse, nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)deleteOperatorWithOperatorId:(NSString *)operatorId andOperatorName:(NSString *)operatorName withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@dodelopt?usr=%@&uid=%@&token=%@&opid=%@&usrname=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], operatorId, operatorName];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock(dictResponse, nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getOperatorPasswordWithOperatorId:(NSString *)operatorId withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@gtoptpwd?usr=%@&uid=%@&token=%@&opid=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], operatorId];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock([dictResponse valueForKeyPath:@"Response.0"], nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)updatePasswordWithOperatorId:(NSString *)operatorId userName:(NSString *)userName currentPassword:(NSString *)currentPassword andNewPassword:(NSString *)newPassword withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@dopwdrst?usr=%@&uid=%@&token=%@&opid=%@&usrname=%@&cpass=%@&npass=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], operatorId, userName, currentPassword, newPassword];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock(dictResponse, nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)createUserWithNewUserDetails:(NewUserDetails *)userDetails withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@docreopt?usr=%@&uid=%@&token=%@&usrtype=%@&usrname=%@&pass=%@&name=%@&num=%@&email=%@&add=%@&city=%@&state=%@&pincode=%@&country=%@&timezone=%@&access=%@&smsalert=%d&emailalert=%d&appalert=%d", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], userDetails.operatorType, userDetails.userName, userDetails.password, userDetails.operatorName, userDetails.mobile, userDetails.email, userDetails.address, userDetails.city, userDetails.state, userDetails.pincode, userDetails.country, userDetails.timeZone, userDetails.access, userDetails.smsAlert, userDetails.emailAlert, userDetails.appAlert];
    
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock(dictResponse, nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)updateUserWithNewUserDetails:(NewUserDetails *)userDetails withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@doupdateopt?usr=%@&uid=%@&token=%@&optId=%@&optname=%@&num=%@&email=%@&add=%@&city=%@&state=%@&pincode=%@&country=%@&status=ACTIVE&timezone=%@&access=%@&smsalert=%d&emailalert=%d&apialert=%d&pre=0&sendmail=0", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], userDetails.operatorId, userDetails.operatorName, userDetails.mobile, userDetails.email, userDetails.address, userDetails.city, userDetails.state, userDetails.pincode, userDetails.country, userDetails.timeZone, userDetails.access, userDetails.smsAlert, userDetails.emailAlert, userDetails.appAlert];
    
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock(dictResponse, nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)getoperatorInfoWithOperatorId:(NSString *)operatorId withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@dovwopt?usr=%@&uid=%@&token=%@&opid=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], operatorId];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock([dictResponse valueForKeyPath:@"Response.0"], nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
        }
    }];
}

- (void)updateCamTitle:(NSString *)title withCamId:(NSString *)camId withCompletionBlock:(CompletionBlock)completionBlock
{
    NSString *strURL = [NSString stringWithFormat:@"%@doupdcam?usr=%@&uid=%@&token=%@&camid=%@&camtitle=%@", DVR_BASE_URL, [Utils getUserName], [Utils getProfileId], [Utils getToken], camId, title];
    
    HTTPService *service = [[HTTPService alloc] initWithUrl:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
                                                     accept:HttpService_APPLICATION_JSON
                                                contentType:HttpService_APPLICATION_JSON
                                                   httpBody:nil
                                                     cookie:@""
                                                 httpMethod:RequestMethodGET];
    
    [service makeRequestSuccessCallback:^(int status, NSData *data) {
        
        if (status != 200) {
            [self showAlert:@"Network error"  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: @"Network error"}];
            completionBlock(nil, err);
            return;
        }
        
        NSDictionary *dictResponse = [[NSDictionary alloc] init];
        NSError * error = nil;
        dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([dictResponse[@"Status"] isEqualToString:@"OK"]) {
            completionBlock(dictResponse, nil);
        }
        else {
            NSString *serverErrorMessage = [dictResponse valueForKeyPath:@"Response.0"];
            NSString *errorMessage = serverErrorMessage != nil ? serverErrorMessage : @"Network error";
            [self showAlert:errorMessage  title:@"Error"];
            NSError *err = [NSError errorWithDomain:@"" code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            completionBlock(nil, err);
        }
    } errorCallback:^(int status, NSError *error) {
        completionBlock(nil, error);
        if (error != nil) {
            [self showAlert:error.localizedDescription  title:@"Error"];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:paraTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    
}

@end
