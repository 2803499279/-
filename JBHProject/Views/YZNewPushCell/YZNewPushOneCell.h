//
//  YZNewPushOneCell.h
//  JBHProject
//
//  Created by zyz on 2017/5/15.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZNewPushOneCell : UITableViewCell

@property (nonatomic, strong) UIView *OneView;

@property (nonatomic, strong) UILabel *Title;

@property (nonatomic, strong) UILabel *Time;

@property (nonatomic, strong) UILabel *Content;

// 定义一个接口给 cell 上的子控件赋值
- (void)setValueForSubViewsByYZPush:(YZPushModel *)PushModel;
// 返回cell高度的接口
+ (CGFloat)PushCellHeightByYZPushIntroduce:(YZPushModel *)sender;


@end
