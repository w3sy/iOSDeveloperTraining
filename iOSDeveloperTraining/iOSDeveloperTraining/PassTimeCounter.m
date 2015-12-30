//
//  PassTimeCounter.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/30.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "PassTimeCounter.h"

@implementation PassTimeCounter

+ (NSString *)passedTimeSince:(NSDate *)date
{
    if (date == nil) {
        return @"没有记录";
    }
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *com = [cal components:NSCalendarUnitSecond|NSCalendarUnitMinute|NSCalendarUnitHour|NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0];
    NSString *timeStr;
    if (com.day >= 3) {
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd";
        timeStr = [df stringFromDate:date];
    } else if(com.day >= 1)
        timeStr = [NSString stringWithFormat:@"%ld天前",(long)com.day];
    else if(com.hour >= 1)
        timeStr = [NSString stringWithFormat:@"%ld小时前",(long)com.hour];
    else if(com.minute >= 1)
        timeStr = [NSString stringWithFormat:@"%ld分钟前",(long)com.minute];
    else
        timeStr = [NSString stringWithFormat:@"%ld秒前",(long)com.second];
    return timeStr;
}

+ (NSString *)passedTimeSinceTimeInterval:(NSTimeInterval)time
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    return [PassTimeCounter passedTimeSince:date];
}

@end
