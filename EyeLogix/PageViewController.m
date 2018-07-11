//
//  PageViewController.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/15/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "PageViewController.h"
#import "DVRListViewController.h"
#import "CamMgmtViewController.h"

@interface PageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) NSArray *dvrMgmtTypeArray;
@property (nonatomic, strong) NSArray<UIViewController *> *viewControllersArray;
@property (nonatomic) NSInteger lastSelectedIndex;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpVCsArray];
    [self doInitialConfiguration];
    [self setupTabType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

- (void)selectPageAtIndex:(NSInteger)index
{
    self.lastSelectedIndex = index;
    UIViewController *selectedVC = self.viewControllersArray[index];
    NSArray *viewControllers = @[selectedVC];
    [self setViewControllers:viewControllers direction:self.lastSelectedIndex <= index ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

#pragma mark - Private Methods
- (void)doInitialConfiguration
{
    self.dataSource = self;
    self.delegate = self;
    [self selectPageAtIndex:0];
}

- (void)setUpVCsArray
{
    self.viewControllersArray = @[[self viewControllerAtIndex:0], [self viewControllerAtIndex:1], [self viewControllerAtIndex:2], [self viewControllerAtIndex:3], [self viewControllerAtIndex:4]];
}

- (void)setupTabType
{
    self.dvrMgmtTypeArray = @[@(DVRMgmt), @(DVRAllocation), @(CamMgmt), @(User), @(OnlineUser)];
}

- (void)callDelegateWithIndex:(NSInteger)index
{
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageVC:didShowPageAtIndex:)]) {
        [self.pageDelegate pageVC:self didShowPageAtIndex:index];
    }
}

#pragma mark - Helper Methods

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (index == CamMgmt) {
        CamMgmtViewController *camMgmtVC = (CamMgmtViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CamMgmtViewController"];
        return camMgmtVC;
    }
    
    DVRListViewController *dvrList = (DVRListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DVRListViewController"];
    dvrList.dvrMgmtType = index;
    
    return dvrList;
}

#pragma mark - UIPageViewControllerDataSource, UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger previousIndex = [self.viewControllersArray indexOfObject:viewController];
    if (previousIndex == 0 || previousIndex == NSNotFound) {
        return nil;
    }
    
    previousIndex --;
    return self.viewControllersArray[previousIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger nextIndex = [self.viewControllersArray indexOfObject:viewController];
    if (nextIndex == NSNotFound) {
        return nil;
    }
    
    nextIndex ++;
    
    if (nextIndex == self.viewControllersArray.count) {
        return nil;
    }
    
    return self.viewControllersArray[nextIndex];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) {
        return;
    }
    
    UIViewController *vc = self.viewControllers[0];
    NSInteger currentIndex = [self.viewControllersArray indexOfObject:vc];
    if (currentIndex >= 0) {
        [self callDelegateWithIndex:currentIndex];
    }
}

@end
