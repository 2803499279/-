//
//  YZPhotoSingleton.m
//  JBHProject
//
//  Created by zyz on 2017/4/24.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZPhotoSingleton.h"

@implementation YZPhotoSingleton

static YZPhotoSingleton *single = nil;

+ (YZPhotoSingleton *)shareSingleton {
    
    // 线程保护,当有一个线程访问了self对象,其它线程就无法访问
    @synchronized(self) {
        if (nil == single) {
            single = [[YZPhotoSingleton alloc] init];
        }
    }
    return single;
}


@end
