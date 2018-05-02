//
//  HomeTopTableViewCell.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/13.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "HomeTopTableViewCell.h"
@interface HomeTopTableViewCell()
@property(nonatomic,strong)UIImageView * userNameImageView;
@property(nonatomic,strong)UILabel * userNameLabel;// 用户姓名
@property(nonatomic,strong)UILabel * userPhoneNumLabel;// 电话
@property(nonatomic,strong)UIImageView * userPhoneImageView;
@property(nonatomic,strong)UIButton * callPhone;// 打电话
@property(nonatomic,strong)UIButton * sendMessage;// 发短信
@property(nonatomic,strong)UIImageView * lineView;// 虚线
@end

@implementation HomeTopTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _userNameImageView = [[UIImageView alloc]init];
        _userPhoneImageView = [[UIImageView alloc]init];
        _userNameLabel = [[UILabel alloc]init];
        _userPhoneNumLabel = [[UILabel alloc]init];
        _callPhone = [[UIButton alloc]init];
        _sendMessage = [[UIButton alloc]init];
        _lineView = [[UIImageView alloc]init];
        
        [self addSubview:_userNameImageView];
        [self addSubview:_userPhoneImageView];
        [self addSubview:_userNameLabel];
        [self addSubview:_userPhoneNumLabel];
        [self addSubview:_callPhone];
        [self addSubview:_sendMessage];
        [self addSubview:_lineView];
        
        
        [self setUI];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_userNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20*Size_ratio);
        make.left.equalTo(self).offset(12*Size_ratio);
        make.height.mas_equalTo(12*Size_ratio);
        make.width.mas_equalTo(12*Size_ratio);
    }];

    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15*Size_ratio);
        make.left.equalTo(self).offset(37*Size_ratio);
        make.height.mas_equalTo(18*Size_ratio);
        make.width.mas_equalTo(200*Size_ratio);
    }];
    
    [_userPhoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-19*Size_ratio);
        make.left.equalTo(self).offset(15*Size_ratio);
        make.height.mas_equalTo(12*Size_ratio);
        make.width.mas_equalTo(7.5*Size_ratio);
    }];
    
    [_userPhoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15*Size_ratio);
        make.left.equalTo(self).offset(37*Size_ratio);
        make.height.mas_equalTo(18*Size_ratio);
        make.width.mas_equalTo(200*Size_ratio);
    }];
    
    [_sendMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15*Size_ratio);
        make.right.equalTo(self).offset(-90*Size_ratio);
        make.height.mas_equalTo(40*Size_ratio);
        make.width.mas_equalTo(40*Size_ratio);
    }];
    
    [_callPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15*Size_ratio);
        make.right.equalTo(self).offset(-30*Size_ratio);
        make.height.mas_equalTo(40*Size_ratio);
        make.width.mas_equalTo(40*Size_ratio);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0*Size_ratio);
        make.left.equalTo(self).offset(0);
        make.height.mas_equalTo(1*Size_ratio);
        make.width.mas_equalTo(Screen_W);
    }];
//    _lineView.image = [JHTools JHdrawLineOfDashByImageView:_lineView withSize:_lineView.frame.size withDirection:YES];
    
}
#pragma mark ------------- Action
- (void)callPhoneBtnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(callUserPhoneButton:)]) {
        [self.delegate callUserPhoneButton:self];
    }
    sender.enabled =NO;
    
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.0f];//防止重复点击
    
}

-(void)changeButtonStatus{
    
    _callPhone.enabled =YES;
}

- (void)sendMessageBtnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(senderMessageUserPhoneButton:)]) {
        [self.delegate senderMessageUserPhoneButton:self];
    }
    
}
- (void)setModel:(YZOrderModel *)model
{
    _model = model;
    NSString * userName = [NSString stringWithFormat:@"客户姓名  %@",model.custom_name];
    _userNameLabel.attributedText = [JHTools AttribytedStringWithstr:userName changeStr:@"客户姓名"];
    NSString * userPhone = [NSString stringWithFormat:@"客户电话  %@",model.custom_telphone];
    _userPhoneNumLabel.attributedText = [JHTools AttribytedStringWithstr:userPhone changeStr:@"客户电话"];

}
#pragma mark-------------- fucation
- (void)setUI{
    _userNameImageView.image = [UIImage imageNamed:@"details-user"];
    _userNameLabel.textColor = [UIColor blackColor];
    _userNameLabel.font = [UIFont systemFontOfSize:13*Size_ratio];
    
    _userPhoneImageView.image = [UIImage imageNamed:@"details-phone"];

    _userPhoneNumLabel.textColor = [UIColor blackColor];
    _userPhoneNumLabel.font = [UIFont systemFontOfSize:13*Size_ratio];
    
//    _callPhone.backgroundColor = [UIColor greenColor];
    [_callPhone setBackgroundImage:[UIImage imageNamed:@"details-Telephone"] forState:UIControlStateNormal];
    [_callPhone addTarget:self action:@selector(callPhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _callPhone.layer.cornerRadius = 20;
    
//    _sendMessage.backgroundColor = [UIColor brownColor];
    [_sendMessage setBackgroundImage:[UIImage imageNamed:@"details-information"] forState:UIControlStateNormal];
    [_sendMessage addTarget:self action:@selector(sendMessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendMessage.layer.cornerRadius = 20;
    _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self layoutIfNeeded];
}
+ (CGFloat)topCellHeight
{
    return 80*Size_ratio;
}
@end
