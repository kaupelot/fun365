//
//  AppDelegate.m
//  fun365
//
//  Created by walt zeng on 15/6/6.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "JokesTableViewController.h"
#import "AFNetworking.h"

#import "ListModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    // Override point for customization after application launch.
    // 云服务器验证
    [AVOSCloud setApplicationId:avosID
                      clientKey:avosKey];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    // 抽屉效果
    LeftViewController *leftSideDrawerViewController=[[LeftViewController alloc]init];
    JokesTableViewController *ListTVC = [[JokesTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
    UINavigationController *ListNC = [[UINavigationController alloc] initWithRootViewController:ListTVC];
    leftSideDrawerViewController.navigationControllerArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
    [leftSideDrawerViewController.navigationControllerArray replaceObjectAtIndex:2 withObject:ListNC];
    MMDrawerController *drawerController=[[MMDrawerController alloc ]initWithCenterViewController:ListNC leftDrawerViewController:leftSideDrawerViewController];
    [drawerController setMaximumLeftDrawerWidth:self.window.frame.size.width-50];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    // 初始化各个栏目的cid的值
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *news1 = [ud objectForKey:@"news"];
    NSString *eassay1 = [ud objectForKey:@"eassay"];
    NSString *jokes1 = [ud objectForKey:@"jokes"];
    NSString *picture1 = [ud objectForKey:@"picture"];
    NSString *login = [ud objectForKey:@"login"];
    NSString *userName = [ud objectForKey:@"user"];
    NSString *loginLocal = [ud objectForKey:@"loginCount"];
//    NSLog(@"%@,%@,%@,%@",news,eassay,jokes,picture);
    // 给初次使用的设备的登录状态赋值
    if (login == nil) {
        [ud setObject:@"no" forKey:@"login"];
    }
    
    // 当没有WiFi时默认开启无图模式
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case 0:
                NSLog(@"无网络连接");
                break;
                
            case 2:
                NSLog(@"WIFI");
                break;
                
            default:
                break;
        }
    }];
    
    NSString *cql = [NSString stringWithFormat:@"select * from %@ where userName = '%@'",@"UserInfo",userName];
    AVCloudQueryResult *result = [AVQuery doCloudQueryWithCQL:cql];
    if (result.results.count != 0) {
        AVObject *temp1 = result.results[0];
        NSString *count = [temp1 objectForKey:@"loginCount"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"您的账号在别的设备登陆了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        if ([login isEqualToString:@"yes"] && ![count isEqualToString:loginLocal]) {
            [alert show];
            [ud setObject:@"no" forKey:@"login"];
            [ud setObject:@"未登录" forKey:@"user"];
        }
    }
    
    // 由于初始值是空,所以判断为null或者title == (id)[NSNull null] || title.length == 0;
    // 只能并行判断,否则无法给所有的类别赋值.
    if (news1 == nil) {
        [ud setObject:newsONE forKey:@"news"];
    }
    if (eassay1 == nil) {
        [ud setObject:eassayONE forKey:@"eassay"];
    }
    if (jokes1 == nil) {
        [ud setObject:jokesONE forKey:@"jokes"];
    }
    if (picture1 == nil) {
        [ud setObject:pictureONE forKey:@"picture"];
    }
    [ud setObject:versionNOW forKey:@"version"];
    [ud synchronize];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = drawerController;
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

/*
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
*/

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    // 用于全局关闭横屏,不需要单个页面的部分设置
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
