//
//  YZUtil.m
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZUtil.h"

@implementation YZUtil

{
    NSInteger _timeCount;
    
}


#pragma mark - 手机号验证
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,152,155,156,170,171,176,185,186
     * 电信号段: 133,134,153,170,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,152,155,156,170,171,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[256]|7[016]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,134,153,170,177,180,181,189
     */
    NSString *CT = @"^1(3[34]|53|7[07]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - 邮箱验证
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - 身份证验证
+ (BOOL)isIdentityCard:(NSString *)idCard {
    NSString *cardRegex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    
    // 用OC 里面把正则表达式命名成一个计算对比对象,
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cardRegex];
    //    DLog(@"phoneTest is %@",phoneTest);
    
    // 用输入的手机号跟正则表达式对象验证,如果手机号合法返回yes,如果手机号不合法返回NO
    return [cardTest evaluateWithObject:idCard];
    
    //    if ([card length] != 18) {
    //
    //        return NO;
    //    } else {
    //
    //        for (int i=0; i<[card length]; i++) {
    //
    //            unichar c = [card characterAtIndex:i];
    //            if (i <= 16) {
    //
    //                if (c<'0' || c>'9') {
    //
    //                    return NO;
    //                }
    //            } else if (i == 17) {
    //
    //                if (c=='x' || c=='X') {
    //
    //                    return YES;
    //                } else if (c>='0' && c<='9') {
    //
    //                    return YES;
    //                } else {
    //
    //                    return NO;
    //                }
    //            }
    //        }
    //    }
    //    return YES;
}


#pragma mark - 钱验证
+ (BOOL)isValidateMoney:(NSString *)money{
    
    NSString *regex = @"^[0-9]+(.[0-9]{2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:money];
}

#pragma mark - 车牌号验证
+ (BOOL)validateCarNo:(NSString *)carNo {
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    DLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

#pragma mark - Utils
+ (NSMutableAttributedString *)getAttribugedString:(NSString *)strScr range:(NSRange)range color:(UIColor *)color {
    NSMutableAttributedString *mAttributeStr = [[NSMutableAttributedString alloc] initWithString:strScr];
    [mAttributeStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return mAttributeStr;
}



/** 屏幕宽度*/
+ (CGFloat)cellContentViewWidth
{
    CGFloat width = Screen_W;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = Screen_W;
    }
    return width;
}

// 比较时间的大小
+ (BOOL)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay {    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSString *todayStr = [dateFormatter stringFromDate:today];
    //    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {    // 大于 今天大于其他天   可以随意修改时间
        return NO;
    }
    else if (result == NSOrderedAscending){ // 小于
        return YES;
    } else {                                // 等于 今天等于其他天   不可以修改时间
        return YES;
    }
    //DLog(@"Both dates are the same");
}


// 时间戳转时间
+ (NSString *)datestrFromDate:(NSDate *)date withDateFormat:(NSString *)format {
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    
    return [dateFormat stringFromDate:date];
}

// 几天前 几分钟前..
+ (NSString *)updateTimeForTimeInterval:(NSInteger)timeInterval {
    
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = timeInterval;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    if (time < 60) {
        return @"刚刚";
    }
    NSInteger minutes = time / 60;
    if (minutes < 60) {
        
        return [NSString stringWithFormat:@"%ld分钟前", (long)minutes];
    }
    // 秒转小时
    NSInteger hours = time / 3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    // 秒转天数
    NSInteger days = time / 3600 / 24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
    // 秒转月
    NSInteger months = time / 3600 / 24 / 30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",(long)months];
    }
    // 秒转年
    NSInteger years = time / 3600 / 24 / 30 / 12;
    return [NSString stringWithFormat:@"%ld年前",(long)years];
}


// 返回合法字符串
+ (NSString *)validString:(NSString *)string {
    
    if ([self isBlankString:string]) {
        return @"";
    } else {
        return string;
    }
}


/**
 *  判断字符串是否为空
 */
+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] == NO) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

//+ (BOOL)isCurrentUserWithUserId:(NSString *)userId {
//    if ([ZWBUserInfoManager sharedManager].isLogin == NO) {
//        return NO;
//    }
//    if (kStringIsEmpty(userId)) {
//        return [[ZWBUserInfoManager sharedManager].currentUserInfo.id isEqualToString: userId];
//    } else {
//        return NO;
//    }
//}

/** color生成image*/
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}




@end
