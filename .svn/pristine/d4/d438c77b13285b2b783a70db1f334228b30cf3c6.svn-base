//
//  YZInstructionsViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/4/11.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZInstructionsViewCell.h"

@implementation YZInstructionsViewCell

- (void)dealloc
{
    
    self.placeholderView = nil;
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
    
    _placeholderView = [YZPlaceholderTextView new];
    _placeholderView.backgroundColor = [UIColor whiteColor];
    _placeholderView.placeholder = @"请简单描述你的问题和意见(请输入200字以内的内容)";
    _placeholderView.textColor =TimeFont_Color;
    _placeholderView.returnKeyType = UIReturnKeyNext;
    
    _placeholderView.layer.borderWidth = 1.0;
    _placeholderView.layer.borderColor = TimeFont_Color.CGColor;
    _placeholderView.layer.cornerRadius = 5.0;
    _placeholderView.layer.masksToBounds = YES;
    
    [self addSubview:_placeholderView];
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20*YZAdapter);
        make.top.equalTo(self).offset(20*YZAdapter);
        make.width.mas_equalTo(335*YZAdapter);
        make.height.mas_equalTo(66*YZAdapter);
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
