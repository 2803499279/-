//
//  YZRichURLProtocol.h
//  JBHProject
//
//  Created by zyz on 2017/6/13.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZRichURLProtocol : NSURLProtocol

#pragma mark =========== 自己加的属性
/** 可信任的域名,用于支持通过ip访问此域名下的https链接.
 Trusted domain, this domain for support via IP access HTTPS links.
 */
@property(nonatomic, strong) NSMutableArray * trustHostnames;

@end
