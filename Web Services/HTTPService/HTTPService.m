//
//  HttpService.m
//  BellCurveLabs
//
//  Created by Amol Jadhav on 24/12/13.
//  Copyright (c) 2013 Amol Jadhav. All rights reserved.
//

#import "HTTPService.h"

#define REQUEST_TIMEOUT 90

#define METHOD_GET @"GET"
#define METHOD_POST @"POST"
#define METHOD_PUT @"PUT"
#define METHOD_DELETE @"DELETE"

@interface HTTPService() <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) HttpServiceSuccessCallback successCallback;
@property (nonatomic, strong) HttpServiceErrorCallback errorCallback;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic) int responseStatus;

- (void) doRequest:(NSURLRequest *)request;
- (NSString*) resolveHttpMethodEnum: (HttpServiceRequestMethod)methodEnum;

@end

@implementation HTTPService

@synthesize request = _request;
@synthesize successCallback = _successCallback;
@synthesize errorCallback = _errorCallback;

@synthesize connection = _connection;
@synthesize responseData = _responseData;
@synthesize responseStatus = _responseStatus;

- (id) initWithUrl:(NSURL *)url
            accept:(NSString *)accept
       contentType:(NSString *)contentType
          httpBody:(NSString *)body
            cookie:(NSString *)sessionID
        httpMethod:(HttpServiceRequestMethod)method {
  if (self = [super init]) {
    if (url != nil) {
        
        NSLog(@"URL >>>>>>>> %@", url);
        
      self.request = [[NSMutableURLRequest alloc] initWithURL:url];
      self.request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
      self.request.timeoutInterval = REQUEST_TIMEOUT;
      self.request.HTTPMethod = [self resolveHttpMethodEnum:method];
      NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
      NSString *mycUserAgent = [NSString stringWithFormat:@"BellCurveLabs for iOS v.%@", appVersion];
      [self.request setValue:mycUserAgent forHTTPHeaderField:@"User-Agent"];
      if (accept != nil) {
        [self.request setValue:accept forHTTPHeaderField:@"Accept"];
      }
      if (contentType != nil) {
        [self.request setValue:contentType forHTTPHeaderField:@"Content-Type"];
      }
      if (body != nil) {
        [self.request setHTTPBody:[NSData dataWithBytes:[body UTF8String] length:[body length]]];
      }
      if (sessionID != nil) {
        [self.request setValue:sessionID forHTTPHeaderField:@"cookie"];
      }

    }
  }
  return self;
}

- (void) makeRequest; {
  self.successCallback = nil;
  self.errorCallback = nil;
  [self doRequest:self.request];
}

- (void) makeRequestSuccessCallback: (HttpServiceSuccessCallback)success {
  self.successCallback = success;
  self.errorCallback = nil;
  [self doRequest:self.request];
}

- (void) makeRequestSuccessCallback: (HttpServiceSuccessCallback)success
                      errorCallback: (HttpServiceErrorCallback) error {
  self.successCallback = success;
  self.errorCallback = error;
  [self doRequest:self.request];
}

- (void) doRequest:(NSURLRequest *)request {
  if (request == nil) {
    if (self.errorCallback != nil) {
      self.errorCallback(-1, [NSError errorWithDomain:@"HttpService Missing Request Error" code:-998.0 userInfo:nil]);
    }
    return;
  }
  self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  if (self.connection == nil && self.errorCallback != nil) {
    self.errorCallback(-1, [NSError errorWithDomain:@"HttpService Unknown Error" code:-999.0 userInfo:nil]);
  }
}

- (NSString*) resolveHttpMethodEnum: (HttpServiceRequestMethod)methodEnum {
  switch (methodEnum) {
    case RequestMethodGET:
      return METHOD_GET;
    case RequestMethodPOST:
      return METHOD_POST;
    case RequestMethodPUT:
      return METHOD_PUT;
    case RequestMethodDELETE:
      return METHOD_DELETE;
    default:
      return nil;
  }
}

- (void) cancelService {
   self.successCallback = nil;
  self.errorCallback = nil;
  [self.connection cancel];
}

#pragma mark - NSURLConnection delegate methods

- (void) connection: (NSURLConnection *) connection didReceiveData: (NSData *) data {
  if (self.responseData == nil) {
    self.responseData = [[NSMutableData alloc] init];
  }
  [self.responseData appendData:data];
}

- (void) connectionDidFinishLoading: (NSURLConnection *) connection {
   self.successCallback(self.responseStatus, [NSData dataWithData:self.responseData]);
}

- (void) connection: (NSURLConnection *) connection didFailWithError: (NSError *) error {
  self.errorCallback(self.responseStatus, error);
}

- (void) connection: (NSURLConnection *) connection didReceiveResponse: (NSURLResponse *) response{
    
  NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
  self.responseStatus = (int)[httpResponse statusCode];
    NSLog(@"Status Code : %d", self.responseStatus);
    
}

#ifdef DEBUG

// only accept self-signed certificate in DEBUG mode

- (BOOL) connection: (NSURLConnection *) connection
canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *) protectionSpace {
  return YES;
}

- (void) connection: (NSURLConnection *) connection
didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *) challenge {
  [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
       forAuthenticationChallenge:challenge];
  [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#endif

@end
