//
//  YZIdentityViewCell.h
//  JBHProject
//
//  Created by zyz on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZIdentityViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *divider; // 分割线

@property (nonatomic, strong) UIImageView *PromptImage; // 图片

@property (nonatomic, strong) UILabel *name; // 身份证姓名
@property (nonatomic, strong) UILabel *IdNumber; // 身份证号码
@property (nonatomic, strong) UILabel *CarNumber;  // 车牌号
@property (nonatomic, strong) UILabel *ChassisNumber; // 车架号



@end
