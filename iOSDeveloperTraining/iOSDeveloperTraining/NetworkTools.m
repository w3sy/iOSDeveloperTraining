//
//  NetworkTools.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/29.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "NetworkTools.h"

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
                NSLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [NetworkTools sharedHTTPRequestSerializer].cachePolicy = NSURLRequestUseProtocolCachePolicy;
                NSLog(@"WiFi");
                break;
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusReachableViaWWAN:
            default:
                [NetworkTools sharedHTTPRequestSerializer].cachePolicy = NSURLRequestReturnCacheDataElseLoad;
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
