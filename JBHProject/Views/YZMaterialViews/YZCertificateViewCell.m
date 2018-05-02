//
//  YZCertificateViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZCertificateViewCell.h"

@implementation YZCertificateViewCell

- (void)dealloc
{
    
    self.IdCardImage = nil;
    self.DrivingImage = nil;
    self.RunImage = nil;
    self.BillImage = nil;
    
    self.IdCardLabel = nil;
    self.DrivingLabel = nil;
    self.RunLabel = nil;
    self.BillLabel = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    
    _IdCardLabel = [UILabel new];
    _IdCardLabel.text = @"身份证";
    _IdCardLabel.textAlignment = NSTextAlignmentCenter;
    _IdCardLabel.font = FONT(14);
    _IdCardLabel.textColor = WhiteColor;
    _IdCardLabel.backgroundColor = YZColor(74, 77, 91);
    [self addSubview:_IdCardLabel];
    
    _DrivingLabel = [UILabel new];
    _DrivingLabel.text = @"驾驶证";
    _DrivingLabel.textAlignment = NSTextAlignmentCenter;
    _DrivingLabel.font = FONT(14);
    _DrivingLabel.textColor = WhiteColor;
    _DrivingLabel.backgroundColor = YZColor(74, 77, 91);
    [self addSubview:_DrivingLabel];
    
    _RunLabel = [UILabel new];
    _RunLabel.text = @"行驶证";
    _RunLabel.textAlignment = NSTextAlignmentCenter;
    _RunLabel.font = FONT(14);
    _RunLabel.textColor = WhiteColor;
    _RunLabel.backgroundColor = YZColor(74, 77, 91);
    [self addSubview:_RunLabel];
    
    _BillLabel = [UILabel new];
    _BillLabel.text = @"保险大单";
    _BillLabel.textAlignment = NSTextAlignmentCenter;
    _BillLabel.font = FONT(14);
    _BillLabel.textColor = WhiteColor;
    _BillLabel.backgroundColor = YZColor(74, 77, 91);
    [self addSubview:_BillLabel];
    
    
    _IdCardImage = [UIImageView new];
    _IdCardImage.userInteractionEnabled = YES;
    _IdCardImage.image = [UIImage imageNamed:@"YZBackCarImage"];
    [self addSubview:_IdCardImage];
    
    _DrivingImage = [UIImageView new];
    _DrivingImage.userInteractionEnabled = YES;
    _DrivingImage.image = [UIImage imageNamed:@"YZBackCarImage"];
    [self addSubview:_DrivingImage];
    
    _RunImage = [UIImageView new];
    _RunImage.userInteractionEnabled = YES;
    _RunImage.image = [UIImage imageNamed:@"YZBackCarImage"];
    [self addSubview:_RunImage];
    
    _BillImage = [UIImageView new];
    _BillImage.userInteractionEnabled = YES;
    _BillImage.image = [UIImage imageNamed:@"YZBackCarImage"];
    [self addSubview:_BillImage];
    
    _IdCardImage.sd_layout
    .topSpaceToView(self, 10*YZAdapter)
    .leftSpaceToView(self, 10*YZAdapter)
    .widthIs(77*YZAdapter)
    .heightIs(77*YZAdapter);
    
    _IdCardLabel.sd_layout
    .topSpaceToView(_IdCardImage, 10*YZAdapter)
    .leftEqualToView(_IdCardImage)
    .widthIs(77*YZAdapter)
    .heightIs(25*YZAdapter); // 高度根据文字自适应
    
    _DrivingImage.sd_layout
    .topSpaceToView(self, 10*YZAdapter)
    .leftSpaceToView(_IdCardImage, 10*YZAdapter)
    .widthIs(77*YZAdapter)
    .heightIs(77*YZAdapter);
    
    _DrivingLabel.sd_layout
    .topSpaceToView(_DrivingImage, 10*YZAdapter)
    .leftEqualToView(_DrivingImage)
    .widthIs(77*YZAdapter)
    .heightIs(25*YZAdapter); // 高度根据文字自适应
    
    _RunImage.sd_layout
    .topSpaceToView(self, 10*YZAdapter)
    .leftSpaceToView(_DrivingImage, 10*YZAdapter)
    .widthIs(77*YZAdapter)
    .heightIs(77*YZAdapter);
    
    _RunLabel.sd_layout
    .topSpaceToView(_RunImage, 10*YZAdapter)
    .leftEqualToView(_RunImage)
    .widthIs(77*YZAdapter)
    .heightIs(25*YZAdapter); // 高度根据文字自适应
    
    _BillImage.sd_layout
    .topSpaceToView(self, 10*YZAdapter)
    .leftSpaceToView(_RunImage, 10*YZAdapter)
    .widthIs(77*YZAdapter)
    .heightIs(77*YZAdapter);
    
    _BillLabel.sd_layout
    .topSpaceToView(_BillImage, 10*YZAdapter)
    .leftEqualToView(_BillImage)
    .widthIs(77*YZAdapter)
    .heightIs(25*YZAdapter); // 高度根据文字自适应
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
