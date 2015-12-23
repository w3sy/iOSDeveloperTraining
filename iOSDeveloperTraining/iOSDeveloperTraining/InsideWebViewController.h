//
//  InsideWebViewController.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/27.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  应用内浏览器界面控制器
 */
@interface InsideWebViewController : UIViewController

/**
 *  加载页面
 *
 *  @param urlStr 加载页面地址字符串
 */
- (void)loadWithUrlString:(NSString *)urlStr;

@end
