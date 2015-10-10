//
//  List_3_Cell.m
//  fun365
//
//  Created by lanou3g on 15/6/8.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "List_3_Cell.h"

@implementation List_3_Cell

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
   // _title.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_title];
    
    self.image_1 = [[UIImageView alloc] init];
    _image_1.frame = CGRectMake(15, CGRectGetMaxY(_title.frame) + 10, (CGRectGetWidth(self.contentView.frame) - 50) / 3, (CGRectGetWidth(self.contentView.frame) - 50) / 3);
    //_image_1.backgroundColor = [UIColor orangeColor];
    _image_1.contentMode =  UIViewContentModeScaleAspectFill;
    _image_1.clipsToBounds  = YES;
    [self.contentView addSubview:_image_1];
    
    self.image_2 = [[UIImageView alloc] init];
    _image_2.frame = CGRectMake(CGRectGetMaxX(_image_1.frame) + 10, CGRectGetMinY(_image_1.frame), CGRectGetWidth(_image_1.frame), CGRectGetHeight(_image_1.frame));
    //_image_2.backgroundColor = [UIColor orangeColor];
    _image_2.contentMode =  UIViewContentModeScaleAspectFill;
    _image_2.clipsToBounds  = YES;

    [self.contentView addSubview:_image_2];
    
    self.image_3 = [[UIImageView alloc] init];
    _image_3.frame = CGRectMake(CGRectGetMaxX(_image_2.frame) + 10, CGRectGetMinY(_image_1.frame), CGRectGetWidth(_image_1.frame), CGRectGetHeight(_image_1.frame));
    //_image_3.backgroundColor = [UIColor orangeColor];
    _image_3.contentMode =  UIViewContentModeScaleAspectFill;
    _image_3.clipsToBounds  = YES;

    [self.contentView addSubview:_image_3];
    
    self.posttime = [[UILabel alloc] init];
    _posttime.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 160, CGRectGetMaxY(_image_1.frame) + 5 , 150, 20);
    //_posttime.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_posttime];
        
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _title.frame = CGRectMake(10, 10, CGRectGetWidth(self.contentView.frame) - 20, _title.frame.size.height);
    _image_1.frame = CGRectMake(15, _image_1.frame.origin.y, (CGRectGetWidth(self.contentView.frame) - 50) / 3, (CGRectGetWidth(self.contentView.frame) - 50) / 3);
    _image_2.frame = CGRectMake(CGRectGetMaxX(_image_1.frame) + 10, _image_1.frame.origin.y, CGRectGetWidth(_image_1.frame), CGRectGetHeight(_image_1.frame));
    _image_3.frame = CGRectMake(CGRectGetMaxX(_image_2.frame) + 10, _image_1.frame.origin.y, CGRectGetWidth(_image_1.frame), CGRectGetHeight(_image_1.frame));
    _posttime.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 160, _posttime.frame.origin.y , 150, 20);
}

// 返回cell高度
+ (CGFloat)cellHeight
{
    return 195;
}

@end
