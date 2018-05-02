//
//  YZAnimationManager.h
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZAnimationManager : NSObject

/**
 *  为某个视图添加动画
 */
+ (void)addTransformAnimationForView:(UIView *)view;

/**
 *  让某一个视图抖动
 *
 *  @param viewToShake 需要抖动的视图
 */
+ (void)shakeView:(UIView*)viewToShake;

@end
