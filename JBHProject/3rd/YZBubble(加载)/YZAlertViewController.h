//
//  YZAlertViewController.h
//  JBHProject
//
//  Created by zyz on 2017/5/4.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSString * inputText);
typedef void(^CancelBlock)();

@interface YZAlertViewController : UIViewController <UITextFieldDelegate>

- (instancetype)initWithConfirmAction:(ClickBlock)confirmBlock andCancelAction:(CancelBlock)cancelBlcok;

@property (nonatomic, strong) NSString *RealID; // 是否实名认证的标识

@property (nonatomic, strong) NSString *OldVersion;
@property (nonatomic, strong) NSString *NewVersion;


@end
