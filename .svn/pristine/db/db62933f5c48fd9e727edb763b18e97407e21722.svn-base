//
//  DataNullCheckTool.m
//  TTY
//
//  Created by ZYM on 16/4/27.
//  Copyright © 2016年 sinze. All rights reserved.
//

#import "DataNullCheckTool.h"

@implementation DataNullCheckTool

@end
NSString *checkString(id str){
    NSString *tmpStr =  [NSString stringWithFormat:@"%@",str];
    if ([str isKindOfClass:[NSNull class]]||
        [tmpStr isEqualToString:@"(null)"]||
         [tmpStr isEqualToString:@"<null>"]) {
        tmpStr = @"暂无数据";
    }
    return tmpStr;
}

NSString *checkNumber(id str){
    NSString *tmpStr = [NSString stringWithFormat:@"%@",str];
    if ( [str isKindOfClass:[NSNull class]]||![str floatValue]) {
        tmpStr = @"0";
    }
    //去掉数字中的","
    NSMutableString *newStr = [NSMutableString stringWithString:tmpStr];
    for (int i = 0; i < newStr.length; i++) {
        unichar c = [newStr characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if (c == ',') {
            [newStr deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newString = [NSString stringWithString:newStr];
    CGFloat tmpFloat = [newString floatValue] ;
    tmpStr = [NSString stringWithFormat:@"%.2f",tmpFloat];
    return tmpStr;
}
