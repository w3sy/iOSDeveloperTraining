//
//  NSString+QRCodeImage.h
//  QRCodeMaker
//
//  Created by 王博 on 15/11/11.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (QRCodeImage)

- (UIImage *)imageOfQRCodeWithSize:(CGFloat)size;

@end
