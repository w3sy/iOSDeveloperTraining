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
#import "RefreshControlTool.h"

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray * news;
@property (nonatomic) SmartLoadMore * loadMore;
@property (nonatomic) CBStoreHouseRefreshControl *refreshControl;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.news = [NSMutableArray array];
    
    self.loadMore = [SmartLoadMore loadMoreForTableView:self.tableView loadWith:^{
        [self loadNewsWithOffset:self.news.count];
    }];
    
    self.refreshControl = [RefreshControlTool attachToScrollView:self.tableView target:self refreshAction:@selector(refreshAction:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)loadNewsWithOffset:(NSInteger)offset {
    
    NSDictionary * paras = @{@"word":@"iOS", @"tn":@"newsrss", @"sr":@0, @"cl":@2, @"rn":@20, @"ct":@0, @"pn":@(offset)};
    NSMutableURLRequest * req = [[NetworkTools sharedHTTPRequestSerializer] requestWithMethod:@"GET" URLString:@"http://news.baidu.com/ns" parameters:paras error:nil];
    if (!offset) {
        req.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    }
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
        if (!offset) {
            [self.news removeAllObjects];
        }
        [self.news addObjectsFromArray:feedItems];
        BOOL noMoreData = feedItems.count == 0 ? YES:NO;
        [self.loadMore finishLoadAndNoMoreData:noMoreData];
        [self.refreshControl finishingLoading];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)refreshAction:(id)sender {
    [self loadNewsWithOffset:0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshControl scrollViewDidEndDragging];
}

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
    [cell.numberLabel needsUpdateConstraints];
    cell.titleLabel.text = item.title;
    cell.newsDescription.attributedText = item.attrDescription;
    cell.sourceLabel.text = item.author;
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    cell.pubDateLabel.text = [df stringFromDate:item.pubDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RSSItem * item = self.news[indexPath.row];
    
    InsideWebViewController * ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"InsideWebVC"];
    [ivc loadWithUrlString:item.link.absoluteString];
    
    [self.navigationController pushViewController:ivc animated:YES];
}

@end
