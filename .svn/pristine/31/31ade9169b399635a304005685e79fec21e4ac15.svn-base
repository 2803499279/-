//
//  MTWSimpleAlertView.h
//  BekCampsiteManager
//
//  Created by 马腾威 on 2017/3/28.
//  Copyright © 2017年 Shandong Big Amperex Tech. Co., Ltd. All rights reserved.
//

// 屏幕参数
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE   [UIScreen mainScreen].bounds.size
#define SCREEN_RECT   [UIScreen mainScreen].bounds
#define X_BORDER 10
#define Y_BORDER 10
#define fontSize_title 16
#define fontSize_message 13
#define MTWcolor [UIColor colorWithRed:255/255.0 green:136/255.0 blue:27/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#import <UIKit/UIKit.h>

@class MTWSimpleAlertView;
@protocol MTWSimpleAlertViewDelegate <NSObject>

@optional

- (void)actionButtonBeenClickedFromView:(MTWSimpleAlertView *)simpleAlertView;

@end

@interface MTWSimpleAlertView : UIView
@property(nonatomic,strong)UIView * shadowView;
@property (nonatomic ,weak) id<MTWSimpleAlertViewDelegate>delegate;

- (void)configAletViewWithImage:(UIImage*)image Title:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelStr actionButtonTitle:(NSString *)actionStr blurStyle:(UIBlurEffectStyle)blurStyle;

- (void)showAlert;
@end
