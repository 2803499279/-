//
//  YZNullView.m
//  JBHProject
//
//  Created by zyz on 2018/3/29.
//  Copyright © 2018年 聚宝汇. All rights reserved.
//

#import "YZNullView.h"

@interface YZNullView ()
@property(nonatomic,strong)UIImageView * NullImage;
@property(nonatomic,strong)UILabel *NullLabel;

@end


@implementation YZNullView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = YZBackNavColor;
        
        _NullImage = [[UIImageView alloc] initWithFrame:CGRectMake(130*YZAdapter, 162*YZAdapter, 115*YZAdapter, 125*YZAdapter)];
        _NullImage.image = [UIImage imageNamed:@"YZ_Null_Image.jpg"];
        [self addSubview:_NullImage];
        
        _NullLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 315*YZAdapter, Screen_W, 20*YZAdapter)];
        _NullLabel.text = @"暂无数据";
        _NullLabel.font = FONT(18);
        _NullLabel.textAlignment = NSTextAlignmentCenter;
        _NullLabel.textColor = TimeMainFont_Color;
        [self addSubview:_NullLabel];
        
    }
    return self;
}






@end
