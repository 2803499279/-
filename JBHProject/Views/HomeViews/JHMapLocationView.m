//
//  JHMapLocationView.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/18.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "JHMapLocationView.h"
@interface JHMapLocationView()
@property(nonatomic,strong)UIButton * currentLocationButton;// 当前位置
@property(nonatomic,strong)UIButton * walkRouteButton;//步行导航
@property(nonatomic,strong)UIButton * rideRouteButton;//骑行导航
@property(nonatomic,strong)UIButton * driveRouteButton;// 驾车导航

@end
@implementation JHMapLocationView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _currentLocationButton = [[UIButton alloc]init];
        _walkRouteButton = [[UIButton alloc]init];
        _rideRouteButton = [[UIButton alloc]init];
        _driveRouteButton = [[UIButton alloc]init];
        
        [self addSubview:_currentLocationButton];
        [self addSubview:_walkRouteButton];
        [self addSubview:_rideRouteButton];
        [self addSubview:_driveRouteButton];
        
        [self setUI];
        
        [self layoutIfNeeded];

    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_currentLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5*Size_ratio);
        make.left.equalTo(self).offset(10*Size_ratio);
        make.height.mas_equalTo(50*Size_ratio);
        make.width.mas_equalTo(50*Size_ratio);
    }];
    
//    [_walkRouteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(5*Size_ratio);
//        make.left.equalTo(self).offset(Screen_W*0.5 + 40*Size_ratio);
//        make.height.mas_equalTo(40*Size_ratio);
//        make.width.mas_equalTo(40*Size_ratio);
//    }];
    
    [_rideRouteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5*Size_ratio);
        make.left.equalTo(self).offset(Screen_W*0.5 + 90*Size_ratio);
        make.width.mas_equalTo(50*Size_ratio);
        make.height.mas_equalTo(50*Size_ratio);
    }];
    
    [_driveRouteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(5*Size_ratio);
        make.left.equalTo(_rideRouteButton).offset(55*Size_ratio);
        make.width.mas_equalTo(50*Size_ratio);
        make.height.mas_equalTo(50*Size_ratio);
    }];
    

}
#pragma mark ------- 初始化UI
- (void)setUI
{
    [_currentLocationButton setImage:[UIImage imageNamed:@"punctuation"] forState:UIControlStateNormal];
    _currentLocationButton.tag = 100;
    [_walkRouteButton setImage:[UIImage imageNamed:@"walkRoute.png"] forState:UIControlStateNormal];
    _walkRouteButton.tag = 101;
    [_rideRouteButton setImage:[UIImage imageNamed:@"riding"] forState:UIControlStateNormal];
    _rideRouteButton.tag = 102;
    [_driveRouteButton setImage:[UIImage imageNamed:@"car"] forState:UIControlStateNormal];
    _driveRouteButton.tag = 103;
    
    [_currentLocationButton addTarget:self action:@selector(mapLocationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_walkRouteButton addTarget:self action:@selector(mapLocationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rideRouteButton addTarget:self action:@selector(mapLocationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_driveRouteButton addTarget:self action:@selector(mapLocationBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self layoutIfNeeded];
}
#pragma mark -------- Action
- (void)mapLocationBtnClick:(UIButton *)sender
{
    NSInteger btnTag = sender.tag - 100;
    switch (btnTag) {
        case 0:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(showCurrentLocation:)])
            {
                [self.delegate showCurrentLocation:sender];
            }
        }
            break;
        case 1:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(WalkRoutePlanLine:)])
            {
                [self.delegate WalkRoutePlanLine:sender];
            }
        }
            break;
        case 2:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(RideRoutePlanLine:)])
            {
                [self.delegate RideRoutePlanLine:sender];
            }
        }
            break;
        case 3:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DriveRoutePlanLine:)])
            {
                [self.delegate DriveRoutePlanLine:sender];
            }
        }
            break;
        default:
            break;
    }
}
@end
