//
//  YZBankListViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/5/6.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZBankListViewCell.h"
#import "YZBankListModel.h"

@implementation YZBankListViewCell


- (void)dealloc
{
    
    self.backgroundImage = nil;
    self.bankGroImage = nil;
    self.bankImage = nil;
    self.bankLabel = nil;
    self.blockLabel = nil;
    self.NumberLabel = nil;
    self.TailNumberLabel = nil;
}

// 定义一个接口给 cell 上的子控件赋值
- (void)setValueForSubViewsByAction:(YZBankListModel *)YZBankListModel {
    
    self.bankImage.contentMode = UIViewContentModeScaleAspectFit;//关键在此
    
    self.bankLabel.text = YZBankListModel.bank_name;
    NSString *SNumber = [[YZBankListModel.cardno noWhiteSpaceString] substringFromIndex:[YZBankListModel.cardno noWhiteSpaceString].length-4];
    self.TailNumberLabel.text = SNumber;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backgroundImage];
        [self.backgroundImage addSubview:self.bankGroImage];
        [self.backgroundImage addSubview:self.bankImage];
        [self.backgroundImage addSubview:self.bankLabel];
        [self.backgroundImage addSubview:self.blockLabel];
        [self.backgroundImage addSubview:self.NumberLabel];
        [self.backgroundImage addSubview:self.TailNumberLabel];
    }
    return self;
}

- (UIImageView *)backgroundImage {
    if (!_backgroundImage) {
        self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*YZAdapter, 0, Screen_W - 20*YZAdapter, 142*YZAdapter)];
//        self.backgroundImage.backgroundColor = YZColor(64, 102, 175);
        self.backgroundImage.layer.cornerRadius = 10.0f;
        self.backgroundImage.layer.masksToBounds = YES;
        self.backgroundImage.image = [UIImage imageNamed:@"BackBackGro"];
    }
    return _backgroundImage;
}

- (UIView *)bankGroImage {
    if (!_bankGroImage) {
        self.bankGroImage = [[UIView alloc] initWithFrame:CGRectMake(10*YZAdapter, 10*YZAdapter, 50*YZAdapter, 50*YZAdapter)];
        self.bankGroImage.backgroundColor = WhiteColor;
        self.bankGroImage.alpha = 0.6;
        self.bankGroImage.layer.cornerRadius = 25.0;
        self.bankGroImage.layer.masksToBounds = YES;
    }
    return _bankGroImage;
}

- (UIImageView *)bankImage {
    if (!_bankImage) {
        self.bankImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*YZAdapter, 15*YZAdapter, 40*YZAdapter, 40*YZAdapter)];
        self.bankImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gongshang_s" ofType:@"png" ]];
    }
    return _bankImage;
}


- (UILabel *)bankLabel {
    if (!_bankLabel) {
        self.bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(70*YZAdapter, 15*YZAdapter, 160*YZAdapter, 15*YZAdapter)];
        self.bankLabel.text = @"中国工商银行";
        self.bankLabel.font = FONT(14);
        self.bankLabel.textColor = [UIColor whiteColor];
    }
    return _bankLabel;
}

- (UILabel *)blockLabel {
    if (!_blockLabel) {
        self.blockLabel = [[UILabel alloc] initWithFrame:CGRectMake(70*YZAdapter, 40*YZAdapter, 160*YZAdapter, 15*YZAdapter)];
        self.blockLabel.text = @"储蓄卡";
        self.blockLabel.font = FONT(14);
        self.blockLabel.textColor = [UIColor whiteColor];
    }
    return _blockLabel;
}


- (UILabel *)NumberLabel {
    if (!_NumberLabel) {
        self.NumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 105*YZAdapter, (Screen_W - 60*YZAdapter)/4*3, 30*YZAdapter)];
        self.NumberLabel.text = @"**** **** **** ";
        self.NumberLabel.textAlignment = NSTextAlignmentRight;
        self.NumberLabel.font = FONT(30);
        self.NumberLabel.textColor = [UIColor whiteColor];
    }
    return _NumberLabel;
}
- (UILabel *)TailNumberLabel {
    if (!_TailNumberLabel) {
        self.TailNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake((Screen_W - 60*YZAdapter)/4*3, 100*YZAdapter, (Screen_W - 60*YZAdapter)/4, 30*YZAdapter)];
        self.TailNumberLabel.text = @"1234";
        self.TailNumberLabel.textAlignment = NSTextAlignmentRight;
        self.TailNumberLabel.font = FONT(30);
        self.TailNumberLabel.textColor = [UIColor whiteColor];
    }
    return _TailNumberLabel;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIView *subView in self.subviews) {
            
            if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
                UIView *view = ((UIView *)[subView.subviews firstObject]);
                
//                view.backgroundColor = [UIColor clearColor];
//                view.superview.backgroundColor = [UIColor clearColor];
//                
//                NSLog(@"%@", view.subviews[0]);
//                
//                //替换字体
//                [view.subviews[0] setValue:@"删除" forKey:@"text"];
                //替换字体颜色
//                [view.subviews[0] setValue:[UIColor redColor] forKeyPath:@"textColor"];
                
                //也可以直接设置view.layer 但是不会出现边框跟着移动的效果(下图), 这也说明了, UITableViewCellDeleteConfirmationView的frame是跟着你的手指移动在变化的
                
//                UIView *supview = view.superview;
//                
//                CGFloat width = supview.frame.origin.x;
//                
//                CGRect ContentFrame = supview.frame;
//                ContentFrame.origin.x = width - 10*YZAdapter;
//                supview.frame = ContentFrame;
                
                view.superview.layer.cornerRadius = 10.0;
                view.superview.layer.borderWidth = 2.0;
                view.superview.layer.borderColor = [UIColor clearColor].CGColor;
                view.superview.layer.masksToBounds = YES;
                
                
            }
        }
    });
    
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
