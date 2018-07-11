//
//  ServiceManger.h
//  EyeLogix
//
//  Created by Smriti on 4/24/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpService.h"
#import "FilterItem.h"
#import "DVRStoreDetails.h"
#import "DVRAllocationDetails.h"
#import "DVRDetails.h"
#import "NewUserDetails.h"

#define kResultPerPage 15

@interface ServiceManger : NSObject
{
    int httpstatuscode;
    HTTPService *httpService;
}

+ (id)sharedInstance;
+ (void)cancelRequest;

typedef void(^LoginCallback) (NSDictionary *dictResponse);
typedef void(^ForgetPasswordCallback) (NSDictionary *dictResponse);
typedef void(^VideoLinkCallback) (NSArray *arrayResponse);
typedef void(^CamFavListCallback) (NSArray *arrayResponse);
typedef void(^ChangePasswordCallback) (NSDictionary *dictResponse);
typedef void (^FavouriteCallback) (NSDictionary *dictResponse);

typedef void (^CompletionBlock) (NSDictionary *response, NSError *error);
typedef void(^SetPasswordCallback) (NSDictionary *dictResponse);

- (void) LoginService: (NSDictionary *)dictPara
      withCallback: (LoginCallback)callback;

- (void) ForgetPasswordService: (NSDictionary *)dictPara
         withCallback: (ForgetPasswordCallback)callback;

- (void) GetVideoLinks: (NSDictionary *)dictPara
                  withCallback: (VideoLinkCallback)callback;

- (void) GetCamFavList: (NSDictionary *)dictPara
          withCallback: (CamFavListCallback)callback;

- (void) ChangePasswordService: (NSDictionary *)dictPara
                  withCallback: (ChangePasswordCallback)callback;

- (void) setPasswordService: (NSDictionary *)dictPara
                  withCallback: (SetPasswordCallback)callback;

- (void)addToFavouriteServie:(NSDictionary *)params
                withCallback: (FavouriteCallback)callback;
- (void)deleteFromFavouriteServie:(NSDictionary *)params
                withCallback: (FavouriteCallback)callback;

- (void)getRecordingHoursWithParams:(NSDictionary *)params
                withCompletionBlock: (CompletionBlock)completionBlock;
- (void)getPlaybackURLWithParams:(NSDictionary *)params
             withCompletionBlock: (CompletionBlock)completionBlock;

- (void)getAlertsWithFilterItem:(FilterItem *)filterItem
        withCompletionBlock:(CompletionBlock)completionBlock;

- (void)getEventUrlWithEventId:(NSString *)eventId andCamId:(NSString *)camId
           withCompletionBlock:(CompletionBlock)completionBlock;

- (void)registerDeviceToken:(NSString *)deviceToken
        withCompletionBlock:(CompletionBlock)completionBlock;


- (void)getPushNotificationStatusWithCompletionBlock:(CompletionBlock)completionBlock;
- (void)setPushNotificationStatus:(BOOL)enable
              WithCompletionBlock:(CompletionBlock)completionBlock;

- (void)getFAQWithCompletionBlock:(CompletionBlock)completionBlock;

#pragma mark - DVR Mgmt Service calls

- (void)getDVRStoreListWithCompletionBlock:(CompletionBlock)completionBlock;
- (void)getDVRAlocationListWithCompletionBlock:(CompletionBlock)completionBlock;
- (void)getCamListWithCompletionBlock:(CompletionBlock)completionBlock;
- (void)getDVRUserListWithCompletionBlock:(CompletionBlock)completionBlock;
- (void)getDVROnlineUserListWithCompletionBlock:(CompletionBlock)completionBlock;
- (void)updateDVRDetails:(DVRStoreDetails *)storeDetails withCompletionBlock:(CompletionBlock)completionBlock;
- (void)updateAlocatedDVRWith:(DVRAllocationDetails *)allocationDetails andChangedDVRDetails:(DVRDetails *)dvrdetails withCompletionBlock:(CompletionBlock)completionBlock;
- (void)getDVRListWithOperatorId:(NSString *)operatorId withCompletionBlock:(CompletionBlock)completionBlock;
- (void)allocateDVRWithOperatorId:(NSString *)operatorId andStoreId:(NSString *)storeId withCompletionBlock:(CompletionBlock)completionBlock;
- (void)deleteDVRWithStoreId:(NSString *)storeId operatorId:(NSString *)operatorId andOperatorUserName:(NSString *)userName withCompletionBlock:(CompletionBlock)completionBlock;
- (void)deleteOperatorWithOperatorId:(NSString *)operatorId andOperatorName:(NSString *)operatorName withCompletionBlock:(CompletionBlock)completionBlock;
- (void)getOperatorPasswordWithOperatorId:(NSString *)operatorId withCompletionBlock:(CompletionBlock)completionBlock;
- (void)updatePasswordWithOperatorId:(NSString *)operatorId userName:(NSString *)userName currentPassword:(NSString *)currentPassword andNewPassword:(NSString *)newPassword withCompletionBlock:(CompletionBlock)completionBlock;
- (void)createUserWithNewUserDetails:(NewUserDetails *)userDetails withCompletionBlock:(CompletionBlock)completionBlock;
- (void)updateUserWithNewUserDetails:(NewUserDetails *)userDetails withCompletionBlock:(CompletionBlock)completionBlock;
- (void)getoperatorInfoWithOperatorId:(NSString *)operatorId withCompletionBlock:(CompletionBlock)completionBlock;
- (void)updateCamTitle:(NSString *)title withCamId:(NSString *)camId withCompletionBlock:(CompletionBlock)completionBlock;

@end
