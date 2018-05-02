//
//  YZUserInfoManager.h
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZUserInfoModel.h"

@interface YZUserInfoManager : NSObject

+ (instancetype)sharedManager;

/** 登录成功*/
- (void)didLoginInWithUserInfo:(id)userInfo;

/** 退出登录*/
- (void)didLoginOut;

/** 获取当前用户信息*/
- (YZUserInfoModel *)currentUserInfo;

/** 重置用户信息*/
- (void)resetUserInfoWithUserInfo:(YZUserInfoModel *)userModel;

/** 用来记录是否是登陆状态 */
@property (nonatomic, assign) BOOL isLogin;

@end
