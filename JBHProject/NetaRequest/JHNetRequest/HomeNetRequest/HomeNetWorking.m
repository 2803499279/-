//
//  HomeNetWorking.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/21.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "HomeNetWorking.h"
#import "AFURLSessionManager.h"

#define TOKEN [[YZUserInfoManager sharedManager] currentUserInfo].token
#define UID [[YZUserInfoManager sharedManager] currentUserInfo].uid
#define DEVICE @"iOS"
#define VERSION @"1.0";

@interface HomeNetWorking()
@property(nonatomic,strong)AFHTTPSessionManager * sessionManager;
@property(nonatomic,copy)NSString * ipHostName;// 域名解析
@end
@implementation HomeNetWorking

- (instancetype)init
{
    if (self = [super init]) {

        _sessionManager = [[AFHTTPSessionManager alloc]init];
        // 请求超时设定
        // 用于越过验证https证书的代码，证书验证成功现在该方法已弃用
//        [_sessionManager.securityPolicy setAllowInvalidCertificates:YES];
//        [_sessionManager.securityPolicy setValidatesDomainName:NO];
        
        _sessionManager.requestSerializer.timeoutInterval = 6;
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil];
        
    }
    return self;
}
- (NSString *)ipHostName
{
    return [JHTools getIPWithHostName];
}
/**
 创建共享单利
 */
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static HomeNetWorking *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}
// 创建单利
+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}
/**
 GET网络请求
 */
- (void)GET:(NSString *)url success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSArray * array = @[self.ipHostName];
    _sessionManager.trustHostnames = [NSMutableArray arrayWithArray:array];
    [_sessionManager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}
/**
 POST网络请求
 */
- (void)POST:(NSString *)url parameters:(id)params Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSArray * array = @[self.ipHostName];
    _sessionManager.trustHostnames = [NSMutableArray arrayWithArray:array];
    [_sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            DLog(@"请求URL：%@ 参数params:%@ 数据返回：%@",url,params,responseObject);
            successBlock(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            //            DLog(@"Error: %@", error);
            
            failedBlock(error);
        }
    }];
}
/**
 拼接URL
 */
- (NSString *)getUrl:(NSString *)str
{
    
    return [NSString stringWithFormat:@"%@%@",JHbaseUrl,str];
    
}
- (NSMutableDictionary *)getParmsWith:(NSMutableDictionary *)params
{
    params[@"token"] = TOKEN;
    params[@"uid"] = UID;
    params[@"device"] = DEVICE;
    params[@"version"] = VERSION;
    return params;
}
#pragma mark =================== 网络请求
- (void)requestUserInfoPOSTWithURl:(NSString *)url
                        Dictionary:(NSMutableDictionary *)params
                            Succes:(SuccessBlockType)successBlock
                            failed:(FailedBlockType)failedBlock
{
    
 [self POST:[self getUrl:url] parameters:[self getParmsWith:params] Success:successBlock failed:failedBlock];
}
- (void)uploadUserLocationPOSTWithURl:(NSString *)url
                           Dictionary:(NSMutableDictionary *)params
                               Succes:(SuccessBlockType)successBlock
                               failed:(FailedBlockType)failedBlock
{
   
    [self POST:[self getUrl:url] parameters:[self getParmsWith:params] Success:successBlock failed:failedBlock];
}
- (void)requestForTheTaskPOSTWithURl:(NSString *)url
                          Dictionary:(NSMutableDictionary *)params
                              Succes:(SuccessBlockType)successBlock
                              failed:(FailedBlockType)failedBlock
{
    [self POST:[self getUrl:url] parameters:[self getParmsWith:params] Success:successBlock failed:failedBlock];
}

- (void)requestImmediatelyGetTaskPOSTWithURl:(NSString *)url
                                  Dictionary:(NSMutableDictionary *)params
                                      Succes:(SuccessBlockType)successBlock
                                      failed:(FailedBlockType)failedBlock
{
    
    [self POST:[self getUrl:url] parameters:[self getParmsWith:params] Success:successBlock failed:failedBlock];
}

- (void)requestCompleteTaskPOSTWithURl:(NSString *)url
                            Dictionary:(NSMutableDictionary *)params
                                Succes:(SuccessBlockType)successBlock
                                failed:(FailedBlockType)failedBlock
{
    [self POST:[self getUrl:url] parameters:[self getParmsWith:params] Success:successBlock failed:failedBlock];
}

- (void)requestListenSetTaskPOSTWithURl:(NSString *)url
                             Dictionary:(NSMutableDictionary *)params
                                 Succes:(SuccessBlockType)successBlock
                                 failed:(FailedBlockType)failedBlock
{
    [self POST:[self getUrl:url] parameters:[self getParmsWith:params] Success:successBlock failed:failedBlock];
}
- (void)requestPullNewNoticeListenPOSTWithURl:(NSString *)url
                                   Dictionary:(NSMutableDictionary *)params
                                       Succes:(SuccessBlockType)successBlock
                                       failed:(FailedBlockType)failedBlock
{
    [self POST:[self getUrl:url] parameters:[self getParmsWith:params] Success:successBlock failed:failedBlock];
}

- (void)userArrivePOSTLocationPointWithURl:(NSString *)url
                                Dictionary:(NSMutableDictionary *)params
                                    Succes:(SuccessBlockType)successBlock
                                    failed:(FailedBlockType)failedBlock
{
    [self POST:[self getUrl:url] parameters:[self getParmsWith:params] Success:successBlock failed:failedBlock];

}
- (void)userTaskUnsolvedPOSTWithURl:(NSString *)url
                         Dictionary:(NSMutableDictionary *)params
                             Succes:(SuccessBlockType)successBlock
                             failed:(FailedBlockType)failedBlock
{
    [self POST:[self getUrl:url] parameters:[self getParmsWith:params] Success:successBlock failed:failedBlock];

}
/**
 * 查询审核状态
 */
- (void)taskStatusPOSTWithURl:(NSString *)url
                   Dictionary:(NSMutableDictionary *)params
                       Succes:(SuccessBlockType)successBlock
                       failed:(FailedBlockType)failedBlock
{
    [self POST:[self getUrl:url] parameters:[self getParmsWith:params] Success:successBlock failed:failedBlock];
}
@end
