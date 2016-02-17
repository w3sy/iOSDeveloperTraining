//
//  BlueAlertView.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/26.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "BlueAlertView.h"

@interface BlueAlertView ()

@property (nonatomic) UIView * bgView;
@property (nonatomic) UIButton * closeButton;

@end

@implementation BlueAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bgView = [[UIView alloc] initWithFrame:self.bounds];
        self.bgView.backgroundColor = [UIColor colorWithRed:0 green:153/255.0 blue:204/255.0 alpha:1];
        self.bgView.alpha = 0.75;
        [self addSubview:self.bgView];
        self.messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.adjustsFontSizeToFitWidth = YES;
        self.messageLabel.minimumScaleFactor = 0.3;
        self.messageLabel.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:self.messageLabel];
        self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.closeButton.frame = CGRectMake(frame.size.width - 35, 0, 35, 35);
        [self.closeButton setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
        self.closeButton.tintColor = [UIColor whiteColor];
        [self.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)closeAction:(UIButton *)btn {
    [self removeFromSuperview];
}

+ (UINavigationBar *)visibleNavigationBarInView:(UIView *)view {
    if ([view isKindOfClass:[UINavigationBar class]]) {
        if (view.hidden == NO) {
            return (UINavigationBar *)view;
        } else {
            return nil;
        }
    } else if (view.subviews.count > 0) {
        for (UIView * sub in view.subviews) {
            UINavigationBar * bar = [self visibleNavigationBarInView:sub];
            if (bar) {
                return bar;
            }
        }
    }
    return nil;
}

+ (void)showAlertViewWithMessage:(NSString *)message onView:(UIView *)view {
    CGFloat width = view.frame.size.width;
    if (!width) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    CGFloat offsetY = 0;
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
        UINavigationBar * bar = [self visibleNavigationBarInView:view];
        if (bar) {
            offsetY += bar.frame.origin.y + bar.frame.size.height;
        } else {
            if (![UIApplication sharedApplication].statusBarHidden) {
                offsetY += [UIApplication sharedApplication].statusBarFrame.origin.y + [UIApplication sharedApplication].statusBarFrame.size.height;
            }
        }
    }
    BlueAlertView * blueAlertView = [[BlueAlertView alloc] initWithFrame:CGRectMake(0, offsetY, width, 35)];
    blueAlertView.messageLabel.text = message;
    blueAlertView.alpha = 0;
    [view addSubview:blueAlertView];
    [UIView animateWithDuration:0.5 animations:^{
        blueAlertView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                blueAlertView.alpha = 0;
            } completion:^(BOOL finished) {
                [blueAlertView removeFromSuperview];
            }];
        });
    }];
}

@end
