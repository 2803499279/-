//
//  YZBaseRequest.m
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZBaseRequest.h"
#import "YZRequestManager.h"
#import "NSString+YZAddition.h"

#import "YZBubble.h"

#import "YZUserInfoManager.h"
@implementation YZBaseRequest

#pragma mark - 构造
+ (instancetype)zwb_request {
    return [[self alloc] init];
}

+ (instancetype)zwb_requestWithUrl:(NSString *)zwb_url {
    return [self zwb_requestWithUrl:zwb_url isPost:NO];
}

+ (instancetype)zwb_requestWithUrl:(NSString *)zwb_url isPost:(BOOL)zwb_isPost {
    return [self zwb_requestWithUrl:zwb_url isPost:zwb_isPost parameters:nil];
}

+ (instancetype)zwb_requestWithUrl:(NSString *)zwb_url isPost:(BOOL)zwb_isPost parameters:(NSDictionary *)zwb_parameters {
    return [self zwb_requestWithUrl:zwb_url isPost:zwb_isPost parameters:zwb_parameters delegate:nil];
}

+ (instancetype)zwb_requestWithUrl:(NSString *)zwb_url isPost:(BOOL)zwb_isPost parameters:(NSDictionary *)zwb_parameters delegate:(id<ZWBBaseRequestReponseDelegate>)zwb_delegate {
    // 初始化
    YZBaseRequest *request = [self zwb_request];
//    // 设置参数
//    NSString *urlStr = [self getIPAddress];
//    
//    if (urlStr.length == 0) {
//        request.zwb_url = zwb_url;
//    }else {
//        if ([zwb_url isEqualToString:USER_LOGIN_URL]) {
//            request.zwb_url = zwb_url;
//        }else {
//            request.zwb_url = [zwb_url stringByReplacingOccurrencesOfString:@"api-nat.juins.com" withString:urlStr];
//        }
//    }
    request.zwb_url = zwb_url;
    request.zwb_isPost = zwb_isPost;
    request.zwb_parameters = zwb_parameters;
    request.zwb_delegate = zwb_delegate;
    request.zwb_isSepcitlyRequest = NO;
    
    return request;
}

+ (NSString *)getIPAddress{
    
    // iOS之NDS解析
    Boolean result,bResolved;
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    NSString *ipAddress = @"";
    CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, "api.xunpei.net", kCFStringEncodingASCII);
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
    if (hostRef) {
        result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
        if (result == TRUE) {
            addresses = CFHostGetAddressing(hostRef, &result);
        }
    }
    bResolved = result == TRUE ? true : false;
    if(bResolved) {
        struct sockaddr_in* remoteAddr;
        char *ip_address = NULL;
        for(int i = 0; i < CFArrayGetCount(addresses); i++) {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            if(remoteAddr != NULL)
            {
                //获取IP地址
                char ip[16];
                DLog(@"ip address is : %s",strcpy(ip, inet_ntoa(remoteAddr->sin_addr)));
                 strcpy(ip, inet_ntoa(remoteAddr->sin_addr));
                ip_address = inet_ntoa(remoteAddr->sin_addr);
            }
           ipAddress = [NSString stringWithCString:ip_address encoding:NSUTF8StringEncoding];
        }
    }
    CFRelease(hostNameRef);
    CFRelease(hostRef);
    return ipAddress;
}



#pragma mark - 发送请求
- (void)zwb_sendRequest {
    [self zwb_sendRequestWithCompletion:nil failure:nil];
}

- (void)zwb_sendRequestWithCompletion:(ZWBRequestAPICompletion)completion failure:(ZWBRequestAPIFailure)failure {
    
    // 请求连接
    NSString *urlStr = self.zwb_url;
    
    if (urlStr.length == 0 || !urlStr)  return;
    // 参数
    NSDictionary *params = [self getParams];
    
    //得到动画
    if (self.zwb_isPost) { // 普通POST请求
        // 如果图片个数为0为普通参数请求
//        self.hud = [MBProgressHUD getMBProgressHUDWithView:nil];
        if (!self.zwb_imageArray.count) {
            [YZRequestManager POST:[urlStr noWhiteSpaceString] parameters:params responseSeialierType:ZWBResponseSeializerTypeJSON success:^(id responseObject) {
                if (responseObject) {
                    
//                    DLog(@"responseObject: %@", responseObject);
                    // 处理数据
                    [self handleResponse:responseObject completion:completion imgCount:0];
                }
            } failure:^(NSError *error) {
                [self handleError:error failure:failure];
                [[YZBubbleView defaultBubbleView] hide];
                
            }];
        } else {   // 上传图片
            __block NSInteger imgCount = 0;
            for (UIImage *image in self.zwb_imageArray) {
                [YZRequestManager POST:[urlStr noWhiteSpaceString] parameters:params responseSeialierType:ZWBResponseSeializerTypeData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
                    NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
                    [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"filename" fileName:fileName mimeType:@"image/png"];
                    imgCount++;
                } success:^(id responseObject) {
                    // 处理返回的图片信息
                    [self handleResponse:responseObject completion:completion imgCount:imgCount];
                } failure:^(NSError *error) {
                    // 数据请求失败，暂时不做处理
                    DLog(@"%@", error.localizedDescription);
                    [self handleError:error failure:failure];
                    [[YZBubbleView defaultBubbleView] hide];
                }];
            }
        }
    } else {
//        self.hud = [MBProgressHUD getMBProgressHUDWithView:nil];
        [YZRequestManager GET:[urlStr noWhiteSpaceString] parameters:params responseSeializerType:ZWBResponseSeializerTypeJSON success:^(id responseObject) {
            
            if (responseObject) {
                // 处理数据
                [self handleResponse:responseObject completion:completion imgCount:1];
            }
            
        } failure:^(NSError *error) {
            // 数据请求失败，暂时不做处理
            [self handleError:error failure:failure];
            [[YZBubbleView defaultBubbleView] hide];
        }];
    }
}

- (void)handleError:(NSError *)error failure:(ZWBRequestAPIFailure)failure {
//    if (self.hud) {
//        //        self.hud.mode = MBProgressHUDModeText;
//        //        self.hud.label.text = @"网络故障，请加载重试！";
//        [MBProgressHUD hideHUD:self.hud afterDelay:0];
//    } else {
//        //        [MBProgressHUD showAutoMessage:@"网络故障，请加载重试！"];
//    }
    
    if (failure) {
        failure(error);
    } else {
        if ([self.zwb_delegate respondsToSelector:@selector(requestFailureError:)]) {
            [self.zwb_delegate requestFailureError:error];
        }
    }
    // 网络失败，发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kZWBRequestFailureNotification object:nil];
}


- (void)handleResponse:(id)responseObject completion:(ZWBRequestAPICompletion)completion imgCount:(NSInteger)imgCount {
    
    
#if 0
    // 数据的key
    NSArray *allKeys = [responseObject allKeys];
    NSString *dataKey = nil;
    for (NSInteger i = 0; i < allKeys.count; i++) {
        NSString *oneKey = allKeys[i];
//        if ([oneKey isEqualToString:@"resultSuccess"] || [oneKey isEqualToString:@"resultDesc"] || [oneKey isEqualToString:@"resultCode"]) {
//            continue;
//        }
        dataKey = oneKey;
    }
#endif
    BOOL success;
    if (!self.zwb_isSepcitlyRequest) {
        @try {
            success = YES;
        } @catch (NSException *exception) {
            success = YES;
        } @finally {
//            if (success) {
//                if (self.hud) {
//                    //                    self.hud.customView = [[UIImageView alloc] initWithImage:[IMAGE(@"checkmark") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//                    //            self.hud.mode = MBProgressHUDModeCustomView;
//                    //            self.hud.label.text = @"成功!";
//                    [MBProgressHUD hideHUD:self.hud afterDelay:0];
//                }
//            } else {
//                if (self.hud) {
//                    //                    self.hud.mode = MBProgressHUDModeText;
//                    //                    self.hud.label.text = responseObject[@"resultDesc"];
//                    [MBProgressHUD hideHUD:self.hud afterDelay:0];
//                    
//                } else {
//                    // 数据查询出错提示
//                    //                    [MBProgressHUD showAutoMessage:responseObject[@"resultDesc"]];
//                }
//            }
            
        }
    } else {
        success = YES;
    }
    
    
    //    BOOL success = [responseObject[@"resultSuccess"] integerValue];
    //    if (success) {
    //        if (self.hud) {
    ////            self.hud.customView = [[UIImageView alloc] initWithImage:[IMAGE(@"checkmark") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    ////            self.hud.mode = MBProgressHUDModeCustomView;
    ////            self.hud.label.text = @"加载完成";
    //            [MBProgressHUD hideHUD:self.hud afterDelay:0];
    //        }
    //    } else {
    //        if (self.hud) {
    //            self.hud.mode = MBProgressHUDModeText;
    //            self.hud.label.text = responseObject[@"resultDesc"];
    //            [MBProgressHUD hideHUD:self.hud afterDelay:1];
    //
    //        } else {
    //            [MBProgressHUD showAutoMessage:responseObject[@"resultDesc"]];
    //
    //        }
    //    }
    // 数据请求成功回调
    if (completion) {
        completion(responseObject, success, responseObject[@"code"]);
    } else if (self.zwb_delegate) {
        if ([self.zwb_delegate respondsToSelector:@selector(requestSuccessReponse:response:message:)]) {
            [self.zwb_delegate requestSuccessReponse:success response:responseObject message:responseObject[@"code"]];
        }
    }
    // 请求成功，发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kZWBRequestSuccessNotification object:nil];
}

- (void)handlePicResponse:(id)responseObject completion:(ZWBRequestAPICompletion)completion {
    
}

- (NSDictionary *)getParams {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:self.mj_keyValues];
    
    if (![params[@"zwb_url"] isEqualToString:USER_LOGIN_URL]) {
        YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
        [params setObject:model.uid forKey:@"uid"];
        [params setObject:model.token forKey:@"token"];
        [params setObject:@"ios" forKey:@"device"];
        
        // 获取当前APP的版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDictionary));
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [params setObject:app_Version forKey:@"version"];
    }else {
        
        [params setObject:@"ios" forKey:@"device"];
        // 获取当前APP的版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDictionary));
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [params setObject:app_Version forKey:@"version"];
    }
    
    if ([params.allKeys containsObject:@"changePassword"]) {
        [params setObject:params[@"changePassword"] forKey:@"newPassword"];
        [params removeObjectForKey:@"changePassword"];
    }
    if ([params.allKeys containsObject:@"zwb_delegate"]) {
        [params removeObjectForKey:@"zwb_delegate"];
    }
    if ([params.allKeys containsObject:@"zwb_isPost"]) {
        [params removeObjectForKey:@"zwb_isPost"];
    }
    if ([params.allKeys containsObject:@"zwb_isSepcitlyRequest"]) {
        [params removeObjectForKey:@"zwb_isSepcitlyRequest"];
    }
    
    if ([params.allKeys containsObject:@"zwb_url"]) {
        [params removeObjectForKey:@"zwb_url"];
    }
    if (!self.zwb_imageArray.count) {
        if ([params.allKeys containsObject:@"zwb_imageArray"]) {
            [params removeObjectForKey:@"zwb_imageArray"];
        }
    }
    
    DLog(@"params:\n%@", params);
    
    return params;
}




@end
