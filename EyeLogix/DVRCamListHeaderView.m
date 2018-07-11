//
//  DVRCamListHeaderView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/22/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRCamListHeaderView.h"

@interface DVRCamListHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;

@end

@implementation DVRCamListHeaderView

+ (DVRCamListHeaderView *)loadCamListHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed:@"DVRCamListHeaderView" owner:self options:nil].lastObject;
}

- (void)configureHeaderViewWithTitle:(NSString *)title
{
    self.headerTitle.text = title;
}

@end
