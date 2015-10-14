//
//  PicturesTableViewController.m
//  fun365
//
//  Created by lanou3g on 15/6/11.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "PicturesTableViewController.h"
#import "ListCell.h"
#import "List_0_Cell.h"
#import "List_3_Cell.h"
#import "DataBaseHandle.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ListModel.h"

#import <CoreMotion/CoreMotion.h>
#import "DetailViewController.h"

#import "UIViewController+MMDrawerController.h"

@interface PicturesTableViewController ()<UIAccelerometerDelegate>
@property (nonatomic,copy)NSString *nextPageToken;
@property (nonatomic,strong)CMMotionManager *manager;
@property (nonatomic,strong)UIView *nightView;
@property (nonatomic,strong)NSString *cateId;
@property (nonatomic,assign)BOOL homepage;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation PicturesTableViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self nightMode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:@"nightMode" object:nil];
}

- (void)action:(id)sender
{
    [self nightMode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"willDidLoad");
    // 考虑上拉刷新的问题,只能在这儿初始化.
    self.dataArray = [NSMutableArray array];
    
    [self p_data];
    
    //左buttonItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    //右buttonItem
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"随机" style:UIBarButtonItemStylePlain target:self action:@selector(p_refresh)];
    
    
    // 添加刷新控件
    __block PicturesTableViewController *list = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        list.homepage = NO;
        [list p_data];
    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        list.homepage = YES;
        [list p_data];
    }];
    
    
    // 注册
    // 有一张图片的cell
    [self.tableView registerClass:[ListCell class] forCellReuseIdentifier:@"cell_1"];
    // 没有图片的cell
    [self.tableView registerClass:[List_0_Cell class] forCellReuseIdentifier:@"cell_0"];
    // 有三张图片的cell
    [self.tableView registerClass:[List_3_Cell class] forCellReuseIdentifier:@"cell_3"];
    
    // 摇一摇功能
    self.manager = [[CMMotionManager alloc] init];
    _manager.accelerometerUpdateInterval = 1.0/60;
    [_manager startAccelerometerUpdates];
    [NSTimer scheduledTimerWithTimeInterval:1.0/5.0 target:self selector:@selector(p_test) userInfo:nil repeats:YES];
    
}

- (void)p_test
{
    NSString *shake = [[NSUserDefaults standardUserDefaults] objectForKey:@"shake"];
    if ([shake isEqualToString:@"yes"]) {
        [self.navigationItem.rightBarButtonItem setTitle:@"摇一摇"];
        if (fabs(_manager.accelerometerData.acceleration.x) > 2.0 || fabs(_manager.accelerometerData.acceleration.y) > 2.0 || fabs(_manager.accelerometerData.acceleration.z) > 2.0) {
            [self p_refresh];
        }
    }
}


-(void)leftAction:(UIButton *)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

- (void)p_refresh
{
    NSArray *cate = pictures;
    NSArray *title = picturesTitle;
    NSInteger num = arc4random() % cate.count;
    NSString *temp = cate[num];
    self.navigationItem.title = title[num];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:temp forKey:@"picture"];
    [ud synchronize];
    
    _homepage = NO;
    [self p_data];
    [self.tableView reloadData];
}



#pragma mark 夜间模式
- (void)nightMode
{
    // 夜间模式初始化
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *mode = [ud objectForKey:@"night"];
    if ([mode isEqualToString:@"yes"]) {
        if ([_nightView superview] == nil) {
            self.nightView = [[UIView alloc] init];
            _nightView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
            _nightView.backgroundColor = [UIColor blackColor];
            _nightView.alpha = 0.5;
            _nightView.userInteractionEnabled = NO;
            [self.view addSubview:_nightView];
            [self.view bringSubviewToFront:_nightView];
            self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
        }
    }else{
        [_nightView removeFromSuperview];
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // model类
    ListModel *m = _dataArray[indexPath.row];
    
    if (m.images.count == 3) {
        // 3张图片
        List_3_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_3" forIndexPath:indexPath];
        CGRect r = cell.title.frame;
        CGFloat h = [self stringHieght:m.title withfont:17.0f withwidth:self.view.bounds.size.width - 20];
        r.size.height = h;
        cell.title.frame = r;
        // 赋值
        cell.title.text = m.title;
        cell.title.numberOfLines = 0;
        cell.title.font = [UIFont systemFontOfSize:17.0];
        cell.posttime.text = m.posttime;
        cell.posttime.textAlignment = NSTextAlignmentRight;
        cell.posttime.textColor = [UIColor grayColor];
        cell.posttime.font = [UIFont systemFontOfSize:15];
        [cell.image_1 sd_setImageWithURL:m.images[0] placeholderImage:[UIImage imageNamed:@"placehold.jpg"]];
        [cell.image_2 sd_setImageWithURL:m.images[1] placeholderImage:[UIImage imageNamed:@"placehold.jpg"]];
        [cell.image_3 sd_setImageWithURL:m.images[2] placeholderImage:[UIImage imageNamed:@"placehold.jpg"]];
        
        CGRect r1 = cell.image_1.frame;
        CGRect r2 = cell.image_2.frame;
        CGRect r3 = cell.image_3.frame;
        CGRect r4 = cell.posttime.frame;
        r1.origin.y = cell.title.frame.size.height + cell.title.frame.origin.y + 10;
        r2.origin.y = cell.title.frame.size.height + cell.title.frame.origin.y + 10;
        r3.origin.y = cell.title.frame.size.height + cell.title.frame.origin.y + 10;
        r4.origin.y = cell.contentView.frame.size.height - 25;
        cell.image_1.frame = r1;
        cell.image_2.frame = r2;
        cell.image_3.frame = r3;
        cell.posttime.frame = r4;
        
        return cell;
    }else if(m.images.count == 1){
        // 1张图片
        ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_1" forIndexPath:indexPath];
        cell.title.numberOfLines = 0;
        CGRect r4 = cell.posttime.frame;
        r4.origin.y = cell.contentView.frame.size.height - 25;
        cell.posttime.frame = r4;
        
        CGRect r = cell.title.frame;
        CGFloat h = [self stringHieght:m.title withfont:17.0f withwidth:self.view.bounds.size.width - 150];
        r.size.height = h;
        cell.title.frame = r;
        
        // 赋值
        cell.title.text = m.title;
        cell.title.font = [UIFont systemFontOfSize:17.0];
        cell.posttime.text = m.posttime;
        cell.posttime.textAlignment = NSTextAlignmentRight;
        cell.posttime.textColor = [UIColor grayColor];
        cell.posttime.font = [UIFont systemFontOfSize:15];
        [cell.image_1 sd_setImageWithURL:m.images[0] placeholderImage:[UIImage imageNamed:@"placehold.jpg"]];
        
        return cell;
    }else{
        // 无图片
        List_0_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_0" forIndexPath:indexPath];
        
        cell.title.numberOfLines = 0;
        CGRect r = cell.title.frame;
        CGFloat h = [self stringHieght:m.title withfont:17.0f withwidth:self.view.bounds.size.width - 45];
        r.size.height = h;
        cell.title.frame = r;
        
        CGRect r4 = cell.posttime.frame;
        r4.origin.y = cell.contentView.frame.size.height - 25;
        cell.posttime.frame = r4;
        
        // 赋值
        cell.title.text = m.title;
        cell.title.font = [UIFont systemFontOfSize:17.0];
        cell.posttime.text = m.posttime;
        cell.posttime.textAlignment = NSTextAlignmentRight;
        cell.posttime.textColor = [UIColor grayColor];
        cell.posttime.font = [UIFont systemFontOfSize:15];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // model类
    ListModel *m = _dataArray[indexPath.row];
    
    if (m.images.count == 3) {
        CGFloat h = [self stringHieght:m.title withfont:17.0f withwidth:(self.view.bounds.size.width - 20)];
        //return [List_3_Cell cellHeight] - 30 + h;
        return ((self.view.bounds.size.width - 50) / 3) + h + 55;
    }else if(m.images.count == 1){
        CGFloat h = [self stringHieght:m.title withfont:17.0f withwidth:(self.view.bounds.size.width - 150)];
        if (h > (108 - 25) ) {
            return h + 40;
        }
        return [ListCell cellHeight];
    }else{
        CGFloat h = [self stringHieght:m.title withfont:17.0f withwidth:(self.view.bounds.size.width - 45)];
        return h + 55;
    }
}

// 计算文字高度
- (CGFloat)stringHieght:(NSString *)aString withfont:(CGFloat)fontsize withwidth:(CGFloat)wid
{
    CGRect r = [aString boundingRectWithSize:CGSizeMake(wid, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontsize]} context:nil];
    return r.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    detailVC.detailArr = [NSMutableArray arrayWithArray:_dataArray];
    detailVC.index = indexPath.row;
    // 由于设置系统属性,所以每次点击事件都需要重新调出token值更改进去,
    // 思考其他方法
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"next"];
    [ud setObject:temp forKey:@"detail"];
    [ud synchronize];
    
    [self.navigationController presentViewController:detailVC animated:YES completion:nil];
}


#pragma mark 解析

// 请求数据
- (void)p_data
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"picture"];
    
    NSString *url = @"";
    if (!_homepage) {
        url = [NSString stringWithFormat:@"http://yuedu.163.com/source.do?operation=queryContentList&id=%@",temp];
    }else{
        url = [NSString stringWithFormat:@"http://yuedu.163.com/source.do?operation=queryContentList&id=%@&pageToken=%@",temp,_nextPageToken];
    }
    
    __block PicturesTableViewController *list = self;
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject;
        NSDictionary *dict = array[0];
        
        [ud setObject:temp forKey:@"id"];
        [ud setObject:[dict objectForKey:@"nextPageToken"] forKey:@"next"];
        [ud setObject:[dict objectForKey:@"nextPageToken"] forKey:@"detail"];
        [ud synchronize];
        
        list.nextPageToken = [dict objectForKey:@"nextPageToken"];
        
        //        NSLog(@"%@",list.nextPageToken);
        //        下拉刷新,清空旧数据
        if (!list.homepage) {
            [list.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in array[1]) {
            // model类
            ListModel *m = [[ListModel alloc] init];
            [m setValuesForKeysWithDictionary:dict];
            
            [list.dataArray addObject:m];
            [self.tableView reloadData];
        }
        if (_nightView) {
            _nightView.frame = _nightView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
        }
        // 预加载页面
        [self pre_load];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
    // 判断上拉还是下拉
    if (!_homepage) {
        [self.tableView.header endRefreshing];
    }else{
        [self.tableView.footer endRefreshing];
    }
    
}

- (void)pre_load
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    DataBaseHandle *db = [DataBaseHandle shareDataBase];
    for (ListModel *m in _dataArray) {
        NSString *tempUrl = [NSString stringWithFormat:@"http://yuedu.163.com/source.do?operation=queryContentHtml&id=%@&contentUuid=%@",m.sourceID,m.contentID];
        
        [manager GET:tempUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            m.htmldata = [NSData dataWithData:responseObject];
            [db openDB];
            NSData *temp = [db selectHtmlFromCacheWithModel:m];
            if (temp == nil) {
                [db creatCacheTable];
                [db insertToCacheWithModel:m];
            }
            [db closeDB];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
    }
    
}

@end