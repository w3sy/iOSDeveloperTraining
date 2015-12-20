//
//  ResourcesTableViewCell.h
//  iOSDeveloperTraining
//
//  Created by 王博 on 15/12/20.
//  Copyright © 2015年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourcesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *excerptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end
