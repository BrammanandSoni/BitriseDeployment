//
//  DVRSubListTableCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/16/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVRSubListTableCell : UITableViewCell

- (void)configureCellWithTitle:(NSString *)title andImage:(NSString *)image;
- (void)configureCellWithAttributedTitle:(NSAttributedString *)attributedTitle andImage:(NSString *)image;

@end
