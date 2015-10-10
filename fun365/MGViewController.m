//
//  MGViewController.m
//  MGSpotyView
//
//  Created by Matteo Gobbi on 25/06/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "MGViewController.h"
#import "LoginViewController.h"
#import "SDImageCache.h"
#import "ListViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "DataBaseHandle.h"
#import "AboutUsViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "AFNetworking.h"
#import "ListModel.h"

@interface MGViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UILabel *lblTitle;
@property (nonatomic,strong)UIButton *btContact;
@property (nonatomic,copy)NSString *islogin;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,assign)CGFloat cachesSize;
@property (nonatomic,strong)UILabel *cache;
@property (nonatomic,strong)UIAlertView *logOut;
@property (nonatomic,strong)UIAlertView *deleteCaches;
@property (nonatomic,strong)UIActionSheet *changeImage;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImage *userImage;
@property (nonatomic,strong)UIImagePickerController *picker;
@property (nonatomic,assign)BOOL check;
@end

@implementation MGViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.islogin = [ud objectForKey:@"login"];
    self.userName = [ud objectForKey:@"user"];
//    NSString *version1 = [ud objectForKey:@"version"];
    
    if ([_islogin isEqualToString:@"yes"]) {
        [_btContact setTitle:@"注销" forState:UIControlStateNormal];
        _lblTitle.text = _userName;
    }else{
        [_btContact setTitle:@"登录" forState:UIControlStateNormal];
        _lblTitle.text = @"未登录";
    }
    // 预留,等迭代版本检查更新用.
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:checkversion parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *tempDict = responseObject;
        NSArray *temp = [tempDict objectForKey:@"results"];
        NSDictionary *result = temp[0];
        NSString *version2 = [result objectForKey:@"version"];
        NSLog(@"%@==%@",version1,version2);
        if ([version1 isEqualToString:version2]) {
            self.check = YES;
        } else {
            self.check = NO;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    */
    // 清除缓存功能(获取缓存文件夹路径)
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    filePath = [filePath stringByAppendingPathComponent:@"Caches"];
    _cachesSize = [self folderSizeAtPath:filePath];
}

- (void)viewDidLoad {
    [self setOverView:self.myOverView];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark 设置视图

- (UIView *)myOverView {
    UIView *view = [[UIView alloc] initWithFrame:self.overView.bounds];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString:@"yes"]) {
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
        if (imageData != nil) {
            _userImage = [UIImage imageWithData:imageData];
        }
    } else {
        _userImage = [UIImage imageNamed:@"example"];
    }
    
    //Add an example imageView
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.center.x-50.0, view.center.y-60.0, 100.0, 100.0)];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView setClipsToBounds:YES];
    [_imageView setImage:_userImage];
    [_imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_imageView.layer setBorderWidth:2.0];
    [_imageView.layer setCornerRadius:_imageView.frame.size.width/2.0];
    _imageView.userInteractionEnabled = YES;
    
    //Add an example label
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(view.center.x-120.0, view.center.y+50.0, 240.0, 50.0)];
    
    [_lblTitle setText:_userName];
    [_lblTitle setFont:[UIFont boldSystemFontOfSize:22.0]];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    [_lblTitle setTextColor:[UIColor whiteColor]];
    
    // 登陆/注销按钮
    self.btContact = [[UIButton alloc] initWithFrame:CGRectMake(view.center.x-35.0, view.center.y+100.0, 70.0, 35.0)];
    if ([_islogin isEqualToString:@"yes"]) {
        [_btContact setTitle:@"注销" forState:UIControlStateNormal];
        _lblTitle.text = _userName;
    }else{
        [_btContact setTitle:@"登录" forState:UIControlStateNormal];
        _lblTitle.text = @"未登录";
    }
    
    [_btContact addTarget:self action:@selector(actionContact:) forControlEvents:UIControlEventTouchUpInside];
    _btContact.backgroundColor = [UIColor darkGrayColor];
    _btContact.titleLabel.font = [UIFont fontWithName:@"Verdana" size:12.0];
    _btContact.layer.cornerRadius = 5.0;
    
    [view addSubview:_imageView];
    [view addSubview:_lblTitle];
    [view addSubview:_btContact];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:tapRecognizer];
    
    return view;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UITableView Delegate & Datasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return [super tableView:tableView viewForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width - 10, 20)];
    label.textColor = [UIColor whiteColor];
    [headerView addSubview:label];
    headerView.backgroundColor = [UIColor darkGrayColor];
    if (section == 1) {
        label.text = @"账号相关";
        return headerView;
    }
    if (section == 2) {
        label.text = @"系统设置";
        return headerView;
    }
    return nil;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if(section == 1)
//        return @"账号相关";
//    if (section == 2) {
//        return @"系统设置";
//    }
//    return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return [super tableView:tableView heightForHeaderInSection:section];
    if(section == 1)
        return 20.0;
    if(section == 2)
        return 20.0;
    if(section == 3)
        return 20.0;
    return 0.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger mySections = 1;
    
    return mySections + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 1)
        return 1;
    if(section == 2)
        return 4;
    
    return 0;
}

#pragma mark 创建cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[UIColor clearColor]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"社交账号设置";
                cell.textLabel.textColor = [UIColor whiteColor];
            default:
                break;
        }
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"清除缓存";
                cell.textLabel.textColor = [UIColor whiteColor];
                self.cache = [[UILabel alloc] initWithFrame:CGRectMake(self.overView.frame.size.width - 80, 0, 80, 44)];
                [cell.contentView addSubview:_cache];
                _cache.text = [NSString stringWithFormat:@"%.2fMB",_cachesSize];
                _cache.textAlignment = NSTextAlignmentCenter;
                _cache.textColor = [UIColor whiteColor];
                _cache.font = [UIFont systemFontOfSize:15];
            }
                break;
            case 1:
                cell.textLabel.text = @" ";
                cell.textLabel.textColor = [UIColor whiteColor];
                break;
            case 2:
                cell.textLabel.text = @"关于我们";
                cell.textLabel.textColor = [UIColor whiteColor];
                break;
            default:
                break;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"14.png"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}


#pragma mark 选中动作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
                // 社交账号设置
            case 0:
                
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
                // 清除缓存
            case 0:
                self.deleteCaches = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除缓存吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是的", nil];
                _deleteCaches.delegate = self;
                [_deleteCaches show];
                break;
                // 检查更新

            case 1:
            {
                return;
//                NSString *string1 = [NSString string];
//                if (_check) {
//                    string1 = @"已经是最新版本";
//                    
//                } else {
//                    string1 = @"检查到新版本";
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/100859925"]];
//                }
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新" message:string1 delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
            }
                break;

                // 关于我们
            case 2:
            {
                AboutUsViewController *aboutVC = [[AboutUsViewController alloc] init];
                UINavigationController *aboutNC = [[UINavigationController alloc] initWithRootViewController:aboutVC];
                [self presentViewController:aboutNC animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark - LoginAction

// 登陆/注销按钮
- (void)actionContact:(id)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *isLogin = [ud objectForKey:@"login"];
    if ([isLogin isEqualToString:@"no"]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNC animated:YES completion:nil];
    }else{
        self.logOut = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要注销吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是的",nil];
        _logOut.delegate = self;
        [_logOut show];
    }
}

#pragma mark AlertView响应
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 登陆
    if (alertView == _logOut) {
        if (buttonIndex == 0) {
            return;
        }
        if (buttonIndex == 1) {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:@"no" forKey:@"login"];
            [ud setObject:@"" forKey:@"user"];
            [ud synchronize];
            [_btContact setTitle:@"登录" forState:UIControlStateNormal];
            _lblTitle.text = @"未登录";
        }
    }
    
    // 清缓存
    if (alertView == _deleteCaches) {
        if (buttonIndex == 0) {
            return;
        }
        if (buttonIndex == 1) {
            NSString *filePath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
            filePath = [filePath stringByAppendingPathComponent:@"Caches"];
            [MGViewController clearCache:filePath];
            _cachesSize = [self folderSizeAtPath:filePath];
            _cache.text = [NSString stringWithFormat:@"%.2fMB",_cachesSize];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 初始化相册控制器
    self.picker = [[UIImagePickerController alloc] init];
    // 设置代理
    _picker.delegate = self;
    // 允许编辑
    _picker.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        // 拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            NSLog(@"模拟器无法打开相机");
        }
        [self presentViewController:_picker animated:YES completion:nil];
    }else if (buttonIndex == 1){
        // 从相册选择
        // 选择数据源
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_picker animated:YES completion:nil];
        
    }else{
        // 取消
        return;
    }
}



#pragma mark - Gesture recognizer

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.changeImage = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        _changeImage.delegate = self;
        [_changeImage showInView:self.view];
    }
}

#pragma mark 清理缓存
// 计算单个文件大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 计算缓存文件夹大小
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

// 删除缓存文件夹
+ (void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    DataBaseHandle *db = [DataBaseHandle shareDataBase];
    [db openDB];
    [db clearCache];
    [db closeDB];
    
    [[SDImageCache sharedImageCache] cleanDisk];
}

#pragma mark UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (image == nil) {
        }else{
            _userImage = image;
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *userName = [ud objectForKey:@"user"];
            NSString *cql = [NSString stringWithFormat:@"select password from %@ where userName = '%@'",@"UserInfo",userName];
            AVCloudQueryResult *result = [AVQuery doCloudQueryWithCQL:cql];
            NSData *imageData = UIImagePNGRepresentation(image);
            AVFile *imageFile = [AVFile fileWithName:@"userImage.png" data:imageData];
            AVObject *regist = result.results[0];
            [regist setObject:imageFile forKey:@"image"];
            [ud setObject:imageData forKey:@"image"];
            [ud synchronize];
            [regist saveInBackground];
        }
        _imageView.image = _userImage;
        [self setMainImage:_userImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

@end
