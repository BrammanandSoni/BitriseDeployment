//
//  PlayBackELVC.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/8/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "PlayBackELVC.h"
#import "SlideNavigationController.h"
#import "ServiceManger.h"
#import "Utils.h"
#import "CellCustom.h"
#import "CellHeader.h"
#import "PlayBackTimeSelectionVC.h"
#import "DataHandler.h"

@interface PlayBackELVC ()<SlideNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableSet* _collapsedSections;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *storeList;

@end

@implementation PlayBackELVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Select Cam";
    _collapsedSections = [NSMutableSet new];
    [self doInitialConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)doInitialConfiguration
{
    self.storeList = [DataHandler sharedInstance].camListArray;
    for (int i = 0; i < self.storeList.count; i++) {
        [_collapsedSections addObject:@(i)];
    }
    
    if (self.storeList.count > 0) {
        [_tableView reloadData];
    }
    else {
        [Utils showToastWithMessage:@"No data available. try again."];
    }
}

-(void)tapCollaps:(UIButton*)sender {
    
    [_tableView beginUpdates];
    UIButton *btTemp = (UIButton *)sender;
    int section = (int)btTemp.tag;
    bool shouldCollapse = ![_collapsedSections containsObject:@(section)];
    if (shouldCollapse) {
        btTemp.selected = YES;
        int numOfRows = (int)[_tableView numberOfRowsInSection:section];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [_collapsedSections addObject:@(section)];
    }
    else {
        btTemp.selected = NO;
        NSArray *array = [NSArray arrayWithArray:[[self.storeList objectAtIndex:section] valueForKey:@"Cams"]];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:(int)array.count];
        [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [_collapsedSections removeObject:@(section)];
    }
    [_tableView endUpdates];
}

#pragma mark - SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.storeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [NSArray arrayWithArray:[[self.storeList objectAtIndex:section] valueForKey:@"Cams"]];
    return [_collapsedSections containsObject:@(section)] ? 0 : array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section   {
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *cellIdentifier = @"CellHeader";
    CellHeader *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CellHeader alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellIdentifier];
    }
    
    [cell.btBackground addTarget:self action:@selector(tapCollaps:) forControlEvents:UIControlEventTouchUpInside];
    NSString  *strTitle = [[self.storeList objectAtIndex:section] valueForKey:@"StoreTitle"];
    cell.lbTitle.text = strTitle;
    cell.lbSubTitle.text = @"9510 BEECHNUT ST SUTE G Houston";
    cell.btBackground.tag = section;
    cell.camCountLabel.text = [NSString stringWithFormat:@"%lu", [[[self.storeList objectAtIndex:section] valueForKey:@"Cams"] count]];
    
    return cell.contentView;
}

-(NSArray*) indexPathsForSection:(int)section withNumberOfRows:(int)numberOfRows {
    
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (int i = 0; i < numberOfRows; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellCustom";
    CellCustom *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CellCustom alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellIdentifier];
    }
    
    //NSString *path;
    NSArray *array = [NSArray arrayWithArray:[[self.storeList objectAtIndex:indexPath.section] valueForKey:@"Cams"]];
    
    NSString *camTitle = [array[indexPath.row] valueForKey:@"CamTitle"];
    cell.lbTitle.text = camTitle;
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PlayBackTimeSelectionVC *playbackTimeVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PlayBackTimeSelectionVC"];
    
    NSDictionary *storeDetails = [self.storeList objectAtIndex:indexPath.section];
    
    NSString  *storeTitle = [storeDetails valueForKey:@"StoreTitle"];
    NSDictionary *camDetails = ((NSArray *)[storeDetails valueForKey:@"Cams"])[indexPath.row];
    
    [playbackTimeVC showStoreName:storeTitle andCamDetails:camDetails];
    
    [self.navigationController pushViewController:playbackTimeVC animated:YES];
}

@end
