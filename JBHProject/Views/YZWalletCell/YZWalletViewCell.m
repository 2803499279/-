//
//  YZWalletViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/4/27.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZWalletViewCell.h"
#import "YZWalletModel.h"
@implementation YZWalletViewCell

- (void)dealloc
{
    
    self.time = nil;
    self.price = nil;
    self.Ground = nil;

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
    
    _time = [UILabel new];
    _time.text = @"2017-01-01 22:22:22";
    _time.textAlignment = NSTextAlignmentLeft;
    _time.font = FONT(16);
    _time.textColor = MainFont_Color;
    [self addSubview:_time];
    
    _price = [UILabel new];
    _price.text = @"收入100元";
    _price.textAlignment = NSTextAlignmentRight;
    _price.font = FONT(16);
    _price.textColor = MainFont_Color;
    [self addSubview:_price];
    
    _Ground = [UILabel new];
    _Ground.backgroundColor = BackGround_Color;
    [self addSubview:_Ground];
    
    _time.sd_layout
    .topSpaceToView(self, 2*YZAdapter)
    .leftSpaceToView(self, 10*YZAdapter)
    .widthIs(200*YZAdapter)
    .heightIs(50*YZAdapter);
    
    
    _price.sd_layout
    .topSpaceToView(self, 2*YZAdapter)
    .rightSpaceToView(self, 10*YZAdapter)
    .widthIs(160*YZAdapter)
    .heightIs(50*YZAdapter);
    
    _Ground.sd_layout
    .topSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .widthIs(Screen_W)
    .heightIs(2*YZAdapter);
}

// 定义一个接口给 cell 上的子控件赋值
- (void)setValueForSubViewsByAction:(YZWalletModel *)YZWalletModel {
    
    _time.text = YZWalletModel.datetime;
    
    if ([YZWalletModel.money integerValue] >= 0) {
        _price.text = [NSString stringWithFormat:@"收入%@元", YZWalletModel.money];
    }else {
        _price.text = [NSString stringWithFormat:@"提现%@元", YZWalletModel.money];
    }    
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
