//
//  JHMapLocationView.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/18.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JHMapLocationViewDelegate <NSObject>
/**
 *  @Description 定位到当前位置
 *  @sender 定位按钮
 */
- (void)showCurrentLocation:(UIButton *)sender;
/**
 *  @Description 步行导航
 *  @sender 步行导航按钮
 */
- (void)WalkRoutePlanLine:(UIButton *)sender;
/**
 *  @Description 骑行导航
 *  @sender 骑行导航
 */
- (void)RideRoutePlanLine:(UIButton *)sender;
/**
 *  @Description 开车导航
 *  @sender 开车导航
 */
- (void)DriveRoutePlanLine:(UIButton *)sender;


@end

@interface JHMapLocationView : UIView
@property(nonatomic,weak)id<JHMapLocationViewDelegate> delegate;

@end
