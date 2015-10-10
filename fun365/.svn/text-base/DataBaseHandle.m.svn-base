//
//  DataBaseHandle.m
//  douban
//
//  Created by lanou3g on 15/5/23.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "DataBaseHandle.h"
#import <sqlite3.h>
#import "ListModel.h"

static DataBaseHandle *dataBase = nil;

@implementation DataBaseHandle

+ (instancetype)shareDataBase
{
    if (nil == dataBase) {
        dataBase = [[DataBaseHandle alloc] init];
    }
    return dataBase;
}

static sqlite3 *db = nil;

- (NSString *)p_documentsPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (void)openDB
{
    if (nil != db) {
//        NSLog(@"数据库已经打开");
    }
    NSString *dbPath = [[self p_documentsPath] stringByAppendingPathComponent:@"fun365.sqlite"];
//    NSLog(@"%@",dbPath);
    
    int result = sqlite3_open(dbPath.UTF8String, &db);
    if (result == SQLITE_OK) {
//        NSLog(@"成功打开");
    } else {
//        NSLog(@"打开失败");
    }
}


- (void)closeDB
{
    int result = sqlite3_close(db);
    if (result == SQLITE_OK) {
//        NSLog(@"关闭成功");
    } else {
//        NSLog(@"关闭失败");
    }
    db = nil;
}

/*
- (void)creatUserTable
{
    NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS Users (sid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,sname TEXT,spassword TEXT)";
    int result = sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"用户表创建成功");
    } else {
        NSLog(@"用户表创建失败");
    }
}

- (void)insertUser:(User *)user
{
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO Users (sname,spassword) VALUES ('%@','%@')",user.userName,user.passWord];
    int result = sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"用户创建成功");
    } else {
        NSLog(@"用户创建失败");
    }
}

- (NSArray *)selectUserWithUserName:(NSString *)userName
{
    NSMutableArray *dataArray = nil;
    NSString *selectStr = @"SELECT * FROM Users WHERE sname = ?";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, selectStr.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        dataArray = [NSMutableArray array];
        sqlite3_bind_text(stmt, 1, userName.UTF8String, -1, NULL);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSInteger sid = sqlite3_column_int(stmt, 0);
            NSString *spassword = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            
            User *user = [[User alloc] init];
            user.sid = sid;
            user.passWord = spassword;
            [dataArray addObject:user];
            
        }
    }
    sqlite3_finalize(stmt);
    return dataArray;
}
*/

- (void)creatEnjoyTable
{
    NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists user%@ (sid integer primary key autoincrement not null,stitle TEXT,scate TEXT,scontent TEXT,data BLOB)",temp];
    int result = sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
//        NSLog(@"建表成功");
    } else {
//        NSLog(@"建表失败");
    }
}

- (NSData *)selectHtmlFromEnjoyWithModel:(ListModel *)model
{
    NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSData *data = nil;
    NSString *selectStr = [NSString stringWithFormat:@"select data from user%@ where scontent = ?",temp];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, selectStr.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, model.contentID.UTF8String, -1, NULL);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 0) length:sqlite3_column_bytes(stmt, 0)];
        }
    }
    sqlite3_finalize(stmt);
    
    return data;
}

- (void)insertToEnjoyWithModel:(ListModel *)model
{
    NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    sqlite3_stmt *stmt = nil;
    NSString *insetStr = [NSString stringWithFormat:@"insert into user%@ (stitle,scate,scontent,data) values(?,?,?,?)",temp];
    int result = sqlite3_prepare_v2(db, insetStr.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, model.title.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 2, model.sourceID.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 3, model.contentID.UTF8String, -1, NULL);
        sqlite3_bind_blob(stmt, 4, [model.htmldata bytes], (int)[model.htmldata length], NULL);
        sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
}

- (void)deleteInEnjoyWithModel:(ListModel *)model
{
    NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    // 注意,第一次写语句的时候,放入的参数没有使用''引用,导致无法删除.
    NSString *sqlStr = [NSString stringWithFormat:@"delete from user%@ where scontent = '%@'",temp,model.contentID];
    int result = sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

- (NSArray *)selectModelsInEnjoy
{
    NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from user%@",temp];
    NSMutableArray *enjoyArray = nil;
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sqlStr.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        enjoyArray = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *stitle = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString *scate = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            NSString *scontent = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            // 出现问题,blob后的数字没有更正,真机调试从收藏的详情返回的时候卡住了.
            NSData *data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 4) length:sqlite3_column_bytes(stmt, 4)];
            
            ListModel *model = [[ListModel alloc] init];
            model.title = stitle;
            model.sourceID = scate;
            model.contentID = scontent;
            model.htmldata = data;
            [enjoyArray addObject:model];
        }
    }
    sqlite3_finalize(stmt);
    return enjoyArray;
}

- (void)creatCacheTable
{
    NSString *sqlStr = @"create table if not exists CacheTable (sid integer primary key autoincrement not null,scate TEXT,scontent TEXT,data BLOB)";
    int result = sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
//        NSLog(@"建表成功");
    } else {
//        NSLog(@"建表失败");
    }
}

- (NSData *)selectHtmlFromCacheWithModel:(ListModel *)model
{
    NSData *data = nil;
    NSString *selectStr = @"select data from CacheTable where scontent = ?";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, selectStr.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, model.contentID.UTF8String, -1, NULL);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 0) length:sqlite3_column_bytes(stmt, 0)];
        }
    }
    sqlite3_finalize(stmt);
    
    return data;
}

- (void)insertToCacheWithModel:(ListModel *)model
{
    sqlite3_stmt *stmt = nil;
    NSString *insetStr = @"insert into CacheTable (scate,scontent,data) values(?,?,?)";
    int result = sqlite3_prepare(db, insetStr.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"插入成功");
        sqlite3_bind_text(stmt, 1, model.sourceID.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 2, model.contentID.UTF8String, -1, NULL);
        sqlite3_bind_blob(stmt, 3, [model.htmldata bytes], (int)[model.htmldata length], NULL);
        sqlite3_step(stmt);
    } else {
        NSLog(@"插入失败");
    }
        
    sqlite3_finalize(stmt);
}

- (void)updataCacheWithModel:(ListModel *)model
{
    NSString *updateStr = @"update CacheTable set data = ? where scontent = ?";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, updateStr.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        sqlite3_bind_blob(stmt, 1, [model.htmldata bytes], (int)[model.htmldata length], NULL);
        sqlite3_bind_text(stmt, 2, model.contentID.UTF8String, -1, NULL);
        sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
}

- (void)clearCache
{
    NSString *clearStr = @"delete from CacheTable";
    int result = sqlite3_exec(db, clearStr.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"清除成功");
    } else {
        NSLog(@"清除失败");
    }
}

@end
