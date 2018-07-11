//
//  AlertELVC.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/8/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyLoadingVC.h"

typedef enum eAlertScreenType {
    ASType_All,
    ASType_Cam
}AlertScreenType;

@interface AlertELVC : LazyLoadingVC

@property (nonatomic) AlertScreenType screenType;

#pragma mark Public Methods

- (void)setStoreId:(NSString *)storeId andCamId:(NSString *)camId;

-(void)openEventPlayWithEventId:(NSString *)eventId
                       andCamId:(NSString *)camId;


@end
