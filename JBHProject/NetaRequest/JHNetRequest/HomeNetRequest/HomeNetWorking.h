//
//  HomeNetWorking.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/21.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>
// 定义block类型，用于网络请求结果传递
typedef void(^SuccessBlockType)(id responsData);
typedef void(^FailedBlockType)(NSError * error);

@interface HomeNetWorking : NSObject
/**
 共享单利
 */
+ (instancetype)sharedInstance;

/**
 获取初始信息
 */
- (void)requestUserInfoPOSTWithURl:(NSString *)url
                        Dictionary:(NSMutableDictionary *)params
                            Succes:(SuccessBlockType)successBlock
                            failed:(FailedBlockType)failedBlock;

/**
 上传用户位置
 */
- (void)uploadUserLocationPOSTWithURl:(NSString *)url
                        Dictionary:(NSMutableDictionary *)params
                            Succes:(SuccessBlockType)successBlock
                            failed:(FailedBlockType)failedBlock;

/**
 进行中的任务
 */
- (void)requestForTheTaskPOSTWithURl:(NSString *)url
                           Dictionary:(NSMutableDictionary *)params
                               Succes:(SuccessBlockType)successBlock
                               failed:(FailedBlockType)failedBlock;
/**
 立即抢单
 */
- (void)requestImmediatelyGetTaskPOSTWithURl:(NSString *)url
                          Dictionary:(NSMutableDictionary *)params
                              Succes:(SuccessBlockType)successBlock
                              failed:(FailedBlockType)failedBlock;
/**
 已完成的派单
 */
- (void)requestCompleteTaskPOSTWithURl:(NSString *)url
                                  Dictionary:(NSMutableDictionary *)params
                                      Succes:(SuccessBlockType)successBlock
                                      failed:(FailedBlockType)failedBlock;

/**
 听单设置信息保存
 */
- (void)requestListenSetTaskPOSTWithURl:(NSString *)url
                            Dictionary:(NSMutableDictionary *)params
                                Succes:(SuccessBlockType)successBlock
                                failed:(FailedBlockType)failedBlock;
/**
 拉取新的通知派单
 */
- (void)requestPullNewNoticeListenPOSTWithURl:(NSString *)url
                             Dictionary:(NSMutableDictionary *)params
                                 Succes:(SuccessBlockType)successBlock
                                 failed:(FailedBlockType)failedBlock;

/**
 到达位置
 */
- (void)userArrivePOSTLocationPointWithURl:(NSString *)url
                           Dictionary:(NSMutableDictionary *)params
                               Succes:(SuccessBlockType)successBlock
                               failed:(FailedBlockType)failedBlock;

/**
 * 获取正在处理的订单任务
 */
- (void)userTaskUnsolvedPOSTWithURl:(NSString *)url
                                Dictionary:(NSMutableDictionary *)params
                                    Succes:(SuccessBlockType)successBlock
                                    failed:(FailedBlockType)failedBlock;
/**
 * 查询审核状态
 */
- (void)taskStatusPOSTWithURl:(NSString *)url
                         Dictionary:(NSMutableDictionary *)params
                             Succes:(SuccessBlockType)successBlock
                             failed:(FailedBlockType)failedBlock;
@end
