//
//  RequestHeaders.h
//  BellCurveLabs
//
//  Created by Amol Jadhav on 24/12/13.
//  Copyright (c) 2013 Amol Jadhav. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestHeaders : NSObject {

}
+(NSDictionary *)commonHeaders;
+(NSDictionary *)commonHeadersForText;
@end
