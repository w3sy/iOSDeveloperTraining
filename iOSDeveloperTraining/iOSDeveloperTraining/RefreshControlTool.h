//
//  RefreshControlTool.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/30.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBStoreHouseRefreshControl.h"

@interface RefreshControlTool : NSObject

+ (CBStoreHouseRefreshControl*)attachToScrollView:(UIScrollView *)scrollView
                                           target:(id)target
                                    refreshAction:(SEL)refreshAction;

@end
