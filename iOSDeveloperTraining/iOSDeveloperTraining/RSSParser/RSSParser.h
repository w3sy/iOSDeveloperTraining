//
//  RSSParser.h
//  RSSParser
//
//  Created by Thibaut LE LEVIER on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSItem.h"

/**
 *  RSS解析器
 */
@interface RSSParser : NSObject <NSXMLParserDelegate> {
    RSSItem *currentItem;
    NSMutableArray *items;
    NSMutableString *tmpString;
    NSDictionary *tmpAttrDict;
    void (^block)(NSArray *feedItems);
    void (^failblock)(NSError *error);
}


/**
 *  +解析RSS文档
 *
 *  @param urlRequest RSS地址请求
 *  @param success    解析成功后交付RSSItem的数组
 *  @param failure    失败后交付失败信息
 */
+ (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  －解析RSS文档
 *
 *  @param urlRequest RSS地址请求
 *  @param success    解析成功后交付RSSItem的数组
 *  @param failure    失败后交付失败信息
 */
- (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure;


@end
