//
//  YZNewHomeZoneCell.m
//  JBHProject
//
//  Created by zyz on 2018/1/9.
//  Copyright © 2018年 聚宝汇. All rights reserved.
//

#import "YZNewHomeZoneCell.h"
#import "YZNewHomeModel.h"
@implementation YZNewHomeZoneCell


- (void)dealloc
{
    
    self.Title = nil;
    self.Date = nil;
    self.BView = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.Title];
        [self.contentView addSubview:self.Date];
        [self.contentView addSubview:self.BView];
    }
    return self;
}


// 定义一个接口给 cell 上的子控件赋值
- (void)setValueForSubViewsByAction:(YZNewHomeModel *)homeOneModel{

    self.Title.text = homeOneModel.name;
    
    
    NSInteger num = [homeOneModel.ctime integerValue];
    NSNumber * nums = @(num);
    
    NSString *str1=[NSString stringWithFormat:@"%@", nums];
    
    if ([YZUtil isBlankString:str1] || str1.length == 1) {
        self.Date.text = @"1970-01-01";
    } else {
        
        if (str1.length == 11) {
            NSTimeInterval time=[[str1 substringToIndex:8] doubleValue];//因为时差问题要加8小时 == 28800 sec
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            self.Date.text = [dateFormatter stringFromDate: detaildate];
        }else if (str1.length == 12) {
            NSTimeInterval time=[[str1 substringToIndex:9] doubleValue];//因为时差问题要加8小时 == 28800 sec
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            self.Date.text = [dateFormatter stringFromDate: detaildate];
        }else{
            NSTimeInterval time=[[str1 substringToIndex:10] doubleValue];
            
            NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            
            //实例化一个NSDateFormatter对象
            
            NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
            
            //设定时间格式,这里可以设置成自己需要的格式
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.Date.text = [dateFormatter stringFromDate:detaildate];
        }
        
    }
    
    // 文章内容的高度
    CGRect TFrame = self.Title.frame;
    TFrame.size.height = [[self class] summaryLabelHeightByString:homeOneModel.name];
    self.Title.frame = TFrame;
    
    // 文章时间的展示位置
    
    CGRect DFrame = self.Date.frame;
    DFrame.origin.y = 30*YZAdapter+TFrame.size.height;
    self.Date.frame = DFrame;
    
    // 分割线的位置
    CGRect BFrame = self.BView.frame;
    BFrame.origin.y = [[self class] summaryLabelHeightByString:homeOneModel.name]+66*YZAdapter;
    self.BView.frame = BFrame;
}


// 返回cell高度的接口
+ (CGFloat)EvaluationCellHeightByEvaluation:(NSString *)sender {
    return [self summaryLabelHeightByString:sender]+67*YZAdapter;
}

// 计算sunmmaryLabel上要展示文本的高度
+ (CGFloat)summaryLabelHeightByString:(NSString *)summary {
    
    CGRect rect = [summary boundingRectWithSize:CGSizeMake(Screen_W*YZAdapter, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : FONT(15)} context:nil];
    
    if (rect.size.height > 38*YZAdapter) {
        return 38*YZAdapter;
    }else {
        return 16*YZAdapter;
    }    
}


// 懒加载
- (UILabel *)Title {
    if (!_Title) {
        
        self.Title = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 16*YZAdapter, 345*YZAdapter, 38*YZAdapter)];
        self.Title.text = @"10年理赔数据告诉您, 保险应该买什么?10年理赔数据告诉您, 保险应该买什么?";
        self.Title.font = FONT(15);
        self.Title.numberOfLines = 0;
        self.Title.textColor = MainFont_Color;
        self.Title.textAlignment = NSTextAlignmentLeft;
    }
    return _Title;
}

- (UILabel *)Date {
    if (!_Date) {
        
        self.Date = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 50*YZAdapter, 200*YZAdapter, 13*YZAdapter)];
        self.Date.text = @"2016-11-11";
        self.Date.font = FONT(12);
        self.Date.textColor = TimeMainFont_Color;
        self.Date.textAlignment = NSTextAlignmentLeft;
    }
    return _Date;
}

- (UIView *)BView {
    if (!_BView) {
        
        self.BView = [[UIView alloc] initWithFrame:CGRectMake(0, 76*YZAdapter, Screen_W, 1*YZAdapter)];
        self.BView.backgroundColor = YZDivisionColor;
    }
    return _BView;
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
