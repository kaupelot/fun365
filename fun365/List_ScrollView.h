//
//  List_ScrollView.h
//  fun365
//
//  Created by lanou3g on 15/6/16.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface List_ScrollView : UIView
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *titleView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIPageControl *page;
@end
