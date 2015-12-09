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

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray * rssUrls;
@property (nonatomic) NSMutableArray * news;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rssUrls = [NSMutableArray array];
    [self.rssUrls addObject:@"http://www.cocoachina.com/bbs/rss.php"];
    self.news = [NSMutableArray array];
    
    NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.rssUrls[0]]];
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
        [self.news addObjectsFromArray:feedItems];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    RSSItem * item = self.news[indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.itemDescription;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RSSItem * item = self.news[indexPath.row];
    
    InsideWebViewController * ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"InsideWebVC"];
    [ivc loadWithUrlString:item.link.absoluteString];
    
    [self.navigationController pushViewController:ivc animated:YES];
}

@end
