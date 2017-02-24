//
//  SmartLoadMore.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/20.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "SmartLoadMore.h"

@interface SmartLoadMore ()
{
    BOOL _isLoadling;
    BOOL _noMoreData;
}

@property (nonatomic, copy) void (^loadBlock)(void);
@property (nonatomic, weak) UITableView * tableView;

@end

@implementation SmartLoadMore

static void * SmartLoadMoreFootViewContext;

+ (instancetype)loadMoreForTableView:(UITableView *)tableView loadWith:(void (^)())loadBlock {
    return [[self alloc] initForTableView:tableView loadWith:loadBlock];
}

- (instancetype)initForTableView:(UITableView *)tableView loadWith:(void (^)())loadBlock {
    if (self = [super init]) {
        self.loadBlock = loadBlock;
        [self setupTableView:tableView];
    }
    return self;
}

- (void)finishLoadAndNoMoreData:(BOOL)noMoreData {
    [self.tableView reloadData];
    _isLoadling = NO;
    _noMoreData = noMoreData;
}

- (void)startLoad {
    if (_isLoadling) {
        NSLog(@"Already loading");
        return;
    }
    _isLoadling = YES;
    if (self.loadBlock) {
        self.loadBlock();
    }
}

- (void)setupTableView:(UITableView *)tableView {
    self.tableView = tableView;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:&SmartLoadMoreFootViewContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == &SmartLoadMoreFootViewContext && !_isLoadling) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            CGFloat contentOffsetY = [change[@"new"] CGPointValue].y;
            CGFloat contentHeight = self.tableView.contentSize.height;
            CGFloat tableViewHeight = self.tableView.bounds.size.height;
            // tableview显示内容将尽时，加载更多
            if (tableViewHeight + tableViewHeight + contentOffsetY >= contentHeight) {
                @synchronized(self) {
                    if (_noMoreData) {
                        NSLog(@"No more data");
                        return;
                    }
                    [self startLoad];
                    NSLog(@"SmartLoadMore");
                }
            }
        }
    }
}

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentOffset" context:&SmartLoadMoreFootViewContext];
}

@end
