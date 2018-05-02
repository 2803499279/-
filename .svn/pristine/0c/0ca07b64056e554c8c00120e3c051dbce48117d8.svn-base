//
//  YZRequestManager.h
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZWBResponseSeializerType) {
    /**  默认类型 JSON  如果使用这个响应解析器类型,那么请求返回的数据将会是JSON格式*/
    ZWBResponseSeializerTypeDefault,
    /** JSON类型 如果使用这个响应解析器类型,那么请求返回的数据将会是JSON格式*/
    ZWBResponseSeializerTypeJSON,
    /**  XML类型 如果使用这个响应解析器类型,那么请求返回的数据将会是XML格式*/
    ZWBResponseSeializerTypeXML,
    /** Plist类型 如果使用这个响应解析器类型,那么请求返回的数据将会是Plist格式*/
    ZWBResponseSeializerTypePlist,
    /** Data类型 如果使用这个响应解析器类型,那么请求返回的数据将会是二进制格式*/
    ZWBResponseSeializerTypeData,
    /** Compound类型 如果使用这个响应解析器类型,那么请求返回的数据将会是Compound格式*/
    ZWBResponseSeializerTypeCompound,
    /** Image类型 如果使用这个响应解析器类型,那么请求返回的数据将会是Image格式*/
    ZWBResponseSeializerTypeImage
};


@interface YZRequestManager : NSObject

/**
 *  GET请求 By NSURLSession
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param type       数据解析器类型
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters responseSeializerType:(ZWBResponseSeializerType)type success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 *  POST请求 请求数据 --> By NSURLSession
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param type       数据解析器类型
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters responseSeialierType:(ZWBResponseSeializerType)type success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 *  POST请求 上传数据 --> By NSURLSession
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param type       数据解析器类型
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters responseSeialierType:(ZWBResponseSeializerType)type constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  取消请求
 */
+ (void)cancelAllRequests;


@end
