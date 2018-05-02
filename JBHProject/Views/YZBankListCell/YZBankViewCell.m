//
//  YZBankViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/5/8.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZBankViewCell.h"

@implementation YZBankViewCell

- (void)dealloc
{
    self.bankImage = nil;
    self.bankLabel = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bankImage];
        [self.contentView addSubview:self.bankLabel];
    }
    return self;
}

- (UIImageView *)bankImage {
    if (!_bankImage) {
        self.bankImage = [[UIImageView alloc] initWithFrame:CGRectMake(17*YZAdapter, 8*YZAdapter, 28*YZAdapter, 28*YZAdapter)];
        //        self.bankImage.image = [UIImage imageNamed:@"gongshang_s"];
        self.bankImage.contentMode = UIViewContentModeScaleAspectFit;//关键在此
        self.bankImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gongshang_s" ofType:@"png"]];
        
    }
    return _bankImage;
}


- (UILabel *)bankLabel {
    if (!_bankLabel) {
        self.bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(70*YZAdapter, 15*YZAdapter, 180*YZAdapter, 15*YZAdapter)];
        self.bankLabel.text = @"";
        self.bankLabel.font = FONT(14);
        self.bankLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    }
    return _bankLabel;
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
