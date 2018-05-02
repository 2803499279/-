//
//  HomeCenterTableViewCell.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/13.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "HomeCenterTableViewCell.h"
@interface HomeCenterTableViewCell()
@property(nonatomic,strong)UILabel * addressLabel;// 地址
@property(nonatomic,strong)UILabel * descriptionLabel;// 事故说明
@property(nonatomic,strong)UILabel * rewardMoneytLabel;// 奖金
@property(nonatomic,strong)UIImageView * lineView;// 虚线
@property(nonatomic,strong)UIImageView * addressImageView;
@property(nonatomic,strong)UIImageView * descriptionImageView;
@property(nonatomic,strong)UIImageView * rewardMoneyImageView;
@property(nonatomic,strong)UIImageView * carNumImageView;// 勘查车牌
@property(nonatomic,strong)UILabel * carNumberLabel;// 车牌号
@property(nonatomic,strong)UIImageView * carTypeImageView;// 勘查车型
@property(nonatomic,strong)UILabel * carTypeLabel;// 车辆类型

@end

@implementation HomeCenterTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _addressLabel = [[UILabel alloc]init];
        _descriptionLabel = [[UILabel alloc]init];
        _rewardMoneytLabel = [[UILabel alloc]init];
        _lineView = [[UIImageView alloc]init];
        _addressImageView = [[UIImageView alloc]init];
        _descriptionImageView = [[UIImageView alloc]init];
        _rewardMoneyImageView = [[UIImageView alloc]init];
        _carNumImageView = [[UIImageView alloc]init];
        _carNumberLabel = [[UILabel alloc]init];
        _carTypeImageView = [[UIImageView alloc]init];
        _carTypeLabel = [[UILabel alloc]init];
        
        
        
        [self addSubview:_addressImageView];
        [self addSubview:_addressLabel];
        [self addSubview:_descriptionImageView];
        [self addSubview:_descriptionLabel];
        [self addSubview:_carNumImageView];
        [self addSubview:_carNumberLabel];
        [self addSubview:_carTypeImageView];
        [self addSubview:_carTypeLabel];
        [self addSubview:_rewardMoneyImageView];
        [self addSubview:_rewardMoneytLabel];
        [self addSubview:_lineView];
        
        
        [self setUI];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSString * address = [NSString stringWithFormat:@"事故地址  %@",_model.arise_address];
    CGFloat addressLabelHeight = [JHTools heightOfConttent:address fontSize:16*Size_ratio maxWidth:Screen_W-30*Size_ratio];
    NSString * descriptionStr = [NSString stringWithFormat:@"事故说明  %@",_model.remark];

    CGFloat descriptionLabelHeight = [JHTools heightOfConttent:descriptionStr fontSize:16*Size_ratio maxWidth:Screen_W-30*Size_ratio];
    
    [_addressImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(19*Size_ratio);
        make.left.equalTo(self).offset(15*Size_ratio);
        make.height.mas_equalTo(12*Size_ratio);
        make.width.mas_equalTo(9*Size_ratio);
    }];
    
    [_addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15*Size_ratio);
        make.left.equalTo(self).offset(37*Size_ratio);
        make.height.mas_equalTo(addressLabelHeight*Size_ratio);
        make.width.mas_equalTo(Screen_W - 30*Size_ratio);
    }];
    
    [_descriptionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(28*Size_ratio + addressLabelHeight*Size_ratio);
        make.left.equalTo(self).offset(15*Size_ratio);
        make.height.mas_equalTo(12*Size_ratio);
        make.width.mas_equalTo(8.5*Size_ratio);
    }];
    [_descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25*Size_ratio + addressLabelHeight*Size_ratio);
        make.left.equalTo(self).offset(37*Size_ratio);
        make.height.mas_equalTo(descriptionLabelHeight);
        make.width.mas_equalTo(Screen_W - 30*Size_ratio);
    }];
    
    [_carNumImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(39*Size_ratio + addressLabelHeight*Size_ratio+ descriptionLabelHeight*Size_ratio);
        make.left.equalTo(self).offset(13*Size_ratio);
        make.height.mas_equalTo(13*Size_ratio);
        make.width.mas_equalTo(15*Size_ratio);
    }];
    [_carNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30*Size_ratio + addressLabelHeight*Size_ratio+ descriptionLabelHeight*Size_ratio);
        make.left.equalTo(self).offset(37*Size_ratio);
        make.height.mas_equalTo(30*Size_ratio);
        make.width.mas_equalTo(Screen_W);
    }];

    [_carTypeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(49*Size_ratio + addressLabelHeight*Size_ratio+20*Size_ratio+ descriptionLabelHeight*Size_ratio);
        make.left.equalTo(self).offset(13*Size_ratio);
        make.height.mas_equalTo(14*Size_ratio);
        make.width.mas_equalTo(16*Size_ratio);
    }];
    [_carTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(60*Size_ratio + addressLabelHeight*Size_ratio + descriptionLabelHeight*Size_ratio);
        make.left.equalTo(self).offset(37*Size_ratio);
        make.height.mas_equalTo(30*Size_ratio);
        make.width.mas_equalTo(Screen_W);
    }];

    
    [_rewardMoneyImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(59*Size_ratio + addressLabelHeight*Size_ratio + descriptionLabelHeight*Size_ratio+40*Size_ratio);
        make.left.equalTo(self).offset(15*Size_ratio);
        make.height.mas_equalTo(12.5*Size_ratio);
        make.width.mas_equalTo(11.5*Size_ratio);
    }];
    [_rewardMoneytLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(90*Size_ratio + addressLabelHeight*Size_ratio + descriptionLabelHeight*Size_ratio);
        make.left.equalTo(self).offset(37*Size_ratio);
        make.height.mas_equalTo(30*Size_ratio);
        make.width.mas_equalTo(Screen_W);
    }];
    
    
    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-1*Size_ratio);
        make.left.equalTo(self).offset(0*Size_ratio);
        make.height.mas_equalTo(1*Size_ratio);
        make.width.mas_equalTo(Screen_W);
    }];
    
    
//    _lineView.image = [JHTools JHdrawLineOfDashByImageView:_lineView withSize:_lineView.frame.size withDirection:YES];
}
#pragma mark-------------- fucation
- (void)setUI{
    
    _addressImageView.image = [UIImage imageNamed:@"details-place"];
    _addressLabel.textColor = [UIColor blackColor];
    _addressLabel.font = [UIFont systemFontOfSize:13*Size_ratio];
    _addressLabel.numberOfLines = 0;
    
    _descriptionImageView.image = [UIImage imageNamed:@"details-content"];
    _descriptionLabel.textColor = [UIColor blackColor];
  
    _descriptionLabel.font = [UIFont systemFontOfSize:13*Size_ratio];
    _descriptionLabel.numberOfLines = 0;

    _carNumImageView.image = [UIImage imageNamed:@"details-carNum"];
    _carNumberLabel.textColor = [UIColor blackColor];
    _carNumberLabel.font = [UIFont systemFontOfSize:13*Size_ratio];
    _carNumberLabel.numberOfLines = 0;
    
    
    _carTypeImageView.image = [UIImage imageNamed:@"details-carType"];
    _carTypeLabel.textColor = [UIColor blackColor];
    _carTypeLabel.font = [UIFont systemFontOfSize:13*Size_ratio];
    _carTypeLabel.numberOfLines = 0;
    
    
    _rewardMoneyImageView.image = [UIImage imageNamed:@"details-reward"];
    _rewardMoneytLabel.textColor = [UIColor blackColor];
    _rewardMoneytLabel.font = [UIFont systemFontOfSize:13*Size_ratio];
    _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
   
    
}
- (void)setModel:(YZOrderModel *)model
{
    _model = model;
    NSString * address = [NSString stringWithFormat:@"事故地址  %@",model.arise_address];
    _addressLabel.attributedText = [JHTools AttribytedStringWithstr:address changeStr:@"事故地址"];

    NSString * descriptionStr = [NSString stringWithFormat:@"事故说明  %@",model.remark];
    _descriptionLabel.attributedText = [JHTools AttribytedStringWithstr:descriptionStr changeStr:@"事故说明"];
    
     NSString * carNumStr = [NSString stringWithFormat:@"勘查车牌  %@",model.license_plate];
    _carNumberLabel.attributedText = [JHTools AttribytedStringWithstr:carNumStr changeStr:@"勘查车牌"];
    
    NSString * carType = [NSString stringWithFormat:@"勘查车型  %@",model.vehicle_model];
    _carTypeLabel.attributedText = [JHTools AttribytedStringWithstr:carType changeStr:@"勘查车型"];
    NSString * rewardStr = [NSString stringWithFormat:@"勘查奖励  %@元",model.reward];
    _rewardMoneytLabel.attributedText = [JHTools AttribytedStringWithstr:rewardStr changeStr:@"勘查奖励"];
    
    
//    @property (nonatomic, copy) NSString *license_plate; // 车牌号
//    @property (nonatomic, copy) NSString *vehicle_model; // 车型
   
     [self layoutIfNeeded];
}

+ (NSAttributedString *)AttribytedStringWithstr:(NSString *)str changeStr:(NSString *)changeStr
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = [str rangeOfString:changeStr];
    
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor grayColor]
                   range:range];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Arial" size:13*YZAdapter]
                   range:range];
    
    return string;
}

- (CGFloat)centerCellheightWithModel:(YZOrderModel *)cellModel
{
    NSString * address = [NSString stringWithFormat:@"事故地址  %@",cellModel.arise_address];
    NSString * descriptionStr = [NSString stringWithFormat:@"事故说明  %@",cellModel.remark];
    NSString * rewardStr = [NSString stringWithFormat:@"勘查奖励  %@元",cellModel.reward];
    CGFloat addressLabelHeight = [JHTools heightOfConttent:address fontSize:13*Size_ratio maxWidth:Screen_W-30*Size_ratio];
    CGFloat descriptionLabelHeight = [JHTools heightOfConttent:descriptionStr fontSize:13*Size_ratio maxWidth:Screen_W-30*Size_ratio];
    CGFloat rewardStrHeight = [JHTools heightOfConttent:rewardStr fontSize:13*Size_ratio maxWidth:Screen_W-30*Size_ratio];

        return 57*Size_ratio+addressLabelHeight + descriptionLabelHeight + rewardStrHeight+70*Size_ratio;
}
+ (CGFloat)centerCellHeightWithModel:(YZOrderModel *)cellModel
{
    return [[self alloc]centerCellheightWithModel:cellModel];
}
@end
