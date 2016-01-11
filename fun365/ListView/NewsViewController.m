//
//  NewsViewController.m
//  fun365
//
//  Created by walt zeng on 15/11/24.
//  Copyright © 2015年 曾旺. All rights reserved.
//

#import "NewsViewController.h"
#import "List_ScrollView.h"
#import "DetailViewController.h"

@interface NewsViewController ()
@property (nonatomic,strong)List_ScrollView *ListView;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setHeader]; // 设置轮播图
}

- (void)setHeader
{
    // 添加tableHeaderView
    self.ListView = [[List_ScrollView alloc] init];
    _ListView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, ([[UIScreen mainScreen] bounds].size.width * 9 / 16) + 30);
    self.tableView.tableHeaderView = _ListView;
    
    // 设置scrollView
    _ListView.scrollView.showsHorizontalScrollIndicator = NO;
    _ListView.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * 5, [[UIScreen mainScreen] bounds].size.width * 9 / 16);
    _ListView.scrollView.delegate = self;
    _ListView.scrollView.pagingEnabled = YES;
    _ListView.scrollView.contentOffset = CGPointMake(_ListView.scrollView.frame.size.width, 0);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_ListView.scrollView addGestureRecognizer:tap];
    
    // 3张图片
    _ListView.page.numberOfPages = 3;
}

- (void)tapAction:(UIGestureRecognizer *)sender
{
    NSLog(@"tap");
    // 进入详情页
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.dataArray addObjectsFromArray:self.nextDataArray];
    detailVC.detailArr = [NSMutableArray arrayWithArray:self.dataArray];
    detailVC.index = _ListView.page.currentPage;
    // 由于设置系统属性,所以每次点击事件都需要重新调出token值更改进去,
    // 思考其他方法
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"next"];
    [ud setObject:temp forKey:@"detail"];
    [ud synchronize];
    
    [self.navigationController presentViewController:detailVC animated:YES completion:nil];
}


- (void)p_refresh
{
    NSArray *cate = news;
    NSArray *title = newsTitle;
    NSInteger num = arc4random() % cate.count;
    NSString *temp = cate[num];
    self.navigationItem.title = title[num];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:temp forKey:@"news"];
    [ud synchronize];
    
    
    [self p_data];
    [self p_loadNext];
    [self.tableView reloadData];
    //[self p_setDataForScroll];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.name = @"news";
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
