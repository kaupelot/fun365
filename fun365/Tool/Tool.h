//
//  Tool.h
//  UILesson17_ImageLoading
//
//  Created by lanou3g on 15/5/20.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^BackDataBlock)(id data);

@interface Tool : NSObject

+ (void)solveDataWithUrlString:(NSString *)urlstr httpMethod:(NSString *)method httpBody:(NSString *)body backDataBlock:(BackDataBlock)bb;

@end
