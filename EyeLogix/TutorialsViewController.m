//
//  TutorialsViewController.m
//  EyeLogix
//
//  Created by Brammanand Soni on 8/3/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "TutorialsViewController.h"
#import "TutorialCollectionCell.h"

@interface TutorialsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *imagesArray;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *leftArraowButton;
@property (weak, nonatomic) IBOutlet UIButton *rightArraowButton;
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation TutorialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imagesArray = @[@"eyelogix-app-flash-image-1", @"eyelogix-app-flash-image-2", @"eyelogix-app-flash-image-3", @"eyelogix-app-flash-image-4", @"eyelogix-app-flash-image-5"];
    self.pageControl.numberOfPages = self.imagesArray.count;
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshUI
{
    self.leftArraowButton.hidden = self.pageControl.currentPage == 0;
    self.rightArraowButton.hidden = self.pageControl.currentPage == self.imagesArray.count-1;
    self.getStartedButton.hidden = !(self.pageControl.currentPage == self.imagesArray.count-1);
    self.skipButton.hidden = self.pageControl.currentPage == self.imagesArray.count-1;
}

- (void)setTutorialDisplayFlag
{
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isTutorialShown"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - IBActions

- (IBAction)skipPressed:(UIButton *)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self setTutorialDisplayFlag];
}

- (IBAction)leftArraowClicked:(UIButton *)sender {
    self.pageControl.currentPage --;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [self refreshUI];
}

- (IBAction)rightArraowClicked:(UIButton *)sender {
    self.pageControl.currentPage ++;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [self refreshUI];
}

- (IBAction)getStartedButtonClicked:(UIButton *)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self setTutorialDisplayFlag];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TutorialCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TutorialCollectionCell" forIndexPath:indexPath];
    [cell configureCellWithImage:self.imagesArray[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    float currentPage = self.collectionView.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
    {
        self.pageControl.currentPage = currentPage + 1;
    }
    else
    {
        self.pageControl.currentPage = currentPage;
    }
    [self refreshUI];
}

@end
