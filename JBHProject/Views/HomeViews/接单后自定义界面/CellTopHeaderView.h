//
//  CellTopHeaderView.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/13.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CellTopHeaderViewDelegate <NSObject>
/**
 *  @Description 拖动视图
 *  
 */
- (void)CellTopHeaderViewButton:(UIButton *)sender;
/**
 *  @Description 申请退单
 *
 */
- (void)CellTopHeaderViewRefundBtn:(UIButton *)sender;
@end

@interface CellTopHeaderView : UIView
@property(nonatomic,weak)id <CellTopHeaderViewDelegate>   cellTopHeaderViewDelegate;
@property(nonatomic,copy)NSString * typeName;
@property(nonatomic,copy)NSString * userTimeStr;
@property(nonatomic,strong)UIButton * scrollerButton;// 上下滑动的button
@property(nonatomic,strong)UIButton * refundBtn;// 申请退单
@end
