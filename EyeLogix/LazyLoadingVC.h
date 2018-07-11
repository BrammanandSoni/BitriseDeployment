//
//  LazyLoadingVC.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/26/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LazyLoadingVC : UIViewController

@property (assign, nonatomic) BOOL isNextPageResultsAvailable;
@property (assign, nonatomic) BOOL isLoadingNextPageResults;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomMargin;

- (void)loadNextPageResults;

@end
