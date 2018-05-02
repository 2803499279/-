//
//  HomeHeaderView.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//
/**
 *  fileName
 *  模块名称：首页的头部显示视图
 *  作者：李俊恒
 *  版本：V:1.0
 *  创建日期：2017/04/10
 *  备注：
 *  修改日期：
 *  修改人：
 *  修改内容
 *  Sequence    Date    Author  Version     Description(why & what)
 *   编号        日期     作者    版本号         修改原因及内容描述
 *
 */

#import "HomeHeaderView.h"
@interface HomeHeaderView()
@property(nonatomic,strong)UILabel * reconnoitreNumLabel;// 勘察次数
@property(nonatomic,strong)UILabel * goodJudgeLabel;//好评率
@property(nonatomic,strong)UILabel * monthlyLabel;// 月收入
@property(nonatomic,strong)UIButton * pushButton;// 点击进入
@property(nonatomic,strong)UIButton * reconnoitreButton;//勘察次数跳转到已完成拍单
@property(nonatomic,strong)UIView * oneLineview;// 第一条竖线
@property(nonatomic,strong)UIView * towLineview;// 第二条竖线
@property(nonatomic,strong)UIView * backGroundView;
@end
@implementation HomeHeaderView
#pragma mark ========== lifecircle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _reconnoitreNumLabel = [[UILabel alloc]init];
        _goodJudgeLabel = [[UILabel alloc]init];
        _monthlyLabel = [[UILabel alloc]init];
        _oneLineview = [[UIView alloc]init];
        _towLineview = [[UIView alloc]init];
        _backGroundView = [[UIView alloc]init];
        _pushButton = [[UIButton alloc]init];
        _reconnoitreButton = [[UIButton alloc]init];
        
        [_backGroundView addSubview:_reconnoitreButton];
        [_backGroundView addSubview:_reconnoitreNumLabel];
        [_backGroundView addSubview:_pushButton];
        [_backGroundView addSubview:_goodJudgeLabel];
        [_backGroundView addSubview:_monthlyLabel];
        [_backGroundView addSubview:_oneLineview];
        [_backGroundView addSubview:_towLineview];
        [self addSubview:_backGroundView];
        [self setUI];
    }
    return self;
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20*Size_ratio);
        make.left.equalTo(self).offset(10*Size_ratio);
        make.right.equalTo(self).offset(-10*Size_ratio);
        make.bottom.equalTo(self).offset(-20*Size_ratio);
    }];
    
    [_reconnoitreNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backGroundView).offset(20*Size_ratio);
        make.top.equalTo(_backGroundView).offset(10*Size_ratio);
        make.height.mas_equalTo(60*Size_ratio);
        make.width.mas_equalTo(100*Size_ratio);
    }];
    
    [_reconnoitreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backGroundView).offset(20*Size_ratio);
        make.top.equalTo(_backGroundView).offset(10*Size_ratio);
        make.height.mas_equalTo(60*Size_ratio);
        make.width.mas_equalTo(100*Size_ratio);
    }];
    
    
    [_oneLineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backGroundView).offset(132*Size_ratio);
        make.top.equalTo(_backGroundView).offset(10*Size_ratio);
        make.height.mas_equalTo(60*Size_ratio);
        make.width.mas_equalTo(1*Size_ratio);
    }];
    [_goodJudgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backGroundView).offset(150*Size_ratio);
        make.top.equalTo(_backGroundView).offset(10*Size_ratio);
        make.height.mas_equalTo(60*Size_ratio);
        make.width.mas_equalTo(100*Size_ratio);
    }];
    [_towLineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backGroundView).offset(262*Size_ratio);
        make.top.equalTo(_backGroundView).offset(10*Size_ratio);
        make.height.mas_equalTo(60*Size_ratio);
        make.width.mas_equalTo(1*Size_ratio);
    }];
    [_monthlyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backGroundView).offset(-20*Size_ratio);
        make.top.equalTo(_backGroundView).offset(10*Size_ratio);
        make.height.mas_equalTo(60*Size_ratio);
        make.width.mas_equalTo(100*Size_ratio);
    }];
    [_pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backGroundView).offset(-20*Size_ratio);
        make.top.equalTo(_backGroundView).offset(10*Size_ratio);
        make.height.mas_equalTo(60*Size_ratio);
        make.width.mas_equalTo(100*Size_ratio);
    }];
}
#pragma mark =========== Event
- (void)pushButtonClick:(UIButton *)sender
{
    if (self.homeHeaderViewDelegate && [self.homeHeaderViewDelegate respondsToSelector:@selector(didSelectedpushMoneyView:)]){
        [self.homeHeaderViewDelegate didSelectedpushMoneyView:sender];
    }
}
- (void)reconnoitreButtonClick:(UIButton *)sender
{
    if (self.homeHeaderViewDelegate && [self.homeHeaderViewDelegate respondsToSelector:@selector(didSelectedpushCompletedTaskView:)]){
        [self.homeHeaderViewDelegate didSelectedpushCompletedTaskView:sender];
    }
}
#pragma mark =========== KeyBoardNotify

#pragma mark =========== Fouction
#pragma mark ----------- HandleModelDatasource

#pragma mark ----------- HandleView
- (void)setUI
{
//    self.layer.borderWidth = 0.5;
//    self.layer.borderColor = [[UIColor grayColor] CGColor];
    _backGroundView.backgroundColor = [UIColor whiteColor];
    _backGroundView.layer.cornerRadius = 5*Size_ratio;
    _backGroundView.layer.masksToBounds = YES;
    
    _oneLineview.backgroundColor = [UIColor jhBackGroundColor];
    _towLineview.backgroundColor = [UIColor jhBackGroundColor];
    _reconnoitreNumLabel.textColor = [UIColor jhBaseOrangeColor];
    _reconnoitreNumLabel.font = [UIFont boldSystemFontOfSize:24*Size_ratio];
    _reconnoitreNumLabel.numberOfLines = 0;
    _reconnoitreNumLabel.textAlignment = NSTextAlignmentCenter;
    _reconnoitreNumLabel.adjustsFontSizeToFitWidth = YES;
    
    _goodJudgeLabel.textColor = [UIColor jhBaseOrangeColor];
    _goodJudgeLabel.font = [UIFont boldSystemFontOfSize:24*Size_ratio];
    _goodJudgeLabel.numberOfLines = 0;
    _goodJudgeLabel.adjustsFontSizeToFitWidth = YES;
    _goodJudgeLabel.textAlignment = NSTextAlignmentCenter;

    _monthlyLabel.textColor = [UIColor jhBaseOrangeColor];
    _monthlyLabel.font = [UIFont boldSystemFontOfSize:24*Size_ratio];
    _monthlyLabel.numberOfLines = 0;
    _monthlyLabel.adjustsFontSizeToFitWidth = YES;
    _monthlyLabel.textAlignment = NSTextAlignmentCenter;

    [_pushButton addTarget:self action:@selector(pushButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_pushButton setBackgroundImage:[UIImage imageNamed:@"backGroundImg.png"] forState:UIControlStateHighlighted];
    
    [_reconnoitreButton addTarget:self action:@selector(reconnoitreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_reconnoitreButton setBackgroundImage:[UIImage imageNamed:@"backGroundImg.png"] forState:UIControlStateHighlighted];
}
- (void)setModel:(HomeHeaderModel *)model
{
    NSString * numText = [NSString stringWithFormat:@"%@次\n已勘查数",model.taskCount];
    _reconnoitreNumLabel.attributedText = [self AttribytedStringWithstr:numText changeStr:@"已勘查数" changeStr:@"次"];
    
    NSString * goodJudgeText = [NSString stringWithFormat:@"%@\n好评率",model.taskRate];
    _goodJudgeLabel.attributedText = [self AttribytedStringWithstr:goodJudgeText changeStr:@"好评率" changeStr:@"%"];

    NSString * monthlyText = [NSString stringWithFormat:@"%@元\n本月总收入",model.taskAllreward];
    _monthlyLabel.attributedText = [self AttribytedStringWithstr:monthlyText changeStr:@"本月总收入" changeStr:@"元"];
    [self layoutIfNeeded];

}

- (NSAttributedString *)AttribytedStringWithstr:(NSString *)str changeStr:(NSString *)changeStr
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = [str rangeOfString:changeStr];
    
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor grayColor]
                   range:range];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Arial" size:13*Size_ratio]
                   range:range];
    
    return string;
}

- (NSAttributedString *)AttribytedStringWithstr:(NSString *)str changeStr:(NSString *)changeStr1 changeStr:(NSString *)changeStr2
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = [str rangeOfString:changeStr1];
    
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor grayColor]
                   range:range];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Arial" size:13*Size_ratio]
                   range:range];
    
    NSRange range1 = [str rangeOfString:changeStr2];
    
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor jhBaseOrangeColor]
                   range:range1];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Arial" size:18*Size_ratio]
                   range:range1];
    
    return string;
}
@end
