//
//  AdminViewController.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/14/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "AdminViewController.h"
#import "TopHeaderCollectionViewCell.h"
#import "PageViewController.h"

@interface AdminViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *topBarItems;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) PageViewController *pageVC;
@end

@implementation AdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self doInitialConfiguration];
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pageVC"]) {
        self.pageVC = [segue destinationViewController];
        self.pageVC.pageDelegate = self;
    }
}

#pragma mark - Private Methods

- (void)doInitialConfiguration
{
    self.selectedIndex = 0;
    self.topBarItems = @[@"DVR Mgmt", @"DVR Allocation", @"Cam Mgmt", @"User", @"Online User"];
    [self.collectionView reloadData];
}

- (void)configureNavigationBar
{
    self.title = @"DVR Management";
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu_1"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backbtn:)];
    
    self.navigationItem.leftBarButtonItem = btn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

-(void) backbtn:(id)sender {
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)reloadCollectionView
{
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.topBarItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopHeaderCollectionViewCell" forIndexPath:indexPath];
    [cell showSelection:self.selectedIndex == indexPath.item];
    [cell configureCellWithTitle:self.topBarItems[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.topBarItems[indexPath.item];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    return CGSizeMake(size.width, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.item;
    [self reloadCollectionView];
    [self.pageVC selectPageAtIndex:self.selectedIndex];
}

#pragma mark - PageViewControllerDelegate

- (void)pageVC:(PageViewController *)pageVC didShowPageAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
    [self reloadCollectionView];
}

@end
