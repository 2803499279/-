//
//  MTWSimpleAlertView.m
//  BekCampsiteManager
//
//  Created by 马腾威 on 2017/3/28.
//  Copyright © 2017年 Shandong Big Amperex Tech. Co., Ltd. All rights reserved.
//

#import "MTWSimpleAlertView.h"
#import <UIKit/UIKit.h>
@interface MTWSimpleAlertView (){
    UILabel *_titleLabel;
    UILabel *_messageLabel;
    UIImageView *_imageView;
}
@end
@implementation MTWSimpleAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if (self = [super init]) {
        self.frame = SCREEN_RECT;
    }
    return self;
}
- (UIView *)shadowView
{
    if (_shadowView == nil) {
        _shadowView = [[UIView alloc] initWithFrame:SCREEN_RECT];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.5;

    }
    return _shadowView;
}
- (void)configAletViewWithImage:(UIImage*)image Title:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelStr actionButtonTitle:(NSString *)actionStr blurStyle:(UIBlurEffectStyle)blurStyle{
    if (blurStyle) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:blurStyle];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = SCREEN_RECT;
        [self addSubview:visualEffectView];
    }else{
               [self addSubview:self.shadowView];
    }
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(50*Size_ratio, 200*Size_ratio, SCREEN_WIDTH - 100*Size_ratio, 140*Size_ratio)];
    alertView.alpha = 1.0;
    alertView.backgroundColor = [UIColor whiteColor];
//    alertView.layer.cornerRadius = 10;
//    alertView.clipsToBounds = YES;
    [self addSubview:alertView];
    
    CGFloat width = alertView.frame.size.width;
    CGFloat height;
    
//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 - 30, Y_BORDER, 60, 60)];
    _imageView.backgroundColor = MTWcolor;
    _imageView.image = image;
    [alertView addSubview:_imageView];
    height = CGRectGetMaxY(_imageView.frame);
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_BORDER, height + Y_BORDER, width - 2*X_BORDER, [self heightOfConttent:title fontSize:fontSize_title])];
    _titleLabel.text = title;
    _titleLabel.font = [UIFont systemFontOfSize:fontSize_title];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:_titleLabel];
    height = CGRectGetMaxY(_titleLabel.frame);
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_BORDER, height + Y_BORDER, width - 2*X_BORDER, [self heightOfConttent:message fontSize:fontSize_message])];
    _messageLabel.text = message;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [UIFont systemFontOfSize:fontSize_message];
    _messageLabel.numberOfLines = 0;
    [alertView addSubview:_messageLabel];
    height = CGRectGetMaxY(_messageLabel.frame);
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(5*Size_ratio, height+Y_BORDER, width, 40*Size_ratio)];
    [cancelBtn setTitle:cancelStr forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor jhBackGroundColor]];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    cancelBtn.layer.cornerRadius = 10;
//    cancelBtn.clipsToBounds = YES;
    [alertView addSubview:cancelBtn];
    
    UIButton *actionBtn = [[UIButton alloc] init];
    [actionBtn setBackgroundColor:YZEssentialColor];
    [actionBtn setTitle:actionStr forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
//    actionBtn.layer.cornerRadius = 10;
//    actionBtn.clipsToBounds = YES;
    [alertView addSubview:actionBtn];
    if (actionStr.length > 0) {
        cancelBtn.frame = CGRectMake(6*Size_ratio, height + Y_BORDER+ 15*Size_ratio, width/2-10, 40);
        actionBtn.frame = CGRectMake(width/2-10+12, height + Y_BORDER+15*Size_ratio, width/2-10, 40);
    }
    height = CGRectGetMaxY(cancelBtn.frame) + 10*Size_ratio;
    alertView.frame = CGRectMake(50*Size_ratio, SCREEN_HEIGHT/2-height/2, SCREEN_WIDTH - 100*Size_ratio, height);
}
//计算文本高度
- (CGFloat)heightOfConttent:(NSString*)content fontSize:(CGFloat)fontSize
{
    if (content.length==0) {
        return 0.0;
    }
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    return [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}
//取消
-(void)cancel{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self removeFromSuperview];
        
    } completion:^(BOOL finished) {
        
    }];
}
//确认
-(void)sure{
    if (_delegate &&[_delegate respondsToSelector:@selector(actionButtonBeenClickedFromView:)]) {
        
        [_delegate actionButtonBeenClickedFromView:self];
        
    }
    [self cancel];
}
//警告框显示
-(void)showAlert{
    [UIView animateWithDuration:0.3 animations:^{
        
        UIWindow * window=[UIApplication sharedApplication].keyWindow;
        
        [window addSubview:self];
        
    } completion:^(BOOL finished) {
        
    }];

}
@end
