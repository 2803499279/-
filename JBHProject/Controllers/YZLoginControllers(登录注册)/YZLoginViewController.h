//
//  YZLoginViewController.h
//  JBHProject
//
//  Created by zyz on 2017/4/15.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

//#import "BaseViewController.h"
#import <UIKit/UIKit.h>
@protocol YZLoginViewControllerDelegate <NSObject>
/**
 *  @Description 修改跟控制器
 */
- (void)changeViewRootController:(UIViewController *)vc;
@end

@interface YZLoginViewController : UIViewController
@property(nonatomic,weak)id<YZLoginViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *AlertPhone;

@end
