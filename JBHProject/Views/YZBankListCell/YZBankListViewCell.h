//
//  YZBankListViewCell.h
//  JBHProject
//
//  Created by zyz on 2017/5/6.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZBankListModel;

@interface YZBankListViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *backgroundImage; // 商品图像


@property (nonatomic, strong) UIView *bankGroImage;
@property (nonatomic, strong) UIImageView *bankImage;
@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UILabel *blockLabel;


@property (nonatomic, strong) UILabel *NumberLabel;
@property (nonatomic, strong) UILabel *TailNumberLabel;


// 定义一个接口给 cell 上的子控件赋值
- (void)setValueForSubViewsByAction:(YZBankListModel *)YZBankListModel;

@end
