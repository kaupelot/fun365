//
//  WaterFlowLayout.h
//  UI lesson 21 collectionView_layout
//
//  Created by walt zeng on 15/5/28.
//  Copyright (c) 2015年 aimon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaterFlowDelegate<NSObject>
-(CGFloat)heightForItemIndexPath:(NSIndexPath *)indexPath;
@end



@interface WaterFlowLayout : UICollectionViewLayout

//item大小
@property(nonatomic,assign)CGSize itemSize;
//内边距
@property(nonatomic,assign)UIEdgeInsets sectionInsets;
//item间距
@property(nonatomic,assign)CGFloat insertItemSpacing;
//列数
@property(nonatomic,assign)NSUInteger numberOfColumns;

//代理
@property(nonatomic,weak)id<WaterFlowDelegate>delegate;

@end
