//
//  LiveFootageVC.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/6/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "LiveFootageVC.h"
#import "MediaPlayer.h"
#import "LiveFootageCollectionCell.h"
#import "Utils.h"
#import "ServiceManger.h"
#import "AlertELVC.h"
#import "BottomControlView.h"
#import "DataHandler.h"
#import "PlayBackTimeSelectionVC.h"

#define IndecatorViewTag 111
#define DisconnectedLabelTag 101
#define ReloadButtonBaseTag 1000


#define Orientation [UIApplication sharedApplication].statusBarOrientation

@interface LiveFootageVC ()<MediaPlayerCallback, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, BottomControlViewDelegate>
{
    //NSInteger totalCamsCount;
    //MediaPlayerConfig *config;
    MediaPlayer*        players[5000];
    int                 shot_buffer_size;
    uint8_t*            shot_buffer;
    
    NSInteger selectedFrameCount;
    NSInteger previousFrameCount;
    NSInteger currentFrameSelectedIndex;
}

@property (nonatomic, strong) NSArray *camsArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *frameButtons;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bottomButtons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewCenterYConstraint;

@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic)CGSize screenSize;

@property (nonatomic)BOOL isReloadingSingle;

@end

@implementation LiveFootageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenSize = CGSizeMake([Utils appDelegate].window.frame.size.width, [Utils appDelegate].window.frame.size.height);
    
    
    if (!UIInterfaceOrientationIsLandscape(Orientation)) {
        self.collectionViewHeightConstraint.constant = self.view.frame.size.width * 0.91;
        self.collectionViewCenterYConstraint.constant = -50;

    }
    
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.camsArray.count == 1) {
        selectedFrameCount = 1;
    }
    else {
        selectedFrameCount = 4;
    }
    
    for (UIButton *btn in self.frameButtons) {
        if (btn.tag == selectedFrameCount) {
            btn.selected = YES;
            break;
        }
    }
    
    currentFrameSelectedIndex = -1;
    previousFrameCount = -1;
    
    [self setupCollectionView];
    [self configureNavigationBar];
    [self doInitialConfiguration];
    [self bottomBarSetup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    for (int i = 0; i < self.camsArray.count; i++)
    //    {
    //        config = [[MediaPlayerConfig alloc] init];
    //        config.decodingType = 1; // HW
    //        config.numberOfCPUCores = 2;
    //        config.sslKey = @"75ffa55a38c3629b";
    //        config.aspectRatioMode = 0;
    //        config.aspectRatioZoomModePercent = 100;
    //        config.connectionUrl = [[self.camsArray objectAtIndex:i] valueForKey:@"IP_Url"];
    //        [self getPlayerView:i width:200 height:100];
    //        [players[i] Open:config callback:self];
    //        //usleep(500000);
    //    }
    //    [self.collectionView reloadData];
    [self scrollViewDidEndDecelerating:self.collectionView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (int i = 0; i < self.camsArray.count; i++)
    {
        [players[i] Close];
        players[i] = nil;
    }
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
    
    flowLayout.itemSize = CGSizeMake(self.collectionView.frame.size.width/sqrt(selectedFrameCount), self.collectionView.frame.size.height/sqrt(selectedFrameCount));
    
    [flowLayout invalidateLayout];
}

- (void) dealloc
{
    if (shot_buffer)
    {
        free(shot_buffer);
        shot_buffer = 0;
    }
    
    for (int i = 0; i < self.camsArray.count; i++)
    {
        if (players[i] != nil) {
            
            [players[i] Close];
            players[i] = nil;
        }
    }
}

- (void)actOnFavourite
{
    if (self.screenType == ScreenTypeFavourite) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete Favourite" message:@"Do you want to delete this cam from favourite?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Favourite" message:@"Do you want to add this cam to favourite?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alertView show];
    }
}

- (IBAction)bottomButtonsPressed:(UIButton *)sender {
    switch (sender.tag) {
        case 1: {
            // PlayBack
            
            NSDictionary *camDetails = self.camsArray[currentFrameSelectedIndex];
            
            NSString *storeTitle = [camDetails objectForKey:@"StoreTitle"];
            
            PlayBackTimeSelectionVC *playbackTimeVC = (PlayBackTimeSelectionVC *)[Utils getViewControllerWithIdentifier:@"PlayBackTimeSelectionVC"];
            
            [playbackTimeVC showStoreName:storeTitle andCamDetails:camDetails];
            
            [self.navigationController pushViewController:playbackTimeVC animated:YES];
        }
            break;
            
        case 2: {
            // AddFavourite
            if (currentFrameSelectedIndex == -1) {
                [Utils showToastWithMessage:@"Unable to add to favourite"];
                return;
            }
            
            [self actOnFavourite];
        }
            break;
            
        case 3: {
            // Event
            AlertELVC *alertVC = (AlertELVC *)[Utils getViewControllerWithIdentifier:@"AlertELVC"];
            alertVC.screenType = ASType_Cam;
            NSDictionary *camDetails = self.camsArray[currentFrameSelectedIndex];
            NSString *storeId = [camDetails objectForKey:@"StoreId"];
            NSString *camId = [camDetails objectForKey:@"CamId"];
            [alertVC setStoreId:storeId andCamId:camId];
            [self.navigationController pushViewController:alertVC animated:YES];
        }
            break;
            
        case 4: {
            // ScreenShot
            if (currentFrameSelectedIndex == -1) {
                NSLog(@"unable to screen capture");
                return;
            }
            
            if (players[currentFrameSelectedIndex] == nil) {
                NSLog(@"unable to screen capture");
                return;
            }
            
            MediaPlayerState state = [players[currentFrameSelectedIndex] getState];
            if (state == MediaPlayerStarted) {
                // get screen shot
                [self takeScreenShot];
                
            }
            else {
                [Utils showToastWithMessage:@"Unable to capture screen"];
                return;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return self.screenType == ScreenTypeFavourite;
}

#pragma mark - Service Call

- (void)callAddToFavouriteService
{
    NSDictionary *camDetails = self.camsArray[currentFrameSelectedIndex];
    NSString *camId = [camDetails objectForKey:@"CamId"];
    
    if (!camId) {
        [Utils showToastWithMessage:@"Unable to add to favourite"];
        return;
    }
    
    ServiceManger *service = [ServiceManger sharedInstance];
    NSDictionary *paramsDict = @{@"camid": camId};
    
    [Utils showProgressInView:self.view text:@"Please wait"];
    [service addToFavouriteServie:paramsDict withCallback:^(NSDictionary *dictResponse) {
        [Utils hideProgressInView:self.view];
        [Utils showToastWithMessage:[dictResponse valueForKeyPath:@"Response.ShowMessage"]];
        [DataHandler sharedInstance].reloadCamList = YES;
    }];
}

- (void)callDeleteFromFavouriteService
{
    NSDictionary *camDetails = self.camsArray[currentFrameSelectedIndex];
    NSString *camId = [camDetails objectForKey:@"CamId"];
    
    if (!camId) {
        [Utils showToastWithMessage:@"Unable to delete from favourite"];
        return;
    }
    
    ServiceManger *service = [ServiceManger sharedInstance];
    NSDictionary *paramsDict = @{@"camid": camId};
    
    [Utils showProgressInView:self.view text:@"Please wait"];
    [service deleteFromFavouriteServie:paramsDict withCallback:^(NSDictionary *dictResponse) {
        [Utils hideProgressInView:self.view];
        [Utils showToastWithMessage:[dictResponse valueForKeyPath:@"Response.ShowMessage"]];
        [DataHandler sharedInstance].reloadCamList = YES;
    }];
}

#pragma mark - Public Methods

- (void)showSelectedCamsArray:(NSArray *)selectedCamsArray
{
    self.camsArray = selectedCamsArray;
    //totalCamsCount = selectedCamsArray.count;
    for (int i = 0; i < self.camsArray.count; i++)
    {
        players[i] = nil;
    }
}

#pragma mark - Private Methods

-(void)onTapReload:(UIButton *)btn {
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[[[btn superview] superview] superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSArray *indexPaths = @[indexPath];
    
    self.isReloadingSingle = true;
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
}

-(void)translateOffset {
    
    if(UIInterfaceOrientationIsLandscape(Orientation))  {
        
        CGFloat newOffset = self.screenSize.height * currentFrameSelectedIndex;
        self.collectionView.contentOffset = CGPointMake(newOffset, self.collectionView.contentOffset.y);
    }
    else {
        CGFloat newOffset = self.screenSize.width * currentFrameSelectedIndex;
        self.collectionView.contentOffset = CGPointMake(newOffset, self.collectionView.contentOffset.y);
    }
    
    NSLog(@"Translated");
}

- (void)setupCollectionView
{
    self.collectionView.layer.borderWidth = 1.0;
    self.collectionView.layer.borderColor = [UIColor colorWithRed:229.0/255.0 green:181.0/255.0 blue:77.0/255.0 alpha:1.0].CGColor;
}

- (void)doInitialConfiguration
{
    int width = 5000;
    int height = 5080;
    shot_buffer_size = width * height * 4;
    shot_buffer = malloc(shot_buffer_size);
}

- (void)bottomBarSetup
{
    if (self.screenType == ScreenTypeFavourite) {
        for (UIButton *button in self.bottomButtons) {
            if (button.tag == 2) {
                [button setTitle:@"Delete Favourite" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"DeleteFavouriteGray"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"DeleteFavourite"] forState:UIControlStateSelected];
                break;
            }
        }
    }
}

- (UIView *) getPlayerView:(int)index  width: (float) width height: (float) height
{
    if (players[index] == nil)
    {
        players[index] = [[MediaPlayer alloc] init:CGRectMake( 0, 0, width, height )];
    }
    
    return [players[index] contentView];
}

- (void)configureNavigationBar
{
    if (self.screenType == ScreenTypeFavourite) {
        self.title = @"Favourite Preview";
    }
    else {
        self.title = @"Live Preview";
        
        UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu_1"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(backbtn:)];
        
        self.navigationItem.leftBarButtonItem = btn;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
}

-(void) backbtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetFrameButtonSelection
{
    for (UIButton *btn in self.frameButtons) {
        btn.selected = NO;
    }
}

- (void)addOverlayView
{
    if (self.overlayView == nil) {
        self.overlayView = [[UIView alloc] initWithFrame:[Utils appDelegate].window.bounds];
        
        self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [Utils addTapGestureToView:self.overlayView target:self selector:@selector(onTapOverlayView:)];
        
        BottomControlView *bottomControlView = [[NSBundle mainBundle] loadNibNamed:@"BottomControlView" owner:self options:nil].lastObject;
        bottomControlView.delegate = self;
        UIWindow *window = [Utils appDelegate].window;
        bottomControlView.frame = CGRectMake(window.bounds.size.width/2 - (bottomControlView.frame.size.width/2), window.bounds.size.height - bottomControlView.frame.size.height, bottomControlView.frame.size.width, bottomControlView.frame.size.height);
        [bottomControlView setCountText:self.pageLabel.text andScreenType:self.screenType];
        
        [self.overlayView addSubview:bottomControlView];
    }
    
    [self.view addSubview:self.overlayView];
}

- (void)onTapOverlayView:(id)sender
{
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
}

- (void)onTapScreenShotView:(id)sender
{
    [self takeScreenShot];
}

- (void)takeScreenShot
{
    int32_t desired_width = -1;//100;
    int32_t desired_height = -1;//100;
    int32_t bytes_per_row = 0;
    
    int rc = [players[currentFrameSelectedIndex] getVideoShot:shot_buffer buffer_size:&shot_buffer_size width:&desired_width height:&desired_height bytes_per_row:&bytes_per_row];
    if (rc < 0) {
        [Utils showToastWithMessage:@"Unable to capture screen"];
        return;
    }
    
    [self showShotView:shot_buffer buffer_size:shot_buffer_size width:desired_width height:desired_height bytes_per_row:bytes_per_row];
}

- (void) showShotView:(uint8_t*)buffer
          buffer_size:(int32_t)buffer_size
                width:(int32_t)width
               height:(int32_t)height
        bytes_per_row:(int32_t)bytes_per_row

{    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,
                                                              buffer,
                                                              buffer_size,
                                                              NULL);
    
    //    int bitsPerComponent = 8;
    //    int bitsPerPixel = 32;
    //    int bytesPerRow = bytes_per_row;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width,
                                        height,
                                        8,
                                        32,
                                        bytes_per_row,colorSpaceRef,
                                        bitmapInfo,
                                        provider,NULL,NO,renderingIntent);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    if (newImage == nil) {
        [Utils showToastWithMessage:@"Unable to capture screen"];
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    
    // Save images to document directory
    NSString *imageToSavePath = [[Utils getGalleryDirectoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lf.png",[[NSDate date] timeIntervalSince1970]]];
    NSData* imageData = UIImagePNGRepresentation(newImage);
    if ([imageData writeToFile:imageToSavePath atomically:YES]) {
       [Utils showToastWithMessage:@"Screenshot captured"];
    }
    else {
        [Utils showToastWithMessage:@"Unable to capture screen"];
    }
}

#pragma mark - MediaPlayerCallback

- (int) Status: (MediaPlayer*)player
          args: (int)arg
{
    switch(arg)
    {
        case PLP_BUILD_STARTING:
        case PLP_PLAY_STARTING:
        case CP_CONNECT_STARTING:
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               UIActivityIndicatorView *indicator = [[player contentView] viewWithTag:IndecatorViewTag];
                               [indicator startAnimating];
                               
                               UILabel *disconnectedLabel = [[player contentView] viewWithTag:DisconnectedLabelTag];
                               disconnectedLabel.hidden = YES;
                               
                               UIButton *reloadBtn = [[player contentView] viewWithTag:ReloadButtonBaseTag];
                               reloadBtn.hidden = YES;
                               
                           });
            
            
            
            break;
        }
        case PLP_PLAY_SUCCESSFUL:
        {
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               UIActivityIndicatorView *indicator = [[player contentView] viewWithTag:IndecatorViewTag];
                               [indicator stopAnimating];
                               
                               UILabel *disconnectedLabel = [[player contentView] viewWithTag:DisconnectedLabelTag];
                               disconnectedLabel.hidden = YES;
                               
                               UIButton *reloadBtn = [[player contentView] viewWithTag:ReloadButtonBaseTag];
                               reloadBtn.hidden = YES;

                           });
            break;
        }
            
        case CP_INIT_FAILED:
        case CP_ERROR_DISCONNECTED:
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               UILabel *disconnectedLabel = [[player contentView] viewWithTag:DisconnectedLabelTag];
                               disconnectedLabel.hidden = NO;
                               
                               UIButton *reloadBtn = [[player contentView] viewWithTag:ReloadButtonBaseTag];
                               reloadBtn.hidden = NO;
                               
                               UIActivityIndicatorView *indicator = [[player contentView] viewWithTag:IndecatorViewTag];
                               [indicator stopAnimating];
                           });
            break;
        }
        case PLP_CLOSE_SUCCESSFUL:
        {
            [player Close];
        }
    }
    
    return 0;
}

- (int) OnReceiveData: (MediaPlayer*)player
               buffer: (void*)buffer
                 size: (int) size
                  pts: (long) pts
{
    NSLog(@"OnReceiveData called");
    return 0;
}

- (int) OnReceiveSubtitleString: (MediaPlayer*)player
                           data: (NSString*)data
                       duration: (uint64_t)duration
{
    NSLog(@"OnReceiveSubtitleString called: %@, %llu", data, duration);
    return 0;
}

#pragma mark - IBAction

- (IBAction)framButtonPressed:(UIButton *)sender {
    
    for (int i = 0; i < self.camsArray.count; i++)
    {
        [players[i] Close];
        players[i] = nil;
    }
    
    [self resetFrameButtonSelection];
    sender.selected = !sender.selected;
    
    selectedFrameCount = sender.tag;
    [self.collectionView reloadData];
    
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:self.collectionView afterDelay:0.1];
}


#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger items = 0;
    
    if (self.camsArray.count < selectedFrameCount) {
        items = selectedFrameCount;
    }
    else {
        if ((self.camsArray.count % selectedFrameCount) == 0) {
            items = selectedFrameCount * (self.camsArray.count / selectedFrameCount);
        }
        else {
            items = selectedFrameCount * ((self.camsArray.count / selectedFrameCount) + 1);
        }
    }
    
    return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveFootageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveFootageCollectionCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.camsArray.count) {
        MediaPlayerConfig *config = [[MediaPlayerConfig alloc] init];
        config.decodingType = 0; // HW
        config.numberOfCPUCores = 0;
        config.sslKey = @"75ffa55a38c3629b";
        config.aspectRatioMode = 0;
        config.aspectRatioZoomModePercent = 100;
        config.connectionUrl = [[self.camsArray objectAtIndex:indexPath.row] valueForKey:@"IP_Url"];
        [self getPlayerView:(int)indexPath.row width:cell.contentView.frame.size.width height:cell.contentView.frame.size.height];
        
        //[players[indexPath.row] setFFRate:5000];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           [players[indexPath.row] Open:config callback:self];
        });
        
        UIView *camView = [players[indexPath.row] contentView];
        camView.backgroundColor = [UIColor colorWithRed:71.0 / 255.0 green:71.0 / 255.0 blue:71.0 / 255.0 alpha:1];
        camView.frame = cell.contentView.bounds;
        [cell.contentView addSubview:camView];
        camView.tag = 1001;
        NSDictionary *camDetails = self.camsArray[indexPath.row];
        [cell setCamCaption:camDetails[@"Caption"]];
        
        [[camView viewWithTag:IndecatorViewTag] removeFromSuperview];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.tag = IndecatorViewTag;
        CGSize cellSize = [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:indexPath];
        indicator.center = CGPointMake(cellSize.width/2, cellSize.height/2);
        indicator.hidesWhenStopped = YES;
        [camView addSubview:indicator];
        [indicator startAnimating];
        
        [[camView viewWithTag:DisconnectedLabelTag] removeFromSuperview];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 70, 21)];
        label.tag = DisconnectedLabelTag;
        label.text = @"Disconnected";
        label.textColor = [UIColor whiteColor];
        label.font = [Utils helveticaFontWithSize:8.0];
        [camView addSubview:label];
        label.hidden = YES;
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(cellSize.width/2 - 20, cellSize.height/2 - 20, 40, 40)];
        [button setImage:[UIImage imageNamed:@"Reload"] forState:UIControlStateNormal];
        button.tag = ReloadButtonBaseTag;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        button.hidden = true;
        [button addTarget:self action:@selector(onTapReload:) forControlEvents:UIControlEventTouchUpInside];
        [camView addSubview:button];
        
        //        MediaPlayerState state = [players[indexPath.row] getState];
        //        if (state == MediaPlayerOpening) {
        //            
        //        }
    }
    else {
        [cell setCamCaption:@"NO-CAM"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.camsArray.count && !self.isReloadingSingle) {
        
        [players[indexPath.row] Close];
        players[indexPath.row] = nil;
    }
    
    self.isReloadingSingle = false;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width/sqrt(selectedFrameCount);
    CGFloat height = collectionView.frame.size.height/sqrt(selectedFrameCount);
    
    UIActivityIndicatorView *indicator = [[players[indexPath.row] contentView] viewWithTag:IndecatorViewTag];
    indicator.center = CGPointMake(width/2, height/2);
    
    UIButton *reloadButton = [[players[indexPath.row] contentView] viewWithTag:ReloadButtonBaseTag];
    reloadButton.center = CGPointMake(width/2, height/2);
    
    return CGSizeMake(width, height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    int currentPage = self.collectionView.contentOffset.x / pageWidth;
    
    int totalPage = self.collectionView.contentSize.width / pageWidth;
    
    //NSLog(@"Page Number : %ld", (long)currentPage);
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%d", currentPage+1, totalPage];
    
    if (selectedFrameCount == 1) {
        self.bottomContainerView.userInteractionEnabled = YES;
        for (UIButton *button in self.bottomButtons) {
            [button setSelected:YES];
        }
        
        currentFrameSelectedIndex = currentPage;
    }
    else {
        self.bottomContainerView.userInteractionEnabled = NO;
        for (UIButton *button in self.bottomButtons) {
            [button setSelected:NO];
        }
        
        currentFrameSelectedIndex = -1;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.camsArray.count) {
        MediaPlayerState state = [players[indexPath.row] getState];
        if (state != MediaPlayerClosed && state != MediaPlayerOpening) {
            
            if (selectedFrameCount == 1) {
                
                if (UIInterfaceOrientationIsLandscape(Orientation)) {
                    [self addOverlayView];
                    return;
                }
                
                if (previousFrameCount != -1) {
                    selectedFrameCount = previousFrameCount;
                }
                else {
                    return;
                }
            }
            else {
                previousFrameCount = selectedFrameCount;
                selectedFrameCount = 1;
            }
            
            [collectionView reloadData];
            
            [self resetFrameButtonSelection];
            for (UIButton *btn in self.frameButtons) {
                if (btn.tag == selectedFrameCount) {
                    btn.selected = YES;
                    break;
                }
            }
            
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:self.collectionView afterDelay:0.1];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.screenType == ScreenTypeFavourite) {
            [self callDeleteFromFavouriteService];
        }
        else {
            [self callAddToFavouriteService];
        }
    }
}

#pragma mark - Orientation Change

- (void)didChangeOrientation:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        if(selectedFrameCount == 1){
            [self performSelector:@selector(translateOffset) withObject:nil afterDelay:0.2];
            
        }

        self.collectionViewHeightConstraint.constant = [Utils appDelegate].window.frame.size.height;
        self.collectionViewCenterYConstraint.constant = 0;
        self.navigationController.navigationBarHidden = YES;
        
        
    }
    else {
        
        if(selectedFrameCount == 1){
            [self performSelector:@selector(translateOffset) withObject:nil afterDelay:0.2];
            
        }
    
        self.collectionViewHeightConstraint.constant = self.view.frame.size.width * 0.91;
        self.collectionViewCenterYConstraint.constant = -50;
        self.navigationController.navigationBarHidden = NO;
    }
    
    if (self.overlayView) {
        [self.overlayView removeFromSuperview];
        self.overlayView = nil;
    }
    
    //[self.view layoutIfNeeded];
}

#pragma mark - BottomControlViewDelegate

- (void)didClickedScreenshot:(BottomControlView *)bottomComtrolView
{
    [self takeScreenShot];
}

- (void)didClickedFavourite:(BottomControlView *)bottomComtrolView
{
    [self actOnFavourite];
}

@end
