//
//  EventPlayBackVC.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/25/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "EventPlayBackVC.h"
#import "MediaPlayer.h"
#import "ServiceManger.h"
#import "Utils.h"

#define IndecatorViewTag 111
#define DisconnectedLabelTag 101
#define ReloadButtonBaseTag 1000

#define Orientation [UIApplication sharedApplication].statusBarOrientation

@interface EventPlayBackVC ()<MediaPlayerCallback>
{
    MediaPlayer*        players[1];
    int                 shot_buffer_size;
    uint8_t*            shot_buffer;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAndEventIdLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) NSDictionary *response;


@property (nonatomic, strong) UIView *overlayView;

@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *camId;

- (IBAction)playPauseButtonPressed:(UIButton *)sender;
- (IBAction)screenShotButtonPressed:(UIButton *)sender;

@end

@implementation EventPlayBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!UIInterfaceOrientationIsLandscape(Orientation)) {
        self.containerViewHeightConstraint.constant = self.view.frame.size.width * 0.91;
    }
    
    [self doInitialConfiguration];
    [self configureNavigationBar];
    [self getEventPlayBackUrl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [players[0] Close];
    players[0] = nil;
}

- (void) dealloc
{
    if (shot_buffer)
    {
        free(shot_buffer);
        shot_buffer = 0;
    }
    
    if (players[0] != nil)
        players[0] = nil;
}

#pragma mark - Public Methods

- (void)setEventId:(NSString *)eventId andCamId:(NSString *)camId
{
    self.eventId = eventId;
    self.camId = camId;
}

#pragma mark - Private Methods

-(void)onTapReload:(UIButton *)btn {
    
    [self initializeMediaPlayerWithURLString:self.response[@"EventUrl"]];
}

- (void)initializeMediaPlayerWithURLString:(NSString *)urlString
{
    [players[0] Close];
    players[0] = nil;
    
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
    
    MediaPlayerConfig *config = [[MediaPlayerConfig alloc] init];
    config.decodingType = 0; // SW
    config.numberOfCPUCores = 0;
    config.sslKey = @"75ffa55a38c3629b";
    config.aspectRatioMode = 0;
    config.aspectRatioZoomModePercent = 100;
    config.connectionUrl = urlString;
    [self getPlayerViewForWidth:self.containerView.frame.size.width andHeight:self.containerView.frame.size.height];
    [players[0] Open:config callback:self];
    
    UIView *camView = [players[0] contentView];
    camView.bounds = self.containerView.bounds;
    
    [self.containerView addSubview:camView];
    [Utils addTapGestureToView:camView target:self selector:@selector(onTapCamView:)];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.tag = IndecatorViewTag;
    indicator.center = CGPointMake(self.containerView.frame.size.width/2, self.containerView.frame.size.height/2);
    indicator.hidesWhenStopped = YES;
    [camView addSubview:indicator];
    [indicator startAnimating];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 70, 21)];
    label.tag = DisconnectedLabelTag;
    label.text = @"Disconnected";
    label.textColor = [UIColor whiteColor];
    label.font = [Utils helveticaFontWithSize:8.0];
    [camView addSubview:label];
    label.hidden = YES;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.containerView.frame.size.width/2 - 20, self.containerView.frame.size.height/2 - 20, 40, 40)];
    [button setImage:[UIImage imageNamed:@"Reload"] forState:UIControlStateNormal];
    button.tag = ReloadButtonBaseTag;
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    button.hidden = true;
    [button addTarget:self action:@selector(onTapReload:) forControlEvents:UIControlEventTouchUpInside];
    [camView addSubview:button];
    
}

- (void)onTapCamView:(id)sender
{
    if (UIInterfaceOrientationIsLandscape(Orientation) && [players[0] getState] == MediaPlayerStarted) {
        if (self.overlayView == nil) {
            self.overlayView = [[UIView alloc] initWithFrame:[Utils appDelegate].window.bounds];
            
            self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            [Utils addTapGestureToView:self.overlayView target:self selector:@selector(onTapOverlayView:)];
            
            UIView *screenshotContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.overlayView.frame.size.width/2 - 40, self.overlayView.frame.size.height - 50, 80, 50)];
            screenshotContainerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            [Utils addTapGestureToView:screenshotContainerView target:self selector:@selector(onTapScreenShotView:)];
            
            UIImageView *screenshotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScreenshotGray"]];
            screenshotImageView.frame = CGRectMake(screenshotContainerView.frame.size.width/2 - 15, screenshotContainerView.frame.size.height/2 - 15, 30, 30);
            
            [screenshotContainerView addSubview:screenshotImageView];
            [self.overlayView addSubview:screenshotContainerView];
        }
        
        [self.view addSubview:self.overlayView];
    }
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

- (void)doInitialConfiguration
{
    int width = 5000;
    int height = 5080;
    shot_buffer_size = width * height * 4;
    shot_buffer = malloc(shot_buffer_size);
}

- (UIView *) getPlayerViewForWidth:(float)width andHeight:(float)height
{
    if (players[0] == nil)
    {
        players[0] = [[MediaPlayer alloc] init:CGRectMake( 0, 0, width, height )];
    }
    
    return [players[0] contentView];
}

- (void)configureNavigationBar
{
    self.title = @"Event Play";
    
    [self.navigationController setNavigationBarHidden:false];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:188.0f/255.0f green:16.0f/255.0f blue:15.0f/255.0f alpha:1]];
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu_1"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backbtn:)];
    
    self.navigationItem.leftBarButtonItem = btn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if(self.showCross) {
        
        UIBarButtonItem *crossBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Cross"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(crossBtn:)];
        
        self.navigationItem.rightBarButtonItem = crossBtn;

        
    }
}

-(void) backbtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)crossBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)takeScreenShot
{
    int32_t desired_width = -1;//100;
    int32_t desired_height = -1;//100;
    int32_t bytes_per_row = 0;
    
    int rc = [players[0] getVideoShot:shot_buffer buffer_size:&shot_buffer_size width:&desired_width height:&desired_height bytes_per_row:&bytes_per_row];
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

#pragma mark - Network Call

- (void)getEventPlayBackUrl
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service getEventUrlWithEventId:self.eventId andCamId:self.camId withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response && error == nil) {
            self.response = response;
            
            [self initializeMediaPlayerWithURLString:response[@"EventUrl"]];
            
            if (response[@"CamAbbr"]) {
                
                self.storeLabel.text = response[@"CamAbbr"];
            }
            else {
                self.storeLabel.text = @"";
            }
            
            if (response[@"Title"]) {
                
                self.eventLabel.text = [NSString stringWithFormat:@"Event Title: %@", response[@"Title"]];
            }
            else {
                self.eventLabel.text = @"";
            }
            
            if (response[@"EventDateTime"] && response[@"EventId"]) {
                
                self.dateAndEventIdLabel.text = [NSString stringWithFormat:@"%@, Event Id:%@", response[@"EventDateTime"], response[@"EventId"]];
            }
            else {
                self.dateAndEventIdLabel.text = @"";
            }
            
            
        }
    }];
}

#pragma mark - MediaPlayerCallback

- (int) Status: (MediaPlayer*)player
          args: (int)arg
{
    if ([player getState] == MediaPlayerStarted) {
        
        self.playPauseButton.userInteractionEnabled = true;
    }
    
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
                               UIButton *reloadBtn = [[player contentView] viewWithTag:ReloadButtonBaseTag];
                               reloadBtn.hidden = YES;
                               UILabel *disconnectedLabel = [[player contentView] viewWithTag:DisconnectedLabelTag];
                               disconnectedLabel.hidden = YES;
                           });
            break;
        }
        case PLP_PLAY_SUCCESSFUL:
        {
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               UIActivityIndicatorView *indicator = [[player contentView] viewWithTag:IndecatorViewTag];
                               [indicator stopAnimating];
                               UIButton *reloadBtn = [[player contentView] viewWithTag:ReloadButtonBaseTag];
                               reloadBtn.hidden = YES;
                               UILabel *disconnectedLabel = [[player contentView] viewWithTag:DisconnectedLabelTag];
                               disconnectedLabel.hidden = YES;
                           });
            break;
        }
            
        case CP_INIT_FAILED:
        case CP_ERROR_DISCONNECTED:
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               UIButton *reloadBtn = [[player contentView] viewWithTag:ReloadButtonBaseTag];
                               reloadBtn.hidden = NO;

                               UILabel *disconnectedLabel = [[player contentView] viewWithTag:DisconnectedLabelTag];
                               disconnectedLabel.hidden = NO;
                               
                               UIActivityIndicatorView *indicator = [[player contentView] viewWithTag:IndecatorViewTag];
                               [indicator stopAnimating];
                           });
            break;
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

#pragma mark - IBActions

- (IBAction)playPauseButtonPressed:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [players[0] Pause];
    }
    else {
        [players[0] Play:0];
    }
}

- (IBAction)screenShotButtonPressed:(UIButton *)sender {
    [self takeScreenShot];
}

#pragma mark - Orientation Change

- (void)didChangeOrientation:(NSNotification *)notification
{
    UIActivityIndicatorView *indicator = [[players[0] contentView] viewWithTag:IndecatorViewTag];
    UIButton *reloadBtn = [[players[0] contentView] viewWithTag:ReloadButtonBaseTag];
    
    if (UIInterfaceOrientationIsLandscape(Orientation)) {
        UIWindow *window = [Utils appDelegate].window;
        self.containerViewHeightConstraint.constant = window.frame.size.height;
        self.navigationController.navigationBarHidden = YES;
        indicator.center = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
        reloadBtn.center = indicator.center;
    }
    else {
        UIWindow *window = [Utils appDelegate].window;
        self.containerViewHeightConstraint.constant = window.frame.size.width * 0.91;
        self.navigationController.navigationBarHidden = NO;
        indicator.center = CGPointMake(self.containerView.frame.size.width/2, self.containerView.frame.size.height/2);
        reloadBtn.center = indicator.center;
    }
    
    if (self.overlayView) {
        [self.overlayView removeFromSuperview];
        self.overlayView = nil;
    }
    
    [self.view layoutIfNeeded];
}

@end
