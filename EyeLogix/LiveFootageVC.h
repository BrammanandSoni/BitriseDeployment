//
//  LiveFootageVC.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/6/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ScreenTypeLocation,
    ScreenTypeFavourite
} ScreenType;

@interface LiveFootageVC : UIViewController

@property (nonatomic) ScreenType screenType;

- (void)showSelectedCamsArray:(NSArray *)selectedCamsArray;

@end
