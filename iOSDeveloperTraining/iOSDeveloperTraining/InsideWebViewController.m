//
//  InsideWebViewController.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/27.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "InsideWebViewController.h"
#import "NetworkTools.h"
#import <WebKit/WebKit.h>

@interface InsideWebViewController ()

@property (nonatomic) NSString * urlStr;
@property (nonatomic) WKWebView * webView; //浏览器
@property (weak, nonatomic) IBOutlet UIView *webViewContainerView; //浏览器容器
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgressView; //加载进度条
@property (weak, nonatomic) IBOutlet UILabel *webOriginLabel; //页面地址指示条
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem; //后退工具按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardBarButtonItem; //前进工具按钮

- (IBAction)closeAction:(UIBarButtonItem *)sender;
- (IBAction)refreshAction:(UIBarButtonItem *)sender;
- (IBAction)backAction:(UIBarButtonItem *)sender;
- (IBAction)forwardAction:(UIBarButtonItem *)sender;

@end

@implementation InsideWebViewController

static BOOL webViewKVO;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 实例化浏览器对象
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
    
    [self.webViewContainerView addSubview:self.webView];
    
    // 为浏览器对象添加自动布局约束条件
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * widthConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.webViewContainerView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.webViewContainerView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint * xConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.webViewContainerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint * yConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.webViewContainerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.webViewContainerView addConstraints:@[widthConstraint, heightConstraint, xConstraint, yConstraint]];
    
    /**
     *  添加监听 
     * estimatedProgress 加载进度
     * canGoBack 后退有效
     * canGoForward 前进有效
     * contentOffset 内容偏移量
     */
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:&webViewKVO];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:&webViewKVO];
    [self.webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:&webViewKVO];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    // 创建加载请求
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.webView loadRequest:req];
}

- (void)viewWillAppear:(BOOL)animated {
    // 隐藏导航栏，显示工具栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 显示导航栏，隐藏工具栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    // 销毁前注销监听
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:&webViewKVO];
    [self.webView removeObserver:self forKeyPath:@"canGoBack" context:&webViewKVO];
    [self.webView removeObserver:self forKeyPath:@"canGoForward" context:&webViewKVO];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

/**
 *  使当前页状态栏为浅色内容
 *
 *  @return 返回状态栏样式值UIStatusBarStyleLightContent
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/**
 *  监听回调处理
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == &webViewKVO) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            // 设置加载进度及进度条的显示和隐藏
            self.loadProgressView.progress = (float)self.webView.estimatedProgress;
            if (self.loadProgressView.progress > 0 && self.loadProgressView.progress < 1) {
                self.loadProgressView.hidden = NO;
            }
            if (self.loadProgressView.progress == 1) {
                [UIView animateWithDuration:1.0 animations:^{
                    self.loadProgressView.alpha = 0;
                } completion:^(BOOL finished) {
                    self.loadProgressView.hidden = YES;
                    self.loadProgressView.alpha = 1;
                }];
            }
        } else if ([keyPath isEqualToString:@"canGoBack"]) {
            // 设置后退按钮是否有效
            self.backBarButtonItem.enabled = self.webView.canGoBack;
        } else if ([keyPath isEqualToString:@"canGoForward"]) {
            // 设置前进按钮是否有效
            self.forwardBarButtonItem.enabled = self.webView.canGoForward;
        }
    } else {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            // 在内容顶部下拉页面，显示页面所在域名地址，防止钓鱼页面
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= -40) {
                NSString * baseUrlStr = self.webView.URL.absoluteString;
                baseUrlStr = [[baseUrlStr componentsSeparatedByString:@"://"] lastObject];
                baseUrlStr = [[baseUrlStr componentsSeparatedByString:@"/"] firstObject];
                if (baseUrlStr) {
                    self.webOriginLabel.text = [NSString stringWithFormat:@"本页由 %@ 提供", baseUrlStr];
                }
                [UIView animateWithDuration:0.5 animations:^{
                    self.webOriginLabel.alpha = 1;
                }];
            } else if (new.y >= 0) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.webOriginLabel.alpha = 0;
                }];
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)loadWithUrlString:(NSString *)urlStr {
    self.urlStr = urlStr;
}

- (IBAction)closeAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)refreshAction:(UIBarButtonItem *)sender {
    [self.webView reloadFromOrigin];
}

- (IBAction)backAction:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (IBAction)forwardAction:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

@end
