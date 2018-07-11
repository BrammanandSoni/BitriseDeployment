//
//  GalleryELVC.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/8/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "GalleryELVC.h"
#import "SlideNavigationController.h"
#import "GalleryELVCCollectionCell.h"
#import "Utils.h"
#import "GallerySlideShowELVC.h"
#import "NoResultView.h"

#define kSelected @"selected"
#define kImageNameKey @"imageName"

@interface GalleryELVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate, UIGestureRecognizerDelegate, GallerySlideShowELVCDelegate>
{
    NSInteger selectedFrameCount;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property (nonatomic, strong) NSMutableArray *listItem;
@property (nonatomic) BOOL isDeleteEnabled;
@property (nonatomic, strong) NoResultView *emptyView;

@end

@implementation GalleryELVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self doInitialConfiguration];
    [self configureNavigationBar];
    [self setUpListData];
    [self addLogPressGestureToCollectionView];
    [self reloadCollectionView];
    [self configureTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GallerySlideShowELVC Methods
-(void) didDeleteImage:(NSString *)imageDict sender:(GallerySlideShowELVC *)sender {
    [self reloadUIAndData];
}

#pragma mark - Private Methods

- (void)doInitialConfiguration
{
    self.isDeleteEnabled = NO;
}

- (void)configureNavigationBar
{
    self.title = @"Gallery";
    
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

- (void)configureTabBar
{
    for (UITabBarItem *item in self.tabBar.items) {
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    for (UITabBarItem *item in self.tabBar.items) {
        if (item.tag == 2) {
            self.tabBar.selectedItem = item;
            selectedFrameCount = item.tag;
            break;
        }
    }
}

- (void)setUpListData
{
    NSString *galleryPath = [Utils getGalleryDirectoryPath];
    self.listItem = [NSMutableArray array];
    NSArray *imagesNamesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:galleryPath error:NULL];
    for (NSString *imageName in imagesNamesArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:imageName forKey:kImageNameKey];
        [dict setObject:@(NO) forKey:kSelected];
        
        [self.listItem addObject:dict];
    }
}

- (void)addLogPressGestureToCollectionView
{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:lpgr];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint p = [gestureRecognizer locationInView:self.collectionView];
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
        if (indexPath == nil){
            NSLog(@"couldn't find index path");
        } else {
            //UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            [self addDeleteButtonInNavigationBar];
            self.isDeleteEnabled = YES;
            
            [self.listItem[indexPath.item] setObject:@(YES) forKey:kSelected];
            //[self.collectionView reloadData];
            [self reloadCollectionView];
        }
    }
}

- (void)addDeleteButtonInNavigationBar
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deletePressed:)];
    self.navigationItem.rightBarButtonItem = btn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)removeDeleteButtonFromNavigationBar
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)deletePressed:(id)sender
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Alert!"
                                  message:@"Do you really want to delete these screenshots?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             for (NSDictionary *dict in self.listItem) {
                                 if ([[dict objectForKey:kSelected] boolValue]) {
                                     [Utils deleteFileFromPath:[NSString stringWithFormat:@"%@/%@", [Utils getGalleryDirectoryPath], [dict objectForKey:kImageNameKey]]];
                                 }
                             }
                             
                             [self resetSelection];
                             [self reloadUIAndData];
                         }];
    [alert addAction:ok];
    
    UIAlertAction* cancel = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                         }];
    [alert addAction:cancel];
}

-(void)reloadUIAndData
{
    [self setUpListData];
    [self reloadCollectionView];
}

- (void)resetSelection
{
    [self removeDeleteButtonFromNavigationBar];
    self.isDeleteEnabled = NO;
}

- (void)reloadCollectionView
{
    if (self.listItem.count > 0) {
        [self removeEmptyGalleryView];
        [self.collectionView reloadData];
    }
    else {
        [self loadEmptyGalleryView];
    }
}

- (void)loadEmptyGalleryView
{
    if (self.emptyView == nil) {
        self.emptyView = [[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil].lastObject;
    }
    
    [self.emptyView setImage:[UIImage imageNamed:@"empty"] andTitle:@"Gallery is empty"];
    [self.emptyView setFrame:self.view.bounds];
    [self.view addSubview:self.emptyView];
}

- (void)removeEmptyGalleryView
{
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listItem.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryELVCCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryELVCCollectionCell" forIndexPath:indexPath];
    [cell showDetails:self.listItem[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/selectedFrameCount, collectionView.frame.size.width/selectedFrameCount);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isDeleteEnabled) {
        NSMutableDictionary *dict = self.listItem[indexPath.item];
        [dict setObject:@(![[dict objectForKey:kSelected] boolValue]) forKey:kSelected];
        
        // Reset if no item selected
        BOOL reset = YES;
        for (NSMutableDictionary *detailsDict in self.listItem) {
            if ([[detailsDict objectForKey:kSelected] boolValue]) {
                reset = NO;
                break;
            }
        }
        
        if (reset) {
            [self resetSelection];
        }
        
        //[self.collectionView reloadData];
        [self reloadCollectionView];
    }
    else {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GallerySlideShowELVC *gallerySlideVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"GallerySlideShowELVC"];
        
        gallerySlideVC.delegate = self;
        gallerySlideVC.currentSelectedIndex = indexPath.item;
        [self.navigationController pushViewController:gallerySlideVC animated:NO];
    }
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    selectedFrameCount = item.tag;
    //[self.collectionView reloadData];
    [self reloadCollectionView];
}

@end
