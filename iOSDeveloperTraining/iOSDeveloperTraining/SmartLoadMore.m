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
}

@property (nonatomic, copy) void (^loadBlock)(void);
@property (nonatomic, weak) UITableView * tableView;

@end

@implementation SmartLoadMore

static void * SmartLoadMoreFootViewContext;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    if (!noMoreData) {
        [self.tableView reloadData];
        _isLoadling = NO;
    }
}

- (void)startLoad {
    if (_isLoadling) {
        NSLog(@"already loading");
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
            if (tableViewHeight + tableViewHeight + contentOffsetY >= contentHeight) {
                @synchronized(self) {
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
