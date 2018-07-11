//
//  MoviePlayerVC.h
//  EyeLogix
//
//  Created by Smriti on 5/30/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayer.h"
#import "M3U8.h"
#import "Thumbnailer.h"


@interface LivePreviewVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate, MediaPlayerCallback, UIGestureRecognizerDelegate>{
    
    __weak IBOutlet UIButton *btn1;
    __weak IBOutlet UIButton *btn4;
    __weak IBOutlet UIButton *btn9;
    __weak IBOutlet UIButton *btn16;
    
   
}

- (void)showSelectedCamsArray:(NSArray *)selectedCamsArray;

- (void) initWithContentPath: (NSArray *) arrayPath;

@property (readonly) BOOL playing;

- (void) Close;





@end



