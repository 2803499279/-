//
//  NSString+YZAddition.m
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "NSString+YZAddition.h"

@implementation NSString (YZAddition)

- (NSString *)convertTimesTampWithDateFormat:(NSString *)dateFormat {
    //dateFormat 设置返回的格式 @"yyyy-MM-dd HH:mm"
    if (dateFormat.length == 0) {
        return @"";
    }
    NSTimeInterval timeInterval = [self doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    
    return timeStr;
}

- (NSString *)noWhiteSpaceString {
    NSString *newString = self;
    
    newString = [newString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //去除掉首尾的空白字符和换行字符使用
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return newString;
}


@end
