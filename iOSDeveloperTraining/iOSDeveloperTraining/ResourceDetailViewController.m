//
//  ResourceDetailViewController.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/20.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "ResourceDetailViewController.h"
#import "InsideWebViewController.h"

@interface ResourceDetailViewController () <UIWebViewDelegate>
{
    UIStatusBarStyle _currentStatusBarStyle;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewOffsetConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@end

@implementation ResourceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentStatusBarStyle = UIStatusBarStyleDefault;
    
    NSString * content = self.resourceDetailDict[@"content"];
    [self.webView loadHTMLString:content baseURL:nil];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    [self.webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    self.titleLabel.text = self.resourceDetailDict[@"title"];
    self.authorLabel.text = self.resourceDetailDict[@"author"][@"name"];
    self.dateLabel.text = self.resourceDetailDict[@"date"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _currentStatusBarStyle;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint old = [change[@"old"] CGPointValue];
        CGPoint new = [change[@"new"] CGPointValue];
        self.titleViewOffsetConstraint.constant = -new.y - 244;
        self.titleView.alpha = -new.y/264;
        if (old.y < new.y) {
            if (new.y > -64) {
                self.titleBgView.hidden = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    self.titleBgView.alpha = 1.0;
                    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                }];
                _currentStatusBarStyle = UIStatusBarStyleLightContent;
                [self setNeedsStatusBarAppearanceUpdate];
                self.title = self.resourceDetailDict[@"title"];
            }
        } else {
            if (new.y < -64) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.titleBgView.alpha = 0.0;
                    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:128/255.0 blue:0 alpha:1];
                } completion:^(BOOL finished) {
                    self.titleBgView.hidden = YES;
                }];
                _currentStatusBarStyle = UIStatusBarStyleDefault;
                [self setNeedsStatusBarAppearanceUpdate];
                self.title = nil;
            }
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        return YES;
    }
    
    InsideWebViewController * ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"InsideWebVC"];
    [ivc loadWithUrlString:request.URL.absoluteString];
    
    [self.navigationController pushViewController:ivc animated:YES];
    
    return NO;
}

@end
