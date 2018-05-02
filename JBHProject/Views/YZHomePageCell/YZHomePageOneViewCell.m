//
//  YZHomePageOneViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/8/22.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZHomePageOneViewCell.h"
#import "YZHomePageOneModel.h"
@implementation YZHomePageOneViewCell



- (void)dealloc
{
    
    self.CompleteLabel = nil;
    self.CompleteNumber = nil;
    self.OnewView = nil;
    self.IncomeLabel = nil;
    self.Income = nil;
    self.TWowView = nil;
    self.HighPraiseLabel = nil;
    self.HighPraise = nil;
    self.TherewView = nil;
}

// 定义一个接口给 cell 上的子控件赋值
- (void)setValueForSubViewsByAction:(YZHomePageOneModel *)YZHomePageOneModel {
    
//    self.bankImage.contentMode = UIViewContentModeScaleAspectFit;//关键在此
    
//    self.CompleteLabel.text = YZHomePageOneModel.task_count;
    
    NSString *CompleteStr = [NSString stringWithFormat:@"%@%@", YZHomePageOneModel.task_count, @"次"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:CompleteStr];
    [attrStr addAttribute:NSFontAttributeName
                    value:FONTS(20)
                    range:NSMakeRange(0, CompleteStr.length-1)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:YZEssentialColor
                    range:NSMakeRange(0, CompleteStr.length-1)];
    
    self.CompleteLabel.attributedText = attrStr;
    
    
//    self.IncomeLabel.text = YZHomePageOneModel.task_allreward;
    
    NSString *IncomeaStr = [NSString stringWithFormat:@"%@%@", YZHomePageOneModel.task_allreward, @"元"];
    
    NSMutableAttributedString *IncomeattrStr = [[NSMutableAttributedString alloc] initWithString:IncomeaStr];
    [IncomeattrStr addAttribute:NSFontAttributeName
                    value:FONTS(20)
                    range:NSMakeRange(0, IncomeaStr.length-1)];
    [IncomeattrStr addAttribute:NSForegroundColorAttributeName
                    value:YZEssentialColor
                    range:NSMakeRange(0, IncomeaStr.length-1)];
    
    self.IncomeLabel.attributedText = IncomeattrStr;
    
    
    
//    self.HighPraiseLabel.text = YZHomePageOneModel.task_rate;
    
    NSString *HighaStr = [NSString stringWithFormat:@"%@%@", @"100", @"分"];
    
    NSMutableAttributedString *HighattrStr = [[NSMutableAttributedString alloc] initWithString:HighaStr];
    [HighattrStr addAttribute:NSFontAttributeName
                    value:FONTS(20)
                    range:NSMakeRange(0, HighaStr.length-1)];
    [HighattrStr addAttribute:NSForegroundColorAttributeName
                    value:YZEssentialColor
                    range:NSMakeRange(0, HighaStr.length-1)];
    
    self.HighPraiseLabel.attributedText = HighattrStr;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.CompleteLabel];
        [self.contentView addSubview:self.CompleteNumber];
        [self.contentView addSubview:self.OnewView];
        [self.contentView addSubview:self.IncomeLabel];
        [self.contentView addSubview:self.Income];
        [self.contentView addSubview:self.TWowView];
        [self.contentView addSubview:self.HighPraiseLabel];
        [self.contentView addSubview:self.HighPraise];
        [self.contentView addSubview:self.TherewView];
    }
    return self;
}


- (UILabel *)CompleteLabel {
    if (!_CompleteLabel) {
        self.CompleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22*YZAdapter, 125*YZAdapter, 21*YZAdapter)];
        self.CompleteLabel.font = FONT(14);
        self.CompleteLabel.textColor = MainFont_Color;
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"0次"];
        [attrStr addAttribute:NSFontAttributeName
                        value:FONTS(20)
                        range:NSMakeRange(0, 1)];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:YZEssentialColor
                        range:NSMakeRange(0, 1)];
        
        self.CompleteLabel.attributedText = attrStr;
        
        self.CompleteLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _CompleteLabel;
}

- (UILabel *)CompleteNumber {
    if (!_CompleteNumber) {
        self.CompleteNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 63*YZAdapter, 125*YZAdapter, 15*YZAdapter)];
        self.CompleteNumber.text = @"已完成派单";
        self.CompleteNumber.textAlignment = NSTextAlignmentCenter;
        self.CompleteNumber.font = FONT(14);
        self.CompleteNumber.textColor = MainFont_Color;
    }
    return _CompleteNumber;
}

- (UIView *)OnewView {
    if (!_OnewView) {
        self.OnewView = [[UIView alloc] initWithFrame:CGRectMake(125*YZAdapter, 22*YZAdapter, 2*YZAdapter, 56*YZAdapter)];
        self.OnewView.backgroundColor = BackGround_Color;
//        self.OnewView.alpha = 0.6;
//        self.OnewView.layer.cornerRadius = 25.0;
//        self.OnewView.layer.masksToBounds = YES;
    }
    return _OnewView;
}



- (UILabel *)IncomeLabel {
    if (!_IncomeLabel) {
        self.IncomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(125*YZAdapter, 22*YZAdapter, 125*YZAdapter, 21*YZAdapter)];
        
        self.IncomeLabel.textAlignment = NSTextAlignmentCenter;
        self.IncomeLabel.font = FONT(14);
        self.IncomeLabel.textColor =MainFont_Color;
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"0.0元"];
        [attrStr addAttribute:NSFontAttributeName
                        value:FONTS(20)
                        range:NSMakeRange(0, 3)];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:YZEssentialColor
                        range:NSMakeRange(0, 3)];
        
        self.IncomeLabel.attributedText = attrStr;
        
    }
    return _IncomeLabel;
}
- (UILabel *)Income {
    if (!_Income) {
        self.Income = [[UILabel alloc] initWithFrame:CGRectMake(125*YZAdapter, 63*YZAdapter, 125*YZAdapter, 15*YZAdapter)];
        self.Income.text = @"本月收入";
        self.Income.textAlignment = NSTextAlignmentCenter;
        self.Income.font = FONT(14);
        self.Income.textColor = MainFont_Color;
    }
    return _Income;
}


- (UIView *)TWowView {
    if (!_TWowView) {
        self.TWowView = [[UIView alloc] initWithFrame:CGRectMake(250*YZAdapter, 22*YZAdapter, 2*YZAdapter, 56*YZAdapter)];
        self.TWowView.backgroundColor = BackGround_Color;

    }
    return _TWowView;
}


- (UILabel *)HighPraiseLabel {
    if (!_HighPraiseLabel) {
        self.HighPraiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(250*YZAdapter, 22*YZAdapter, 125*YZAdapter, 21*YZAdapter)];
        self.HighPraiseLabel.textAlignment = NSTextAlignmentCenter;
        self.HighPraiseLabel.font = FONT(14);
        self.HighPraiseLabel.textColor = MainFont_Color;
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"0分"];
        [attrStr addAttribute:NSFontAttributeName
                        value:FONTS(20)
                        range:NSMakeRange(0, 2)];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:YZEssentialColor
                        range:NSMakeRange(0, 2)];
        
        self.HighPraiseLabel.attributedText = attrStr;
    }
    return _HighPraiseLabel;
}
- (UILabel *)HighPraise {
    if (!_HighPraise) {
        self.HighPraise = [[UILabel alloc] initWithFrame:CGRectMake(250*YZAdapter, 63*YZAdapter, 125*YZAdapter, 15*YZAdapter)];
        self.HighPraise.text = @"服务分";
        self.HighPraise.textAlignment = NSTextAlignmentCenter;
        self.HighPraise.font = FONT(14);
        self.HighPraise.textColor = MainFont_Color;
    }
    return _HighPraise;
}


- (UIView *)TherewView {
    if (!_TherewView) {
        self.TherewView = [[UIView alloc] initWithFrame:CGRectMake(0, 93*YZAdapter, Screen_W, 15*YZAdapter)];
        self.TherewView.backgroundColor = YZColor(245, 245, 245);
        
    }
    return _TherewView;
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
