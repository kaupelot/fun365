//
//  ListDetailViewController.m
//  fun365
//
//  Created by walt zeng on 15/6/15.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "ListDetailViewController.h"
#import "ListModel.h"
#import "MyView.h"
#import "UIImageView+WebCache.h"
#import "DataBaseHandle.h"
#import "LoginViewController.h"
#import "AFNetworking.h"

@interface ListDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)MyView *mV;
@property (nonatomic,strong)UIWebView *view1;
@property (nonatomic,strong)UIWebView *view2;
@property (nonatomic,strong)UIWebView *view3;
// 加载页面的图片缓存数组
@property (nonatomic,strong)NSArray *pictureArray;
@property (nonatomic,strong)NSMutableDictionary *pictureDict;
@end

@implementation ListDetailViewController

- (void)loadView
{
    self.mV = [[MyView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.view = _mV;
    
}

// 添加下部菜单
- (void)p_loadView
{
    [_mV bringSubviewToFront:_mV.buttonsView];
    _mV.scrollView.delegate = self;
    
    // 添加点击事件
    [_mV.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_mV.commitButton addTarget:self action:@selector(commitButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_mV.favButton addTarget:self action:@selector(favButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_mV.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_mV.shareButton setTitle:@"顶部" forState:UIControlStateNormal];
    [_mV.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self nightMode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"详情页0 %@",mode);
    // 初始化图片字典
    self.pictureDict = [NSMutableDictionary dictionary];
    [self p_data];
    [self p_loadView];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 通过tag值取出3个视图,同时销毁掉.
    self.view1 = (UIWebView *)[self.mV viewWithTag:(_index - 1 + 100)];
    self.view2 = (UIWebView *)[self.mV viewWithTag:(_index + 0 + 100)];
    self.view3 = (UIWebView *)[self.mV viewWithTag:(_index + 1 + 100)];
    
    [self removeWithUiwebView:_view1];
    [self removeWithUiwebView:_view2];
    [self removeWithUiwebView:_view3];
    
}

// 存在问题,当点击第一个或者第二个项目详情之后模态返回会在这儿崩掉.
// 已经解决:原因,tag值匹配错误,导致清除错误
- (void)removeWithUiwebView:(UIWebView *)webview
{
    [webview loadRequest:nil];
    [webview removeFromSuperview];
    webview = nil;
    webview.delegate = nil;
    [webview stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)p_data
{
    if (self.index > (self.detailArr.count - 2)) {
        if (_detailArr.count != 1) {
            [self p_dataWithIndex:_index - 1];
        }
    } else if (self.index == 0) {
        // 防止越界,当仅有一条收藏的情况
        if (_detailArr.count != 1) {
            [self p_dataWithIndex:_index + 1];
        }
    } else {
        [self p_dataWithIndex:_index - 1];
        [self p_dataWithIndex:_index + 1];
    }
    [self p_dataWithIndex:_index];
}

- (void)getNextPageWithNum:(NSInteger)num
{
    // 将3个webview通过tag值取出来,进行操作.
    self.view1 = (UIWebView *)[self.mV viewWithTag:(_index - 1 + 100)];
    self.view2 = (UIWebView *)[self.mV viewWithTag:(_index + 0 + 100)];
    self.view3 = (UIWebView *)[self.mV viewWithTag:(_index + 1 + 100)];
    
    // 测试加入判断是否空加载
    switch (num) {
        case 0:
            // 加入判断避免涉及到0
            if (_index != 0 ) {
                self.index -= 1;
                _view1.frame = CGRectMake(CGRectGetWidth(_mV.frame), 44, CGRectGetWidth(_mV.frame), CGRectGetHeight(_mV.frame) - 44);
                _view2.frame = CGRectMake(CGRectGetWidth(_mV.frame) * 2, 44, CGRectGetWidth(_mV.frame), CGRectGetHeight(_mV.frame) - 44);
                // 加入判断避免在_index等于1时跳出-1
                if (_index != 0 ) {
                    [self removeWithUiwebView:_view3];
                    [self p_dataWithIndex:(_index - 1)];
                }
            }
            break;
            
        case 2:
            if (_index != _detailArr.count - 1) {
            self.index += 1;
            _view3.frame = CGRectMake(CGRectGetWidth(_mV.frame), 44, CGRectGetWidth(_mV.frame), CGRectGetHeight(_mV.frame) - 44);
            _view2.frame = CGRectMake(0, 44, CGRectGetWidth(_mV.frame), CGRectGetHeight(_mV.frame) - 44);
                if (_index != _detailArr.count - 1) {
                    [self removeWithUiwebView:_view1];
                    [self p_dataWithIndex:(_index + 1)];
                }
            }
            break;
            
        default:
            break;
    }
    self.mV.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.mV.frame), 0);
}

- (void)p_dataWithIndex:(NSInteger)index
{
    NSInteger temp = (index - _index + 1) % 3;
    UIWebView *view = [[UIWebView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_mV.frame) * temp, 44, CGRectGetWidth(_mV.frame), CGRectGetHeight(_mV.frame) - 44)];
    view.tag = 100 + index;
    view.delegate = self;
    [self.mV.scrollView addSubview:view];
    
    [self loadDetailWithScrollView:view index:index];
    
    self.mV.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.mV.frame), 0);
    
    ListModel *m = _detailArr[_index + 0];
    self.navigationItem.title = m.title;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger temp = scrollView.contentOffset.x / self.mV.frame.size.width;
    
    [self getNextPageWithNum:temp];
    
}

- (void)pre_load
{
    DataBaseHandle *db = [DataBaseHandle shareDataBase];
    for (ListModel *m in _detailArr) {
        NSString *tempUrl = [NSString stringWithFormat:@"http://yuedu.163.com/source.do?operation=queryContentHtml&id=%@&contentUuid=%@",m.sourceID,m.contentID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
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

- (void)loadDetailWithScrollView:(UIWebView *)sender index:(NSInteger)index
{
    ListModel *cate = self.detailArr[index];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *idStr = [ud valueForKey:@"id"];
    NSString *urlString = [NSString stringWithFormat:@"http://yuedu.163.com/source.do?operation=queryContentHtml&id=%@&contentUuid=%@",idStr,cate.contentID];
    
    
    DataBaseHandle *db = [DataBaseHandle shareDataBase];
    [db openDB];
    NSData *htmlData = [db selectHtmlFromCacheWithModel:cate];
    if (htmlData == nil) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            cate.htmldata = [NSData dataWithData:responseObject];
            // 将看过的内容加入缓存.
            [db openDB];
            [db creatCacheTable];
            [db insertToCacheWithModel:cate];
            [db closeDB];
            
            [self loadWebView:sender urlStr:string];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
    } else {
        NSLog(@"缓存");
        NSString *string = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
        
        [self loadWebView:sender urlStr:string];
    }
    [db closeDB];
    
}

// 封装页面加载的方法
// 目前问题:点击进入的第一个页面会和第二个页面撞图.
// 同时需要重新处理内存释放的问题.
- (void)loadWebView:(UIWebView *)webview urlStr:(NSString *)string
{
    NSString *urlStr = [string stringByReplacingOccurrencesOfString:@"</h1>" withString:@"</h1><hr/>"];
    
    CGFloat max = self.view.frame.size.width - 20;
    NSString *appendStr = [NSString stringWithFormat:@"<head><style>h1{color:#363636;font:200 24px arial,sans-serif,'宋体'}img{max-width:%0.fpx !important;}pre{white-space: pre-wrap;word-wrap: break-word;}ul{list-style-type :none;-webkit-padding-start: 0px;}li{-webkit-padding-start: 0px;}</style></head>",max];
    urlStr = [urlStr stringByAppendingString:appendStr];
    
    // 无图模式
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"photo"] isEqualToString:@"yes"]) {
        
        NSArray *pictureArray = [self getImageUrlArray:urlStr];
        for (int i = 0 ; i < pictureArray.count; i++) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:pictureArray[i] withString:[self replaceUrlSpecialString:pictureArray[i]]];
        }
    }
    
    [webview loadHTMLString:urlStr baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSURLCache sharedURLCache] setMemoryCapacity: 0];
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}


- (NSArray *)getImageUrlArray:(NSString*) content
{
    //    DDLOG_CURRENT_METHOD;
    NSString *urlPattern = @"<img[^>]+?src=[\"']?([^>'\"]+)[\"']?";
    NSError *error = [NSError new];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlPattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSMutableArray *listImage = [NSMutableArray array];
    
    //match 这块内容非常强大
    // 报黄,"implicit conversion from enumeration type",将"NSRegularExpressionCaseInsensitive"更换为"NSMatchingReportProgress"
    NSUInteger counts =[regex numberOfMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, [content length])];//匹配到的次数
    if(counts > 0){
        NSArray* matches = [regex matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];
        
        for (NSTextCheckingResult *match in matches) {
            NSInteger count = [match numberOfRanges];//匹配项
            for(NSInteger index = 0;index < count;index++){
                NSRange halfRange = [match rangeAtIndex:index];
                if (index == 1) {
                    //[listImage addObject:[content substringWithRange:halfRange]];
                    //                    NSLog(@"转换出来的字符串＝＝＝%@",[content substringWithRange:halfRange]);
                    [listImage addObject:[content substringWithRange:halfRange]];
                }
            }
        }//遍历后可以看到三个range，1、为整体。2、为([\\w-]+\\.)匹配到的内容。3、([\\w.%&=-]*)匹配到的内容
    }
    
    
    return listImage;
}

- (NSString *)replaceUrlSpecialString:(NSString *)string {
    
    return [string stringByReplacingOccurrencesOfString:@"/"withString:@"_"];
}


#pragma mark 夜间模式
- (void)nightMode
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *mode = [ud objectForKey:@"night"];
    if ([mode isEqualToString:@"yes"]) {
        // 给夜间模式视图初始化
        if (_mV.nightView == nil) {
            self.mV.nightView = [[UIView alloc] init];
            _mV.nightView.frame = CGRectMake(0 , 0, CGRectGetWidth(_mV.frame), CGRectGetHeight(_mV.frame) - 0);
            _mV.nightView.backgroundColor = [UIColor blackColor];
            _mV.nightView.alpha = 0.5;
            _mV.nightView.userInteractionEnabled = NO;
            [self.mV addSubview:_mV.nightView];
        }
    }else{
        [_mV.nightView removeFromSuperview];
    }
}


#pragma mark 点击事件
// 返回
- (void)backButtonAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 评论,目前为上一页
- (void)commitButtonAction:(UIButton *)sender
{
    [self getNextPageWithNum:0];
}

// 收藏
- (void)favButtonAction:(UIButton *)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    DataBaseHandle *db = [DataBaseHandle shareDataBase];
    NSString *string = [NSString string];
    if ([[ud objectForKey:@"login"] isEqualToString:@"yes"]) {
        ListModel *m = _detailArr[_index];
        [db openDB];
        [db creatEnjoyTable];
        NSData *data = [db selectHtmlFromEnjoyWithModel:m];
        if (data == nil) {
            [db insertToEnjoyWithModel:m];
            string = @"收藏成功";
        } else {
            string = @"您已经收藏过了";
        }
        [db closeDB];
    } else {
        string = @"您还没有登录,请登录";
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNC animated:YES completion:nil];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收藏" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

// 分享
- (void)shareButtonAction:(UIButton *)sender
{
    self.view2 = (UIWebView *)[self.mV viewWithTag:(_index + 100)];
    if ([_view2 subviews]) {
        UIScrollView *scrollView = [[_view2 subviews] objectAtIndex:0];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

// 返回顶部代码,暂时不使用,寻找更好的解决方案,不使用按键的.
- (void)goBackTop:(UIButton *)sender
{
    self.view2 = (UIWebView *)[self.mV viewWithTag:(_index + 100)];
    if ([_view2 subviews]) {
        UIScrollView *scrollView = [[_view2 subviews] objectAtIndex:0];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

// 下一条
- (void)nextButtonAction:(UIButton *)sender
{
    [self getNextPageWithNum:2];
}

@end