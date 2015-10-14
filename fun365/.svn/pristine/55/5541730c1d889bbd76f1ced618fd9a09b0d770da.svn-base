//
//  imageCell.m
//  test
//
//  Created by 553766229 on 6/6/15.
//  Copyright (c) 2015年 553766229. All rights reserved.
//

#import "imageCell.h"

@implementation imageCell
-(instancetype)initWithFrame:(CGRect)frame
{

    if (self =[super initWithFrame:frame]) {
        
        [self setView];
    }

    return self;

}

-(void)setView
{

//文章图片
    self.contentIamge=[[UIImageView alloc]init];
    _contentIamge.frame=CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-20);
   // _contentIamge.backgroundColor=[UIColor yellowColor];
    [self.contentView addSubview:_contentIamge];
//文章题目
    self.contentLabel=[[UILabel alloc]init];
    _contentLabel.frame=CGRectMake(5, CGRectGetMaxY(_contentIamge.frame)+3, _contentIamge.frame.size.width, 20);
   // _contentLabel.backgroundColor=[UIColor grayColor];
    [self.contentView addSubview:_contentLabel];
    
    self.h=_contentIamge.frame.size.height;
}


-(void)layoutSubviews
{
    
    
    [super layoutSubviews];
     _contentIamge.frame=CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-20);
    _contentLabel.frame=CGRectMake(5, CGRectGetMaxY(_contentIamge.frame)+3, _contentIamge.frame.size.width, 20);
    

}
@end
