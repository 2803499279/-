//
//  NeiHanHelper.h
//  NeiHanDuanZiDemo1
//
//  Created by LJH on 15/11/13.
//  Copyright © 2015年 李俊恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHTools : NSObject
/**
 *  计算自1970年开始到现在的日期
 *
 *  @param data 秒数
 *
 *  @return 年月日
 */
+ (NSString *)converToFormatDate:(NSString *)data;
+ (NSString *)WYconverToFormatDate:(NSString *)data;
+ (NSString *)convertToFormatDateTime:(NSString *)dataFrom1970;
// 获取系统时间
+ (NSString *)getSystemTime;
// 获取可变字符串
+ (NSAttributedString *)AttribytedStringWithstr:(NSString *)str changeStr:(NSString *)changeStr;
/**
 *  判断与当前时间的对比
 *
 *  @param projectDate 传入的时间
 *
 *  @return 返回是否大于当前系统时间
 */
+ (BOOL)isEqualeSystemDate:(NSString *)projectDate;

/**
 字符串高度
 */
+ (CGFloat)heightOfConttent:(NSString*)content fontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth;

+ (CGSize) calculteImageSizeWidyh:(NSString *)orignilWidth height:(NSString *)orignilHeight width:(CGFloat)width;

+ (void)changeDrawerLeftViewControllerWidth:(CGFloat)width;
/**
 html字符串的标签替换
 <br>换行\n
 &nbsp空格\t
 */
+ (NSString *)htmlChangeWithNSString:(NSString *)htmlStr;
/**
 * @Description:  用来处理银行卡的账号显示
 * @return 只显示后四位的卡号
 */
+ (NSString *)bankNumberStrWithStr:(NSString *)str;
// 绘制虚线获取图片
+ (UIImage *)JHdrawLineOfDashByImageView:(UIImageView *)imageView withSize:(CGSize)size withDirection:(BOOL)isV;
/**
 *根据时间删除超过一小时的model
 */
+ (NSMutableArray *)homeListOrderModelWithArray:(NSArray *)dataArray;
+(NSString *)getNowTimeTimestamp2;
/**
 *用时多久
 */
+ (NSString *)getTaskUseTime:(NSString *)time;

/**
 * DNS解析域名
 */

+ (NSString*)getIPWithHostName;
/**
 * 获取当前时间秒数
 */
+ (NSString *)getCurrentSecondTime;
/**
 * 将数据库的数据按时间顺序排序
 */
+ (NSMutableArray *)YZOrderModel:(NSArray *)dataArray;
@end
