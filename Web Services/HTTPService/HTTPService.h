//
//  HttpService.h
//  BellCurveLabs
//
//  Created by Amol Jadhav on 24/12/13.
//  Copyright (c) 2013 Amol Jadhav. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HttpService_APPLICATION_JSON @"application/json"
#define HttpService_TEXT_PLAIN @"text/plain"
#define HttpService_FORM_URL_ENCODED @"application/x-www-form-urlencoded"

typedef void(^HttpServiceSuccessCallback) (int status, NSData *data);
typedef void(^HttpServiceErrorCallback) (int status, NSError *error);

typedef enum {
  RequestMethodGET,
  RequestMethodPOST,
  RequestMethodDELETE,
  RequestMethodPUT,
  RequestMethodNone
} HttpServiceRequestMethod;

@interface HTTPService : NSObject

- (id) initWithUrl:(NSURL *)url
            accept:(NSString *)accept
       contentType:(NSString *)contentType
          httpBody:(NSString *)body
            cookie:(NSString *)sessionID
        httpMethod:(HttpServiceRequestMethod)method;

- (void) makeRequest;

- (void) makeRequestSuccessCallback: (HttpServiceSuccessCallback)success;

- (void) makeRequestSuccessCallback: (HttpServiceSuccessCallback)success errorCallback: (HttpServiceErrorCallback) error;

- (void) cancelService;

@end
