//
//  YZPromptViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZPromptViewCell.h"

@implementation YZPromptViewCell

- (void)dealloc
{
    
    self.PromptLabel = nil;
    self.PromptImage = nil;
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
    
    _PromptLabel = [UILabel new];
    _PromptLabel.font = FONT(12);
    _PromptLabel.textColor = TimeMainFont_Color;
    // 不同文字字体的颜色
    NSMutableAttributedString *CertificateNamestring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", @"证件信息照上传",  @"(请拍摄清晰的照片)"] attributes:nil];
    [CertificateNamestring addAttribute:NSForegroundColorAttributeName value:MainFont_Color range:NSMakeRange(0, 7)];
    [CertificateNamestring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 7)];
    _PromptLabel.attributedText = CertificateNamestring;
    [self addSubview:_PromptLabel];
    
    _PromptImage = [UIImageView new];
    [self addSubview:_PromptImage];
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    [_PromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20*YZAdapter);
        make.top.equalTo(self).offset(20*YZAdapter);
        make.width.mas_equalTo(295*YZAdapter);
        make.height.mas_equalTo(15*YZAdapter);
    }];
    
    [_PromptImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Screen_W - 40*YZAdapter);
        make.top.equalTo(self).offset(20*YZAdapter);
        make.height.mas_equalTo(20*YZAdapter);
        make.width.mas_equalTo(20*YZAdapter);
    }];
    

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
