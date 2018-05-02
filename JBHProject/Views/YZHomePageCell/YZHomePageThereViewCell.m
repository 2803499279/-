//
//  YZHomePageThereViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/8/22.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZHomePageThereViewCell.h"
#import "YZHomePageTwoModel.h"
@implementation YZHomePageThereViewCell


- (void)dealloc
{
    self.BackView = nil;
    self.ContentImage = nil;
    self.Title = nil;
    self.promet = nil;
    self.reads = nil;
    self.start = nil;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.BackView];
        [self.contentView addSubview:self.ContentImage];
        [self.contentView addSubview:self.Title];
        [self.contentView addSubview:self.promet];
        [self.contentView addSubview:self.reads];
        [self.contentView addSubview:self.start];
        
    }
    return self;
}

// 定义一个接口给 cell 上的子控件赋值
- (void)setValueForSubViewsByAction:(YZHomePageTwoModel *)YZHomePageTwoModel {

    [self.ContentImage sd_setImageWithURL:[NSURL URLWithString:YZHomePageTwoModel.img_uri] placeholderImage:nil];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
    self.Title.text = YZHomePageTwoModel.title;
    
    self.promet.text = YZHomePageTwoModel.category;
    
    self.reads.text = YZHomePageTwoModel.read;
    
    self.start.text = YZHomePageTwoModel.good;

}
//// 返回cell高度的接口
//+ (CGFloat)PushCellHeightByYZPushIntroduce:(YZPushModel *)PushModel {
//
//    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:PushModel.pic]];
//    //    UIImage *image = [UIImage imageWithData:data];
//    //    DLog(@"w = %f,h = %f",image.size.width,image.size.height);
//    return [self summaryLabelHeightByString:PushModel.content]+imageHeight+105*YZAdapter;
//
//}
//
//// 计算sunmmaryLabel上要展示文本的高度
//+ (CGFloat)summaryLabelHeightByString:(NSString *)summary {
//    CGRect rect = [summary boundingRectWithSize:CGSizeMake(Screen_W-32*YZAdapter, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : FONT(14)} context:nil];
//    return rect.size.height;
//}



- (UIView *)BackView {
    if (!_BackView) {
        self.BackView = [[UIView alloc] initWithFrame:CGRectMake(2*YZAdapter, 0, Screen_W-4*YZAdapter, 1*YZAdapter)];
        self.BackView.backgroundColor = BackGround_Color;

    }
    return _BackView;
}

- (UIImageView *)ContentImage {
    if (!_ContentImage) {
        self.ContentImage = [[UIImageView alloc] initWithFrame:CGRectMake(12*YZAdapter, 14*YZAdapter, 106*YZAdapter, 70*YZAdapter)];
        self.ContentImage.image = [UIImage imageNamed:@"Login-background"];
        self.userInteractionEnabled = YES;
        //        self.BackImageView.layer.cornerRadius = 3;
        //        self.BackImageView.layer.masksToBounds = YES;
    }
    return _ContentImage;
}


- (UILabel *)Title {
    if (!_Title) {
        
        self.Title = [[UILabel alloc] initWithFrame:CGRectMake(130*YZAdapter, 14*YZAdapter, 235*YZAdapter, 38*YZAdapter)];
        self.Title.text = @"10年理赔数据告诉您, 保险应该买什么?";
        self.Title.font = FONT(15);
        self.Title.numberOfLines = 0;
        self.Title.textColor = MainFont_Color;
        self.Title.textAlignment = NSTextAlignmentLeft;
    }
    return _Title;
}


- (UILabel *)promet {
    if (!_promet) {
        
        self.promet = [[UILabel alloc] initWithFrame:CGRectMake(130*YZAdapter, 67*YZAdapter, 56*YZAdapter, 17*YZAdapter)];
        self.promet.text = @"速勘技巧";
        
        self.promet.layer.cornerRadius = 2.0;
        self.promet.layer.masksToBounds = YES;
        self.promet.layer.borderWidth = 1.0;
        self.promet.layer.borderColor = YZEssentialColor.CGColor;
        self.promet.layer.masksToBounds = YES;
        
        self.promet.font = FONT(10);
        self.promet.textColor = MainFont_Color;
        self.promet.textAlignment = NSTextAlignmentCenter;
    }
    return _promet;
}

- (UILabel *)reads {
    if (!_reads) {
        
        self.reads = [[UILabel alloc] initWithFrame:CGRectMake(260*YZAdapter, 75*YZAdapter, 52*YZAdapter, 11*YZAdapter)];
        self.reads.text = @"5945阅";
        self.reads.font = FONT(10);
        self.reads.textColor = TimeFont_Color;
        self.reads.textAlignment = NSTextAlignmentRight;
    }
    return _reads;
}



- (UILabel *)start {
    if (!_start) {
        
        self.start = [[UILabel alloc] initWithFrame:CGRectMake(320*YZAdapter, 75*YZAdapter, 42*YZAdapter, 11*YZAdapter)];
        self.start.text = @"1000赞";
        self.start.font = FONT(10);
        self.start.textColor = TimeFont_Color;
        self.start.textAlignment = NSTextAlignmentRight;
    }
    return _start;
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
