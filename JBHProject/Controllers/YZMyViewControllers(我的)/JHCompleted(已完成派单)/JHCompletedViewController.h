//
//  JHCompletedViewController.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/28.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeNetWorking.h"
@interface JHCompletedViewController : BaseViewController
@property(nonatomic,strong)HomeNetWorking * manager;
@property(nonatomic,assign)BOOL isHomePushVc;
@end
