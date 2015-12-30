//
//  SearchBarButtonItem.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/30.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "SearchBarButtonItem.h"

@interface SearchBarButtonItem () <UISearchBarDelegate>
{
    UIView * _searchView;
    UIButton * _searchBtn;
    UISearchBar * _searchBar;
    void(^_searchActionBlock)(NSString * keyword);
    void(^_cancelActionBlock)(void);
}

@end

@implementation SearchBarButtonItem

- (instancetype)init {
    if (self = [super init]) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _searchView.clipsToBounds = YES;
        _searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _searchBtn.tintColor = [UIColor whiteColor];
        [_searchBtn setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateNormal];
        _searchBtn.frame = CGRectMake(0, 0, 40, 40);
        [_searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_searchView addSubview:_searchBtn];
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 0, [UIScreen mainScreen].bounds.size.width - 40, 40)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.barStyle = UIBarStyleBlack;
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.hidden = YES;
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.tintColor = [UIColor whiteColor];
        [_searchView addSubview:_searchBar];
        
        self.customView = _searchView;
    }
    return self;
}

- (void)searchBtnAction {
    _searchBtn.hidden = YES;
    [_searchBar becomeFirstResponder];
    _searchBar.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _searchView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    _searchBtn.hidden = NO;
    searchBar.hidden = YES;
    _searchView.frame = CGRectMake(0, 0, 40, 40);
    if (_cancelActionBlock) {
        _cancelActionBlock();
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if (_searchActionBlock) {
        _searchActionBlock(searchBar.text);
    }
}

- (void)setSearchActionBlock:(void(^)(NSString * keyword))block {
    _searchActionBlock = block;
}

- (void)setCancelActionBlock:(void(^)(void))block {
    _cancelActionBlock = block;
}

@end
