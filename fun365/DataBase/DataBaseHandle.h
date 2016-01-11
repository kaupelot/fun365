//
//  DataBaseHandle.h
//  douban
//
//  Created by lanou3g on 15/5/23.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@class ListModel;

@interface DataBaseHandle : NSObject

+ (instancetype)shareDataBase;

- (NSString *)p_documentsPath;

- (void)openDB;

- (void)closeDB;

/*
- (void)creatUserTable;

- (void)insertUser:(User *)user;

- (NSArray *)selectUserWithUserName:(NSString *)userName;
*/

// 用户信息考虑不再使用数据库存储,开辟两个表类,一个是缓存html字符串,另一个保存收藏的信息,如果多用户登录,当网络请求成功之后本地建表存储收藏信息.

- (void)creatEnjoyTable;

- (NSData *)selectHtmlFromEnjoyWithModel:(ListModel *)model;

- (void)insertToEnjoyWithModel:(ListModel *)model;

- (void)deleteInEnjoyWithModel:(ListModel *)model;

- (NSArray *)selectModelsInEnjoy;

- (void)creatCacheTable;

- (NSData *)selectHtmlFromCacheWithModel:(ListModel *)model;

- (void)insertToCacheWithModel:(ListModel *)model;

- (void)updataCacheWithModel:(ListModel *)model;

- (void)clearCache;

@end
