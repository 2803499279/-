//
//  YZBaseModel.m
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZBaseModel.h"

@implementation YZBaseModel

//+ (NSDictionary *)replacedKeyFromPropertyName {
//    return @{
//             @"ID":@"id",
//             @"desc":@"description",
//             @"responseData" : @"data"
//             };
//}

/** 字典数组转模型数组*/
+ (NSMutableArray *)modelArrayWithDictArray:(NSArray *)response {
    if ([response isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [self mj_objectArrayWithKeyValuesArray:response];
        return array;
    }
    return [NSMutableArray new];
}

/** 字典转模型*/
+ (id)modelWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        return [self mj_objectWithKeyValues:dictionary];
    }
    return [[self alloc] init];
}

/** 模型包含模型数组*/
+ (void)setUpModelClassInArrayWithContainDict:(NSDictionary *)dict {
    if (dict.allKeys.count == 0) {
        return ;
    }
    [self mj_setupObjectClassInArray:^NSDictionary *{
        return dict;
    }];
}

/**
 *  字典数组转模型数组
 *  @param dict     模型包含模型数组 格式为 key-字段名字 value-[被包含的类名]
 */

+ (NSMutableArray *)modelArrayWithDictArray:(NSArray *)response containDict:(NSDictionary *)dict {
    if (dict == nil) {
        dict = [NSMutableDictionary new];
    }
    [self setUpModelClassInArrayWithContainDict:dict];
    return [self modelArrayWithDictArray:response];
}

+ (id)modelWithDictionary:(NSDictionary *)dictionary containDict:(NSDictionary *)dict {
    if (dict == nil) {
        dict = [NSMutableDictionary new];
    }
    [self setUpModelClassInArrayWithContainDict:dict];
    return [self modelWithDictionary:dictionary];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

#pragma mark - FileManager
- (id)unarchiver {
    id obj = [YZFileCacheManager getObjectByFileName:[self.class description]];
    return obj;
}

- (void)archive {
    [YZFileCacheManager saveObject:self byFileName:[self.class description]];
}

- (void)remove {
    [YZFileCacheManager removeObjectByFileName:[self.class description]];
}



@end
