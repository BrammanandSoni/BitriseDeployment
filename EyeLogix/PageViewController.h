//
//  PageViewController.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/15/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageViewController;

@protocol PageViewControllerDelegate <NSObject>

- (void)pageVC:(PageViewController *)pageVC didShowPageAtIndex:(NSInteger)index;

@end

@interface PageViewController : UIPageViewController

@property (nonatomic, weak) id <PageViewControllerDelegate> pageDelegate;

- (void)selectPageAtIndex:(NSInteger)index;

@end
