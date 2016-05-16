//
//  List_0_Cell.m
//  fun365
//
//  Created by walt zeng on 15/6/8.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "List_0_Cell.h"

@implementation List_0_Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView
{
    
    self.title = [[UILabel alloc] init];
    _title.frame = CGRectMake(10, 10, CGRectGetWidth(self.contentView.frame) - 20, 30);
    //_title.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_title];
    
    self.posttime = [[UILabel alloc] init];
    _posttime.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 160, CGRectGetMaxY(self.contentView.frame) - 35 , 150, 20);
    //_posttime.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_posttime];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _title.frame = CGRectMake(10, 10, CGRectGetWidth(self.contentView.frame) - 20, _title.frame.size.height);
    _posttime.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 160, _posttime.frame.origin.y , 150, 20);
}

// 返回cell高度
+ (CGFloat)cellHeight
{
    return 90;
}

@end
