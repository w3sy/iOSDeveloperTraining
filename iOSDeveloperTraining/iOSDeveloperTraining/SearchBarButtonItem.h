//
//  SearchBarButtonItem.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/30.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBarButtonItem : UIBarButtonItem

- (void)setSearchActionBlock:(void(^)(NSString * keyword))block;

- (void)setCancelActionBlock:(void(^)(void))block;

@end
