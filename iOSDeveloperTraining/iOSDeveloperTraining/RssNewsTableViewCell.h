//
//  RssNewsTableViewCell.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/20.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义资讯Cell
 */
@interface RssNewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsDescription;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pubDateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidthLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLeadingLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
