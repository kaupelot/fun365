//
//  ViewController.m
//  test
//
//  Created by 553766229 on 6/6/15.
//  Copyright (c) 2015年 553766229. All rights reserved.
//

#import "ViewController.h"
#import "WaterFlowLayout.h"
#import "ListModel.h"
#import "UIImageView+WebCache.h"
#import "imageCell.h"
#import "UIViewController+MMDrawerController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "DetailViewController.h"
#import "MyView.h"
#import "DataBaseHandle.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()<UICollectionViewDataSource,UIAccelerometerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WaterFlowDelegate>

@property(nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)CMMotionManager *manager;
@property (nonatomic,copy)NSString *nextPageToken;
@property (nonatomic,strong)UIView *nightView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *nextDataArray;
@property (nonatomic,strong)NSMutableArray *oldArray;
@property (nonatomic,strong)WaterFlowLayout *layout;
@end

@implementation ViewController

// 目前存在问题,瀑布流到下拉刷新3页左右就报奔溃了.Terminating app due to uncaught exception 'CALayerInvalidGeometry', reason: 'CALayer position contains NaN: [187.5 nan]'*** First throw call stack:
// 已经解决,原因是没有加入判断规避一些没有图片的对象.

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
    self.oldArray = [NSMutableArray array];
    
    WaterFlowLayout *layout=[[WaterFlowLayout alloc]init];
    layout.delegate=self;
    
    CGFloat w=([[UIScreen mainScreen]bounds].size.width-25)/2;
    layout.itemSize=CGSizeMake(w, w);
    layout.sectionInsets=UIEdgeInsetsMake(5, 5, 5, 5);
    layout.insertItemSpacing=5;
    layout.numberOfColumns=2;
    //创建uicollectionview
    self.collection=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collection.backgroundColor=[UIColor whiteColor];
    _collection.dataSource=self;
    _collection.delegate=self;
    
    //注册
    [_collection registerClass:[imageCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:_collection];
    NSLog(@"view will appear");
    
    //左buttonItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    //右buttonItem

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"随机" style:UIBarButtonItemStylePlain target:self action:@selector(p_refresh)];
    
    
    // 添加刷新控件
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == 0) {
            [self p_reload];
        } else {
            [self p_data];
        }
    }];
    
    __block ViewController *list = self;
    [self.collection addLegendHeaderWithRefreshingBlock:^{
        [list p_data];
    }];
    
    [self.collection addLegendFooterWithRefreshingBlock:^{
        [list.dataArray addObjectsFromArray:list.nextDataArray];
        list.nextDataArray = [NSMutableArray array];
        [list.collection reloadData];
        if (list.nightView) {
            list.nightView.frame = CGRectMake(0, 0, list.collection.contentSize.width, list.collection.contentSize.height);
        }
        [list p_loadNext];
    }];
    
    // 摇一摇功能
    self.manager = [[CMMotionManager alloc] init];
    _manager.accelerometerUpdateInterval = 1.0/60;
    [_manager startAccelerometerUpdates];
    [NSTimer scheduledTimerWithTimeInterval:1.0/5.0 target:self selector:@selector(p_test) userInfo:nil repeats:YES];
    
}

#pragma mark 解析

// 刷新或者随机数据的时候会出现越界,问题待解决.UICollectionView received layout attributes for a cell with an index path that does not exist: <NSIndexPath: 0xc0000000000c0016> {length = 2, path = 0 - 24}
// 当下拉过多数据之后,上拉刷新出现同样问题.Assertion failure in -[UICollectionViewData validateLayoutInRect:], /SourceCache/UIKit_Sim/UIKit-3347.44/UICollectionViewData.m:426
// 请求数据 NSInvalidArgumentException', reason: 'Attempt to insert non-property list object null for key next
// 问题解决思路:自己写的代理方法对于item数量减少没有处理方法,不会删除,导致错误.需要重新编写.
// 已经解决,用时整整一天.
- (void)p_data
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"picture"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",originUrl,temp];

    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataArray = [NSMutableArray arrayWithArray:[self getArrayWithData:responseObject]];
        [self.collection reloadData];
        [self p_loadNext];
        // 预加载页面
        [self pre_load];
        // 调整夜间模式遮盖
        if (_nightView) {
            _nightView.frame = CGRectMake(0, 0, self.collection.contentSize.width, self.collection.contentSize.height);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
    [self.collection.header endRefreshing];
    
}

// 由于图片界面对model类要求,特别修改
- (NSArray *)getArrayWithData:(NSData *)responseObject
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"picture"];
    // 无法对afnetworking请求到的数据进行加载,因为直接解析成了数组.
    // 已经解决,直接对返回值进行设置为二进制就OK了.
    NSString *contentTemp = [NSString stringWithFormat:@"temp%@",temp];
    NSMutableArray *dataArray = [NSMutableArray array];
    
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
    for (NSDictionary *dict in backArray) {
        // model类
        ListModel *m = [[ListModel alloc] init];
        [m setValuesForKeysWithDictionary:dict];
        // 取得字典中的值
        [m setValuesForKeysWithDictionary:[dict objectForKey:@"summaryImage"]];
        if (m.summaryImageHeight != 0 && m.summaryImageWidth != 0 && m.summaryImageURL != nil) {
            
            [dataArray addObject:m];
        }
        
    }
    return dataArray;
}

- (void)p_loadNext
{
    if (![_nextPageToken isEqualToString:@"no"]) {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"picture"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@&pageToken=%@",originUrl,temp,_nextPageToken];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        self.nextDataArray = [NSMutableArray arrayWithArray:[self getArrayWithData:responseObject]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    }
    [self.collection.footer endRefreshing];

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
    NSString *temp = [ud objectForKey:@"picture"];
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
        [self.collection reloadData];
    }
    [self p_loadNext];
    // 预加载页面
    [self pre_load];
    }
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
            _nightView.frame = CGRectMake(0, 0, self.collection.frame.size.width, self.collection.contentSize.height);
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
//    NSLog(@"%@",temp);
    self.navigationItem.title = title[num];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:temp forKey:@"picture"];
    [ud synchronize];
    
    [self p_data];
}


//item高度
-(CGFloat)heightForItemIndexPath:(NSIndexPath *)indexPath
{
    ListModel *M=_dataArray[indexPath.item];
    CGFloat w=([[UIScreen mainScreen]bounds].size.width-5)/2;
    CGFloat h=(w*M.summaryImageHeight)/M.summaryImageWidth;
    return h;
}


//item个数
-(NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}


//选中cell的操作
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    imageCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ListModel *m=_dataArray[indexPath.row];
    cell.contentLabel.text=m.title;
    cell.contentLabel.font=[UIFont systemFontOfSize:15];
    
    
    cell.contentLabel.numberOfLines=0;
    cell.contentLabel.textAlignment=NSTextAlignmentCenter;
    NSURL *url=[NSURL URLWithString:m.summaryImageURL];
    [cell.contentIamge sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placehold.jpg"]];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    // 进入详情之前预加载
//    [self.dataArray addObjectsFromArray:self.nextDataArray];
    detailVC.detailArr = [NSMutableArray arrayWithArray:_dataArray];
    [detailVC.detailArr addObjectsFromArray:_nextDataArray];
    detailVC.index = indexPath.item;
    // 由于设置系统属性,所以每次点击事件都需要重新调出token值更改进去,
    // 思考其他方法
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *temp = [ud objectForKey:@"next"];
    [ud setObject:temp forKey:@"detail"];
    [ud synchronize];
    
    [self.navigationController presentViewController:detailVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
