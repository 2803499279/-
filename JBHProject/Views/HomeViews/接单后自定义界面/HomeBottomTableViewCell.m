//
//  HomeBottomTableViewCell.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/13.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "HomeBottomTableViewCell.h"

@interface HomeBottomTableViewCell()
@property(nonatomic,strong)UIImageView * iconImageView;// 客服头像
@property(nonatomic,strong)UILabel * nameLabel;// 客服姓名昵称
@property(nonatomic,strong)UILabel * introduceLabel;// 介绍 责任客服
@property(nonatomic,strong)UILabel * oneWoedsLabel;// 一句话
@property(nonatomic,strong)UIButton * chatBtn;// 跳转聊天界面
@property(nonatomic,strong)UIImageView * topLineView;//顶部虚线
@property(nonatomic,strong)UIImageView * bottomLineView;//底部虚线
@end

@implementation HomeBottomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImageView = [[UIImageView alloc]init];
        _nameLabel = [[UILabel alloc]init];
        _introduceLabel = [[UILabel alloc]init];
        _oneWoedsLabel = [[UILabel alloc]init];
        _chatBtn = [[UIButton alloc]init];
        _topLineView = [[UIImageView alloc]init];
        _bottomLineView = [[UIImageView alloc]init];
        
        [self addSubview:_iconImageView];
        [self addSubview:_nameLabel];
        [self addSubview:_introduceLabel];
        [self addSubview:_oneWoedsLabel];
        [self addSubview:_chatBtn];
        [self addSubview:_topLineView];
        [self addSubview:_bottomLineView];
        [self setUI];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10*Size_ratio);
        make.left.equalTo(self).offset(10*Size_ratio);
        make.height.mas_equalTo(1*Size_ratio);
        make.width.mas_equalTo(Screen_W - 20*Size_ratio);
    }];
    
    _topLineView.image = [JHTools JHdrawLineOfDashByImageView:_topLineView withSize:_topLineView.frame.size withDirection:YES];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15*Size_ratio);
        make.top.equalTo(self).offset(20*Size_ratio);
        make.width.mas_equalTo(60*Size_ratio);
        make.height.mas_equalTo(60*Size_ratio);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(80*Size_ratio);
        make.top.equalTo(self).offset(25*Size_ratio);
        make.width.mas_equalTo(60*Size_ratio);
        make.height.mas_equalTo(20*Size_ratio);
    }];
    
    [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(80*Size_ratio);
            make.top.equalTo(self).offset(50*Size_ratio);
            make.width.mas_equalTo(60*Size_ratio);
            make.height.mas_equalTo(20*Size_ratio);
    }];
    
    [_oneWoedsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(145*Size_ratio);
        make.top.equalTo(self).offset(40*Size_ratio);
        make.width.mas_equalTo(150*Size_ratio);
        make.height.mas_equalTo(20*Size_ratio);
    }];
    
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-25*Size_ratio);
        make.top.equalTo(self).offset(25*Size_ratio);
        make.width.mas_equalTo(40*Size_ratio);
        make.height.mas_equalTo(40*Size_ratio);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10*Size_ratio);
        make.left.equalTo(self).offset(10*Size_ratio);
        make.height.mas_equalTo(1*Size_ratio);
        make.width.mas_equalTo(Screen_W - 20*Size_ratio);
    }];
    
    _bottomLineView.image = [JHTools JHdrawLineOfDashByImageView:_bottomLineView withSize:_bottomLineView.frame.size withDirection:YES];
    
}
#pragma mark --------Fucation
- (void)setUI
{
    
    _iconImageView.backgroundColor = [UIColor jhBaseBuleColor];
    _iconImageView.layer.cornerRadius = 30*Size_ratio;
    
    _nameLabel.textColor = [UIColor blackColor];
//    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:16*Size_ratio];
    _nameLabel.text = @"小蓝";
    
    _introduceLabel.textColor = [UIColor jhUserInfoBlack];
//    _introduceLabel.textAlignment = NSTextAlignmentCenter;
    _introduceLabel.text = @"责任客服";
    _introduceLabel.adjustsFontSizeToFitWidth = YES;
    _introduceLabel.font = [UIFont systemFontOfSize:16*Size_ratio];
    
    _oneWoedsLabel.textColor = YZEssentialColor;
    _oneWoedsLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _oneWoedsLabel.textAlignment = NSTextAlignmentCenter;
    _oneWoedsLabel.text = @"请尽快抵达现场";
    _oneWoedsLabel.adjustsFontSizeToFitWidth = YES;
    _oneWoedsLabel.layer.cornerRadius = 10*Size_ratio;
    _oneWoedsLabel.layer.masksToBounds = YES;
    _oneWoedsLabel.font = [UIFont systemFontOfSize:14*Size_ratio];
    
    _chatBtn.backgroundColor = YZEssentialColor;
    _chatBtn.layer.cornerRadius = 20*Size_ratio;

    [self layoutIfNeeded];
}
@end
