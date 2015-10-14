//
//  logViewCell.m
//  test
//
//  Created by 553766229 on 8/6/15.
//  Copyright (c) 2015年 553766229. All rights reserved.
//

#import "logViewCell.h"

@implementation logViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier    {


    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self m_setView];
        
    }

    return self;
}

-(void)m_setView{
    
//用户头像
    self.userImage=[[UIImageView alloc]init];
    _userImage.frame=CGRectMake(5, 5, 50, 50);
    _userImage.backgroundColor=[UIColor cyanColor];
    [self.contentView addSubview:_userImage];
//用户名
    self.nameLabel=[[UILabel alloc]init];
    _nameLabel.frame=CGRectMake(60, 15, self.bounds.size.width - 155, 30);
    //_nameLabel.backgroundColor=[UIColor cyanColor];
    [self addSubview:_nameLabel];
//设置按钮
    self.setButton=[UIButton buttonWithType:UIButtonTypeSystem];
    _setButton.frame=CGRectMake(self.bounds.size.width - 100, 15, 60, 30);
    //_setButton.backgroundColor=[UIColor cyanColor];
    [self addSubview:_setButton];
    

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
