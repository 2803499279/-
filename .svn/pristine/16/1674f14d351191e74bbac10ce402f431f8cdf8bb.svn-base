//
//  BaseViewController.h
//  TTY
//
//  Created by 李俊恒 on 16/4/2.
//  Copyright © 2016年 sinze. All rights reserved.
//
/**
 *  @ClassName 一级界面的父类控制器，用来设置导航栏的属性面板
 *  @Description 一个一级界面的父类视图控制器
 *  @Version  V:1.0
 *  @author 李俊恒
 *  @Date 16/8/19
 */
#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic,strong)UIImageView * navBarLineView;
@property (nonatomic,assign)BOOL isHiddenLineView;
@property (nonatomic,strong)UIButton * rightBtn;
@property(nonatomic,copy)NSString * naviTitle;
-(void)hiddenLeftButton;
-(void)hiddenBootomLineView;
-(void)navLeftItemAction;
-(void)goBack;
- (void)navRightButtonClicked;
/**
 *  添加客服电话按钮
 */
- (void)addServiceRightButton;
/**
 *
 * 添加导航栏左侧按钮
 */
- (void)addLeftNavigationBarTitleWith:(NSString *)leftBtnImage;
/**
 *  定制一级界面的导航栏属性
 *
 *  @param title      标题
 *  @param imageNamed 背景图片
 */
- (void)customNavigationBarTitle:(NSString *)title backGroundImageName:(NSString *)imageNamed;
/**
 *  定制从一级界面Push出的二级界面
 *
 *  @param title      导航栏标题
 *  @param imageNamed 背景图片
 */
- (void)customPushViewControllerNavBarTitle:(NSString *)title backGroundImageName:(NSString *)imageNamed;
/**
 *  去除navigationBar下面的横线
 */
- (void)removeNavigationBarLine ;
@end
