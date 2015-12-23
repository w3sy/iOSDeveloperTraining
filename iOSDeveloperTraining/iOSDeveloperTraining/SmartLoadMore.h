//
//  SmartLoadMore.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/20.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自动加载更多数据类
 */
@interface SmartLoadMore : NSObject

/**
 *  ＋获得自动加载对象
 *
 *  @param tableView 目标tableView
 *  @param loadBlock 加载动作Block
 *
 *  @return 返回一个SmartLoadMore对象
 */
+ (instancetype)loadMoreForTableView:(UITableView *)tableView loadWith:(void (^)())loadBlock;

/**
 *  －获得自动加载对象
 *
 *  @param tableView 目标tableView
 *  @param loadBlock 加载动作Block
 *
 *  @return 返回一个SmartLoadMore对象
 */
- (instancetype)initForTableView:(UITableView *)tableView loadWith:(void (^)())loadBlock;

/**
 *  指示加载已完成
 *
 *  @param noMoreData 不再加载更多数据＝YES
 */
- (void)finishLoadAndNoMoreData:(BOOL)noMoreData;

/**
 *  手动开始加载数据
 */
- (void)startLoad;

@end
