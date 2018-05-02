//
//  YZSubmitAuditViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/4/11.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZSubmitAuditViewCell.h"

@implementation YZSubmitAuditViewCell

- (void)dealloc
{
    self.SubmitAudit = nil;
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
    
    _SubmitAudit = [UIButton buttonWithType:UIButtonTypeSystem];
    [_SubmitAudit setTitle:@"提交实时审核" forState:UIControlStateNormal];
    _SubmitAudit.tintColor = [UIColor whiteColor];
    _SubmitAudit.backgroundColor = GreenButton_Color;
    _SubmitAudit.titleLabel.font = FONT(17);
    
    [self addSubview:_SubmitAudit];
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_SubmitAudit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15*YZAdapter);
        make.top.equalTo(self).offset(10*YZAdapter);
        make.width.mas_equalTo(355*YZAdapter);
        make.height.mas_equalTo(35*YZAdapter);
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
