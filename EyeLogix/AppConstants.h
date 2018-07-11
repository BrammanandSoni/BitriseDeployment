//
//  AppConstants.h
//  EyeLogix
//
//  Created by Smriti on 4/24/16.
//  Copyright © 2016 Smriti. All rights reserved.
//



#import "AppConstants.h"

#define BASE_URL @"http://live.eyelogix.in:8080/dvrlive/iosappapi/"
#define BASE_URL @"http://live.eyelogix.in:8080/dvrlive/iosappapi/"
#define BASE_URL1 @"http://live.eyelogix.in:8080/dvrlive/appsapi/"
#define DVR_BASE_URL @"http://mgm.eyelogix.in/dvr/"


#define LoggerStream(level, ...)   NSLog(__VA_ARGS__)
#define LoggerVideo(level, ...)    NSLog(__VA_ARGS__)
#define LoggerAudio(level, ...)    NSLog(__VA_ARGS__)
#define LoggerApp(level, ...)   NSLog(__VA_ARGS__)

typedef enum : NSUInteger {
    DVRMgmt,
    DVRAllocation,
    CamMgmt,
    User,
    OnlineUser
} DVRMgmtTabType;

typedef enum : NSUInteger {
    EditDVRMgmt,
    EditDVRAllocation,
    AllocateDVR,
    ChangePassword
} EditDVRType;

typedef enum : NSUInteger {
    UserUpdate,
    UserCreate
} UserType;

typedef enum : NSUInteger {
    ANUUserType,
    ANUUserNameAndName,
    ANUPassAndContact,
    ANUEmailAndAddress,
    ANUCountryAndState,
    ANUCityAndPinCode,
    ANUTimeZoneAndAccessType,
    ANUAlerts,
    ANUCTA
    
} AddNewUserRowType;
