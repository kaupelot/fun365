//
//  List_ScrollView.m
//  fun365
//
//  Created by lanou3g on 15/6/16.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "List_ScrollView.h"

@implementation List_ScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width * 9 / 16)];
    _scrollView.backgroundColor = [UIColor cyanColor];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollView];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), [[UIScreen mainScreen] bounds].size.width, 30)];
    _titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:_titleView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_titleView.frame) - 100, CGRectGetHeight(_titleView.frame))];
    //_titleLabel.backgroundColor = [UIColor orangeColor];
    [_titleView addSubview:_titleLabel];

    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), 0, 100, CGRectGetHeight(_titleView.frame))];
    //_page.backgroundColor = [UIColor orangeColor];
    _page.backgroundColor = [UIColor clearColor];
    [_titleView addSubview:_page];
}
@end
