//
//  PlayBackStreamVC.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/19/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "PlayBackStreamVC.h"
#import "MediaPlayer.h"
#import "SliderView.h"
#import "Utils.h"
#import "ServiceManger.h"
#import "DatePickerView.h"
#import "PlayBackTimeSelectionVC.h"
#import "PlaybackBottomControlView.h"

#define IndecatorViewTag 111
#define DisconnectedLabelTag 101
#define ReloadButtonBaseTag 2000

#define BottomControlViewTag 1001

#define Orientation [UIApplication sharedApplication].statusBarOrientation

@interface PlayBackStreamVC ()<MediaPlayerCallback, SliderViewDelegate, DatePickerViewDelegate, PlaybackBottomControlViewDelegate>
{
    MediaPlayer*        players[1];
    int                 shot_buffer_size;
    uint8_t*            shot_buffer;
    
    int currectSliderValue;
}

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *camLabel;
@property (weak, nonatomic) IBOutlet UILabel *topTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet SliderView *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *camAndTimeContainerView;
@property (weak, nonatomic) IBOutlet UIView *sliderContainerView;


@property (nonatomic, strong) DatePickerView *datePickerView;
@property (nonatomic, strong) UIView *overlayView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;


@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSString *storeName;
@property (nonnull, strong) NSDictionary *camDetails;
@property (nonatomic, strong) NSDictionary *recordingHoursDict;

//@property (nonatomic, strong) NSString *playbackURL;
//@property (nonatomic, strong) NSDictionary *recordingHoursDict;
//@property (nonatomic, strong) NSDate *selectedDate;
//@property (nonnull, strong) NSDictionary *camDetails;

@property (nonatomic, strong) NSDateComponents *dateComponents;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSDictionary *response;

- (IBAction)screenShotButtonPressed:(UIButton *)sender;

@end

@implementation PlayBackStreamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!UIInterfaceOrientationIsLandscape(Orientation)) {
        self.containerViewHeightConstraint.constant = self.view.frame.size.width * 0.91;
        
    }
    
    [self configureNavigationBar];
    [self setupViews];
    [self doInitialConfiguration];
    [self configureDateFormatter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [self callGetRecordingService];
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
    // Remove PlayBackTimeSelectionVC
    
    NSMutableArray *vcsArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in vcsArray) {
        if ([vc isKindOfClass:[PlayBackTimeSelectionVC class]]) {
            [vcsArray removeObject:vc];
            break;
        }
    }
    
    self.navigationController.viewControllers = vcsArray;
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

- (void)setDate:(NSDate *)date stoteName:(NSString *)storeName andCamDetails:(NSDictionary *)camDetails
{
    self.selectedDate = date;
    self.storeName = storeName;
    self.camDetails = camDetails;
}

//- (void)streamCamWithCamDetails:(NSDictionary *)camDetails playbackURL:(NSString *)playbackURL recordingHoursDetails:(NSDictionary *)details andDate:(NSDate *)date
//{
//    self.playbackURL = playbackURL;
//    self.recordingHoursDict = details;
//    self.selectedDate = date;
//    self.camDetails = camDetails;
//}

#pragma mark - Private Methods

-(void)onTapReload:(UIButton *)btn {
    
    [self initializeMediaPlayerWithUrl:[self.response objectForKey:@"PlaybackUrl"]];
}

- (void)setupViews
{
    self.storeNameLabel.text = self.storeName;
    self.camLabel.text = [self.camDetails objectForKey:@"CamTitle"];
}

- (void)configureNavigationBar
{
    self.title = @"PlayBack";
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu_1"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backbtn:)];
    
    self.navigationItem.leftBarButtonItem = btn;
    
    UIBarButtonItem *calenderButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Calender"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(rightButton:)];
    self.navigationItem.rightBarButtonItem = calenderButton;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void) backbtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButton:(id)sender
{
    [self openDatePickerView];
}

- (void)openDatePickerView
{
    if (self.datePickerView == nil) {
        self.datePickerView = [[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil].lastObject;
    }
    
    self.datePickerView.delegate = self;
    self.datePickerView.frame = self.view.frame;
    [self.view addSubview:self.datePickerView];
}


- (void)doInitialConfiguration
{
    int width = 5000;
    int height = 5080;
    shot_buffer_size = width * height * 4;
    shot_buffer = malloc(shot_buffer_size);
}

- (void)initializeMediaPlayerWithUrl:(NSString *)url
{
    [players[0] Close];
    players[0] = nil;
    
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
    
    MediaPlayerConfig *config = [[MediaPlayerConfig alloc] init];
    config.decodingType = 0; // HW
    config.numberOfCPUCores = 0;
    config.sslKey = @"75ffa55a38c3629b";
    config.aspectRatioMode = 0;
    config.aspectRatioZoomModePercent = 100;
    config.connectionUrl = url;
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
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    button.tag = ReloadButtonBaseTag;
    button.hidden = true;
    [button addTarget:self action:@selector(onTapReload:) forControlEvents:UIControlEventTouchUpInside];
    [camView addSubview:button];
}

- (UIView *) getPlayerViewForWidth:(float)width andHeight:(float)height
{
    if (players[0] == nil)
    {
        players[0] = [[MediaPlayer alloc] init:CGRectMake( 0, 0, width, height )];
    }
    
    return [players[0] contentView];
}

- (void)onTapCamView:(id)sender
{
    if (UIInterfaceOrientationIsLandscape(Orientation) && [players[0] getState] == MediaPlayerStarted) {
        if (self.overlayView == nil) {
            self.overlayView = [[UIView alloc] initWithFrame:[Utils appDelegate].window.bounds];
            
            self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            [Utils addTapGestureToView:self.overlayView target:self selector:@selector(onTapOverlayView:)];
            
            PlaybackBottomControlView *playbackControlView = [[NSBundle mainBundle] loadNibNamed:@"PlaybackBottomControlView" owner:self options:nil].lastObject;
            playbackControlView.tag = BottomControlViewTag;
            playbackControlView.frame = CGRectMake(self.overlayView.frame.size.width/2 - playbackControlView.frame.size.width/2, self.overlayView.frame.size.height - playbackControlView.frame.size.height, playbackControlView.frame.size.width, playbackControlView.frame.size.height);
            playbackControlView.delegate = self;
            playbackControlView.sliderViewDelegate = self;
            playbackControlView.sliderValue = currectSliderValue;
            playbackControlView.timeText = self.timeLabel.text;
            playbackControlView.recordingHoursDict = self.recordingHoursDict;
            
            [self.overlayView addSubview:playbackControlView];
        }
        
        [self.view addSubview:self.overlayView];
    }
}

- (void)onTapOverlayView:(id)sender
{
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
}

- (void)setupSliderView
{
    self.sliderView.delegate = self;
    self.sliderView.recordingHoursDict = self.recordingHoursDict;
    [self.sliderView setNeedsDisplay];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.selectedDate];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSInteger minutes = (hour * 60) + minute;
    currectSliderValue = (int)minutes;
    
    [self.sliderView setSliderValue:currectSliderValue];
}

- (void)configureDateFormatter
{
    self.dateComponents = [[NSDateComponents alloc] init];
    
    self.dateFormatter = [NSDateFormatter new];
    [self.dateFormatter setLocale:[NSLocale currentLocale]];
    [self.dateFormatter setDateFormat:@"hh:mm aa"];
}

/*

- (void)callGetPlayBackURLWithDateTimeString:(NSString *)dateTime
{
    ServiceManger *service = [ServiceManger sharedInstance];
    
    NSString *camId = [self.camDetails objectForKey:@"CamId"];
    NSDictionary *params = @{@"camid": camId ? camId : @"" , @"datetime": dateTime};
    
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service getPlaybackURLWithParams:params withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            NSLog(@"playback url = %@", [response objectForKey:@"PlaybackUrl"]);
            self.playbackURL = [response objectForKey:@"PlaybackUrl"];
            [self initializeMediaPlayer];
        }
    }];
}
 */

#pragma mark - Network Call

- (void)callGetRecordingService
{
    ServiceManger *service = [ServiceManger sharedInstance];
    
    NSString *camId = [self.camDetails objectForKey:@"CamId"];
    NSDictionary *params = @{@"camid": camId ? camId : @"" , @"date": [Utils stringFromDate:self.selectedDate inFormat:@"yyyy-MM-dd"]};
    
    [Utils showProgressInView:self.view text:@"Loading..."];
    [service getRecordingHoursWithParams:params withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            self.recordingHoursDict = [response objectForKey:@"RecordingHours"];
            [self setupSliderView];
            [self callGetPlayBackURLWithDateTimeString:[Utils stringFromDate:self.selectedDate inFormat:@"yyyy-MM-dd HH:mm:ss"]];
        }
    }];
}

- (void)callGetPlayBackURLWithDateTimeString:(NSString *)dateTimeString
{
    ServiceManger *service = [ServiceManger sharedInstance];
    
    NSString *camId = [self.camDetails objectForKey:@"CamId"];
    NSDictionary *params = @{@"camid": camId ? camId : @"" , @"datetime": dateTimeString};
    
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service getPlaybackURLWithParams:params withCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        if (response) {
            self.response = response;
            if (self.overlayView) {
                [self.overlayView removeFromSuperview];
                self.overlayView = nil;
            }
            
             self.topTimeLabel.text = [Utils stringFromDate:self.selectedDate inFormat:@"yyyy-MM-dd hh:mm:ss"];
            [self initializeMediaPlayerWithUrl:[response objectForKey:@"PlaybackUrl"]];
            
            self.camAndTimeContainerView.hidden = NO;
            self.sliderContainerView.hidden = NO;
        }
    }];
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
                               
                               UIButton *btnReload = [[player contentView] viewWithTag:ReloadButtonBaseTag];
                               btnReload.hidden = YES;
                               
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
                               
                               
                               UIButton *btnReload = [[player contentView] viewWithTag:ReloadButtonBaseTag];
                               btnReload.hidden = YES;
                               
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
                               
                               UIButton *btnReload = [[player contentView] viewWithTag:ReloadButtonBaseTag];
                               btnReload.hidden = NO;
                               
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

#pragma mark - SliderViewDelegate
- (void)sliderView:(SliderView *)sliderView didChangeSliderValue:(int)value
{
    [self.dateComponents setMinute:value];
    self.timeLabel.text = [self.dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:self.dateComponents]];
    
    PlaybackBottomControlView *playbackControlView = [self.overlayView viewWithTag:BottomControlViewTag];
    playbackControlView.timeText = self.timeLabel.text;
}

-(void)sliderView:(SliderView *)sliderView didEndDraggingWithValue:(int)value
{
    currectSliderValue = value;
    [self.dateComponents setMinute:value];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:self.dateComponents];
    
    NSString *datePart = [Utils stringFromDate:self.selectedDate inFormat:@"yyyy-MM-dd"];
    NSString *timePart = [Utils stringFromDate:date inFormat:@"HH:mm:ss"];
    NSString *dateTimeString = [NSString stringWithFormat:@"%@ %@", datePart, timePart];
    
    [self callGetPlayBackURLWithDateTimeString:dateTimeString];
    
    /*
    if (self.delegate && [self.delegate respondsToSelector:@selector(playBackVC:didUpdateDateTime:)]) {
        [self.delegate playBackVC:self didUpdateDateTime:dateTimeString];
    }
     */
}

#pragma mark - IBAction

- (IBAction)screenShotButtonPressed:(UIButton *)sender {
    MediaPlayerState state = [players[0] getState];
    if (state == MediaPlayerStarted) {
        // get screen shot
        [self takeScreenShot];
        
    }
    else {
        [Utils showToastWithMessage:@"Unable to capture screen"];
        return;
    }
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    
//    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
//        NSLog(@"LandScape");
//    }
//    else if (orientation == UIInterfaceOrientationPortrait) {
//        NSLog(@"Portrait");
//    }
//    
//    NSLog(@"size = %f %f", size.width, size.height);
//    
//    AppDelegate *appDel = [Utils appDelegate];
//    NSLog(@"Window size = %f %f", appDel.window.frame.size.width, appDel.window.frame.size.height);
//    
//    [players[0] contentView].frame = CGRectMake(0, 0, size.width, size.height);
//    [appDel.window addSubview:[players[0] contentView]];
//}

#pragma mark - DatePickerViewDelegate

- (void)datePickerView:(DatePickerView *)pickerView didSelectDate:(NSDate *)date
{
    [self.datePickerView removeFromSuperview];
    self.datePickerView = nil;
    
    self.selectedDate = date;
    [self callGetRecordingService];
}

- (void)didCancelDatePickerView:(DatePickerView *)pickerView
{
    [self.datePickerView removeFromSuperview];
    self.datePickerView = nil;
}

#pragma mark - PlaybackBottomControlViewDelegate

- (void)didClickOnScreenshotButton:(PlaybackBottomControlView *)playbackControlView
{
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
    }
    else {
        UIWindow *window = [Utils appDelegate].window;
        self.containerViewHeightConstraint.constant = window.frame.size.width * 0.91;
        self.navigationController.navigationBarHidden = NO;
        indicator.center = CGPointMake(self.containerView.frame.size.width/2, self.containerView.frame.size.height/2);
    }
    
    reloadBtn.center = indicator.center;
    
    if (self.overlayView) {
        [self.overlayView removeFromSuperview];
        self.overlayView = nil;
    }
    
    [self.sliderView setSliderValue:currectSliderValue];
    [self.view layoutIfNeeded];
}

@end
