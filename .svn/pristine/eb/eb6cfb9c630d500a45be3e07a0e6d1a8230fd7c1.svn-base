//
//  YZDataBase.h
//  JBHProject
//
//  Created by zyz on 2017/4/26.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YZOrderModel;

@interface YZDataBase : NSObject

// 创建单例的接口
+ (YZDataBase *)shareDataBase;

// 创建添加订单的接口
- (void)insertOrder:(YZOrderModel *)Order;

// 取出订单表格中所有的订单
- (NSArray *)selectAllOrder;

// 根据uid取出订单表格中的相应订单
- (NSArray *)selectUidOrder:(NSString *)uid;

// 根据tid取出订单表格中的相应订单
- (NSArray *)selectTidOrder:(NSString *)tid Uid:(NSString *)uid;

// 删除订单的接口
- (void)deleteOneMovieByOrderID:(NSString *)tid;

// 修改订单
- (void)ModifyTheOrder:(NSString *)state Tid:(NSString *)tid  Uid:(NSString *)uid;
/**
 * 修改状态是否成功
 */
@property(nonatomic,assign)BOOL isSuccessSteState;



// 创建添加通知消息的接口
- (void)insertPush:(YZPushModel *)Push;

// 根据uid取出通知消息表格中的相应订单
- (NSArray *)selectUidPush:(NSString *)uid;

// 删除通知消息的接口
- (void)deleteOneMovieByPushID:(NSString *)mid;










@end
