//
//  RefreshControlTool.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/30.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBStoreHouseRefreshControl.h"

/**
 *  刷新工具类
 */
@interface RefreshControlTool : NSObject

/**
 *  获得一个刷新控制器
 *
 *  @param scrollView    目标scrollView
 *  @param target        调用对象
 *  @param refreshAction 刷新动作SEL
 *
 *  @return 返回一个CBStoreHouseRefreshControl对象
 */
+ (CBStoreHouseRefreshControl*)attachToScrollView:(UIScrollView *)scrollView
                                           target:(id)target
                                    refreshAction:(SEL)refreshAction;

@end
