//
//  YZNewPushOneCell.m
//  JBHProject
//
//  Created by zyz on 2017/5/15.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZNewPushOneCell.h"

@implementation YZNewPushOneCell

- (void)dealloc
{
//    self.OneView = nil;
    self.Title = nil;
    self.Time = nil;
    self.Content = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        [self.contentView addSubview:self.OneView];
        [self.contentView addSubview:self.Title];
        [self.contentView addSubview:self.Time];
        [self.contentView addSubview:self.Content];
        
    }
    return self;
}

// 定义一个接口给 cell 上的子控件赋值
- (void)setValueForSubViewsByYZPush:(YZPushModel *)PushModel {
    
    self.Title.text = PushModel.title;
    
    NSInteger num = [PushModel.datetime integerValue];
    NSNumber * nums = @(num);
    
    NSString *str1=[NSString stringWithFormat:@"%@", nums];
    
    if ([YZUtil isBlankString:str1] || str1.length == 1) {
        self.Time.text = @"1970-01-01";
    } else {

        NSString *NowTime =  [JHTools converToFormatDate:str1];
        self.Time.text = NowTime;
    }
    
    self.Content.text = PushModel.content;
    CGRect ContentFrame = self.Content.frame;
    ContentFrame.size.height = [[self class] summaryLabelHeightByString:PushModel.content];
    self.Content.frame = ContentFrame;
    
}

// 返回cell高度的接口
+ (CGFloat)PushCellHeightByYZPushIntroduce:(YZPushModel *)PushModel {
    return [self summaryLabelHeightByString:PushModel.content]+58*YZAdapter;
}

// 计算sunmmaryLabel上要展示文本的高度
+ (CGFloat)summaryLabelHeightByString:(NSString *)summary {
    CGRect rect = [summary boundingRectWithSize:CGSizeMake(Screen_W-32*YZAdapter, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : FONT(14)} context:nil];
    return rect.size.height;
}


// 懒加载

//- (UIView *)OneView {
//    if (!_OneView) {
//        
//        self.OneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 20*YZAdapter)];
//        self.OneView.backgroundColor = BackGround_Color;
//    }
//    return _OneView;
//}


- (UILabel *)Title {
    if (!_Title) {
        
        self.Title = [[UILabel alloc] initWithFrame:CGRectMake(16*YZAdapter, 18*YZAdapter, 250*YZAdapter, 16*YZAdapter)];
        self.Title.text = @"10年理赔数据告诉您, 保险应该买什么?";
        self.Title.font = FONT(16);
        self.Title.textColor = MainFont_Color;
        self.Title.textAlignment = NSTextAlignmentLeft;
    }
    return _Title;
}



- (UILabel *)Time {
    if (!_Time) {
        
        self.Time = [[UILabel alloc] initWithFrame:CGRectMake(265*YZAdapter, 18*YZAdapter, 95*YZAdapter, 16*YZAdapter)];
        self.Time.text = @"2016-11-11";
        self.Time.font = FONT(10);
        self.Time.textColor = TimeFont_Color;
        self.Time.textAlignment = NSTextAlignmentRight;
    }
    return _Time;
}


- (UILabel *)Content {
    if (!_Content) {
        
        self.Content = [[UILabel alloc] initWithFrame:CGRectMake(16*YZAdapter, 50*YZAdapter, Screen_W-32*YZAdapter, 10*YZAdapter)];
        self.Content.text = @"2016-11-11";
        self.Content.font = FONT(14);
        self.Content.textColor = TimeFont_Color;
        [self changeLineSpaceForLabel:self.Content WithSpace:8*YZAdapter];
        self.Content.numberOfLines = 0;
        self.Content.textAlignment = NSTextAlignmentLeft;
    }
    return _Content;
}


- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

//- (void)layoutSubviews {
//    
//    [super layoutSubviews];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        for (UIView *subView in self.subviews) {
//            
//            if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
//                UIView *view = ((UIView *)[subView.subviews firstObject]);
//                
//                //                view.backgroundColor = [UIColor clearColor];
//                //                view.superview.backgroundColor = [UIColor clearColor];
//                //
//                //                NSLog(@"%@", view.subviews[0]);
//                //
//                //                //替换字体
//                //                [view.subviews[0] setValue:@"删除" forKey:@"text"];
//                //替换字体颜色
//                //                [view.subviews[0] setValue:[UIColor redColor] forKeyPath:@"textColor"];
//                
//                //也可以直接设置view.layer 但是不会出现边框跟着移动的效果(下图), 这也说明了, UITableViewCellDeleteConfirmationView的frame是跟着你的手指移动在变化的
//                view.superview.layer.cornerRadius = 10.0;
//                view.superview.layer.borderWidth = 2.0;
//                view.superview.layer.borderColor = [UIColor clearColor].CGColor;
//                view.superview.layer.masksToBounds = YES;
//                
//                
//            }
//        }
//    });
//    
//}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
