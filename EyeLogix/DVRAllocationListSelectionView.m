//
//  DVRAllocationListSelectionView.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/19/17.
//  Copyright © 2017 Smriti. All rights reserved.
//

#import "DVRAllocationListSelectionView.h"
#import "CategoryTableCell.h"

@interface DVRAllocationListSelectionView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *listTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation DVRAllocationListSelectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self doInitialConfiguration];
}

+ (DVRAllocationListSelectionView *)loadDVRAllocationListSelectionView
{
    return [[NSBundle mainBundle] loadNibNamed:@"DVRAllocationListSelectionView" owner:self options:nil].lastObject;
}

- (void)setHeaderTitle:(NSString *)headerTitle andListTitle:(NSString *)listTitle
{
    self.headerTitleLabel.text = headerTitle;
    self.listTitleLabel.text = listTitle;
}

- (void)showOnlyCloseButton
{
    self.closeButton.hidden = NO;
}

#pragma mark - Private Methods

- (void)doInitialConfiguration
{    
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryTableCell" bundle:nil] forCellReuseIdentifier:@"CategoryTableCell"];
}

#pragma mark - IBAction

- (IBAction)closeButtonClicked:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)allButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listSelectionViewDidSelectAll:)]) {
        [self.delegate listSelectionViewDidSelectAll:self];
    }
    [self removeFromSuperview];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.listType) {
        case UserList:
            return self.userListArray.count;
            break;
            
        case DVRList:
            return self.dvrListArray.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableCell"];
    
    switch (self.listType) {
        case UserList: {
            DVRUser *user = self.userListArray[indexPath.row];
            [cell configureCellWithTitle:user.userName];
        }
            
            break;
            
        case DVRList: {
            DVRDetails *dvrDetails = self.dvrListArray[indexPath.row];
            [cell configureCellWithTitle:dvrDetails.storeTitle];
        }
            
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.listType) {
        case UserList: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(listSelectionView:didSelectUser:)]) {
                [self.delegate listSelectionView:self didSelectUser:self.userListArray[indexPath.row]];
            }
        }
            
            break;
            
        case DVRList: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(listSelectionView:didSelectDVR:)]) {
                [self.delegate listSelectionView:self didSelectDVR:self.dvrListArray[indexPath.row]];
            }
        }
            
            break;
    }
    
    [self removeFromSuperview];
}

@end
