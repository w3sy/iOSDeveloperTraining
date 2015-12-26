//
//  QRCodeViewController.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/26.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeViewController : UIViewController

@property (nonatomic) NSString * message;

- (void)setFinishBlock:(void(^)(void))block;

@end
