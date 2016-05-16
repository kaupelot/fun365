//
//  LeftViewController.m
//  fun365
//
//  Created by walt zeng on 15/6/10.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftView.h"
#import "UIViewController+MMDrawerController.h"
#import "EassaysViewController.h"
#import "ViewController.h"
#import "NewsViewController.h"
#import "JokesViewController.h"
#import "MGViewController.h"
#import "ListViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tableView;
// 所有数据存储到这个数组里面
@property (nonatomic,strong)NSArray *cateArray;
@property (nonatomic,strong)LeftView *lV;
@property (nonatomic,strong)UISwitch *sharkSwitch;
@property (nonatomic,strong)UISwitch *nightSwitch;
@property (nonatomic,strong)UISwitch *imageSwitch;
@property (nonatomic) CGFloat brightness NS_AVAILABLE_IOS(5_0);
@end

@implementation LeftViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *name = [ud objectForKey:@"user"];
    _lV.nameLabel.textColor = [UIColor whiteColor];
    if ([name length] == 0) {
        _lV.nameLabel.text = @"未登录";
    }else{
        _lV.nameLabel.text = name;
    }
}

- (void)loadView
{
    self.lV = [[LeftView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _lV.backgroundColor = [UIColor clearColor];
    self.view = _lV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    _lV.backgroundColor = [UIColor clearColor];
    
    _lV.listTab.delegate = self;
    _lV.listTab.dataSource = self;
    
    [_lV.myButton addTarget:self action:@selector(setButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_lV.myButton setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:(UIControlStateNormal)];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString:@"yes"]) {
        
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
        [_lV.userImage setImage:[UIImage imageWithData:imageData]];
    } else {
    [_lV.userImage setImage:[UIImage imageNamed:@"example"]];
    }
    
    // 头像设为圆形
    _lV.userImage.layer.cornerRadius = _lV.userImage.frame.size.width / 2;
    _lV.userImage.clipsToBounds = YES;
    _lV.userImage.layer.borderWidth = 2.0f;
    _lV.userImage.layer.borderColor = [[UIColor grayColor] CGColor];
    
    
    
    // 摇一摇开关
    self.sharkSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_lV.frame.size.width - 110, 315, 50, _lV.frame.size.height)];
    [_lV.listTab addSubview:_sharkSwitch];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *mode1 = [ud objectForKey:@"shake"];
    //NSLog(@"创建 %@",mode);
    if ([mode1 isEqualToString:@"yes"]) {
        _sharkSwitch.on = YES;
    }else
    {
        _sharkSwitch.on = NO;
    }
    [_sharkSwitch addTarget:self action:@selector(sharkAction:) forControlEvents:(UIControlEventValueChanged)];
    
    // 无图模式开关
    self.imageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_lV.frame.size.width - 110, 395, 50, _lV.frame.size.height)];
    [_lV.listTab addSubview:_imageSwitch];
    NSString *mode2 = [ud objectForKey:@"photo"];
    //NSLog(@"创建 %@",mode);
    if ([mode2 isEqualToString:@"yes"]) {
        _imageSwitch.on = YES;
    }else
    {
        _imageSwitch.on = NO;
    }

    [_imageSwitch addTarget:self action:@selector(imageAction:) forControlEvents:(UIControlEventValueChanged)];
    
    // 夜间模式开关
    self.nightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_lV.frame.size.width - 110, 355, 50, _lV.frame.size.height)];
    NSString *mode3 = [ud objectForKey:@"night"];
    //NSLog(@"创建 %@",mode);
    if ([mode3 isEqualToString:@"yes"]) {
        _nightSwitch.on = YES;
    }else
    {
        _nightSwitch.on = NO;
    }
    // 添加事件
    [_nightSwitch addTarget:self action:@selector(nightMode:) forControlEvents:(UIControlEventValueChanged)];
    [_lV.listTab addSubview:_nightSwitch];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"分类";
    }
    return @"模式设置";
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    if (section == 1) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = @[@"新闻",@"文章",@"段子",@"图片",@"我的收藏",@"摇一摇",@"夜间模式",@"无图模式"];
    // 重用标识符
    static NSString *cellID = @"cell_1";
    // 重用池取值
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section == 0) {
        cell.textLabel.text = array[indexPath.row];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = array[indexPath.row + 5];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            
        }
        if (indexPath.row == 1) {
            /*
            self.nightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_lV.frame.size.width - 55, 5, 50, _lV.frame.size.height)];
            [cell addSubview:_nightSwitch];
             */
        }
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)setButtonAction:(UIButton *)sender
{
    NSLog(@"设置");
    UIImage *image = [[UIImage alloc] init];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString:@"yes"]) {
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
        if (imageData != nil) {
            image = [UIImage imageWithData:imageData];
        }
    } else {
        image = [UIImage imageNamed:@"example"];
    }
    MGViewController *myVC = [[MGViewController alloc] initWithMainImage:image];
    
    self.mm_drawerController.centerViewController = myVC;
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSObject *navigationController = [self.navigationControllerArray objectAtIndex:indexPath.row];
    
    if (![navigationController isKindOfClass:[UINavigationController class]]) {
        
        UIViewController *newViewController;
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    newViewController = (UIViewController *)[[NewsViewController alloc] init];
                    break;
                case 1:
                    newViewController = (UIViewController *)[[EassaysViewController alloc] init];
                    break;
                case 2:
                    newViewController = (UIViewController *)[[JokesViewController alloc] init];
                    break;
                case 3:
                    newViewController = (UIViewController *)[[ViewController alloc] init];
                    break;
                case 4:
                    newViewController = (UIViewController *)[[ListViewController alloc] init];
                    break;
                default:
                    newViewController = (UIViewController *)[[ListViewController alloc] init];
                    break;
            }
        }
        
        
        navigationController = (UINavigationController *)[[UINavigationController alloc] initWithRootViewController:(UIViewController *)newViewController];
    }
    
    [self.navigationControllerArray replaceObjectAtIndex:indexPath.row withObject:navigationController];
    
    [self.mm_drawerController setCenterViewController:(UINavigationController *)navigationController withCloseAnimation:YES completion:nil];
    return indexPath;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    // 根据点击切换不同的栏目
//    NewsTableViewController *newsVC = [[NewsTableViewController alloc] init];
//    UINavigationController *newsNC = [[UINavigationController alloc] initWithRootViewController:newsVC];
//    
//    EassaysTableViewController *eassaysVC = [[EassaysTableViewController alloc] init];
//    UINavigationController *eassaysNC = [[UINavigationController alloc] initWithRootViewController:eassaysVC];
//    
//    JokesTableViewController *jokeVC = [[JokesTableViewController alloc] init];
//    UINavigationController *jokeNC = [[UINavigationController alloc] initWithRootViewController:jokeVC];
//    
//    ViewController *pictureVC = [[ViewController alloc] init];
//    UINavigationController *pictureNC = [[UINavigationController alloc] initWithRootViewController:pictureVC];
//    
//    ListViewController *listVC = [[ListViewController alloc] init];
//    UINavigationController *listNC = [[UINavigationController alloc] initWithRootViewController:listVC];
//    
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//                self.mm_drawerController.centerViewController = newsNC;
//                break;
//                
//            case 1:
//                self.mm_drawerController.centerViewController = eassaysNC;
//                break;
//                
//            case 2:
//                self.mm_drawerController.centerViewController = jokeNC;
//                break;
//                
//            case 3:
//                self.mm_drawerController.centerViewController = pictureNC;
//                break;
//                
//            case 4:
//                self.mm_drawerController.centerViewController = listNC;
//                break;
//                
//            default:
//                break;
//        }
//        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
                // 摇一摇
            case 0:
                
                break;
                // 夜间模式
            case 1:
                
                break;
                // 无图模式
            case 2:
                
                break;
            default:
                break;
        }
    }
}

#pragma mark 开关按钮
// 夜间模式
- (void)nightMode:(UISwitch *)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (sender.on) {
        [ud setObject:@"yes" forKey:@"night"];
        [ud synchronize];
//        [[UIScreen mainScreen] setBrightness:0.1];
    }else{
        [ud setObject:@"no" forKey:@"night"];
        [ud synchronize];
//        [[UIScreen mainScreen] setBrightness:1];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:@"nightMode" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nightMode" object:nil];
}

- (void)action:(id)sender
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"nightMode" object:nil];
}

// 摇一摇
- (void)sharkAction:(UISwitch *)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (sender.on) {
        [ud setObject:@"yes" forKey:@"shake"];
    }else{
        [ud setObject:@"no" forKey:@"shake"];
    }
    [ud synchronize];
}

// 无图模式
- (void)imageAction:(UISwitch *)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (sender.on) {
        [ud setObject:@"yes" forKey:@"photo"];
    }else{
        [ud setObject:@"no" forKey:@"photo"];
    }
    [ud synchronize];
}


- (NSString *)generateWithArray:(NSArray *)array
{
    NSInteger num = arc4random() % array.count;
    NSString *temp = array[num];
    return temp;
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

@end
