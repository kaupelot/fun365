//
//  BaseTableViewController.h
//  fun365
//
//  Created by walt zeng on 15/11/1.
//  Copyright © 2015年 曾旺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

@property (strong, nonatomic) NSString *name;

- (void)p_refresh;// 用于更新摇一摇方法.

@end
