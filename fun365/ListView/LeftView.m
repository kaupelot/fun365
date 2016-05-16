//
//  LeftView.m
//  fun365
//
//  Created by walt zeng on 15/6/10.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "LeftView.h"

@implementation LeftView

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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"13.png"]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 65, 65)];
    _userImage.backgroundColor = [UIColor clearColor];
    [self addSubview:_userImage];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userImage.frame) + 15, CGRectGetMinY(_userImage.frame) + 25, 150, 40)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_nameLabel];
    
    self.myButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _myButton.frame = CGRectMake(CGRectGetWidth(self.frame) * 8 / 12 + 10, CGRectGetMinY(_userImage.frame)+15
                                 , CGRectGetWidth(self.frame) / 10, CGRectGetWidth(self.frame) / 10);
    _myButton.backgroundColor = [UIColor clearColor];
    [self addSubview:_myButton];
    
//    self.listTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    self.listTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) style:UITableViewStyleGrouped];
    _listTab.backgroundColor = [UIColor clearColor];
    [self addSubview:_listTab];
}

@end
