//
//  DVRListHeaderView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/16/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRListHeaderView.h"
#import "Utils.h"

@interface DVRListHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *dropDownImageView;
@property (weak, nonatomic) IBOutlet UIImageView *dvrTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activeImageView;

@end

@implementation DVRListHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [Utils  addTapGestureToView:self target:self selector:@selector(onTapView:)];
}

+ (DVRListHeaderView *)loadDVRListHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed:@"DVRListHeaderView" owner:self options:nil].lastObject;
}

- (void)showActiveImage:(BOOL)show
{
    self.activeImageView.hidden = !show;
}

- (void)configureViewWithStoreDetails:(DVRStoreDetails *)storeDetails
{
    self.titleLabel.text = storeDetails.storeTitle;
    self.subTitleLabel.text = storeDetails.storeAddress;
    [self expandCollapseImage:storeDetails.isExpanded];
}

- (void)configureViewWithDVRAllocationDetails:(DVRAllocationDetails *)dvrAllocationDetails
{
    self.titleLabel.attributedText = [self getDVRAllocationTitleWithStoreTitle:dvrAllocationDetails.storeTitle andName:dvrAllocationDetails.name];
    self.subTitleLabel.text = dvrAllocationDetails.storeAddress;
    [self expandCollapseImage:dvrAllocationDetails.isExpanded];
}

- (void)configureViewWithUserDetails:(DVRUserDetails *)userDetails
{
    self.titleLabel.text = userDetails.operatorName;
    self.subTitleLabel.text = userDetails.operatorType;
    [self expandCollapseImage:userDetails.isExpanded];
}

- (void)configureViewWithOnlineUserDetails:(DVROnlineUserDetails *)onlineUserDetails
{
    self.titleLabel.text = onlineUserDetails.name;
    self.subTitleLabel.text = onlineUserDetails.userType;
    [self expandCollapseImage:onlineUserDetails.isExpanded];
}

#pragma mark - Private Methods

- (void)expandCollapseImage:(BOOL)isExpanded
{
    if (isExpanded) {
        self.dropDownImageView.image = [UIImage imageNamed:@"Down_Arrow"];
    }
    else {
        self.dropDownImageView.image = [UIImage imageNamed:@"Right_Arrow"];
    }
}

- (void)onTapView:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapOnDVRListHeaderView:)]) {
        [self.delegate didTapOnDVRListHeaderView:self];
    }
}

- (NSAttributedString *)getDVRAllocationTitleWithStoreTitle:(NSString *)storeTitle andName:(NSString *)name
{
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.0/255.0 green:162.0/255.0 blue:80.0/250.0 alpha:1]};
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)", name] attributes:attrs];
    
    NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] initWithString:storeTitle];
    [finalString appendAttributedString:nameString];
    
    return finalString;
}

@end
