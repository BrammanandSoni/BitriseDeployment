//
//  CamTitleView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 8/14/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "CamTitleView.h"
#import "Utils.h"

@interface CamTitleView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextView;
- (IBAction)yesButtonClicked:(UIButton *)sender;
- (IBAction)noButtonClicked:(UIButton *)sender;

@property (nonatomic, strong) DVRCamDetails *camDetails;

@end

@implementation CamTitleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

+ (CamTitleView *)loadCamTitleView
{
    return [[NSBundle mainBundle] loadNibNamed:@"CamTitleView" owner:self options:nil].lastObject;
}

- (void)configureViewWithCamDetails:(DVRCamDetails *)camDetails
{
    self.camDetails = camDetails;
    self.titleTextView.text = camDetails.camTitle;
}

- (IBAction)yesButtonClicked:(UIButton *)sender {
    
    if ([self.titleTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [Utils showToastWithMessage:@"Cam Title Empty"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(camTitleViewDidClickOnYesButton:withTitle:andCamDetails:)]) {
        [self.delegate camTitleViewDidClickOnYesButton:self withTitle:self.titleTextView.text andCamDetails:self.camDetails];
    }
}

- (IBAction)noButtonClicked:(UIButton *)sender {
    [self removeFromSuperview];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
