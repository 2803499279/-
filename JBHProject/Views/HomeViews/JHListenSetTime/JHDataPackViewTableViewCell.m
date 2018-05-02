//
//  JHDataPackViewTableViewCell.m
//  SetTimeDemo
//
//  Created by 李俊恒 on 2017/4/25.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "JHDataPackViewTableViewCell.h"

@implementation JHDataPackViewTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _statrTimeLabel = [[UILabel alloc]init];
        _endTimeLabel = [[UILabel alloc]init];
        
        [self addSubview:_statrTimeLabel];
        [self addSubview:_endTimeLabel];
        [self setUI];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _statrTimeLabel.frame = CGRectMake(4*Size_ratio, 5*Size_ratio, self.frame.size.width*0.5 - 10*Size_ratio, 40*Size_ratio);
//    _statrTimeLabel.backgroundColor = [UIColor redColor];
    _endTimeLabel.frame = CGRectMake(self.frame.size.width*0.5, 5*Size_ratio, self.frame.size.width*0.5 - 10*Size_ratio, 40*Size_ratio);
//    _endTimeLabel.backgroundColor = [UIColor blueColor];
}
- (void)setUI
{
    _statrTimeLabel.textColor = MainFont_Color;
    _statrTimeLabel.font = FONT(15);
    _statrTimeLabel.textAlignment = NSTextAlignmentCenter;

    _endTimeLabel.textColor = MainFont_Color;
    _endTimeLabel.textAlignment = NSTextAlignmentCenter;
    _endTimeLabel.font = FONT(15);
    [self layoutIfNeeded];
}
@end
