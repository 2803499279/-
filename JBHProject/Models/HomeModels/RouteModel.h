//
//  RouteModel.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteModel : NSObject
@property(nonatomic,copy)NSString * titleLabelText;// 时间 + 公里数
@property(nonatomic,copy)NSString * contentText;// 有多少个红绿灯
/**
 * 解析POI搜索返回的数据
 */
+ (instancetype)RouteModelModelWith:(AMapNaviRoute *)naivRoute;

@end
