//
//  MyView.m
//  FloatButton
//
//  Created by lanou3g on 15/6/9.
//  Copyright (c) 2015年 夏栋. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView
{
    self.backgroundColor = [UIColor whiteColor];
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    // 容器
    self.buttonsView = [[UIView alloc] init];
    _buttonsView.frame = CGRectMake(0, self.bounds.size.height * 14 / 15, self.bounds.size.width, self.bounds.size.height / 15);
    _buttonsView.backgroundColor = [UIColor blackColor];
    _buttonsView.alpha = 0.7;
    [self addSubview:_buttonsView];
    
    // 返回
    self.backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _backButton.frame = CGRectMake(0, 0, CGRectGetWidth(_buttonsView.frame) / 5, CGRectGetHeight(_buttonsView.frame));
    [_backButton setTitle:@"返回" forState:(UIControlStateNormal)];
    [_backButton setTitleColor:[UIColor cyanColor] forState:(UIControlStateNormal)];
    _backButton.backgroundColor = [UIColor clearColor];
    [_buttonsView addSubview:_backButton];
    
    // 评论,目前由上一页功能替代
    self.commitButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _commitButton.frame = CGRectMake(CGRectGetMaxX(_backButton.frame), 0, CGRectGetWidth(_backButton.frame), CGRectGetHeight(_backButton.frame));
    [_commitButton setTitle:@"上一页" forState:(UIControlStateNormal)];
    [_commitButton setTitleColor:[UIColor cyanColor] forState:(UIControlStateNormal)];
    _commitButton.backgroundColor = [UIColor clearColor];
    [_buttonsView addSubview:_commitButton];
    
    // 收藏
    self.favButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _favButton.frame = CGRectMake(CGRectGetMaxX(_commitButton.frame), 0, CGRectGetWidth(_backButton.frame), CGRectGetHeight(_backButton.frame));
    [_favButton setTitle:@"收藏" forState:(UIControlStateNormal)];
    [_favButton setTitleColor:[UIColor cyanColor] forState:(UIControlStateNormal)];
    _favButton.backgroundColor = [UIColor clearColor];
    [_buttonsView addSubview:_favButton];
    
    // 分享
    self.shareButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _shareButton.frame = CGRectMake(CGRectGetMaxX(_favButton.frame), 0, CGRectGetWidth(_backButton.frame), CGRectGetHeight(_backButton.frame));
    [_shareButton setTitle:@"分享" forState:(UIControlStateNormal)];
    [_shareButton setTitleColor:[UIColor cyanColor] forState:(UIControlStateNormal)];
    _shareButton.backgroundColor = [UIColor clearColor];
    [_buttonsView addSubview:_shareButton];
    
    // 下一条
    self.nextButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _nextButton.frame = CGRectMake(CGRectGetMaxX(_shareButton.frame), 0, CGRectGetWidth(_backButton.frame), CGRectGetHeight(_backButton.frame));
    [_nextButton setTitle:@"下一页" forState:(UIControlStateNormal)];
    [_nextButton setTitleColor:[UIColor cyanColor] forState:(UIControlStateNormal)];
    _nextButton.backgroundColor = [UIColor clearColor];
    [_buttonsView addSubview:_nextButton];

}

@end
