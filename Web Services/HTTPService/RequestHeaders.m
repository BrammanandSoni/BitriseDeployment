//
//  RequestHeaders.m
//  BellCurveLabs
//
//  Created by Amol Jadhav on 24/12/13.
//  Copyright (c) 2013 Amol Jadhav. All rights reserved.
//

#import "RequestHeaders.h"


@implementation RequestHeaders

+(NSDictionary *)commonHeaders {
	
   NSDictionary *headerDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"MyCurrent for iOS v.1.0",@"User-Agent", @"application/json", @"Accept", @"application/json", @"Content-Type", nil] ;
    
    return headerDictionary;
}


+(NSDictionary *)commonHeadersForText {
	
    NSDictionary *headerDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"MyCurrent for iOS v.1.0",@"User-Agent", @"text/plain", @"Accept", @"application/json", @"Content-Type", nil] ;
    
    return headerDictionary;
}

@end
