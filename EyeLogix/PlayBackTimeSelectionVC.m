//
//  PlayBackTimeSelectionVC.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/20/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "PlayBackTimeSelectionVC.h"
#import "DatePickerView.h"
#import "Utils.h"
#import "PlayBackStreamVC.h"
#import "ServiceManger.h"

@interface PlayBackTimeSelectionVC ()<DatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *camLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) DatePickerView *datePickerView;

@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSDictionary *camDetails;
@property (nonatomic, strong) NSDictionary *recordingHoursDict;

- (IBAction)selectTimeButtonPressed:(UIButton *)sender;

@end

@implementation PlayBackTimeSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureNavigationBar];
    [self doInitialConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)doInitialConfiguration {
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
    
//    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Calender"]
//                                                                       style:UIBarButtonItemStylePlain
//                                                                      target:self
//                                                                      action:@selector(filterButton:)];
//    [filterButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, -60)];
    
//    self.navigationItem.rightBarButtonItems = @[calenderButton, filterButton];
    
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

- (void)filterButton:(id)sender
{
    NSLog(@"Filter button pressed.");
}

- (void)openDatePickerView
{
    if (self.datePickerView == nil) {
        self.datePickerView = [[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil].lastObject;
    }
    
    [self.datePickerView setTitle:@"Select Time" andDatePickerMode:UIDatePickerModeDateAndTime];
    
    self.datePickerView.delegate = self;
    self.datePickerView.frame = self.view.frame;
    [self.view addSubview:self.datePickerView];
}

//- (void)callGetRecordingServiceWithDate:(NSDate *)date
//{
//    ServiceManger *service = [ServiceManger sharedInstance];
//    
//    NSString *camId = [self.camDetails objectForKey:@"CamId"];
//    NSDictionary *params = @{@"camid": camId ? camId : @"" , @"date": [Utils stringFromDate:date inFormat:@"yyyy-MM-dd"]};
//    
//    [Utils showProgressInView:self.view text:@"Loading..."];
//    [service getRecordingHoursWithParams:params withCompletionBlock:^(NSDictionary *response, NSError *error) {
//        [Utils hideProgressInView:self.view];
//        if (response) {
//            self.recordingHoursDict = response;
//            [self callGetPlayBackURLWithDate:date];
//        }
//    }];
//}
//
//- (void)callGetPlayBackURLWithDate:(NSDate *)date
//{
//    ServiceManger *service = [ServiceManger sharedInstance];
//    
//    NSString *camId = [self.camDetails objectForKey:@"CamId"];
//    NSDictionary *params = @{@"camid": camId ? camId : @"" , @"datetime": [Utils stringFromDate:date inFormat:@"yyyy-MM-dd hh:mm:ss"]};
//    
//    [Utils showProgressInView:self.view text:@"Loading..."];
//    
//    [service getPlaybackURLWithParams:params withCompletionBlock:^(NSDictionary *response, NSError *error) {
//        [Utils hideProgressInView:self.view];
//        if (response) {
//            NSLog(@"recording response = %@", response);
//            /*
//            
//            self.timeLabel.text = [Utils stringFromDate:date inFormat:@"yyyy-MM-dd hh:mm:ss"];
//            
//            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            PlayBackStreamVC *playbackTimeVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PlayBackStreamVC"];
//            playbackTimeVC.delegate = self;
//            [playbackTimeVC streamCamWithCamDetails:self.camDetails playbackURL:[response objectForKey:@"PlaybackUrl"] recordingHoursDetails:[self.recordingHoursDict objectForKey:@"RecordingHours"] andDate:date];
//                        
//            [playbackTimeVC removeFromParentViewController];
//            [self addChildViewController:playbackTimeVC];
//            playbackTimeVC.view.frame = self.vcContainerView.frame;
//            [self.view addSubview:playbackTimeVC.view];
//            [playbackTimeVC didMoveToParentViewController:self];
//             */
//        }
//    }];
//}

- (void)pushPlaybackStreamVCWithDate:(NSDate *)date
{
    PlayBackStreamVC *playbackVC = (PlayBackStreamVC *)[Utils getViewControllerWithIdentifier:@"PlayBackStreamVC"];
    [playbackVC setDate:date stoteName:self.storeName andCamDetails:self.camDetails];
    [self.navigationController pushViewController:playbackVC animated:NO];
}

#pragma mark - Public Methods

- (void)showStoreName:(NSString *)storeName andCamDetails:(NSDictionary *)camDetails
{
    self.storeName = storeName;
    self.camDetails = camDetails;
}

#pragma mark - IBAction

- (IBAction)selectTimeButtonPressed:(UIButton *)sender {
    [self openDatePickerView];
}

#pragma mark - DatePickerViewDelegate

- (void)datePickerView:(DatePickerView *)pickerView didSelectDate:(NSDate *)date
{
    [self.datePickerView removeFromSuperview];
    self.datePickerView = nil;
    
    [self pushPlaybackStreamVCWithDate:date];
    
    //[self callGetRecordingServiceWithDate:date];
}

- (void)didCancelDatePickerView:(DatePickerView *)pickerView
{
    [self.datePickerView removeFromSuperview];
    self.datePickerView = nil;
}

/*
#pragma mark - PlayBackStreamVCDelegate

- (void)playBackVC:(PlayBackStreamVC *)playbackVC didUpdateDateTime:(NSString *)dateTime
{
    self.timeLabel.text = dateTime;
}
 */

@end
