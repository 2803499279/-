//
//  UIView+YZExtension.m
//  JBHProject
//
//  Created by zyz on 2017/5/31.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "UIView+YZExtension.h"

@implementation UIView (YZExtension)


/**
 *  输出所有子控件
 */
+ (UIView *)ff_foundViewInView:(UIView *)view clazzName:(NSString *)clazzName {
    // 递归出口
    if ([view isKindOfClass:NSClassFromString(clazzName)]) {
        return view;
    }
    // 遍历所有子视图
    for (UIView *subView in view.subviews) {
        UIView *foundView = [self ff_foundViewInView:subView clazzName:clazzName];
        if (foundView) {
            return foundView;
        }
    }
    return nil;
}

@end
