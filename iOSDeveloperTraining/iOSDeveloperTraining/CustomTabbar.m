//
//  CustomTabbar.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/22.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "CustomTabbar.h"

@implementation CustomTabbar

- (void)awakeFromNib {
    // 设置标签栏图标选中颜色(storyboard上目前有bug设置无效)
    self.tintColor = [UIColor colorWithRed:0 green:128/255.0 blue:0 alpha:1];
    
}

@end
