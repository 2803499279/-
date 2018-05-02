//
//  POISearchModel.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/17.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POISearchModel : NSObject
@property(nonatomic,copy)NSString * poiName;// 地址商户名字
@property(nonatomic,copy)NSString * poiAddress;// 商户地址
@property(nonatomic,copy)AMapGeoPoint * selectedLocation;// 坐标
/**
 * 解析POI搜索返回的数据
 */
+ (NSMutableArray *)poiSearchModelWith:(AMapPOISearchResponse *)response;

+ (instancetype)poiModelWith:(NSString *)name address:(NSString *)address;

+ (NSMutableArray *)poiInputModelWith:(AMapInputTipsSearchResponse *)response;

@end
