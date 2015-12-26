//
//  NetworkTools.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/29.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "NetworkTools.h"
#import "BlueAlertView.h"

@implementation NetworkTools

+ (NSMutableURLRequest *)requestGETWithUrlString:(NSString *)urlStr {
    return [[NetworkTools sharedHTTPRequestSerializer] requestWithMethod:@"GET" URLString:urlStr parameters:nil error:nil];
}

+ (AFHTTPRequestSerializer *)sharedHTTPRequestSerializer {
    static AFHTTPRequestSerializer *serializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serializer = [AFHTTPRequestSerializer serializer];
    });
    return serializer;
}

+ (AFHTTPSessionManager *)sharedHTTPSessionManager {
    static AFHTTPSessionManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [NetworkTools sharedHTTPRequestSerializer];
    });
    return manager;
}

+ (void)startReachabilityMonitoringWithDefaultBlock {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [NetworkTools sharedHTTPRequestSerializer].cachePolicy = NSURLRequestReturnCacheDataDontLoad;
                [BlueAlertView showAlertViewWithMessage:@"当前无网络" onView:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [NetworkTools sharedHTTPRequestSerializer].cachePolicy = NSURLRequestUseProtocolCachePolicy;
                [BlueAlertView showAlertViewWithMessage:@"正在使用WiFi网络" onView:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [BlueAlertView showAlertViewWithMessage:@"正在蜂窝数据网络" onView:nil];
            case AFNetworkReachabilityStatusUnknown:
            default:
                [NetworkTools sharedHTTPRequestSerializer].cachePolicy = NSURLRequestReturnCacheDataElseLoad;
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
