//
//  PopupListView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/25/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "PopupListView.h"
#import "Utils.h"

@interface PopupListView ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (nonatomic, strong) NSArray *listItem;

- (IBAction)closeButtonPressed:(UIButton *)sender;
- (IBAction)actionButtonPressed:(UIButton *)sender;

@end

@implementation PopupListView

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title actionButtonTitle:(NSString *)actionButtonTitle withListItem:(NSArray *)listItem
{
    self.titleLabel.text = title;
    [self.actionButton setTitle:actionButtonTitle forState:UIControlStateNormal];
    self.listItem = listItem;
    [self.tableView reloadData];
}

#pragma mark - IBAction

- (IBAction)closeButtonPressed:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)actionButtonPressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionButtonClicked:)]) {
        [self.delegate actionButtonClicked:self];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.listItem[indexPath.row];
    cell.textLabel.font = [Utils helveticaFontWithSize:14.0];
    cell.textLabel.numberOfLines = 2;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupListView:didSelectItemAtIndex:)]) {
        [self.delegate popupListView:self didSelectItemAtIndex:indexPath.row];
    }
}

@end
