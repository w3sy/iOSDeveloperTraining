//
//  PassTimeCounter.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/30.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassTimeCounter : NSObject

+ (NSString *)passedTimeSince:(NSDate *)date;

+ (NSString *)passedTimeSinceTimeInterval:(NSTimeInterval)time;

@end
