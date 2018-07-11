//
//  GallerySlideShowELVC.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/13/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "GallerySlideShowELVC.h"
#import "GallerySlideCollectionCell.h"
#import "Utils.h"

#define kImageNameKey @"imageName"


@interface GallerySlideShowELVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *listItem;

@end

@implementation GallerySlideShowELVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *galleryPath = [Utils getGalleryDirectoryPath];
    self.listItem = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:galleryPath error:NULL] mutableCopy];
    self.pageControl.numberOfPages = self.listItem.count;
    self.pageControl.currentPage = self.currentSelectedIndex;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configureNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

-(void)updateUIOnImageDelete {
    
    //Reducing width by 1 item on delete action.
    CGFloat pageWidth = self.collectionView.frame.size.width;
    self.collectionView.contentSize = CGSizeMake(self.collectionView.contentSize.width - pageWidth, self.collectionView.contentSize.height);
    
    if(self.currentSelectedIndex > 0) {
        
        //Shifting contentOffset accordingly
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x - pageWidth, self.collectionView.contentOffset.y)];
    }
    
    self.pageControl.numberOfPages--;
    self.pageControl.currentPage = self.currentSelectedIndex;
    
    [self.collectionView reloadData];

}

-(void)sharePressed {
    
    
    GallerySlideCollectionCell *cell = (GallerySlideCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectedIndex inSection:0]];
    
    NSArray *items = @[cell.imageView.image];
    
    
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:^{
        
        
    }];
    
    
    
}

-(void)deletePressed {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Alert!"
                                  message:@"Do you really want to delete this screenshot?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             NSString *currentImage = self.listItem[self.currentSelectedIndex];
                             
                             [Utils deleteFileFromPath:[NSString stringWithFormat:@"%@/%@", [Utils getGalleryDirectoryPath], currentImage]];
                             
                             if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteImage:sender:)])
                             {
                                 [self.delegate didDeleteImage:currentImage
                                                        sender:self];
                                 
                             }
                             
                             [self.listItem removeObjectAtIndex:self.currentSelectedIndex];
                             
                             if(self.listItem.count == 0){
                                 
                                 [self.navigationController popViewControllerAnimated:NO];
                             }
                             else {
                                 
                                 if(self.currentSelectedIndex > 0) {
                                     
                                     self.currentSelectedIndex--;
                                 }
                                 
                                 [self updateUIOnImageDelete];
                                 
                             }
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

- (void)configureNavigationBar
{
    self.title = @"Gallery";
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu_1"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backbtn:)];
    self.navigationItem.leftBarButtonItem = btn;
    
    UIBarButtonItem *btnDelete = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deletePressed)];
    
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Share"] style:UIBarButtonItemStylePlain target:self action:@selector(sharePressed)];
    
    self.navigationItem.rightBarButtonItems = @[btnShare, btnDelete];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
}

-(void) backbtn:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listItem.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView    cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GallerySlideCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GallerySlideCollectionCell" forIndexPath:indexPath];
    [cell showImage:[NSString stringWithFormat:@"%@/%@", [Utils getGalleryDirectoryPath], self.listItem[indexPath.item]]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    
    self.currentSelectedIndex = self.collectionView.contentOffset.x / pageWidth;
    
    self.pageControl.currentPage = self.currentSelectedIndex;
}

@end
