//
//  ListCell.m
//  fun365
//
//  Created by lanou3g on 15/6/6.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

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
    self.image_1 = [[UIImageView alloc] init];
    _image_1.frame = CGRectMake(10, 10, 108, 108);
    //_image_1.backgroundColor = [UIColor orangeColor];
    
    _image_1.contentMode =  UIViewContentModeScaleAspectFill;
    _image_1.clipsToBounds  = YES;
    
    [self.contentView addSubview:_image_1];
    
    self.title = [[UILabel alloc] init];
    _title.frame = CGRectMake(CGRectGetMaxX(_image_1.frame) + 10, CGRectGetMinY(_image_1.frame), CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(_image_1.frame) - 30, 30);
    //_title.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_title];
    
    self.posttime = [[UILabel alloc] init];
    _posttime.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 160, CGRectGetMaxY(self.image_1.frame) - 35 , 150, 20);
    //_posttime.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_posttime];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _image_1.frame = CGRectMake(_image_1.frame.origin.x, _image_1.frame.origin.y, _image_1.frame.size.width, _image_1.frame.size.height);
    
    _title.frame = CGRectMake(CGRectGetMaxX(_image_1.frame) + 10, CGRectGetMinY(_image_1.frame), CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(_image_1.frame) - 30, _title.frame.size.height);
    _posttime.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 160, _posttime.frame.origin.y , 150, 20);
}

// 返回cell高度
+ (CGFloat)cellHeight
{
    return 148;
}

@end
