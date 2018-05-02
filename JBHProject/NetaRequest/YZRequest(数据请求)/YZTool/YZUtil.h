//
//  YZUtil.h
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZUtil : NSObject

/** 正则判断手机号是否正确*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/** 正则判断身份证是否正确*/
+ (BOOL)isIdentityCard:(NSString *)idCard;
/** 正则判断邮箱是否正确*/
+ (BOOL)isValidateEmail:(NSString *)email;
/** 正则判断金额是否正确*/
+ (BOOL)isValidateMoney:(NSString *)money;
/** 正则判断车牌号是否正确*/
+ (BOOL)validateCarNo:(NSString *)carNo;

/**
 处理部分字符串颜色显示
 
 @param strScr 老字符串
 @param range 范围
 @param color 颜色
 @return 返回富文本字符串
 */
+ (NSMutableAttributedString *)getAttribugedString:(NSString *)strScr range:(NSRange)range color:(UIColor *)color;



/**
 比较时间的大小
 
 @param oneDay 一个日期
 @param anotherDay 另一个日期
 @return 比较日期的大小
 */
+ (BOOL)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;

/**
 *  转化时间 时间戳转时间
 */
+ (NSString *)datestrFromDate:(NSDate *)date withDateFormat:(NSString *)format;

/**
 *  转化时间
 *  几天前，几分钟前
 */
+ (NSString *)updateTimeForTimeInterval:(NSInteger)timeInterval;

// 返回屏幕的宽度
+ (CGFloat)cellContentViewWidth;
// 返回合法的字符串
+ (NSString *)validString:(NSString *)string;
/** 判断字符串是否为空*/
+ (BOOL)isBlankString:(NSString *)string;

/** 是否是当前用户*/
//+ (BOOL)isCurrentUserWithUserId:(NSString *)userId;
/** color生成image*/
+ (UIImage *)imageWithColor:(UIColor *)color;


@end
