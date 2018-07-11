//
//  CellHeader.h
//  EyeLogix
//
//  Created by Smriti on 4/21/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellHeader : UITableViewCell

@property(nonatomic, weak) IBOutlet UIButton *btBackground;
@property(nonatomic, weak) IBOutlet UILabel *lbTitle;
@property(nonatomic, weak) IBOutlet UILabel *lbSubTitle;
@property(nonatomic, weak) IBOutlet UIButton *btCheckBox;
@property (weak, nonatomic) IBOutlet UILabel *camCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *crossLabel;

@end
