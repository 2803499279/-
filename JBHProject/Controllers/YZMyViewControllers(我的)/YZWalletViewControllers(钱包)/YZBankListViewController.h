//
//  YZBankListViewController.h
//  JBHProject
//
//  Created by zyz on 2017/5/6.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "BaseViewController.h"

@protocol YZBankListViewControllerDelegate <NSObject>

- (void)bankImage:(NSString *)image bankLabel:(NSString *)label bankNumn:(NSString *)bankNum bank:(NSString *)bank;

@end


@interface YZBankListViewController : BaseViewController

@property (nonatomic, strong) id<YZBankListViewControllerDelegate>delegate;

@property (nonatomic, strong) NSString *BankListID; // 是否需要返回信息

@end
