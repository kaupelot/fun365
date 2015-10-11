//
//  DetailViewController.m
//  UILesson17_TableViewLoading
//
//  Created by lanou3g on 15/6/8.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "DetailViewController.h"
#import "ListModel.h"
#import "MyView.h"
#import "UIImageView+WebCache.h"
#import "DataBaseHandle.h"
#import "LoginViewController.h"
#import "AFNetworking.h"

#import <ShareSDK/ShareSDK.h>

// 加入md5加密
#import <CommonCrypto/CommonDigest.h>

@interface DetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)MyView *mV;
@property (nonatomic,strong)UIWebView *view1;
@property (nonatomic,strong)UIWebView *view2;
@property (nonatomic,strong)UIWebView *view3;
// 创建token数组用于存储token,同时判定是否已经请求
//@property (nonatomic,strong)NSMutableArray *tokenArr;
// 加载页面的图片缓存数组
@property (nonatomic,strong)NSArray *pictureArray;
@property (nonatomic,strong)NSMutableDictionary *pictureDict;
@end

@implementation DetailViewController

- (void)loadView
{
    self.mV = [[MyView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    self.tokenArr = [NSMutableArray array];
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
    [_mV.nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self nightMode];
    self.pictureDict = [NSMutableDictionary dictionary];
    [self p_data];
    [self p_loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     //NSLog(@"详情页0 %@",mode);
    // 初始化图片字典
//    self.pictureDict = [NSMutableDictionary dictionary];
//    [self p_data];
//    [self p_loadView];
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

#pragma mark 禁止webview中的链接点击
//- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
//    if(navigationType==UIWebViewNavigationTypeLinkClicked)//判断是否是点击链接
//    {
//        return NO;
//    }
//    else{return YES;}
//}

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
    [self p_dataWithIndex:_index];
//    [NSThread detachNewThreadSelector:@selector(p_loadOther) toTarget:self withObject:nil];
    // 上面的方法没法使用原因不理解,stackoverflow上面的答案.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self p_loadOther];
    });
}

- (void)p_loadOther
{
    if (self.index == self.detailArr.count - 1) {
        if (_detailArr.count != 1) {
            [self p_dataWithIndex:_index - 1];
            // 加入定时器,当下一页加载完成之后及时显示页面.
            //            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refreshView) userInfo:nil repeats:NO];
        }
        
    } else if (self.index == 0) {
        if (_detailArr.count != 1) {
            [self p_dataWithIndex:_index + 1];
        }
    } else {
        [self p_dataWithIndex:_index - 1];
        [self p_dataWithIndex:_index + 1];
    }
}

// 当页面即将到达最后页的时候,定时刷新出下一个页面.
- (void)refreshView
{
    [self p_dataWithIndex:_index + 1];
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
            // 更新逻辑,防止到达数组尾部
            if (_index != _detailArr.count - 1) {
                self.index += 1;
                _view3.frame = CGRectMake(CGRectGetWidth(_mV.frame), 44, CGRectGetWidth(_mV.frame), CGRectGetHeight(_mV.frame) - 44);
                _view2.frame = CGRectMake(0, 44, CGRectGetWidth(_mV.frame), CGRectGetHeight(_mV.frame) - 44);
                // 防止越界
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
    // 当图片即将到达边缘的时候预加载.
    if (index == (_detailArr.count - 6)) {
        [self p_load];
        [NSThread detachNewThreadSelector:@selector(p_load) toTarget:self withObject:nil];
    }
    [self loadDetailWithScrollView:view index:index];
    
    NSLog(@"%ld--%ld",(long)_index,(long)_detailArr.count);
    
    self.mV.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.mV.frame), 0);
    
    ListModel *m = _detailArr[_index + 0];
    self.navigationItem.title = m.title;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger temp = scrollView.contentOffset.x / self.mV.frame.size.width;
    
    [self getNextPageWithNum:temp];

}


- (void)p_load
{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"detail"] isEqualToString:@"no"]) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *string = [ud valueForKey:@"detail"];
    NSString *idStr = [ud valueForKey:@"id"];
    // 判断token数组的数据情况,向里面导入数据或者判断不进行解析.
//    if (count1 != 0 && [_tokenArr[count1 - 1] isEqualToString:string]) {
//        return;
//    } else {
//        [_tokenArr addObject:string];
//    }
//    NSLog(@"%@",string);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@&pageToken=%@",originUrl,idStr,string];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dict = array[0];
//        NSLog(@"%@",array);
        // 针对数据源已经没有数据时候判断,及时终止刷新.
        // json请求到的事null,并不是字符串,而是类
        if ([dict objectForKeyedSubscript:@"nextPageToken"] != [NSNull null]) {
            NSString *string1 = [dict objectForKey:@"nextPageToken"];
            [ud setObject:string1 forKey:@"detail"];
            
        } else {
            [ud setObject:@"no" forKey:@"detail"];
        }
        [ud synchronize];
        
        NSArray *temp = array[1];
        
        for (NSDictionary *dict in temp) {
            ListModel *cate = [[ListModel alloc] init];
            [cate setValuesForKeysWithDictionary:dict];
            [_detailArr addObject:cate];
        }
        [self pre_load];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    }
}

- (void)pre_load
{
    DataBaseHandle *db = [DataBaseHandle shareDataBase];
    for (ListModel *m in _detailArr) {
        NSString *tempUrl = [NSString stringWithFormat:@"%@%@&contentUuid=%@",contentUrl,m.sourceID,m.contentID];
        
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@&contentUuid=%@",contentUrl,idStr,cate.contentID];
    NSLog(@"%@",urlString);
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
            [self loadWebView:sender urlStr:@"网络加载失败,请稍后再试!"];
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
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"share" ofType:@"png"];
    ListModel *model = _detailArr[_index];
    NSString *contentSTR = [self p_aaa:model.breif];
    contentSTR = [contentSTR stringByAppendingString:model.source];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:contentSTR
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:model.title
                                                  url:model.source
                                          description:model.breif
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

// 处理分享的时候字符串中间的"-"
- (NSString *)p_aaa:(NSString *)content
{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//替换所有html和换行匹配元素为"-"
    
    regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"-{1,}" options:0 error:nil] ;
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//把多个"-"匹配为一个"-"
    
    //根据"-"分割到数组
    NSString *backStr = [content stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([backStr length] >= 100) {
        backStr = [backStr substringToIndex:100];
    }
    return backStr;
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
