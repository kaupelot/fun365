//
//  ListCell.h
//  fun365
//
//  Created by walt zeng on 15/6/6.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UIImageView *image_1;
@property (nonatomic,strong)UILabel *posttime;

// 返回cell高度
+ (CGFloat)cellHeight;

@end
