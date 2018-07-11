//
//  MoviePlayerVC.m
//  EyeLogix
//
//  Created by Smriti on 5/30/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "LivePreviewVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "AppConstants.h"
#import "MBProgressHUD.h"


static NSString * formatTimeInterval(CGFloat seconds, BOOL isLeft)
{
    seconds = MAX(0, seconds);
    
    NSInteger s = seconds;
    NSInteger m = s / 60;
    NSInteger h = m / 60;
    
    s = s % 60;
    m = m % 60;
    
    NSMutableString *format = [(isLeft && seconds >= 0.5 ? @"-" : @"") mutableCopy];
    if (h != 0) [format appendFormat:@"%ld:%0.2ld", (long)h, (long)m];
    else        [format appendFormat:@"%ld", (long)m];
    [format appendFormat:@":%0.2ld", (long)s];
    
    
    return format;
}

static NSMutableDictionary * gHistory;

@interface LivePreviewVC () {
    
    BOOL                _disableUpdateHUD;
    NSTimeInterval      _tickCorrectionTime;
    NSTimeInterval      _tickCorrectionPosition;
    NSUInteger          _tickCounter;
    BOOL                _fullscreen;
    BOOL                _isRecord;
    BOOL                _hiddenHUD;
    BOOL                _fitMode;
    BOOL                _infoMode;
    BOOL                _restoreIdleTimer;
    BOOL                _interrupted;
    
    IBOutlet UIView              *_topHUD;
    IBOutlet UIToolbar           *_topBar;
    IBOutlet UIToolbar           *_bottomBar;
    IBOutlet UISlider            *_progressSlider;
    
    UIBarButtonItem     *_playBtn;
    UIBarButtonItem     *_pauseBtn;
    
    UIBarButtonItem     *_aspectBtn;
    UIButton            *_aspectInternalBtn;
    
    UIBarButtonItem     *_volumeBtn;
    UIButton            *_volumeInternalBtn;
    
    UIBarButtonItem     *_speedDownBtn;
    UIButton            *_speedDownInternalBtn;
    
    UIBarButtonItem     *_speedUpBtn;
    UIButton            *_speedUpInternalBtn;
    
    //UIBarButtonItem     *_rewindBtn;
    //UIBarButtonItem     *_fforwardBtn;
    UIBarButtonItem     *_spaceItem;
    UIBarButtonItem     *_fixedSpaceItem;
    
    IBOutlet UIButton   *_doneButton;
    UIButton            *_shotButton;
    UILabel             *_progressLabel;
    UILabel             *_leftLabel;
    UIButton            *_infoButton;
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UIView *_viewMainPlayer;
    
    IBOutlet UIActivityIndicatorView *_activityIndicatorView;
    UILabel             *_subtitlesLabel;
    
    UITapGestureRecognizer *_tapGestureRecognizer;
    UITapGestureRecognizer *_doubleTapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureRecognizer;
    
    BOOL                _savedIdleTimer;
    
    NSString            *_path;
    
    MediaPlayerConfig*  config;
    int                 ff_rate;
    
    M3U8*               m3u8_parser;
    NSArray*            allGetInfoXmlStrings;
    
    int                 shot_buffer_size;
    uint8_t*            shot_buffer;
    
    int                 actualPlayerCount;
    int                 intFrameCount;
    UIView*             frameView[8];
    MediaPlayer*        players[16];
    
    CGPoint             touchMoveLast;
    
    float intVideoWidth;
    float intVideoHeight;
    int intSelectedIndex;
    
    NSArray *arrayVideos;

    __weak IBOutlet NSLayoutConstraint *collectionViewHeight;
    __weak IBOutlet NSLayoutConstraint *mainPlayerViewHeight;
    
    MBProgressHUD *progressHud;
    __weak IBOutlet UILabel *lbFrameRatio;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
- (IBAction)tabFrameButton:(id)sender;



@end

@implementation LivePreviewVC

+ (void)initialize
{
    if (!gHistory)
        gHistory = [NSMutableDictionary dictionary];
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void) initWithContentPath: (NSArray *) arrayPath
{
    
    int intCountPlayers = (int)arrayPath.count;
    
    actualPlayerCount = (intCountPlayers < 1 ? 1 : intCountPlayers);
    
    arrayVideos = arrayPath;
    
    
    for (int i = 0; i < actualPlayerCount; i++)
    {
        frameView[i] = nil;
    }
    
    for (int i = 0; i < actualPlayerCount; i++)
    {
        players[i] = nil;
    }
    
    m3u8_parser = [[M3U8 alloc] init];
    ff_rate = 1000;
    _infoMode = NO;
    
    int width = 5000;
    int height = 5080;
    shot_buffer_size = width * height * 4;
    shot_buffer = malloc(shot_buffer_size);
    
    _isRecord = NO;
    
}

- (void)showSelectedCamsArray:(NSArray *)selectedCamsArray
{
    NSLog(@"cams Array = %@", selectedCamsArray);
    NSMutableArray *urlsArray = [NSMutableArray array];
    for (NSDictionary *camDetails in selectedCamsArray) {
        [urlsArray addObject:camDetails[@"IP_Url"]];
    }
    
    [self initWithContentPath:urlsArray];
}

-(void) viewDidLoad {
    [super viewDidLoad];
    

    self.title = @"Live Preview";
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu_1"]
                                                                                    style:UIBarButtonItemStylePlain
                                                                                   target:self
                                                        action:@selector(backbtn:)];
    
    self.navigationItem.leftBarButtonItem = btn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [_collectionView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];

    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [_viewMainPlayer addGestureRecognizer:doubleTap];
    
    [self updateView];
}

-(void) doDoubleTap {
    _viewMainPlayer.hidden = YES;
    _collectionView.hidden = NO;

    [self setupFramesForAllViews: actualPlayerCount width:intVideoWidth height:intVideoHeight ];

}


-(void) backbtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)updateView
{
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:[UIApplication sharedApplication]];

    
    intVideoWidth = (_collectionView.frame.size.width - 10) / 2;
    
    intVideoHeight = (intVideoWidth * 3)/4;
    
    if (actualPlayerCount < 5) {
        intFrameCount = actualPlayerCount;
        lbFrameRatio.text = [NSString stringWithFormat:@"%d / %d", 1, actualPlayerCount];
    }
    else    {
        intFrameCount = 4;
    }
    
    
    
    collectionViewHeight.constant = (self.view.frame.size.width * 3)/ 4;
    mainPlayerViewHeight.constant = (self.view.frame.size.width * 3)/ 4;
    

    progressHud.hidden = YES;
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    _tapGestureRecognizer.numberOfTapsRequired = 1;
    
    _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    
    [_tapGestureRecognizer requireGestureRecognizerToFail: _doubleTapGestureRecognizer];
    
    [self.view addGestureRecognizer:_doubleTapGestureRecognizer];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
}

-(void) viewWillAppear:(BOOL)animated   {
    intSelectedIndex = -1;

    [self setupFramesForAllViews: actualPlayerCount width:intVideoWidth height:intVideoHeight ];
}

-(void) viewDidAppear:(BOOL)animated    {

    for (int i = 0; i < actualPlayerCount; i++)
    {
        config = [[MediaPlayerConfig alloc] init];
        config.decodingType = 0; // HW
        config.numberOfCPUCores = 0;
        config.sslKey = @"75ffa55a38c3629b";
        config.aspectRatioMode = 1;
        config.aspectRatioZoomModePercent = 100;
        config.connectionUrl = [arrayVideos objectAtIndex:i];
        [players[i] Open:config callback:self];
        usleep(500000);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
    
    [_activityIndicatorView stopAnimating];
    
    if (_fullscreen)    {
        [self fullscreenMode:NO];
    }
    
    if (_infoMode)  {
        [self showInfoView:NO animated:NO];
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:_savedIdleTimer];
    
    [_activityIndicatorView stopAnimating];
    _interrupted = YES;
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] Close];
    }
    
    UIView *v = [self.view.subviews objectAtIndex:0];
    [v removeFromSuperview];
}

- (void) dealloc
{
    if (shot_buffer)
    {
        free(shot_buffer);
        shot_buffer = 0;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (int i = 0; i < actualPlayerCount; i++)
    {
        frameView[i] = nil;
    }
    
    for (int i = 0; i < actualPlayerCount; i++)
    {
        players[i] = nil;
    }
}

- (void) Close
{
    for (int i = 0; i < actualPlayerCount; i++)
    {
        frameView[i] = nil;
    }
    
    for (int i = 0; i < actualPlayerCount; i++)
    {
        players[i] = nil;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) applicationWillResignActive: (NSNotification *)notification
{

}

#pragma mark - gesture recognizer

- (void) handleTap: (UITapGestureRecognizer *) sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (sender == _tapGestureRecognizer) {
            

            
        } else if (sender == _doubleTapGestureRecognizer) {
            _viewMainPlayer.hidden = YES;
            _collectionView.hidden = NO;
            [self setupFramesForAllViews: actualPlayerCount width:intVideoWidth height:intVideoHeight ];
        }
    }
}

- (void) handlePan: (UIPanGestureRecognizer *) sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    
    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
    
    touchMoveLast = [touch locationInView:self.view];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
    
    CGPoint touchMoveCurrent = [touch locationInView:self.view];
    int delta_x = (int)(touchMoveCurrent.x	 - touchMoveLast.x) / 2; // 2 for slow move
    int delta_y = (int)(touchMoveCurrent.y - touchMoveLast.y) / 2;
    
    int directions = [players[0] getAvailableDirectionsForAspectRatioMoveMode];
    MediaPlayerConfig* cfg = [players[0] getConfig];
    if (cfg.aspectRatioMode == 5)
    {
        if ((delta_x >= 0 && (directions & 0x2) == 0x2) ||
            (delta_x < 0 && (directions & 0x1) == 0x1))
            cfg.aspectRatioMoveModeX += delta_x;
        
        if ((delta_y >= 0 && (directions & 0x8) == 0x8) ||
            (delta_y < 0 && (directions & 0x4) == 0x4))
            cfg.aspectRatioMoveModeY -= delta_y;
        
        for (int i = 0; i < actualPlayerCount; i++)
        {
            [players[i] updateView];
        }
    }
    
    touchMoveLast = touchMoveCurrent;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
    CGPoint touchLocation = [touch locationInView:self.view];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
}
#pragma mark - public

-(void) play
{
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] Play:0];
    }
//    [self updatePlayButton];
}

- (void) pause
{
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] Pause];
    }
//    [self updatePlayButton];
}

#pragma mark - actions

- (void) doneDidTouch: (id) sender
{
    if (self.presentingViewController || !self.navigationController)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void) shotDidTouch: (id) sender
{
    if (players[0] == nil)
        return;
    
    int32_t desired_width = -1;//100;
    int32_t desired_height = -1;//100;
    int32_t bytes_per_row = 0;
    
    int rc = [players[0] getVideoShot:shot_buffer buffer_size:&shot_buffer_size width:&desired_width height:&desired_height bytes_per_row:&bytes_per_row];
    if (rc < 0)
        return;
    
    [self showShotView:shot_buffer buffer_size:shot_buffer_size width:desired_width height:desired_height bytes_per_row:bytes_per_row];
}

- (void) infoDidTouch: (id) sender
{

    
    if (players[0] == nil)
        return;
    
    if (_isRecord)
    {
        [players[0] recordStop];
        _isRecord = NO;
        [_infoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        NSString * tmpfile = [NSTemporaryDirectory() stringByAppendingPathComponent:@""];
        [players[0] recordSetup: tmpfile flags: RECORD_AUTO_START splitTime:0 splitSize:0 prefix:@"TestRecord"];
        [players[0] recordStart];
        _isRecord = YES;
        [_infoButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_infoButton setFont:[UIFont boldSystemFontOfSize:18]];
    }
}

- (void) playDidTouch: (id) sender
{
    if (players[0] == nil)
        return;
    
    MediaPlayerState state = [players[0] getState];

    if (state == MediaPlayerStarted)
        [self pause];
    else
        [self play];
    
    [_activityIndicatorView stopAnimating];
    
}

- (void) aspectDidTouch: (id) sender
{
    if (players[0] == nil)
        return;
    
    MediaPlayerConfig* cfg = [players[0] getConfig];
    cfg.aspectRatioMode++;
    if (cfg.aspectRatioMode > 5)    {
        cfg.aspectRatioMode = 0;
    }

    
    switch (cfg.aspectRatioMode)
    {
        case 0:
            [_aspectInternalBtn setTitle:@"Stretch" forState:UIControlStateNormal];
            break;
        case 1:
            [_aspectInternalBtn setTitle:@"Fit to screen" forState:UIControlStateNormal];
            break;
        case 2:
            [_aspectInternalBtn setTitle:@"Crop" forState:UIControlStateNormal];
            break;
        case 3:
            [_aspectInternalBtn setTitle:@"Original size" forState:UIControlStateNormal];
            break;
        case 4:
            [_aspectInternalBtn setTitle:@"Zoom" forState:UIControlStateNormal];
            break;
            
        case 5:
        {
            MediaPlayerConfig* cfg = [players[0] getConfig];
            if (cfg.aspectRatioMode == 5)
            {
                cfg.aspectRatioMoveModeX = 50;
                cfg.aspectRatioMoveModeY = 50;
                for (int i = 0; i < actualPlayerCount; i++)
                {
                    [players[i] updateView];
                }
            }
            [_aspectInternalBtn setTitle:@"Move" forState:UIControlStateNormal];
            break;
        }
    }
    
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] updateView];
    }
}

- (void) volumeDidTouch: (id) sender
{
    if (players[0] == nil)
        return;
    
    MediaPlayerConfig* cfg = [players[0] getConfig];
    BOOL mute = (cfg.enableAudio == 1);
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] toggleMute:mute];
    }
    

    switch (cfg.enableAudio)
    {
        case 0:
            [_volumeInternalBtn setTitle:@"Unmute" forState:UIControlStateNormal];
            break;
        case 1:
            [_volumeInternalBtn setTitle:@"Mute" forState:UIControlStateNormal];
            break;
    }
}

- (void) speedDownDidTouch: (id) sender
{
    
    //    UIView *frameView = [self frameView];
    //    frameView.frame = CGRectMake( 0, 0, 500, 500 );
    
    MediaPlayerConfig* cfg = [players[0] getConfig];
    if (cfg.aspectRatioMode == 4)
    {
        cfg.aspectRatioZoomModePercent--;
        for (int i = 0; i < actualPlayerCount; i++)
        {
            [players[i] updateView];
        }
        return;
    }
    
    ff_rate = 400;
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] setFFRate:ff_rate];
    }
}

- (void) speedUpDidTouch: (id) sender
{
    //    UIView *frameView = [self frameView];
    //    frameView.frame = self.view.bounds;
    
    MediaPlayerConfig* cfg = [players[0] getConfig];
    if (cfg.aspectRatioMode == 4)
    {
        cfg.aspectRatioZoomModePercent++;
        for (int i = 0; i < actualPlayerCount; i++)
        {
            [players[i] updateView];
        }
        return;
    }
    
    ff_rate = 3000;
    for (int i = 0; i < actualPlayerCount; i++)
    {
        [players[i] setFFRate:ff_rate];
    }
}


- (void) forwardDidTouch: (id) sender
{
    //    [self setMoviePosition: _moviePosition + 10];
}

- (void) rewindDidTouch: (id) sender
{
    //    [self setMoviePosition: _moviePosition - 10];
}

- (void) progressDidChange: (id) sender
{
    UISlider *slider = sender;
    [players[0] setLiveStreamPosition:slider.value * 1000];
}

#pragma mark - private

- (void) restorePlay
{
    
}

- (void) setupFramesForAllViews:(int) playerCount width: (float) width height: (float) height
{    
    for (int i = 0; i < playerCount; i++)
    {
        [self getPlayerView:i width: width height:height];
        
        if (intSelectedIndex == i) {
            [self getPlayerView:i width: width height:height].frame = CGRectMake(0, 0, width, height);
        }
        else    {
            [self getPlayerView:i width: width height:height];
        }
    }
    
    [_collectionView reloadData];
}

- (UIView *) getPlayerView:(int)index  width: (float) width height: (float) height
{
    if (players[index] == nil)
    {
        players[index] = [[MediaPlayer alloc] init:CGRectMake( 0, 0, width, height )];
    }
    
    return [players[index] contentView];
}

//- (void) setupUserInteraction
//{
//    self.view.userInteractionEnabled = YES;
//    
//    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    _tapGestureRecognizer.numberOfTapsRequired = 1;
//    
//    _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
//    
//    [_tapGestureRecognizer requireGestureRecognizerToFail: _doubleTapGestureRecognizer];
//    
//    [self.view addGestureRecognizer:_doubleTapGestureRecognizer];
//    [self.view addGestureRecognizer:_tapGestureRecognizer];
//    
//}




- (void) enableAudio: (BOOL) on
{
    
}

- (void) tick
{
    MediaPlayerState state = [players[0] getState];
    
    if (state == MediaPlayerStarted)
    {
        _tickCorrectionTime = 0;
        [_activityIndicatorView stopAnimating];
    }
    
    if (state == MediaPlayerStarted)
    {
        const NSTimeInterval time =  0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [self tick];
                       });
    }
    
    if ((_tickCounter++ % 3) == 0)
    {

        
        int source_videodecoder_filled = 0;
        int source_videodecoder_size = 0;
        int videodecoder_videorenderer_filled = 0;
        int videodecoder_videorenderer_size = 0;
        int source_audiodecoder_filled = 0;
        int source_audiodecoder_size = 0;
        int audiodecoder_audiorenderer_filled = 0;
        int audiodecoder_audiorenderer_size = 0;
        [players[0] getInternalBuffersState:&source_videodecoder_filled
                   source_videodecoder_size:&source_videodecoder_size
          videodecoder_videorenderer_filled:&videodecoder_videorenderer_filled
            videodecoder_videorenderer_size:&videodecoder_videorenderer_size
                 source_audiodecoder_filled:&source_audiodecoder_filled
                   source_audiodecoder_size:&source_audiodecoder_size
          audiodecoder_audiorenderer_filled:&audiodecoder_audiorenderer_filled
            audiodecoder_audiorenderer_size:&audiodecoder_audiorenderer_size];
       
        
        int view_orientation = 1;
        int view_width = 0;
        int view_height = 0;
        int video_width = (int)intVideoWidth;
        int video_height = (int)intVideoHeight;
        int aspect_left = 0;
        int aspect_top = 0;
        int aspect_width = 0;
        int aspect_height = 0;
        int aspect_zoom = 0;
        [players[0] getViewSizesAndVideoAspects:&view_orientation
                                     view_width:&view_width
                                    view_height:&view_height
                                    video_width:&video_width
                                   video_height:&video_height
                                    aspect_left:&aspect_left
                                     aspect_top:&aspect_top
                                   aspect_width:&aspect_width
                                  aspect_height:&aspect_height
                                    aspect_zoom:&aspect_zoom];
        
    }
}

//- (void) updateBottomBar
//{
//    MediaPlayerState state = [players[0] getState];
//    UIBarButtonItem *playPauseBtn = (state == MediaPlayerStarted) ? _pauseBtn : _playBtn;
//    //[_bottomBar setItems:@[_spaceItem, _rewindBtn, _fixedSpaceItem, playPauseBtn,
//    //                       _fixedSpaceItem, _fforwardBtn, _spaceItem] animated:NO];
//    [_bottomBar setItems:@[_spaceItem, _fixedSpaceItem, _speedDownBtn, _speedUpBtn, _fixedSpaceItem, playPauseBtn, _fixedSpaceItem, _aspectBtn,
//                           _fixedSpaceItem, _volumeBtn, _fixedSpaceItem, _spaceItem] animated:NO];
//}
//
//- (void) updatePlayButton
//{
//    [self updateBottomBar];
//}



- (void) fullscreenMode: (BOOL) on
{
    _fullscreen = on;
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:on withAnimation:UIStatusBarAnimationNone];
}

- (void) enableUpdateHUD
{
    _disableUpdateHUD = NO;
}

- (int) Status: (MediaPlayer*)player1
          args: (int)arg
{
    switch(arg)
    {
        case PLP_BUILD_STARTING:
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [_activityIndicatorView startAnimating];
//                               [self updatePlayButton];
                           });
            break;
        }
        case PLP_PLAY_SUCCESSFUL:
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [_activityIndicatorView stopAnimating];
//                               [self updatePlayButton];
                               
                               [_progressSlider addTarget:self
                                                   action:@selector(progressDidChange:)
                                         forControlEvents:UIControlEventValueChanged];
                               
                               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
                               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                   [self tick];
                                   
                                   MediaPlayerConfig* cfg = [player1 getConfig];
                                   cfg.aspectRatioMode = 1;
                                   [player1 updateView];

                               });
                               
                               
                               
                           });
            break;
        }
    }
    return 0;
}

-(int) OnReceiveData: (MediaPlayer*)player
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

- (void) showInfoView: (BOOL) showInfo animated: (BOOL)animated
{
    
    if (showInfo) {
        
        if (animated) {
            
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                             animations:^{
                                 
                             }
                             completion:nil];
        }
    } else {
        
        if (animated) {
            
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                             animations:^{
                                 
                                 
                             }
                             completion:^(BOOL f){
                                
                             }];
        }
    }
    
    _infoMode = showInfo;
}

- (void) showShotView:(uint8_t*)buffer
          buffer_size:(int32_t)buffer_size
                width:(int32_t)width
               height:(int32_t)height
        bytes_per_row:(int32_t)bytes_per_row

{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Test video shot"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 10, 85, 50)];
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,
                                                              buffer,
                                                              buffer_size,
                                                              NULL);
    
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = bytes_per_row;
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
    [imageView setImage:newImage];
    
    //check if os version is 7 or above
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [alertView setValue:imageView forKey:@"accessoryView"];
    }else{
        [alertView addSubview:imageView];
    }
    
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    
    [alertView show];
}

#pragma mark - Colletion view data source


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return intFrameCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(intVideoWidth, intVideoHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    [cell.contentView addSubview:[players[indexPath.row] contentView]];

    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float floatTempWidth = _collectionView.frame.size.width - 10;
    float floatTempHeight = (floatTempWidth * 3)/4;
    
    [self getPlayerView:(int)indexPath.row width: floatTempWidth height:floatTempHeight].frame = CGRectMake(0, 0, floatTempWidth, floatTempHeight);
    [_viewMainPlayer addSubview:[players[indexPath.row] contentView]];
    _viewMainPlayer.hidden = NO;
    _collectionView.hidden = YES;
    
    intSelectedIndex = (int)indexPath.row;
    

    
}

#pragma mark - Custom Methods

- (IBAction)tabFrameButton:(id)sender {
    
    [self unSelectedAll];
    
    intSelectedIndex = -1;
    
    UIButton *btTemp = (UIButton *)sender;
    btTemp.selected = YES;
    
    int intTag = (int) [btTemp tag];
    
    if (actualPlayerCount < intTag) {
        intFrameCount = actualPlayerCount;
        lbFrameRatio.text = [NSString stringWithFormat:@"%d / %d", 1, actualPlayerCount];
    }
    else    {
        intFrameCount = intTag;
        lbFrameRatio.text = [NSString stringWithFormat:@"%d / %d", 1, intTag];
    }
    
    if (intTag == 1) {
         intVideoWidth = _collectionView.frame.size.width - 10;
    }
    
    else if(intTag == 4)    {
         intVideoWidth = (_collectionView.frame.size.width - 10) / 2;
    }
    
    else if(intTag == 9)    {
         intVideoWidth = (_collectionView.frame.size.width - 20) / 3;
    }
    
    else if(intTag == 16)    {
         intVideoWidth = (_collectionView.frame.size.width - 30) / 4;
    }
    
    intVideoHeight = (intVideoWidth * 3)/4;
    
    _collectionView.hidden = NO;

    
    [self setupFramesForAllViews:intFrameCount width:intVideoWidth height:intVideoHeight ];

}



-(void) unSelectedAll {
   
    btn1.selected = NO;
    btn4.selected = NO;
    btn9.selected = NO;
    btn16.selected = NO;
    
}

@end

