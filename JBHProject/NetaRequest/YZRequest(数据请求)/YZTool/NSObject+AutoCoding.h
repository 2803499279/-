//
//  NSObject+AutoCoding.h
//  JBHProject
//
//  Created by zyz on 2017/4/20.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AutoCoding) <NSSecureCoding>
//coding
+ (NSDictionary *)codableProperties;
- (void)setWithCoder:(NSCoder *)aDecoder;
//property access
- (NSDictionary *)codableProperties;
- (NSDictionary *)dictionaryRepresentation;
//loading / saving
+ (instancetype)objectWithContentsOfFile:(NSString *)path;
- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;
@end
