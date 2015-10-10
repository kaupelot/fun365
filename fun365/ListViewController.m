//
//  ListViewController.m
//  fun365
//
//  Created by lanou3g on 15/6/6.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "ListViewController.h"
#import "ListCell.h"
#import "List_0_Cell.h"
#import "List_3_Cell.h"
#import "ListDetailViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ListModel.h"
#import "DataBaseHandle.h"
#import "LoginViewController.h"
#import "MyView.h"

#import "UIViewController+MMDrawerController.h"

@interface ListViewController ()
{
    // 记录编辑状态
    UITableViewCellEditingStyle _tab;
}
@property (nonatomic,strong)UIView *nightView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSString *status;

@end

@implementation ListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataArray = [NSMutableArray array];
    // 尚未弄清楚原理,只能在这里加载数据.
    [self p_data];
    [self nightMode];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:@"nightMode" object:nil];
}

- (void)action:(id)sender
{
    [self nightMode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //左buttonItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    //右buttonItem
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"edit.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    
    // 注册
    // 有一张图片的cell
    [self.tableView registerClass:[ListCell class] forCellReuseIdentifier:@"cell_1"];
    // 没有图片的cell
    [self.tableView registerClass:[List_0_Cell class] forCellReuseIdentifier:@"cell_0"];
    // 有三张图片的cell
    [self.tableView registerClass:[List_3_Cell class] forCellReuseIdentifier:@"cell_3"];
    
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
            if (self.tableView.frame.size.height <= [[UIScreen mainScreen] bounds].size.height) {
                _nightView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, [[UIScreen mainScreen] bounds].size.height);
            }else{
                _nightView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
            }
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

// 刷新功能,待实现.
-(void)rightAction
{
    if ([_status isEqualToString:@"yes"]) {
        _tab = UITableViewCellEditingStyleDelete;
        // 布尔值直接取反
        [self.tableView setEditing:!self.tableView.editing animated:YES];
    }
}


-(void)leftAction:(UIButton *)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ListModel *model = _dataArray[indexPath.row];
        DataBaseHandle *db = [DataBaseHandle shareDataBase];
        [db openDB];
        [db deleteInEnjoyWithModel:model];
        [db closeDB];
        [_dataArray removeObject:model];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // model类
    ListModel *m = _dataArray[indexPath.row];
/*
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
 */
    // 无图片
    List_0_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_0" forIndexPath:indexPath];
    
    cell.title.numberOfLines = 0;
    
        // 赋值
        
        CGRect r = cell.title.frame;
        CGFloat h = [self stringHieght:m.title withfont:17.0f withwidth:self.view.bounds.size.width - 45];
        r.size.height = h;
        cell.title.frame = r;
        
        CGRect r4 = cell.posttime.frame;
        r4.origin.y = cell.contentView.frame.size.height - 25;
        cell.posttime.frame = r4;
        
        cell.title.text = m.title;
        cell.title.font = [UIFont systemFontOfSize:17.0];
        cell.posttime.text = m.posttime;
        cell.posttime.textAlignment = NSTextAlignmentRight;
        cell.posttime.textColor = [UIColor grayColor];
        cell.posttime.font = [UIFont systemFontOfSize:15];
        return cell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // model类
    ListModel *m = _dataArray[indexPath.row];

    if (m.images.count == 3) {
        CGFloat h = [self stringHieght:m.title withfont:17.0f withwidth:(self.view.bounds.size.width - 20)];
        
        return ((self.view.bounds.size.width - 50) / 3) + h + 55;
        
    }else if(m.images.count == 1){
        CGFloat h = [self stringHieght:m.title withfont:17.0f withwidth:(self.view.bounds.size.width - 150)];
        if (h > (108 - 25) ) {
            return h + 40;
        }
        return [ListCell cellHeight];
    }else{
        CGFloat h = [self stringHieght:m.title withfont:17.0f withwidth:(self.view.bounds.size.width - 45)];
        return h + 25;
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
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    if ([login isEqualToString:@"yes"]) {
    ListDetailViewController *detailVC = [[ListDetailViewController alloc] init];
    detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    detailVC.detailArr = [NSMutableArray arrayWithArray:_dataArray];
    detailVC.index = indexPath.row;
    
    [self.navigationController presentViewController:detailVC animated:YES completion:nil];
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNC animated:YES completion:nil];
    }
}


#pragma mark 解析

// 请求数据
- (void)p_data
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![[ud objectForKey:@"login"] isEqualToString:@"yes"]) {
        ListModel *model = [[ListModel alloc] init];
        model.title = @"请登录";
        [self.dataArray addObject:model];
    } else {
    DataBaseHandle *db = [DataBaseHandle shareDataBase];
    [db openDB];
    self.dataArray = [NSMutableArray arrayWithArray:[db selectModelsInEnjoy]];
//        NSLog(@"%@",_dataArray);
    [db closeDB];
    [self.tableView reloadData];
    }
}



@end
