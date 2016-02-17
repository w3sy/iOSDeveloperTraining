//
//  ResourcesViewController.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/20.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "ResourcesViewController.h"
#include "NetworkTools.h"
#import "ResourcesTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ResourceDetailViewController.h"

@interface ResourcesViewController ()
{
    AFHTTPSessionManager * _manager;
    NSMutableArray * _dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ResourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    _manager = [NetworkTools sharedHTTPSessionManager];
    
    [self loadDataWithPage:1];
}

- (void)loadDataWithPage:(NSInteger)page {
    [_manager GET:@"http://swkits.com/develop/wp-json/posts" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [_dataArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        // 当没有网络时
        if (error.code == -1009) {
            [NetworkTools sharedHTTPRequestSerializer].cachePolicy = NSURLRequestReturnCacheDataDontLoad;
            [self loadDataWithPage:page];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowResourceDetail"]) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary * dic = _dataArray[indexPath.row];
        ResourceDetailViewController * dvc = [segue destinationViewController];
        dvc.resourceDetailDict = dic;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResourcesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ResourceCell" forIndexPath:indexPath];
    
    NSDictionary * dic = _dataArray[indexPath.row];
    cell.titleLabel.text = dic[@"title"];
    
    NSData * excerptData = [dic[@"excerpt"] dataUsingEncoding:NSUnicodeStringEncoding];
    @try {
        cell.excerptLabel.attributedText = [[NSAttributedString alloc] initWithData:excerptData options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    }
    @catch (NSException *exception) {
        cell.excerptLabel.attributedText = nil;
    }
    
    @try {
        NSString * avatarStr = dic[@"author"][@"avatar"];
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:avatarStr] placeholderImage:[UIImage new]];
    }
    @catch (NSException *exception) {
        cell.avatarImageView.image = nil;
    }
    
    @try {
        NSString * name = dic[@"author"][@"name"];
        cell.authorLabel.text = name;
    }
    @catch (NSException *exception) {
        cell.authorLabel.text = nil;
    }
    cell.dateLabel.text = dic[@"date"];
    
    return cell;
}

@end
