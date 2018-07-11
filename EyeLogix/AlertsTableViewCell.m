//
//  AlertsTableViewCell.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/24/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "AlertsTableViewCell.h"

@interface AlertsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *smsAlertButton;
@property (weak, nonatomic) IBOutlet UIButton *emailAlertButton;
@property (weak, nonatomic) IBOutlet UIButton *appAlertButton;

@property (nonatomic, strong) NewUserDetails *userDetails;

@end

@implementation AlertsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithNewUserDetails:(NewUserDetails *)userDetails
{
    self.userDetails = userDetails;
    self.smsAlertButton.selected = userDetails.smsAlert;
    self.emailAlertButton.selected = userDetails.emailAlert;
    self.appAlertButton.selected = userDetails.appAlert;
}

- (IBAction)checkboxClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 0) { // SMS Alert
        self.userDetails.smsAlert = sender.selected;
    }
    else if (sender.tag == 1) { // Email Alert
        self.userDetails.emailAlert = sender.selected;
    }
    else if (sender.tag == 2) { // App Alert
        self.userDetails.appAlert = sender.selected;
    }
}

@end
