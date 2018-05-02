//
//  LeftBodyTableViewCell.m
//  NewTTY
//
//  Created by 李俊恒 on 2016/11/14.
//  Copyright © 2016年 sinze. All rights reserved.
//

#import "LeftBodyTableViewCell.h"
@interface LeftBodyTableViewCell()

/**
 * 按钮底部的文字
 */
@property(nonatomic,strong)UILabel * contentLabel;// 文字显示
/**
 * 按钮
 */
@property(nonatomic,strong)UIButton * itemButton;// 右边的按钮

@property(nonatomic,strong)UIImageView * iconImageView;// 头像显示

@property(nonatomic,strong)UIView * lineView;


@end

@implementation LeftBodyTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconImageView = [[UIImageView alloc]init];
        _contentLabel = [[UILabel alloc]init];
        _rowImageView = [[UIImageView alloc]init];
        _lineView = [[UIView alloc]init];
        _desLabel = [[UILabel alloc]init];
        
        
        [self addSubview:_lineView];
        [_itemButton addSubview:_desLabel];
        [_itemButton addSubview:_rowImageView];
        [_itemButton addSubview:_iconImageView];
        [_itemButton addSubview:_contentLabel];
        [self.contentView addSubview:_itemButton];
//        self.alpha = 0;
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    _contentLabel.textColor = MainFont_Color;
    _contentLabel.font = [UIFont systemFontOfSize:14*YZAdapter];

//    _iconImageView.layer.cornerRadius = 4*YZAdapter;
    
//    _iconImageView.backgroundColor = [UIColor jhSureGreen];
    
    [_itemButton setBackgroundImage:[UIImage imageNamed:@"backGroundImg.png"] forState:UIControlStateHighlighted];

    [_itemButton addTarget:self action:@selector(itemButonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _rowImageView.image = [UIImage imageNamed:@"fh"];
    
    _desLabel.textColor = YZLesserEssentialColor;
    _desLabel.font = [UIFont systemFontOfSize:14*Size_ratio];
    _desLabel.textAlignment = NSTextAlignmentRight;
    
    _lineView.backgroundColor = [UIColor jhBackGroundColor];

}
- (void)itemButonClick:(UIButton*)buuton
{
    if(self.leftDelegate && [self.leftDelegate respondsToSelector:@selector(leftBodyButtonClicked:)]){
    [self.leftDelegate leftBodyButtonClicked:self];
    }
}
- (void)createCellWith:(LeftBarModel *)model
{
    _model = model;
    _contentLabel.text = model.myLabelTitle;
    _iconImageView.image = [UIImage imageNamed:model.iconImageNameStr];
    [self layoutIfNeeded];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = 17*YZAdapter;
    CGFloat width = 17*YZAdapter;
    if ([_model.iconImageNameStr isEqualToString:@"实名认证"]) {
        height = 15*YZAdapter;
        width = 18*YZAdapter;
    }
//    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(12*YZAdapter);
//        make.centerY.mas_equalTo(self);
//        make.height.mas_equalTo(height);
//        make.width.mas_equalTo(width);
//    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15*YZAdapter);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(45*YZAdapter);
        make.width.mas_equalTo(Screen_W);
    }];
    _itemButton.frame=CGRectMake(0*YZAdapter, 0, Screen_W, 45*YZAdapter);
   
    
    
    [_rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12*Size_ratio);
        make.centerY.mas_equalTo(self);
        make.height.mas_offset(17*YZAdapter);
        make.width.mas_equalTo(12*YZAdapter);
    }];
#pragma mark ======= 文字是否移动
    CGFloat rightY ;
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    NSString *dicStartPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"startdic.txt"];
    NSDictionary *readDic = [NSDictionary dictionaryWithContentsOfFile:dicStartPath];
    if(readDic!=nil){
        if (![YZUtil isBlankString:model.realname] || ![YZUtil isBlankString:model.cardno]){
            NSString *  Mypower = [[readDic[@"data"] objectForKey:@"setting"]objectForKey:@"power"];
            if ([Mypower integerValue]==1&&[_desLabel.text isEqualToString:@"已开启"]) {
                rightY = -24*Size_ratio;
            }else
            {
                rightY = -14*Size_ratio;
            }
            
        }
    }
#pragma mark========= 文字移动位置
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(rightY);
        make.centerY.mas_equalTo(self);
        make.height.mas_offset(17*YZAdapter);
        make.width.mas_equalTo(60*YZAdapter);
    }];

    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.mas_offset(1);
        make.width.mas_equalTo(Screen_W);
    }];
}

@end
