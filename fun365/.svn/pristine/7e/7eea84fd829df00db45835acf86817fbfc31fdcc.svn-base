//
//  WaterFlowLayout.m
//  UI lesson 21 collectionView_layout
//
//  Created by lanou3g on 15/5/28.
//  Copyright (c) 2015年 aimon. All rights reserved.
//

#import "WaterFlowLayout.h"

//类目
@interface WaterFlowLayout()

//获取Item总数量
@property(nonatomic,assign)NSUInteger numberOfItems;

//保存每一列的总高度
@property(nonatomic,strong)NSMutableArray *columnHeights;

//保存每一个item计算好的属性(x,y,w,h)
@property(nonatomic,strong)NSMutableArray *itemAtrributes;

//获取最长列的索引
-(NSInteger)m_indexForLongestColumn;

//获取最短列的索引
-(NSInteger)m_indexforShortsetColumn;

@end



@implementation WaterFlowLayout


//懒加载
-(NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        
        self.columnHeights=[NSMutableArray array];
    }

    return _columnHeights;
}


//懒加载
-(NSMutableArray *)itemAtrributes{
    if (!_itemAtrributes) {
        self.itemAtrributes=[NSMutableArray array];
    }
    return _itemAtrributes;
}


//获取最长列的索引
-(NSInteger)m_indexForLongestColumn{
    //记录那一列最长
    NSInteger longsetIndex=0;
    //记录当前最长高度
    CGFloat longestHeight=0;
    for (int i=0; i<self.numberOfColumns; i++) {
        //获取高度
        CGFloat currentHeight=[self.columnHeights[i] floatValue];
        //判断,选出最长高度
        if(currentHeight>longestHeight  ){
            longestHeight=currentHeight;
            longsetIndex=i;
        }
    }
    return longsetIndex;
}

//获取最短列索引
-(NSInteger)m_indexforShortsetColumn
{

//记录哪一列最短
    NSInteger shortestIndex=0;
    CGFloat shortestHeiht=MAXFLOAT;
    for (int i=0; i<self.numberOfColumns; i++) {
        CGFloat currentHeight=[self.columnHeights[i] floatValue];
        if (currentHeight<shortestHeiht) {
            shortestHeiht=currentHeight;
            shortestIndex=i;
        }
    }
    return shortestIndex;
}


//准备布局
-(void)prepareLayout
{
    //调用父类
    [super prepareLayout];
    //给每一列添加top高度
    for (int i=0; i<self.numberOfColumns; i++) {
        
        self.columnHeights[i] =@(self.sectionInsets.top);
    }
    
    // 由于学习瀑布流的时候没有考虑到图片数据减少的情况,导致arributes与items数目不能相符,数据越界.所以处理可变数据的时候需要初始化数组.
    self.itemAtrributes=[NSMutableArray array];
    //获取item的数量
    self.numberOfItems =[self.collectionView numberOfItemsInSection:0];
    //为每一个item设置frame 和 indexpath
    for (int i=0; i< self.numberOfItems; i++) {
        
        //查找最短列
        NSInteger shortestIndex=[self m_indexforShortsetColumn];
        CGFloat shortestH=[self.columnHeights[shortestIndex] floatValue];
        
        //计算x值:内边距left+(item宽 +item间距)*索引
        
        CGFloat detalX=self.sectionInsets.left +(self.itemSize.width +self.insertItemSpacing) * shortestIndex;
        
        //计算y值
        CGFloat detalY=shortestH +self.insertItemSpacing;
        
        
        //设置indexPath
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        
        
        //设置属性
        UICollectionViewLayoutAttributes *layoutArr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        //保存item的高度
        CGFloat itemHeight=0;
        
        //代理有无,并且方法有无
        if (_delegate && [_delegate respondsToSelector:@selector(heightForItemIndexPath:)] ) {
            //使用代理方法获取item的高度
            itemHeight=[_delegate heightForItemIndexPath:indexPath];
        }
        
        //设置frame
        layoutArr.frame=CGRectMake(detalX+5, detalY, self.itemSize.width, itemHeight);
        
        //放入数组
        
        [self.itemAtrributes addObject:layoutArr];
        
        //更新高度
        self.columnHeights[shortestIndex]=@(detalY +itemHeight);
    }
}


//计算contentview的大小
-(CGSize)collectionViewContentSize
{
    
    //获取最长高度索引
    NSInteger longerstIndex=[self m_indexForLongestColumn];
    //通过索引获取高度
    CGFloat lohgestH=[self.columnHeights[longerstIndex] floatValue];
    //获取collectionView的size
    CGSize contentSize=self.collectionView.frame.size;
    //最大高度+bottom
    contentSize.height=lohgestH +self.sectionInsets.bottom;
    return contentSize;
    
}


//返回每一个item的attribute
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //返回每一个item的attribute
    return self.itemAtrributes;
}

@end
