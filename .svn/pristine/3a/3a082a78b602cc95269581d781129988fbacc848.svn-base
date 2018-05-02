//
//  MBProgressHUD+YZExpand.h
//  JBHProject
//
//  Created by zyz on 2017/5/11.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (YZExpand)

/**
 *  自定义图片的提示，3s后自动消失
 *
 *  @param iconName 要显示的文字
 *  @param title 图片地址(建议不要太大的图片)
 *  @param view 要添加的view
 */
+ (void)showCustomIcon:(NSString *)iconName Title:(NSString *)title ToView:(UIView *)view;

/**
 *  自动消失成功提示，带默认图
 *
 *  @param success 要显示的文字
 *  @param view    要添加的view
 */
+ (void)showSuccess:(NSString *)success ToView:(UIView *)view;


/**
 *  自动消失错误提示,带默认图
 *
 *  @param error 要显示的错误文字
 *  @param view  要添加的View
 */
+ (void)showError:(NSString *)error ToView:(UIView *)view;


/**
 *  自动消失提示,带默认图
 *
 *  @param Info 要显示的文字
 *  @param view  要添加的View
 */
+ (void)showInfo:(NSString *)Info ToView:(UIView *)view;


/**
 *  自动消失提示,带默认图
 *
 *  @param warn 要显示的文字
 *  @param view  要添加的View
 */
+ (void)showWarn:(NSString *)warn ToView:(UIView *)view;



/**
 *  快速显示一条提示信息
 *
 *  @param message 要显示的文字
 */
+ (void)showAutoMessage:(NSString *)message;


/**
 *  自定义停留时间，有图(菊花)
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 *  @param time    停留时间
 */
+ (void)showIconMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time;


/**
 *  显示文本信息，无图
 *
 *  @param message 要显示的文字
 *  @param view 要添加的View
 *  @param time 停留时间
 */
+ (void)showMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time;


/**
 从视图上得到HUD
 
 @param view 要添加的view
 @return 返回HUD
 */
+ (MBProgressHUD *)getMBProgressHUDWithView:(UIView *)view;

/**
 *  文字+菊花提示,不自动消失
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 *
 */
+ (void)showMessage:(NSString *)message ToView:(UIView *)view;


/**
 *  自定义动画
 *
 *  @param message  显示的文字
 *  @param model    样式
 *  @param view     加载在view上
 *
 *  @return 返回动画
 */
+ (MBProgressHUD *)showMessage:(NSString *)message model:(MBProgressHUDMode)model ToView:(UIView *)view;

/**
 *  隐藏ProgressView
 *
 *  @param view superView
 */
+ (void)hideHUDForView:(UIView *)view;


/**
 *  延迟隐藏ProgressView
 */
+ (void)hideHUD:(MBProgressHUD *)hud afterDelay:(CGFloat)time;





@end
