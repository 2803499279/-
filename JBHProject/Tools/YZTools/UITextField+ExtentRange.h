//
//  UITextField+ExtentRange.h
//  JBHProject
//
//  Created by zyz on 2017/6/13.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end
