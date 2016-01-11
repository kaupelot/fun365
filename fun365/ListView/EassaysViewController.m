//
//  EassaysViewController.m
//  fun365
//
//  Created by walt zeng on 15/11/24.
//  Copyright © 2015年 曾旺. All rights reserved.
//

#import "EassaysViewController.h"

@interface EassaysViewController ()

@end

@implementation EassaysViewController

- (void)loadView
{
    [super loadView];
    self.name = @"eassay";
}

- (void)p_refresh
{
    NSArray *cate = eassays;
    NSArray *title = eassaysTitle;
    NSInteger num = arc4random() % cate.count;
    NSString *temp = cate[num];
    self.navigationItem.title = title[num];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:temp forKey:@"eassay"];
    [ud synchronize];
    
    [self p_data];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
