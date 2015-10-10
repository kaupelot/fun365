//
//  DetailCell.m
//  test
//
//  Created by 553766229 on 6/6/15.
//  Copyright (c) 2015年 553766229. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{



    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
        
    }
    return self;
}


-(void)setupView
{
//用户头像
    self.userImage=[[UIImageView alloc]init];
    _userImage.frame=CGRectMake(5, 2, 30, 30);
    _userImage.backgroundColor=[UIColor cyanColor];
    
    [self addSubview:_userImage];
    
//用户昵称
    self.nameLabel=[[UILabel alloc]init];
    _nameLabel.frame=CGRectMake(40, 2, self.frame.size.width-40, 20);
    _nameLabel.backgroundColor=[UIColor cyanColor];
    [self addSubview:_nameLabel];
    
    






}

-(void)layoutSubviews
{

    [super layoutSubviews];
    _nameLabel.frame=CGRectMake(40, 2, self.frame.size.width-40, 20);
    
    
    
    


}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
