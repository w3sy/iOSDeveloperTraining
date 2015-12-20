//
//  NewsViewController.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/9.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "NewsViewController.h"
#import "RSSParser.h"
#import "InsideWebViewController.h"
#import "RssNewsTableViewCell.h"
#import "NetworkTools.h"
#import "SmartLoadMore.h"

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _errorReloadCount;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray * news;
@property (nonatomic) SmartLoadMore * loadMore;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.news = [NSMutableArray array];
    
    self.loadMore = [SmartLoadMore loadMoreForTableView:self.tableView loadWith:^{
        [self loadNewsWithOffset:self.news.count];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)loadNewsWithOffset:(NSInteger)offset {
    
    NSDictionary * paras = @{@"word":@"iOS开发", @"tn":@"newsrss", @"sr":@0, @"cl":@2, @"rn":@20, @"ct":@0, @"pn":@(offset)};
    NSURLRequest * req = [[NetworkTools sharedHTTPRequestSerializer] requestWithMethod:@"GET" URLString:@"http://news.baidu.com/ns" parameters:paras error:nil];
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
        if (!offset) {
            [self.news removeAllObjects];
        }
        [self.news addObjectsFromArray:feedItems];
        BOOL noMoreData = feedItems.count == 0 ? YES:NO;
        [self.loadMore finishLoadAndNoMoreData:noMoreData];
        _errorReloadCount = 0;
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
//        if (error.code == 6003 && _errorReloadCount++ <= 20) {
//            [self loadNewsWithOffset:self.news.count+_errorReloadCount];
//        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RssNewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RssNews" forIndexPath:indexPath];
    
    RSSItem * item = self.news[indexPath.row];
    
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.titleLabel.text = item.title;
    NSData * data = [item.itemDescription dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString * attrStr = nil;
    @try {
         attrStr = [[NSAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    cell.newsDescription.attributedText = attrStr;
    cell.sourceLabel.text = item.author;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RSSItem * item = self.news[indexPath.row];
    
    InsideWebViewController * ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"InsideWebVC"];
    [ivc loadWithUrlString:item.link.absoluteString];
    
    [self.navigationController pushViewController:ivc animated:YES];
}

@end
