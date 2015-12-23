//
//  NetworkTools.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/29.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 *  网络工具类
 */
@interface NetworkTools : NSObject

/**
 *  使用共享的网络请求管理器，创建一个可变请求
 *
 *  @param urlStr 请求的地址字符串
 *
 *  @return 返回一个可变请求
 */
+ (NSMutableURLRequest *)requestGETWithUrlString:(NSString *)urlStr;

/**
 *  获得一个网络请求生成器
 *
 *  @return 返回一个单例AFHTTPRequestSerializer对象
 */
+ (AFHTTPRequestSerializer *)sharedHTTPRequestSerializer;

/**
 *  获得一个网络请求管理器
 *
 *  @return 返回一个单例AFHTTPSessionManager对象
 */
+ (AFHTTPSessionManager *)sharedHTTPSessionManager;

/**
 *  开始网络状态监测（使用默认行为，DefaultBlock详见.m）
 */
+ (void)startReachabilityMonitoringWithDefaultBlock;

@end
