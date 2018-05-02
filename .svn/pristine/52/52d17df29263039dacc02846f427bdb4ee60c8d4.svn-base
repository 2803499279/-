//
//  UIColor+JHColor.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "UIColor+JHColor.h"
#import "JHBaseColor.c.h"
@implementation UIColor (JHColor)
//根据colortype获取color 内部实现
+(UIColor *)getZMColorWithColorType:(JHColor)jhColorType{
    
    UIColor *tempColor = [UIColor colorWithRed:
                          jhColorType.JHRed
                                         green:jhColorType.JHGreen
                                          blue:jhColorType.JHBlue
                                         alpha:jhColorType.JHAlph];
    return tempColor;
}

#pragma mark ===========================================
#pragma mark JHBaseBuleColor

//获取BaseBueColor
+(UIColor *)jhBaseBuleColor{
    return [UIColor getZMColorWithColorType:jhBaseBuleColor];
    
}

+(UIColor *)jhTodoCellTitleGary{
    return [UIColor getZMColorWithColorType:jhTodoCellTitleGary];
}

+(UIColor *)jhTodoCellContentGray{
    return [UIColor getZMColorWithColorType:jhTodoCellContentGray];
}

+ (UIColor *)jhTodoCellBackBlue{
    return [UIColor getZMColorWithColorType:jhTodoCellBackBlue];
}

+ (UIColor *)jhSureGreen{
    return [UIColor getZMColorWithColorType:jhSureGreen];
}

+ (UIColor *)jhUserInfoBlack{
    return  [UIColor getZMColorWithColorType:jhUserInfoBlack];
}

+ (UIColor *)jhCancelRed{
    return  [UIColor getZMColorWithColorType:jhCancelRed];
}

+ (UIColor *)jhUserInfoContentBlue{
    return [UIColor getZMColorWithColorType:jhUserInfoContentBlue];
}

+ (UIColor *)jhUserInfoMarginGray{
    return [UIColor getZMColorWithColorType:jhUserInfoMarginGray];
}
+ (UIColor *)jhNavigationColor
{
    return [UIColor getZMColorWithColorType:jhNavigationColor];
}
+ (UIColor *)jhBackGroundColor
{
    return [UIColor getZMColorWithColorType:jhBackGroundColor];
}+ (UIColor *)jhBaseOrangeColor
{
    return [UIColor getZMColorWithColorType:jhBaseOrangeColor];
}
@end
