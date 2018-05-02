//
//  HomeHeaderModel.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/22.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeHeaderModel : NSObject
@property(nonatomic,copy)NSString * taskCount;// 代勘数
@property(nonatomic,copy)NSString * taskAllreward;// 本月收入
@property(nonatomic,copy)NSString * taskRate;// 好评率
@property(nonatomic,copy)NSString * power;// 是否开听单
@property(nonatomic,copy)NSString * accPower;// 是否开启只能听单
@property(nonatomic,copy)NSString * address;// 常驻地址
@property(nonatomic,copy)NSArray * time;// 接单时间
@property(nonatomic,strong)NSString * point;// 地址坐标
/**
 * 解析POI搜索返回的数据
 */
+ (instancetype)HomeHeaderModelWith:(id)respondsData;
- (NSArray *)timeWithtimeStr:(NSString *)timeStr;
@end
