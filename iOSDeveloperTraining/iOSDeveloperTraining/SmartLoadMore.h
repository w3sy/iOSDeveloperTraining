//
//  SmartLoadMore.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/20.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartLoadMore : NSObject

+ (instancetype)loadMoreForTableView:(UITableView *)tableView loadWith:(void (^)())loadBlock;

- (instancetype)initForTableView:(UITableView *)tableView loadWith:(void (^)())loadBlock;

- (void)finishLoadAndNoMoreData:(BOOL)noMoreData;

- (void)startLoad;

@end
