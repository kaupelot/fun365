//
//  AboutUsViewController.m
//  fun365
//
//  Created by walt zeng on 15/6/19.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ListModel.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //  返回按钮
    UIButton *backbutton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    backbutton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -50, [UIScreen mainScreen].bounds.size.width, 50);
    [backbutton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"14.png"] forState:(UIControlStateNormal)];
    [backbutton setTitle:@"返回" forState:(UIControlStateNormal)];
    [backbutton addTarget:self action:@selector(backbuttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backbutton];
    [self p_setupView];
    
    
}

- (void)backbuttonAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 布局

- (void)p_setupView
{
    
    
    // 图标
    UIImageView *logoview =[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 60, 80, 120, 120)];
    logoview.image = [UIImage imageNamed:@"share.png"];
    [logoview.layer setMasksToBounds:YES];
    [logoview.layer setCornerRadius:20];
    [self.view addSubview:logoview];
    
    
    NSString * cLabelString = @"  蛮有味是一款轻量的阅读app,我们集合了段子,趣图,新闻,文章等一些富有影响力的阅读资源.通过特色的摇一摇功能,您可以随心切换您想不到的阅读资源.随时收藏可以随时阅读,流量不足时我们为您开启无图模式.";
    UILabel * cLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,230, [UIScreen mainScreen].bounds.size.width - 40, 200)];
    cLabel.numberOfLines = 0;
    cLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    cLabel.textColor = [UIColor grayColor];
    // 设置Label行间距
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:cLabelString];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:10];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [cLabelString length])];
    [cLabel setAttributedText:attributedString1];
    [cLabel sizeToFit];
    [self.view addSubview:cLabel];
    
    
    // 制作人
    NSString *edictLabelstring = @" 技术支持:@XDD233,@艺成行天涯,@aimon,";
    UILabel *edictLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 , [UIScreen mainScreen].bounds.size.height - 200 , [UIScreen mainScreen].bounds.size.width - 40 , 50)];
    edictLabel.numberOfLines = 0;
    edictLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    edictLabel.textColor = [UIColor grayColor];
    // 设置Label行间距
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:edictLabelstring];
    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle2 setLineSpacing:10];
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [edictLabelstring length])];
    [edictLabel setAttributedText:attributedString2];
    [edictLabel sizeToFit];
    [self.view addSubview:edictLabel];
    
    //     联系我们
    NSString *contactus = @"反馈:13601047527@163.com";
    
    UILabel *contactusLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 , [UIScreen mainScreen].bounds.size.height - 170 , [UIScreen mainScreen].bounds.size.width - 40 , 50)];
    contactusLabel.numberOfLines = 0;
    contactusLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    contactusLabel.textColor = [UIColor grayColor];
    // 设置Label行间距
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:contactus];
    NSMutableParagraphStyle *paragraphStyle3 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle3 setLineSpacing:10];
    [attributedString3 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [contactus length])];
    [contactusLabel setAttributedText:attributedString3];
    [contactusLabel sizeToFit];
    [self.view addSubview:contactusLabel];
    // 版本号
//    NSString *version = @" 版本号:V1.0";
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 , [UIScreen mainScreen].bounds.size.height - 110 , [UIScreen mainScreen].bounds.size.width - 40 , 50)];
    versionLabel.numberOfLines = 0;
    versionLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    versionLabel.textColor = [UIColor grayColor];
    // 设置Label行间距
//    NSMutableAttributedString *attributedString4 = [[NSMutableAttributedString alloc] initWithString:version];
    NSMutableParagraphStyle *paragraphStyle4 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle4 setLineSpacing:10];
//    [attributedString4 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [version length])];
//    [versionLabel setAttributedText:attributedString4];
    [versionLabel sizeToFit];
    [self.view addSubview:versionLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark 夜间模式
- (void)nightMode
{
    // 夜间模式初始化
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *mode = [ud objectForKey:@"night"];
    if ([mode isEqualToString:@"yes"]) {
        self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    }else{
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    }
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
