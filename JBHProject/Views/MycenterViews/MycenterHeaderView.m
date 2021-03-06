//
//  MycenterHeaderView.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/8/23.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "MycenterHeaderView.h"
@interface MycenterHeaderView()
@property(nonatomic,strong)UIImageView * myBackGroundImageView;
@property(nonatomic,strong)UIButton * starImageView;//好评率
@property(nonatomic,strong)UIButton * myAccountImageView;//我的账户
@property(nonatomic,strong)UIButton * starButton;//好评率按钮
@property(nonatomic,strong)UIButton * myAccountButton;// 我的账户
//@property(nonatomic,strong)UIButton * userIcon;// 用户头像
//@property(nonatomic,strong)UIButton * userName;// 用户名
//@property(nonatomic,strong)UIButton * userPhoneNumber;//电话号
@end
@implementation MycenterHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _myBackGroundImageView = [[UIImageView alloc]initWithFrame:frame];
        _userIcon = [[UIButton alloc]init];
        _userName = [[UIButton alloc]init];
        _userPhoneNumber = [[UIButton alloc]init];
        _starImageView = [[UIButton alloc]init];
        _starButton = [[UIButton alloc]init];
        _myAccountImageView = [[UIButton alloc]init];
        _myAccountButton = [[UIButton alloc]init];
        _userImage = [UIImageView new];
        
        [_myBackGroundImageView addSubview:_userImage];
        [_myBackGroundImageView addSubview:_userIcon];
        [_myBackGroundImageView addSubview:_userName];
        [_myBackGroundImageView addSubview:_userPhoneNumber];
        [_myBackGroundImageView addSubview:_starImageView];
        [_myBackGroundImageView addSubview:_starButton];
        [_myBackGroundImageView addSubview:_myAccountImageView];
        [_myBackGroundImageView addSubview:_myAccountButton];
        
        [self addSubview:_myBackGroundImageView];

        [self setMyHeaderViewUI];

        [self layoutIfNeeded];

    }
    return self;
}
- (void)setDataSoucesArray:(NSArray *)dataSoucesArray
{
    [_userName setTitle:@"汤圆" forState:UIControlStateNormal];
    [_userPhoneNumber setTitle:@"137****3837" forState:UIControlStateNormal];
    [_userPhoneNumber setTitleColor:MainFont_Color forState:UIControlStateNormal];
    [_starButton setTitle:@"服务分" forState:UIControlStateNormal];
    [_starButton setTitleColor:MainFont_Color forState:UIControlStateNormal];
    [_myAccountButton setTitle:@"钱包" forState:UIControlStateNormal];
    [_myAccountButton setTitleColor:MainFont_Color forState:UIControlStateNormal];
    [_starImageView setTitle:@"100分" forState:UIControlStateNormal];
    [_starImageView setTitleColor:YZEssentialColor forState:UIControlStateNormal];
}
- (void)setMyHeaderViewUI{
    
    self.userInteractionEnabled = YES;
    self.myBackGroundImageView.userInteractionEnabled = YES;
    self.myBackGroundImageView.image = [UIImage imageNamed:@"MycenterBgImg"];
    
    _userImage.userInteractionEnabled = YES;
    _userImage.layer.cornerRadius = 38*YZAdapter;
    _userImage.layer.masksToBounds = YES;
    
    _userIcon.layer.cornerRadius = 38*YZAdapter;
    _userIcon.layer.masksToBounds = YES;
    [_userIcon addTarget:self action:@selector(userIconClicked:) forControlEvents:UIControlEventTouchUpInside];
    _userIcon.backgroundColor = [UIColor clearColor];
    
    [_userName addTarget:self action:@selector(userIconClicked:) forControlEvents:UIControlEventTouchUpInside];
    _userName.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_userName setTitleColor:MainFont_Color forState:UIControlStateNormal];
    _userName.titleLabel.font = [UIFont systemFontOfSize:17*YZAdapter];
    
    [_userPhoneNumber addTarget:self action:@selector(userIconClicked:) forControlEvents:UIControlEventTouchUpInside];
    _userPhoneNumber.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_userPhoneNumber setTitleColor:[UIColor jhUserInfoMarginGray] forState:UIControlStateNormal];
    _userPhoneNumber.titleLabel.font = [UIFont systemFontOfSize:14*YZAdapter];

    [_starButton addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_starImageView addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    _starImageView.backgroundColor = [UIColor jhSureGreen];
    
    
    [_starButton setTitleColor:[UIColor jhUserInfoMarginGray] forState:UIControlStateNormal];
    _starButton.titleLabel.font = [UIFont systemFontOfSize:14*YZAdapter];
    
    [_myAccountImageView addTarget:self action:@selector(myAccountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_myAccountImageView setImage:[UIImage imageNamed:@"YZNewWithdrawal"] forState:UIControlStateNormal];
//    _myAccountImageView.backgroundColor = [UIColor jhSureGreen];

    [_myAccountButton addTarget:self action:@selector(myAccountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_myAccountButton setTitleColor:[UIColor jhUserInfoMarginGray] forState:UIControlStateNormal];
    _myAccountButton.titleLabel.font = [UIFont systemFontOfSize:14*YZAdapter];

    self.myBackGroundImageView.backgroundColor = WhiteColor;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [_myBackGroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(0*YZAdapter);
//        make.left.equalTo(self).offset(0*YZAdapter);
//        make.right.equalTo(self).offset(0*YZAdapter);
//        make.bottom.equalTo(self).offset(0*YZAdapter);
//    }];
    
    [_userIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.equalTo(_myBackGroundImageView).offset(64+30*YZAdapter);
        make.height.mas_equalTo(76*YZAdapter);
        make.width.mas_equalTo(76*YZAdapter);
    }];
    
    [_userImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.equalTo(_myBackGroundImageView).offset(64+30*YZAdapter);
        make.height.mas_equalTo(76*YZAdapter);
        make.width.mas_equalTo(76*YZAdapter);
    }];
    
    
    [_userName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_userIcon);
        make.bottom.equalTo(_userIcon).offset(30*YZAdapter);
        make.height.mas_equalTo(20*YZAdapter);
        make.width.mas_equalTo(Screen_W);
    }];
   
    [_userPhoneNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_userIcon);
        make.bottom.equalTo(_userName).offset(20*YZAdapter);
        make.height.mas_equalTo(20*YZAdapter);
        make.width.mas_equalTo(Screen_W);
    }];
    
    [_starImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIcon).offset(-50*YZAdapter);
        make.bottom.equalTo(_userPhoneNumber).offset(35*YZAdapter);
        make.height.mas_equalTo(30*YZAdapter);
        make.width.mas_equalTo(60*YZAdapter);
    }];
    
    [_starButton mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(_starImageView);
        make.bottom.equalTo(_starImageView).offset(25*YZAdapter);
        make.height.mas_equalTo(20*YZAdapter);
        make.width.mas_equalTo(60*YZAdapter);
    }];
    
    [_myAccountImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_userIcon).offset(50*YZAdapter);
        make.bottom.equalTo(_userPhoneNumber).offset(35*YZAdapter);
        make.height.mas_equalTo(30*YZAdapter);
        make.width.mas_equalTo(30*YZAdapter);
    }];
    
    [_myAccountButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_myAccountImageView);
        make.bottom.equalTo(_myAccountImageView).offset(25*YZAdapter);
        make.height.mas_equalTo(20*YZAdapter);
        make.width.mas_equalTo(60*YZAdapter);
    }];
}
#pragma mark ========== delegate

#pragma mark ========== Event
- (void)userIconClicked:(UIButton *)sender
{
// 进入个人信息中心
    if (self.myCenterViewDelegate && [self.myCenterViewDelegate respondsToSelector:@selector(didSelectedpushUserCenter:)]){
        [self.myCenterViewDelegate didSelectedpushUserCenter:sender];
    }

}
- (void)startBtnClicked:(UIButton *)sender
{
// 进入好评率
}
- (void)myAccountButtonClicked:(UIButton *)sender
{
// 进入我的账户
    if (self.myCenterViewDelegate && [self.myCenterViewDelegate respondsToSelector:@selector(didSelectedpushMyAccount:)]){
        [self.myCenterViewDelegate didSelectedpushMyAccount:sender];
    }
}

@end
