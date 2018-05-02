//
//  CellTopHeaderView.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/13.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "CellTopHeaderView.h"
@interface CellTopHeaderView()
@property(nonatomic,strong)UILabel * typeLabel;// 勘察类型
@property(nonatomic,strong)UILabel * useTimeLabel;// 耗时
@property(nonatomic,strong)UIImageView * lineView;// 虚线

@end
@implementation CellTopHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _typeLabel = [[UILabel alloc]init];
        _useTimeLabel = [[UILabel alloc]init];
        _scrollerButton = [[UIButton alloc]init];
        _lineView = [[UIImageView alloc]init];
        _refundBtn = [[UIButton alloc]init];
       
        [self addSubview:_typeLabel];
        [self addSubview:_useTimeLabel];
        [self addSubview:_scrollerButton];
        [self addSubview:_lineView];
        [self addSubview:_refundBtn];
        [self setUI];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8*YZAdapter);
        make.left.equalTo(self).offset(12*YZAdapter);
        make.height.mas_equalTo(24*YZAdapter);
        make.width.mas_equalTo(75*YZAdapter);
    }];
    [_useTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8*YZAdapter);
        make.left.equalTo(self).offset(76*YZAdapter);
        make.height.mas_equalTo(24*YZAdapter);
        make.width.mas_equalTo(100*YZAdapter);
    }];
    [_scrollerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5*YZAdapter);
        make.left.equalTo(self).offset(Screen_W*0.5-18*YZAdapter);
        make.width.mas_equalTo(18*YZAdapter);
        make.height.mas_equalTo(18*YZAdapter);
    }];
    
    [_refundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8*YZAdapter);
        make.right.equalTo(self).offset(-25*YZAdapter);
        make.width.mas_equalTo(75*YZAdapter);
        make.height.mas_equalTo(20*YZAdapter);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.height.mas_equalTo(1*Size_ratio);
        make.width.mas_equalTo(Screen_W);
    }];
    
}
#pragma mark ------ Action
- (void)setTypeName:(NSString *)typeName
{
    _typeLabel.text = typeName;

}
- (void)setUserTimeStr:(NSString *)userTimeStr
{
    _useTimeLabel.text = userTimeStr;

}
- (void)topHeaderViewBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    if (self.cellTopHeaderViewDelegate && [self.cellTopHeaderViewDelegate respondsToSelector:@selector(CellTopHeaderViewButton:)])
    {
        // 调用代理方法
        [self.cellTopHeaderViewDelegate CellTopHeaderViewButton:sender];
    }
}
- (void)refundBtnClick:(UIButton *)sender
{
    
    if (self.cellTopHeaderViewDelegate && [self.cellTopHeaderViewDelegate respondsToSelector:@selector(CellTopHeaderViewRefundBtn:)])
    {
        // 调用代理方法
        [self.cellTopHeaderViewDelegate CellTopHeaderViewRefundBtn:sender];
    }
}
#pragma mark ------ Fucation
- (void)setUI{
    _typeLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _typeLabel.textColor = [UIColor grayColor];
    _typeLabel.font = FONTS(13);
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    
    _useTimeLabel.textColor = [UIColor grayColor];
    _useTimeLabel.font = FONTS(13);
    _useTimeLabel.adjustsFontSizeToFitWidth = YES;
    _useTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    [_scrollerButton setBackgroundImage:[UIImage imageNamed:@"下"] forState:0];
    _scrollerButton.layer.cornerRadius = 15*YZAdapter;
    [_scrollerButton addTarget:self action:@selector(topHeaderViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [_refundBtn setTitle:@"申请退单" forState:UIControlStateNormal];
    [_refundBtn addTarget:self action:@selector(refundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _refundBtn.titleLabel.font = FONT(13);
    _refundBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_refundBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_refundBtn setTitleColor:[UIColor jhCancelRed] forState:UIControlStateHighlighted];
    [self layoutIfNeeded];
}

@end
