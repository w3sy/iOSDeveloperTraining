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
@property (nonatomic) WKWebView * webView;
@property (weak, nonatomic) IBOutlet UIView *webViewContainerView;
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgressView;
@property (weak, nonatomic) IBOutlet UILabel *webOriginLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardBarButtonItem;

- (IBAction)closeAction:(UIBarButtonItem *)sender;
- (IBAction)refreshAction:(UIBarButtonItem *)sender;
- (IBAction)backAction:(UIBarButtonItem *)sender;
- (IBAction)forwardAction:(UIBarButtonItem *)sender;

@end

@implementation InsideWebViewController

static BOOL webViewKVO;

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
    
    [self.webViewContainerView addSubview:self.webView];
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * widthConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.webViewContainerView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.webViewContainerView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint * xConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.webViewContainerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint * yConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.webViewContainerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.webViewContainerView addConstraints:@[widthConstraint, heightConstraint, xConstraint, yConstraint]];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:&webViewKVO];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:&webViewKVO];
    [self.webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:&webViewKVO];
    
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.webView loadRequest:req];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:&webViewKVO];
    [self.webView removeObserver:self forKeyPath:@"canGoBack" context:&webViewKVO];
    [self.webView removeObserver:self forKeyPath:@"canGoForward" context:&webViewKVO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == &webViewKVO) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
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
                NSString * baseUrlStr = self.webView.URL.absoluteString;
                baseUrlStr = [[baseUrlStr componentsSeparatedByString:@"://"] lastObject];
                baseUrlStr = [[baseUrlStr componentsSeparatedByString:@"/"] firstObject];
                if (baseUrlStr) {
                    self.webOriginLabel.text = [NSString stringWithFormat:@"本页由 %@ 提供", baseUrlStr];
                }
            }
        } else if ([keyPath isEqualToString:@"canGoBack"]) {
            self.backBarButtonItem.enabled = self.webView.canGoBack;
        } else if ([keyPath isEqualToString:@"canGoForward"]) {
            self.forwardBarButtonItem.enabled = self.webView.canGoForward;
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
