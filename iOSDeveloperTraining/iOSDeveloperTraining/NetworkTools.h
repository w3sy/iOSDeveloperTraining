//
//  NetworkTools.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/29.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkTools : NSObject

+ (NSMutableURLRequest *)requestGETWithUrlString:(NSString *)urlStr;

+ (AFHTTPRequestSerializer *)sharedHTTPRequestSerializer;

+ (AFHTTPSessionManager *)sharedHTTPSessionManager;

+ (void)startReachabilityMonitoringWithDefaultBlock;

@end
