//
//  EassaysTableViewController.m
//  fun365
//
//  Created by walt zeng on 15/6/11.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "EassaysTableViewController.h"
#import "ListCell.h"
#import "List_0_Cell.h"
#import "List_3_Cell.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ListModel.h"
#import "DataBaseHandle.h"
#import <CoreMotion/CoreMotion.h>
#import "DetailViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface EassaysTableViewController ()<UIAccelerometerDelegate>
@property (nonatomic,copy)NSString *nextPageToken;
@property (nonatomic,strong)CMMotionManager *manager;
@property (nonatomic,strong)UIView *nightView;
@property (nonatomic,strong)NSString *cateId;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *nextDataArray;

@end

@implementation EassaysTableViewController

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
    
    // 考虑上拉刷新的问题,只能在这儿初始化.
    self.dataArray = [NSMutableArray array];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == 0) {
            [self p_reload];
        } else {
            [self p_data];
        }
    }];
    
    //左buttonItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    //右buttonItem
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"随机" style:UIBarButtonItemStylePlain target:self action:@selector(p_refresh)];
    
    
    // 添加刷新控件
    __block EassaysTableViewController *list = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [list p_data];
    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [list.dataArray addObjectsFromArray:list.nextDataArray];
        list.nextDataArray = [NSMutableArray array];
        [list.tableView reloadData];
        if (list.nightView) {
            list.nightView.frame = CGRectMake(0, 0, list.tableView.contentSize.width, list.tableView.contentSize.height);
        }
        [list p_loadNext];
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

#pragma mark 解析

// 请求数据
- (void)p_data
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"eassay"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",originUrl,temp];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = [self getArrayWithData:responseObject];
        self.dataArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            // model类
            ListModel *m = [[ListModel alloc] init];
            [m setValuesForKeysWithDictionary:dict];
            
            [self.dataArray addObject:m];
            [self.tableView reloadData];
        }
        
        [self p_loadNext];
        // 预加载页面
        [self pre_load];
        // 调整夜间模式遮盖
        if (_nightView) {
            _nightView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
    [self.tableView.header endRefreshing];
    
}

- (NSArray *)getArrayWithData:(NSData *)responseObject
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"eassay"];
    // 无法对afnetworking请求到的数据进行加载,因为直接解析成了数组.
    // 已经解决,直接对返回值进行设置为二进制就OK了.
    NSString *contentTemp = [NSString stringWithFormat:@"temp%@",temp];
    
    
    DataBaseHandle *db = [DataBaseHandle shareDataBase];
    [db openDB];
    [db creatCacheTable];
    ListModel *model = [[ListModel alloc] init];
    model.sourceID = temp;
    model.contentID = contentTemp;
    model.htmldata = [NSData dataWithData:responseObject];
    if ([db selectHtmlFromCacheWithModel:model] == nil) {
        [db insertToCacheWithModel:model];
    } else {
        [db updataCacheWithModel:model];
    }
    [db closeDB];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dict = array[0];
    
    // 针对数据源已经没有数据时候判断,及时终止刷新.
    // json请求到的事null,并不是字符串,而是类
    NSString *nextToken = [NSString string];
    if ([dict objectForKeyedSubscript:@"nextPageToken"] != [NSNull null]) {
        nextToken = [dict objectForKeyedSubscript:@"nextPageToken"];
    } else {
        nextToken = @"no";
    }
    [ud setObject:temp forKey:@"id"];
    [ud setObject:nextToken forKey:@"next"];
    [ud setObject:nextToken forKey:@"detail"];
    [ud synchronize];
    
    self.nextPageToken = nextToken;
    
    NSArray *backArray = array[1];
    return backArray;
}

- (void)p_loadNext
{
    if (![_nextPageToken isEqualToString:@"no"]) {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"eassay"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@&pageToken=%@",originUrl,temp,_nextPageToken];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.nextDataArray = [NSMutableArray array];
        NSArray *array = [self getArrayWithData:responseObject];
        
        for (NSDictionary *dict in array) {
            // model类
            ListModel *m = [[ListModel alloc] init];
            [m setValuesForKeysWithDictionary:dict];
            
            [self.nextDataArray addObject:m];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    }
    [self.tableView.footer endRefreshing];
    
}

- (void)pre_load
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    DataBaseHandle *db = [DataBaseHandle shareDataBase];
    for (ListModel *m in _dataArray) {
        NSString *tempUrl = [NSString stringWithFormat:@"%@%@&contentUuid=%@",contentUrl,m.sourceID,m.contentID];
        
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

- (void)p_reload
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"eassay"];
    NSString *contentTemp = [NSString stringWithFormat:@"temp%@",temp];
    ListModel *model = [[ListModel alloc] init];
    model.sourceID = temp;
    model.contentID = contentTemp;
    DataBaseHandle *db = [DataBaseHandle shareDataBase];
    [db openDB];
    NSData *responseObject = [db selectHtmlFromCacheWithModel:model];
    [db closeDB];
    if (responseObject != nil) {
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    
    for (NSDictionary *dict in array[1]) {
        // model类
        ListModel *m = [[ListModel alloc] init];
        [m setValuesForKeysWithDictionary:dict];
        
        [self.dataArray addObject:m];
        [self.tableView reloadData];
    }
    [self p_loadNext];
    // 预加载页面
    [self pre_load];
    }
}

// 摇一摇功能
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
        if ([_nightView superview] != nil) {
            [_nightView removeFromSuperview];
            self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
        }
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
        CGFloat h = [self stringHieght:m.title withfont:17.0f withwidth:self.view.bounds.size.width - 148];
        if (h > 108) {
            h = 108;
        }
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
        return ((self.view.bounds.size.width - 50) / 3) + h + 55;
    }else if(m.images.count == 1){
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
    // 这样会改变数据数组,不采用
//    [self.dataArray addObjectsFromArray:self.nextDataArray];
    detailVC.detailArr = [NSMutableArray arrayWithArray:_dataArray];
    [detailVC.detailArr addObjectsFromArray:_nextDataArray];
    detailVC.index = indexPath.row;
    // 由于设置系统属性,所以每次点击事件都需要重新调出token值更改进去,
    // 思考其他方法
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"next"];
    [ud setObject:temp forKey:@"detail"];
    [ud synchronize];
    
    [self.navigationController presentViewController:detailVC animated:YES completion:nil];
}

@end
