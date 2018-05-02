//
//  HomeTopTableViewCell.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/13.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZOrderModel.h"
@class HomeTopTableViewCell;
@protocol HomeTopTableViewCellDelegate <NSObject>
/**
 *  @Description 打电话
 *
 */
- (void)callUserPhoneButton:(HomeTopTableViewCell *)cell;
- (void)senderMessageUserPhoneButton:(HomeTopTableViewCell *)cell;

@end
@interface HomeTopTableViewCell : UITableViewCell
@property(nonatomic,strong)YZOrderModel * model;
+ (CGFloat)topCellHeight;
@property(nonatomic,weak)id<HomeTopTableViewCellDelegate>delegate;
@end
