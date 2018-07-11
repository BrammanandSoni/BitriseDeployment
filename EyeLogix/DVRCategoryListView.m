//
//  DVRCategoryListView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/18/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRCategoryListView.h"
#import "CategoryTableCell.h"
#import "Utils.h"

@interface DVRCategoryListView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *listTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, strong) NSString *imageName;

@end

@implementation DVRCategoryListView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self doInitialConfiguration];
}

#pragma mark - Public Methods

+ (DVRCategoryListView *)loadCategoryListView
{
    return [[NSBundle mainBundle] loadNibNamed:@"DVRCategoryListView" owner:self options:nil].lastObject;
}

- (void)configureListViewWithHeaderTitle:(NSString *)headerTitle andListTitle:(NSString *)listTitle
{
    self.headerTitleLabel.text = headerTitle;
    self.listTitleLabel.text = listTitle;
}

- (void)configureImage:(NSString *)imageName
{
    self.imageName = imageName;
}

- (void)showOnlyCloseButton
{
    self.closeButton.hidden = NO;
}

#pragma mark - Private Methods

- (void)doInitialConfiguration
{
    [Utils addTapGestureToView:self.bgView target:self selector:@selector(onTapBgView:)];
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryTableCell" bundle:nil] forCellReuseIdentifier:@"CategoryTableCell"];
}

- (void)onTapBgView:(UITapGestureRecognizer *)recognizer
{
    [self removeFromSuperview];
}

#pragma mark - IBActions

- (IBAction)closeButtonClicked:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)allButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListViewDidSelectAll:)]) {
        [self.delegate categoryListViewDidSelectAll:self];
    }
    [self removeFromSuperview];
    
    //[self.delegate categoryListView:self didSelectCategoryAtIndex:0];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableCell"];
    [cell configureCellWithTitle:self.listArray[indexPath.row]];
    if (self.imageName) {
        [cell setThumbImage:self.imageName];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryListView:didSelectCategoryAtIndex:)]) {
        [self.delegate categoryListView:self didSelectCategoryAtIndex:indexPath.row];
    }
    [self removeFromSuperview];
}

@end
