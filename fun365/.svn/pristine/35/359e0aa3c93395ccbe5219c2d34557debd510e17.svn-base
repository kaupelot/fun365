//
//  Tool.m
//  UILesson17_ImageLoading
//
//  Created by lanou3g on 15/5/20.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (void)solveDataWithUrlString:(NSString *)urlstr httpMethod:(NSString *)method httpBody:(NSString *)body backDataBlock:(BackDataBlock)bb
{
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if ([method isEqualToString:@"POST"]) {
        [request setHTTPMethod:method];
        NSData *paraData = [body dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:paraData];
    }
    
//    __block NSData *backData = nil;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        backData = data;
//        return backData;
//        NSLog(@"%@",data);
        bb(data);
        
    }];
    
//    NSLog(@"back:%@",backData);
//    return backData;
}


@end
