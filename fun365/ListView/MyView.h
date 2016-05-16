//
//  MyView.h
//  FloatButton
//
//  Created by walt zeng on 15/6/9.
//  Copyright (c) 2015年 夏栋. All rights reserved.
//

#import <UIKit/UIKit.h>

// 用于详情页的菜单栏
@interface MyView : UIView
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *buttonsView;
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UIButton *commitButton;
@property (nonatomic,strong)UIButton *favButton;
@property (nonatomic,strong)UIButton *shareButton;
@property (nonatomic,strong)UIButton *nextButton;

@property (nonatomic,strong)UIView *nightView;
@end
