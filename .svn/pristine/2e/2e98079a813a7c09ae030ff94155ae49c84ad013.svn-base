//
//  HomeHeaderView.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeHeaderModel.h"
@protocol HomeHeaderViewDelegate <NSObject>
/**
 *  @Description item跳转到钱包界面
 *  @sender 点击的立即抢单按钮
 */
- (void)didSelectedpushMoneyView:(UIButton *)sender;
/**
 * 跳转到已完成拍单界面
 */
- (void)didSelectedpushCompletedTaskView:(UIButton *)sender;
@end

@interface HomeHeaderView : UIView
@property(nonatomic,strong)HomeHeaderModel * model;
@property(nonatomic,weak)id<HomeHeaderViewDelegate> homeHeaderViewDelegate;
@end
