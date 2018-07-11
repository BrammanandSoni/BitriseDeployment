//
//  DVRCamListHeaderView.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/22/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVRCamListHeaderView : UIView

+ (DVRCamListHeaderView *)loadCamListHeaderView;
- (void)configureHeaderViewWithTitle:(NSString *)title;

@end
