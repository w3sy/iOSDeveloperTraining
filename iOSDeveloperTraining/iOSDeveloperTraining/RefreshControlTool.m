//
//  RefreshControlTool.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/30.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "RefreshControlTool.h"

@implementation RefreshControlTool

+ (CBStoreHouseRefreshControl*)attachToScrollView:(UIScrollView *)scrollView
                                                   target:(id)target
                                            refreshAction:(SEL)refreshAction {
    return [CBStoreHouseRefreshControl attachToScrollView:scrollView target:target refreshAction:refreshAction plist:@"loading"];
}

@end
