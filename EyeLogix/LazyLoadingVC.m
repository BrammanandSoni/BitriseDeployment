//
//  LazyLoadingVC.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/26/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "LazyLoadingVC.h"

#define kLoaderViewHeight 40
#define kLoaderViewTag 12121

@interface LazyLoadingVC ()

@end

@implementation LazyLoadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)setIsLoadingNextPageResults:(BOOL)isLoadingResults
{
    _isLoadingNextPageResults = isLoadingResults;
    
    if (isLoadingResults) {
        [self addLoaderViewForNextResults];
        self.constraintBottomMargin.constant = kLoaderViewHeight;
    }
    else {
        self.constraintBottomMargin.constant = 0;
        UIView *view = [self.view viewWithTag:kLoaderViewTag];
        [view removeFromSuperview];
    }
    
    [self.view layoutIfNeeded];
}

- (void)addLoaderViewForNextResults
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kLoaderViewHeight, self.view.frame.size.width, kLoaderViewHeight)];
    [view setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:245.0/255.0 blue:249.0/255.0 alpha:1.0]];
    [view setTag:kLoaderViewTag];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [indicatorView setCenter:CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2)];
    [indicatorView startAnimating];
    [indicatorView setColor:[UIColor darkGrayColor]];
    [indicatorView setHidden:NO];
    [view addSubview:indicatorView];
    [self.view addSubview:view];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isLoadingNextPageResults) {
        return;
    }
    
    if (self.isNextPageResultsAvailable && (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + 30)) {
        
        self.isLoadingNextPageResults = YES;
        [self loadNextPageResults];
    }
}

#pragma mark - Overriden Methods

- (void)loadNextPageResults
{
    NSLog(@"Over ride this method to make server call");
}

@end
