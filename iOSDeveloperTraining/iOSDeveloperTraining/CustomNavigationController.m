//
//  CustomNavigationController.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/20.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  把状态栏样式控制权交给，栈顶页面
 *
 *  @return 返回栈顶页面控制器
 */
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
