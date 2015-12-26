//
//  QRCodeShareActivity.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/26.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "QRCodeShareActivity.h"
#import "QRCodeViewController.h"

@interface QRCodeShareActivity ()

@property (nonatomic) NSArray * activityItems;

@end

@implementation QRCodeShareActivity

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (nullable NSString *)activityType {
    return @"QRCodeShareActivity";
}
- (nullable NSString *)activityTitle {
    return NSLocalizedStringFromTable(@"二维码分享", @"Localization", @"二维码分享");
}
- (nullable UIImage *)activityImage {
    return [UIImage imageNamed:@"QRCode"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id obj in activityItems) {
        if ([obj isKindOfClass:[NSURL class]] || [obj isKindOfClass:[NSString class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.activityItems = activityItems;
}

- (nullable UIViewController *)activityViewController {
    QRCodeViewController * qvc = [[QRCodeViewController alloc] init];
    [qvc setFinishBlock:^{
        [self activityDidFinish:YES];
    }];
    for (id obj in self.activityItems) {
        if ([obj isKindOfClass:[NSURL class]]) {
            NSURL * url = obj;
            qvc.message = url.absoluteString;
            return qvc;
        }
    }
    for (id obj in self.activityItems) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString * str = obj;
            qvc.message = str;
            return qvc;
        }
    }
    return qvc;
}

- (void)performActivity {
    
}

@end
