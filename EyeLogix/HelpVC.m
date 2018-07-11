//
//  HelpVC.m
//  EyeLogix
//
//  Created by Smriti on 5/24/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "HelpVC.h"
#import "FAQVC.h"
#import "Utils.h"
#import <MessageUI/MessageUI.h>

@interface HelpVC ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *faqButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self doinitialConfiguration];
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods

- (void)doinitialConfiguration
{
    self.faqButton.layer.borderWidth = 1.0;
    self.faqButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.feedbackButton.layer.borderWidth = 1.0;
    self.feedbackButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)configureNavigationBar
{
    self.title = @"Help";
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu_1"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backbtn:)];
    
    self.navigationItem.leftBarButtonItem = btn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void) backbtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Button

-(IBAction)btFAQ:(id)sender {
    FAQVC *faqVC = (FAQVC *)[Utils getViewControllerWithIdentifier:@"FAQVC"];
    [self.navigationController pushViewController:faqVC animated:YES];
}

-(IBAction)btFeedback:(id)sender {
    
    NSString *strMail = @"support@eyelogix.in";
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc]init];
        mailComposeVC.mailComposeDelegate = self;
        [mailComposeVC setSubject:@"Support Request from App"];
        [mailComposeVC setToRecipients:[NSArray arrayWithObject:strMail]];
        [mailComposeVC setMessageBody:@"" isHTML:false];
        
        [self presentViewController:mailComposeVC animated:YES completion:NULL];
    }
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
