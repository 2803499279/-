//
//  YZHomePageThereViewCell.h
//  JBHProject
//
//  Created by zyz on 2017/8/22.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZHomePageTwoModel;

@interface YZHomePageThereViewCell : UITableViewCell


@property (nonatomic, strong) UIView *BackView;
@property (nonatomic, strong) UIImageView *ContentImage;

@property (nonatomic, strong) UILabel *Title;
@property (nonatomic, strong) UILabel *promet;
@property (nonatomic, strong) UILabel *reads;
@property (nonatomic, strong) UILabel *start;

// 定义一个接口给 cell 上的子控件赋值
- (void)setValueForSubViewsByAction:(YZHomePageTwoModel *)YZHomePageTwoModel;


@end
