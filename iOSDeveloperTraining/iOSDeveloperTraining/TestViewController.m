//
//  TestViewController.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/11/27.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "TestViewController.h"
#import "InsideWebViewController.h"
#import "RefreshControlTool.h"
#import "NetworkTools.h"

@interface TestViewController () <UIScrollViewDelegate>
{
    AFHTTPSessionManager * _manager;
}

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) CBStoreHouseRefreshControl *refreshControl;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.delegate = self;
    self.refreshControl = [RefreshControlTool attachToScrollView:self.scrollView target:self refreshAction:@selector(refresh:)];
    
//    _manager = [NetworkTools sharedHTTPSessionManager];
//    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"application/javascript", nil];
//    [_manager POST:@"http://wangb.local/test/wp-admin/admin-ajax.php" parameters:@{@"log":@"w3sy", @"pwd":@"123", @"lwa":@"1", @"login-with-ajax":@"login"} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
}

- (void)refresh:(id)sender {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl finishingLoading];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshControl scrollViewDidEndDragging];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    InsideWebViewController * ivc = [segue destinationViewController];
    [ivc loadWithUrlString:self.urlTextField.text];
}

@end
