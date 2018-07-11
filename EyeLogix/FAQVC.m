//
//  FAQVC.m
//  EyeLogix
//
//  Created by Brammanand Soni on 8/23/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "FAQVC.h"
#import "ServiceManger.h"
#import "Utils.h"
#import "FAQTableCell.h"

@interface FAQVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *faqsArray;

@property (nonatomic) NSInteger selectedSection;

@end

@implementation FAQVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.estimatedRowHeight = 45.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.selectedSection = -1;
    
    [self configureNavigationBar];
    [self getFAQs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)configureNavigationBar
{
    self.title = @"FAQs";
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu_1"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backbtn:)];
    
    self.navigationItem.leftBarButtonItem = btn;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void) backbtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Network Call

- (void)getFAQs
{
    ServiceManger *service = [ServiceManger sharedInstance];
    [Utils showProgressInView:self.view text:@"Loading..."];
    
    [service getFAQWithCompletionBlock:^(NSDictionary *response, NSError *error) {
        [Utils hideProgressInView:self.view];
        
        if (response && error == nil) {
            self.faqsArray = [Utils getArrayFromDictionary:response];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.faqsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectedSection == section ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FAQTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FAQTableCell"];
    
    if (indexPath.row == 0) {
        [cell configureCellWithDetails:self.faqsArray[indexPath.section] forCellType:FAQCellTypeQuestion selected:indexPath.section == self.selectedSection];
    }
    else {
        
        
        [cell configureCellWithDetails:self.faqsArray[indexPath.section] forCellType:FAQCellTypeAnswere selected:false];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedSection == indexPath.section) {
        
        self.selectedSection = NSIntegerMax;
    }
    else {
        self.selectedSection = indexPath.section;
        
    }
    
    [tableView reloadData];
    
}

@end
