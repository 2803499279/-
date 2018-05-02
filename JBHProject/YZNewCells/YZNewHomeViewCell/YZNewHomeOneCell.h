//
//  YZNewHomeOneCell.h
//  JBHProject
//
//  Created by zyz on 2018/1/9.
//  Copyright © 2018年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZNewHomeModel;

@interface YZNewHomeOneCell : UITableViewCell

@property (nonatomic, strong) MyLabel *Title;

@property (nonatomic, strong) UIImageView *ProductImage;

@property (nonatomic, strong) UILabel *Date;

@property (nonatomic, strong) UIView *BView;

// 定义一个接口给 cell 上的子控件赋值
- (void)setValueForSubViewsByAction:(YZNewHomeModel *)homeOneModel;

@end
