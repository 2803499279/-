//
//  YZOrderModel.h
//  JBHProject
//
//  Created by zyz on 2017/4/26.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZBaseModel.h"

@interface YZOrderModel : YZBaseModel

@property (nonatomic, copy) NSString *tid; // 任务ID
@property (nonatomic, copy) NSString *type; // 任务类型编码
@property (nonatomic, copy) NSString *type_name; // 任务类型文字说明
@property (nonatomic, copy) NSString *custom_name; // 客户姓名
@property (nonatomic, copy) NSString *custom_telphone; // 客户电话
@property (nonatomic, copy) NSString *arise_datetime; // 事故时间
@property (nonatomic, copy) NSString *arise_nearby; // 事故地址标志提示
@property (nonatomic, copy) NSString *arise_address; // 事故地址
@property (nonatomic, copy) NSString *arise_point; // 事故坐标
@property (nonatomic, copy) NSString *distance; // 到我的距离（公里），即时计算
@property (nonatomic, copy) NSString *reward; // 代勘奖励（元）
@property (nonatomic, copy) NSString *remark; // 事故说明
@property (nonatomic, copy) NSString *cts_uid; // 责任客服ID
@property (nonatomic, copy) NSString *cts_name; // 责任客服名称
@property (nonatomic, copy) NSString *cts_avator; // 责任客服形象

@property (nonatomic, copy) NSString *state; // 是否被接单

@property (nonatomic, copy) NSString *license_plate; // 车牌号
@property (nonatomic, copy) NSString *vehicle_model; // 车型


@end
