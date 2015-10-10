//
//  DetailController.m
//  fun365
//
//  Created by lanou3g on 15/6/6.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "DetailController.h"
#import "DetailView.h"
#import "ListViewController.h"
@interface DetailController ()
@property (nonatomic,strong)DetailView *dv;
@end

@implementation DetailController

- (void)loadView
{
    self.dv = [[DetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = _dv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:(UIBarButtonItemStyleDone) target:self action:@selector(leftAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction:)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 按键响应事件
// 后退
- (void)leftAction:(UIBarButtonItem *)sender
{
    //ListViewController *listVC = [[ListViewController alloc] initWithStyle:(UITableViewStylePlain)];
    [self.navigationController popViewControllerAnimated:YES];
}

// 收藏功能
- (void)rightAction:(UIBarButtonItem *)sender
{

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
