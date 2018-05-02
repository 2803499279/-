//
//  MBProgressHUD+YZExpand.m
//  JBHProject
//
//  Created by zyz on 2017/5/11.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "MBProgressHUD+YZExpand.h"

@implementation MBProgressHUD (YZExpand)


#pragma mark 显示错误信息
+ (void)showError:(NSString *)error ToView:(UIView *)view{
    [self showCustomIcon:@"MBHUD_Error" Title:error ToView:view];
}

+ (void)showSuccess:(NSString *)success ToView:(UIView *)view
{
    [self showCustomIcon:@"MBHUD_Success" Title:success ToView:view];
}

+ (void)showInfo:(NSString *)Info ToView:(UIView *)view
{
    [self showCustomIcon:@"MBHUD_Info" Title:Info ToView:view];
}

+ (void)showWarn:(NSString *)Warn ToView:(UIView *)view
{
    [self showCustomIcon:@"MBHUD_Warn" Title:Warn ToView:view];
}

+ (void)showCustomIcon:(NSString *)iconName Title:(NSString *)title ToView:(UIView *)view
{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = title;
    hud.label.font = CHINESE_SYSTEM(18);
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 代表需要蒙版效果
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    // 3秒之后再消失
    [hud hideAnimated:YES afterDelay:3];
}


+ (MBProgressHUD *)getMBProgressHUDWithView:(UIView *)view {
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    return [MBProgressHUD HUDForView:view];
}

// 文字+菊花提示,不自动消失
+ (void)showMessage:(NSString *)message ToView:(UIView *)view {
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
    hud.label.font = CHINESE_SYSTEM(18);
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    //代表需要蒙版效果
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    
    //    return [self showMessage:message model:MBProgressHUDModeIndeterminate ToView:view];
    
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message model:(MBProgressHUDMode)model ToView:(UIView *)view {
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = model;
    hud.minSize = CGSizeMake(50.f, 50.f);
    hud.label.text = message;
    hud.label.font = CHINESE_SYSTEM(18);
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    //代表需要蒙版效果
    //    hud.dimBackground = YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    
    return hud;
}



/**
 *  进度条View
 */
+ (MBProgressHUD *)showProgressToView:(UIView *)view Text:(NSString *)text{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = text;
    hud.label.font = CHINESE_SYSTEM(18);
    // 代表需要蒙版效果
    //    hud.dimBackground = YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    
    return hud;
}

//自定义停留时间，有图(菊花)
+ (void)showIconMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time{
    [self showMessage:message ToView:view RemainTime:time Model:MBProgressHUDModeIndeterminate];
}


//快速显示一条提示信息
+ (void)showAutoMessage:(NSString *)message{
    
    [self showMessage:message ToView:nil RemainTime:1 Model:MBProgressHUDModeText];
}

//显示底部文本信息，无图
+ (void)showMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time{
    [self showMessage:message ToView:view RemainTime:time Model:MBProgressHUDModeText];
}

+ (void)showMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time Model:(MBProgressHUDMode)model{
    
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [self getMBProgressHUDWithView:nil] ? [self getMBProgressHUDWithView:nil] : [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = CHINESE_SYSTEM(18);
    
    //模式
    hud.mode = model;
    //    hud.square = YES;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 代表需要蒙版效果
    //    hud.dimBackground = YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4f];
//    [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.4f];
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
//    hud.bezelView.backgroundColor = [UIColor redColor];
//    hud.label.backgroundColor = [UIColor redColor];
//    hud.label.textColor = WhiteColor;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // X秒之后再消失
    [hud hideAnimated:YES afterDelay:time];
}

+ (void)hideHUD:(MBProgressHUD *)hud afterDelay:(CGFloat)time {
    
    [hud hideAnimated:YES afterDelay:time];
}


+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].delegate.window;
    
    [self hideHUDForView:view animated:YES];
}






@end
