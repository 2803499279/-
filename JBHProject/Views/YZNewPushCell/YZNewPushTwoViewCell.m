//
//  YZNewPushTwoViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/5/15.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZNewPushTwoViewCell.h"

@implementation YZNewPushTwoViewCell

- (void)dealloc
{
    
//    self.OneView = nil;
    
    self.Title = nil;
    self.Time = nil;
    self.Content = nil;
    
    self.BackGroundView = nil;
    self.BackView = nil;
    self.details = nil;
    self.BackImageView = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        [self.contentView addSubview:self.OneView];
        
        [self.contentView addSubview:self.Title];
        [self.contentView addSubview:self.Time];
        [self.contentView addSubview:self.Content];
        
//        [self.contentView addSubview:self.BackGroundView];
        [self.contentView addSubview:self.BackView];
        [self.contentView addSubview:self.details];
        [self.contentView addSubview:self.BackImageView];
        
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
        
//        if (str1.length == 11) {
//            
//            NSTimeInterval time=[[str1 substringToIndex:8] doubleValue];//因为时差问题要加8小时 == 28800 sec
//            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//            //实例化一个NSDateFormatter对象
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            //设定时间格式,这里可以设置成自己需要的格式
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//            self.Time.text = [dateFormatter stringFromDate: detaildate];
//            
//        }else if (str1.length == 12) {
//            
//            NSTimeInterval time=[[str1 substringToIndex:9] doubleValue];//因为时差问题要加8小时 == 28800 sec
//            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//            //实例化一个NSDateFormatter对象
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            //设定时间格式,这里可以设置成自己需要的格式
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//            self.Time.text = [dateFormatter stringFromDate: detaildate];
//            
//        }else{
//            
//            NSTimeInterval time=[[str1 substringToIndex:10] doubleValue];
//            NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//            //实例化一个NSDateFormatter对象
//            NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
//            //设定时间格式,这里可以设置成自己需要的格式
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//            self.Time.text = [dateFormatter stringFromDate:detaildate];
        
            NSString *NowTime =  [JHTools converToFormatDate:str1];
            self.Time.text = NowTime;
            
//        }
    }
    
    self.Content.text = PushModel.content;
    CGRect ContentFrame = self.Content.frame;
    ContentFrame.size.height = [[self class] summaryLabelHeightByString:PushModel.content];
    self.Content.frame = ContentFrame;
    
    CGRect BackViewFrame = self.BackView.frame;
    BackViewFrame.origin.y = ContentFrame.size.height+ContentFrame.origin.y+10*YZAdapter;
    self.BackView.frame = BackViewFrame;
    
    CGRect BackGroundViewFrame = self.BackGroundView.frame;
    BackGroundViewFrame.origin.y = BackViewFrame.size.height+BackViewFrame.origin.y+11*YZAdapter;
    self.BackGroundView.frame = BackGroundViewFrame;
    
    
    CGRect detailsFrame = self.details.frame;
    detailsFrame.origin.y = BackViewFrame.size.height+BackViewFrame.origin.y+15*YZAdapter;
    self.details.frame = detailsFrame;
    
    
    CGRect BackImageViewFrame = self.BackImageView.frame;
    BackImageViewFrame.origin.y = BackViewFrame.size.height+BackViewFrame.origin.y+15*YZAdapter;
    self.BackImageView.frame = BackImageViewFrame;
}

// 返回cell高度的接口
+ (CGFloat)PushCellHeightByYZPushIntroduce:(YZPushModel *)PushModel {
    return [self summaryLabelHeightByString:PushModel.content]+105*YZAdapter;
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
        
        self.Content = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 50*YZAdapter, Screen_W-30*YZAdapter, 10*YZAdapter)];
        self.Content.text = @"2016-11-11";
        self.Content.font = FONT(14);
        self.Content.textColor = TimeFont_Color;
        self.Content.numberOfLines = 0;
        self.Content.textAlignment = NSTextAlignmentLeft;
    }
    return _Content;
}

- (UIView *)BackView {
    if (!_BackView) {
        self.BackView = [[UIView alloc] initWithFrame:CGRectMake(16*YZAdapter, 10*YZAdapter, Screen_W-16*YZAdapter, 1*YZAdapter)];
        self.BackView.backgroundColor = YZColor(240, 240, 240);
    }
    return _BackView;
}


- (UIButton *)BackGroundView {
    if (!_BackGroundView) {
        self.BackGroundView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.BackGroundView.frame = CGRectMake(0, 10*YZAdapter, Screen_W, 45*YZAdapter);
//        self.BackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 10*YZAdapter, Screen_W, 45*YZAdapter)];
//        self.BackGroundView.userInteractionEnabled = YES;
    }
    return _BackGroundView;
}


- (UILabel *)details {
    if (!_details) {
        
        self.details = [[UILabel alloc] initWithFrame:CGRectMake(16*YZAdapter, 80*YZAdapter, 100*YZAdapter, 17*YZAdapter)];
        self.details.text = @"查看详情";
        self.details.font = FONT(14);
        self.details.textColor = TimeFont_Color;
        self.details.numberOfLines = 0;
        self.details.textAlignment = NSTextAlignmentLeft;
    }
    return _details;
}

- (UIImageView *)BackImageView {
    if (!_BackImageView) {
        self.BackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_W-25*YZAdapter, 15*YZAdapter, 7*YZAdapter, 16*YZAdapter)];
        self.BackImageView.image = [UIImage imageNamed:@"YZFH"];
        self.userInteractionEnabled = YES;
        //        self.BackImageView.layer.cornerRadius = 3;
        //        self.BackImageView.layer.masksToBounds = YES;
    }
    return _BackImageView;
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
