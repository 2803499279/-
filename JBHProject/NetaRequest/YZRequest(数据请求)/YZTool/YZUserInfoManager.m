//
//  YZUserInfoManager.m
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZUserInfoManager.h"
#import "YZFileCacheManager.h"
#import "NSFileManager+YZPath.h"
#import "YZCommonConstant.h"

@implementation YZUserInfoManager


static YZUserInfoManager *_sinleton = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sinleton = [[YZUserInfoManager alloc] init];
    });
    return _sinleton;
}

/** 登录*/
- (void)didLoginInWithUserInfo:(id)userInfo {
    YZUserInfoModel *userModel = [YZUserInfoModel modelWithDictionary:userInfo];
    [userModel archive];
    [YZFileCacheManager saveUserData:@YES forKey:kZWBHasLoginFlag];
}

/** 退出登录*/
- (void)didLoginOut {
    [YZFileCacheManager removeObjectByFileName:NSStringFromClass([YZUserInfoModel class])];
    [YZFileCacheManager saveUserData:@NO forKey:kZWBHasLoginFlag];
}

/** 获取当前用户信息*/
- (YZUserInfoModel *)currentUserInfo {
    id obj = [YZFileCacheManager getObjectByFileName:NSStringFromClass([YZUserInfoModel class])];
    if (obj) return  obj;
    
    return nil;
}

/** 重置用户信息*/
- (void)resetUserInfoWithUserInfo:(YZUserInfoModel *)userModel {
    [userModel archive];
}

/** 判断是否是登陆状态*/
- (BOOL)isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZWBHasLoginFlag];
}


@end
