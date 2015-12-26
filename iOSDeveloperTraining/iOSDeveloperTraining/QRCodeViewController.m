//
//  QRCodeViewController.m
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/26.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import "QRCodeViewController.h"
#import "NSString+QRCodeImage.h"

@interface QRCodeViewController ()
{
    void(^_finishBlock)(void);
    CGFloat _originalBrightness;
}

@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
- (IBAction)backAction:(id)sender;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageLabel.text = self.message;
    self.qrcodeImageView.image = [self.message imageOfQRCodeWithSize:250];
}

- (void)viewDidAppear:(BOOL)animated {
    _originalBrightness = [UIScreen mainScreen].brightness;
    [UIScreen mainScreen].brightness = 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIScreen mainScreen].brightness = _originalBrightness;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFinishBlock:(void(^)(void))block {
    _finishBlock = block;
}

- (IBAction)backAction:(id)sender {
    if (_finishBlock) {
        _finishBlock();
    }
}

@end
