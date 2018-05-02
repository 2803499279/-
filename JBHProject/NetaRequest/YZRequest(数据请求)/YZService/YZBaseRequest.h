//
//  YZBaseRequest.h
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZWBRequestAPICompletion)(id responseObject, BOOL success, NSString *message);

typedef void (^ZWBRequestAPIFailure)(NSError *error);

@protocol ZWBBaseRequestReponseDelegate <NSObject>

@required
/** 代理返回数据，此方法必须实现*/
- (void)requestSuccessReponse:(BOOL)success response:(id)response message:(NSString *)message;
- (void)requestFailureError:(NSError *)error;
@end


@interface YZBaseRequest : NSObject

//@property (nonatomic, strong) MBProgressHUD *hud;

/** 代理*/
@property (nonatomic, weak) id<ZWBBaseRequestReponseDelegate> zwb_delegate;

/** 链接*/
@property (nonatomic, copy) NSString *zwb_url;
/** 默认GET*/
@property (nonatomic, assign) BOOL zwb_isPost;

/** 参数字典*/
@property (nonatomic, strong) NSDictionary *zwb_parameters;

/** 图片数组*/
@property (nonatomic, strong) NSArray *zwb_imageArray;
@property (nonatomic, assign) BOOL zwb_isSepcitlyRequest;
/** 构造方法*/
+ (instancetype)zwb_request;
+ (instancetype)zwb_requestWithUrl:(NSString *)zwb_url;
+ (instancetype)zwb_requestWithUrl:(NSString *)zwb_url isPost:(BOOL)zwb_isPost;
+ (instancetype)zwb_requestWithUrl:(NSString *)zwb_url isPost:(BOOL)zwb_isPost parameters:(NSDictionary *)zwb_parameters;
+ (instancetype)zwb_requestWithUrl:(NSString *)zwb_url isPost:(BOOL)zwb_isPost parameters:(NSDictionary *)zwb_parameters delegate:(id<ZWBBaseRequestReponseDelegate>)zwb_delegate;


/** 开始请求，设置代理，通过代理回调, 不需要通过block回调*/
- (void)zwb_sendRequest;

/** 开始请求，设置代理或者没有设置代理，需要block进行回调，block优先级高于代理*/
- (void)zwb_sendRequestWithCompletion:(ZWBRequestAPICompletion)completion failure:(ZWBRequestAPIFailure)failure;
//- (void)zwb_sendRequestWithCompletion:(void (^)(id response))ZWBRequestAPICompletion;


@end
