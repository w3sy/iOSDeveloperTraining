//
//  WeChatShareActivity.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 16/2/17.
//  Copyright © 2016年 wangbo. All rights reserved.
//

#import "WeChatShareActivity.h"
#import "WXApi.h"
#import "RSSItem.h"
#import "UIImageView+AFNetworking.h"

@interface WeChatShareActivity ()

@property (nonatomic) NSArray * activityItems;
@property (nonatomic) RSSItem * item;

@end

@implementation WeChatShareActivity

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (nullable NSString *)activityType {
    return @"WeChatShareActivity";
}

- (nullable NSString *)activityTitle {
    
    NSArray * titles = @[@"微信分享", @"微信朋友圈", @"微信收藏"];
    return NSLocalizedStringFromTable(titles[_scene], @"Localization", titles[_scene]);
}

- (nullable UIImage *)activityImage {
    
    NSArray * imageNames = @[@"icon64_appwx_logo", @"icon_res_download_moments", @"icon_res_download_collect"];
    return [UIImage imageNamed:imageNames[_scene]];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id obj in activityItems) {
        if ([obj isKindOfClass:[NSURL class]] || [obj isKindOfClass:[NSString class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.activityItems = activityItems;
    for (id obj in self.activityItems) {
        if ([obj isKindOfClass:[RSSItem class]]) {
            self.item = obj;
        }
    }
}

- (nullable UIViewController *)activityViewController {
    return nil;
}

- (void)performActivity {
    
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
    req.scene = self.scene;
    
    if (self.item) {
        req.bText = NO;
        WXWebpageObject * web = [WXWebpageObject object];
        web.webpageUrl = self.item.link.absoluteString;
        WXMediaMessage * msg = [WXMediaMessage message];
        msg.mediaObject = web;
        msg.title = self.item.title;
        UIImage * img = [[UIImageView sharedImageCache] cachedImageForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.item.imageUrlString]]];
        [msg setThumbImage:img];
        req.message = msg;
        [WXApi sendReq:req];
        return;
    }
    for (id obj in self.activityItems) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString * str = obj;
            req.bText = YES;
            req.text = str;
            [WXApi sendReq:req];
            return;
        }
    }
    
}

@end
