//
//  FAQTableCell.h
//  EyeLogix
//
//  Created by Brammanand Soni on 8/23/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum eFAQCellType {
    FAQCellTypeQuestion,
    FAQCellTypeAnswere
}FAQCellType;

@interface FAQTableCell : UITableViewCell

- (void)configureCellWithDetails:(NSDictionary *)details forCellType:(FAQCellType)cellType  selected:(BOOL)selected;

@end
