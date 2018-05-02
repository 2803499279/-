//
//  YZIdentityViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZIdentityViewCell.h"

@implementation YZIdentityViewCell


- (void)dealloc
{
    
    self.name = nil;
    self.IdNumber = nil;
    self.CarNumber = nil;
    self.ChassisNumber = nil;
    
    self.PromptImage = nil;
    
    self.divider = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.divider];
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    
    _name = [UILabel new];
    _name.font = FONT(12);
    _name.textColor = MainFont_Color;
    // 不同文字字体的颜色
    NSMutableAttributedString *CertificateNamestring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", @"身份证姓名:",  @"王红"] attributes:nil];
    [CertificateNamestring addAttribute:NSForegroundColorAttributeName value:TimeFont_Color range:NSMakeRange(0, 6)];
//    [CertificateNamestring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 7)];
    _name.attributedText = CertificateNamestring;
    [self addSubview:_name];
    
    _IdNumber = [UILabel new];
    _IdNumber.font = FONT(12);
    _IdNumber.textColor = MainFont_Color;
    // 不同文字字体的颜色
    NSMutableAttributedString *CertificateIdNumberstring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", @"身份证号码:",  @"412729199010144568"] attributes:nil];
    [CertificateIdNumberstring addAttribute:NSForegroundColorAttributeName value:TimeFont_Color range:NSMakeRange(0, 6)];
//    [CertificateIdNumberstring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 7)];
    _IdNumber.attributedText = CertificateIdNumberstring;
    [self addSubview:_IdNumber];
    
    _CarNumber = [UILabel new];
    _CarNumber.font = FONT(12);
    _CarNumber.textColor = MainFont_Color;
    // 不同文字字体的颜色
    NSMutableAttributedString *CertificateCarNumberstring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", @"车牌号:",  @"豫A98546"] attributes:nil];
    [CertificateCarNumberstring addAttribute:NSForegroundColorAttributeName value:TimeFont_Color range:NSMakeRange(0, 4)];
//    [CertificateCarNumberstring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 7)];
    _CarNumber.attributedText = CertificateCarNumberstring;
    [self addSubview:_CarNumber];
    
    _ChassisNumber = [UILabel new];
    _ChassisNumber.font = FONT(12);
    _ChassisNumber.textColor = MainFont_Color;
    // 不同文字字体的颜色
    NSMutableAttributedString *CertificateChassisNumberstring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", @"车架号:",  @"LBS41108119900408"] attributes:nil];
    [CertificateChassisNumberstring addAttribute:NSForegroundColorAttributeName value:TimeFont_Color range:NSMakeRange(0, 4)];
//    [CertificateChassisNumberstring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 7)];
    _ChassisNumber.attributedText = CertificateChassisNumberstring;
    [self addSubview:_ChassisNumber];
    
    
    _PromptImage = [UIImageView new];
    [self addSubview:_PromptImage];
    
    
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    // 文本
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20*YZAdapter);
        make.top.equalTo(self).offset(15*YZAdapter);
        make.width.mas_equalTo(295*YZAdapter);
        make.height.mas_equalTo(13*YZAdapter);
    }];
    
    [_IdNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20*YZAdapter);
        make.top.equalTo(self).offset(40*YZAdapter);
        make.width.mas_equalTo(295*YZAdapter);
        make.height.mas_equalTo(13*Size_ratio);
    }];
    
    [_CarNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20*YZAdapter);
        make.top.equalTo(self).offset(65*YZAdapter);
        make.width.mas_equalTo(295*YZAdapter);
        make.height.mas_equalTo(13*YZAdapter);
    }];
    
    [_ChassisNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20*YZAdapter);
        make.top.equalTo(self).offset(90*YZAdapter);
        make.width.mas_equalTo(295*YZAdapter);
        make.height.mas_equalTo(13*YZAdapter);
    }];
    
    // 图片
    [_PromptImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Screen_W - 40*YZAdapter);
        make.top.equalTo(self).offset(10*YZAdapter);
        make.height.mas_equalTo(15*YZAdapter);
        make.width.mas_equalTo(15*YZAdapter);
    }];
    
    
    
}

// 分割线
- (UIImageView *)divider {
    if (!_divider) {
        
        self.divider = [[UIImageView alloc] initWithFrame:CGRectMake(10*YZAdapter, 5*YZAdapter, 355*YZAdapter, 1*YZAdapter)];
        
        self.divider.image = [self drawLineOfDashByImageView:self.divider];
        
    }
    return _divider;
}

- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {5,5};
    
    CGContextSetStrokeColorWithColor(line, TimeFont_Color.CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    
    CGContextMoveToPoint(line, 0.0, 2.0);
    
    CGContextAddLineToPoint(line, 355*YZAdapter, 2.0);
    
    CGContextStrokePath(line);
    
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
