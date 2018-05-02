//
//  CompletedTableViewCell.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/28.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "CompletedTableViewCell.h"
@interface CompletedTableViewCell()
@property(nonatomic,strong)UILabel * typeLabel;// 车辆代勘也就是类别可能是返回数据显示
@property(nonatomic,strong)UILabel * timeLabel;// 显示系统当前时间
@property(nonatomic,strong)UILabel * addressLabel;// 显示地址
@property(nonatomic,strong)UILabel * nearbyLabel;// 附近地址

@property(nonatomic,strong)UILabel * costLabel;// 费用展示
@property(nonatomic,strong)UILabel * costTypeLabel;// 勘察奖励

@property(nonatomic,strong)UILabel * describeLabel;// 简短描述事故状况
@property(nonatomic,strong)UIImageView * verticalLineView;// 竖向线条
@property(nonatomic,strong)UIImageView * horizontalLineView;// 横向线条
@property(nonatomic,strong)UIView * backGroundView;
@end
@implementation CompletedTableViewCell
#pragma mark ========== lifecircle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _typeLabel = [[UILabel alloc]init];
        _timeLabel = [[UILabel alloc]init];
        _addressLabel = [[UILabel alloc]init];
        _costLabel = [[UILabel alloc]init];
        _describeLabel = [[UILabel alloc]init];
        _verticalLineView = [[UIImageView alloc]init];
        _horizontalLineView = [[UIImageView alloc]init];
        _backGroundView = [[UIView alloc]init];
        _nearbyLabel = [[UILabel alloc]init];
        _costTypeLabel = [[UILabel alloc]init];
        _backGroundView.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor jhBackGroundColor];
        
        [_backGroundView addSubview:_typeLabel];
        [_backGroundView addSubview:_timeLabel];
        [_backGroundView addSubview:_addressLabel];
        [_backGroundView addSubview:_nearbyLabel];
        [_backGroundView addSubview:_costLabel];
        [_backGroundView addSubview:_costTypeLabel];
        [_backGroundView addSubview:_describeLabel];
        [_backGroundView addSubview:_verticalLineView];
        [_backGroundView addSubview:_horizontalLineView];
        [self addSubview:_backGroundView];
        [self setUI];
        _backGroundView.layer.cornerRadius = 10*Size_ratio;
        _backGroundView.layer.masksToBounds = YES;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(10*YZAdapter);
        make.right.equalTo(self).offset(-10*YZAdapter);
        make.bottom.equalTo(self).offset(-20*YZAdapter);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundView).offset(15*YZAdapter);
        make.left.equalTo(_backGroundView).offset(20*YZAdapter);
        make.height.mas_equalTo(30*YZAdapter);
        make.width.mas_equalTo(100*YZAdapter);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundView).offset(15*YZAdapter);
        make.right.equalTo(_backGroundView).offset(-5*YZAdapter);
        make.height.mas_equalTo(30*YZAdapter);
        make.width.mas_equalTo(150*YZAdapter);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundView).offset(50*YZAdapter);
        make.left.equalTo(_backGroundView).offset(20*YZAdapter);
        make.width.mas_equalTo(Screen_W*2/3 - 80*YZAdapter);
        make.height.mas_equalTo(55*YZAdapter);
    }];
    
    [_nearbyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundView).offset(90*YZAdapter);
        make.left.equalTo(_backGroundView).offset(20*YZAdapter);
        make.width.mas_equalTo(Screen_W*2/3 - 80*YZAdapter);
        make.height.mas_equalTo(55*YZAdapter);
    }];
    
    [_verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_backGroundView).offset(Screen_W*2/3 - 80*YZAdapter + 30*YZAdapter);
        make.top.equalTo(_backGroundView).offset(50*YZAdapter);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(90*YZAdapter);
    }];
    
    
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundView).offset(50*YZAdapter);
        make.right.equalTo(_backGroundView).offset(-30*YZAdapter);
        make.width.mas_equalTo(Screen_W/3-20*YZAdapter);
        make.height.mas_equalTo(55*YZAdapter);
    }];
    
    [_costTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundView).offset(90*YZAdapter);
        make.right.equalTo(_backGroundView).offset(-30*YZAdapter);
        make.width.mas_equalTo(Screen_W/3-20*YZAdapter);
        make.height.mas_equalTo(55*YZAdapter);
    }];
    
    [_horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backGroundView).offset(15*YZAdapter);
        make.bottom.equalTo(_costTypeLabel).offset(5*YZAdapter);
        make.width.mas_equalTo(Screen_W -50*YZAdapter);
        make.height.mas_equalTo(1);
    }];

    CGFloat height = [JHTools heightOfConttent:_cellModel.remark fontSize:18*Size_ratio maxWidth:Screen_W-50*YZAdapter];

    [_describeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundView).offset(160*YZAdapter);
        make.left.equalTo(_backGroundView).offset(15*YZAdapter);
        make.width.mas_equalTo(Screen_W-50*YZAdapter);
        make.height.mas_equalTo(height*YZAdapter);
    }];

}
#pragma mark =========== Event
- (NSAttributedString *)AttribytedStringWithstr:(NSString *)str changeStr:(NSString *)changeStr color:(UIColor *)color
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = [str rangeOfString:changeStr];
    
    [string addAttribute:NSForegroundColorAttributeName
                   value:color
                   range:range];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont boldSystemFontOfSize:30*Size_ratio]
                   range:range];
    
    return string;
}

- (void)setCellModel:(CompeletedModel *)cellModel
{
    _cellModel = cellModel;
    _typeLabel.text = _cellModel.type_name;
    _timeLabel.text = [JHTools converToFormatDate:_cellModel.arise_datetime];
    NSString * str = [NSString stringWithFormat:@"距您约 %@ 公里",_cellModel.distance];
    _addressLabel.attributedText = [self AttribytedStringWithstr:str changeStr:_cellModel.distance color:[UIColor blackColor]];
    
    _nearbyLabel.text = _cellModel.arise_address;
    
    NSString * costStr = [NSString stringWithFormat:@"%@ 元",_cellModel.reward];
    _costLabel.attributedText = [self AttribytedStringWithstr:costStr changeStr:_cellModel.reward color:[UIColor blackColor]];
    _describeLabel.text = [NSString stringWithFormat:@"%@",_cellModel.remark];
    if (_cellModel.remark.length > 21) {
        _describeLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        _describeLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self layoutIfNeeded];

}
#pragma mark =========== Fouction
- (void)setUI
{
    self.backgroundColor = [UIColor whiteColor];
    _typeLabel.textColor = [UIColor jhTodoCellTitleGary];
    _typeLabel.backgroundColor = [UIColor jhBackGroundColor];
    _typeLabel.font = [UIFont systemFontOfSize:14*Size_ratio];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    
    _timeLabel.textColor = [UIColor jhTodoCellTitleGary];
    _timeLabel.font = [UIFont systemFontOfSize:14*Size_ratio];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    _addressLabel.textColor = [UIColor blackColor];
    _addressLabel.font = [UIFont systemFontOfSize:20*Size_ratio];
    _addressLabel.adjustsFontSizeToFitWidth = YES;
    _addressLabel.numberOfLines = 0;
    _addressLabel.textAlignment = NSTextAlignmentCenter;
    _nearbyLabel.textColor = [UIColor grayColor];
    _nearbyLabel.font = [UIFont systemFontOfSize:16*Size_ratio];
    _nearbyLabel.textAlignment = NSTextAlignmentCenter;
    _nearbyLabel.numberOfLines = 0;
    
    _costLabel.textColor = [UIColor blackColor];
    _costLabel.font = [UIFont systemFontOfSize:20*Size_ratio];
    _costLabel.textAlignment = NSTextAlignmentCenter;
    _costLabel.numberOfLines = 0;
    
    _costTypeLabel.textColor = [UIColor grayColor];
    _costTypeLabel.font = [UIFont systemFontOfSize:16*Size_ratio];
    _costTypeLabel.text = @"勘查奖励";
    _costTypeLabel.textAlignment = NSTextAlignmentCenter;
    
    _costLabel.adjustsFontSizeToFitWidth = YES;
    
    _describeLabel.textColor = [UIColor jhTodoCellTitleGary];
    _describeLabel.font = [UIFont systemFontOfSize:18*Size_ratio];
    _describeLabel.numberOfLines = 0;

    _verticalLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _horizontalLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (CGFloat)cellHeightWithModel:(CompeletedModel *)model
{
    
    CGFloat height = [JHTools heightOfConttent:model.remark fontSize:18*Size_ratio maxWidth:Screen_W-50*YZAdapter];
    
    return 190*YZAdapter + height*YZAdapter;
}
+ (CGFloat)HomeCellHeightWithModel:(CompeletedModel *)model
{
    return [[self alloc] cellHeightWithModel:model];
}

@end
