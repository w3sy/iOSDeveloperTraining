//
//  BlueAlertView.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/26.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueAlertView : UIView

@property (nonatomic) UILabel * messageLabel;

/**
 *  显示消息框
 *
 *  @param message 消息字符串
 *  @param view    显示在view上,如果view == nil,则显示在window上
 */
+ (void)showAlertViewWithMessage:(NSString *)message onView:(UIView *)view;

@end
