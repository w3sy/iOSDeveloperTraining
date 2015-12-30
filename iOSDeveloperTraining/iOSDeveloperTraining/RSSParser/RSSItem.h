//
//  RSSItem.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/29.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Rss新闻model
 */
@interface RSSItem : NSObject <NSCoding>

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *itemDescription;
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSURL *link;
@property (strong,nonatomic) NSURL *commentsLink;
@property (strong,nonatomic) NSURL *commentsFeed;
@property (strong,nonatomic) NSNumber *commentsCount;
@property (strong,nonatomic) NSDate *pubDate;
@property (strong,nonatomic) NSString *author;
@property (strong,nonatomic) NSString *guid;

@property (strong,nonatomic) NSAttributedString * attrDescription;

-(NSArray *)imagesFromItemDescription;
-(NSArray *)imagesFromContent;

@property (nonatomic) NSString * simpleDescription;
@property (nonatomic) NSString * imageUrlString;

@end
