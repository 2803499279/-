//
//  CustomAleartView.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/14.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "CustomAleartView.h"
@interface CustomAleartView()
@property(nonatomic,strong)UIImageView * myAleartImageView;// 显示的图片
@property(nonatomic,strong)UILabel * messageLabel;// 提示信息的label
@property(nonatomic,strong)UIButton * sureBtn;// 确定按钮
@property(nonatomic,strong)UIView * backGroundView;// 背景view
@end
@implementation CustomAleartView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _myAleartImageView = [[UIImageView alloc]init];
        _messageLabel = [[UILabel alloc]init];
        _sureBtn = [[UIButton alloc]init];
        _backGroundView = [[UIView alloc]init];
        
        [_backGroundView addSubview:_myAleartImageView];
        [_backGroundView addSubview:_messageLabel];
        [_backGroundView addSubview:_sureBtn];
        
        [self addSubview:_backGroundView];
        
        [self setUI];
    }
    return self;
}
#pragma mark ----------Fucation
- (void)setUI
{

}

@end
