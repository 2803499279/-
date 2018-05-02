//
//  YZPromptViewController.h
//  JBHProject
//
//  Created by zyz on 2017/4/12.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSString * inputText);
//typedef void(^CancelBlock)();

@interface YZPromptViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString *IDStr;

@property (nonatomic, strong) UILabel *reloadImageBtn;

@property (nonatomic, strong) UILabel *reloadImageBtn1;

@property (nonatomic, strong) NSString *reloadIBStr;

@property (nonatomic, strong) NSString *OrderError;

- (instancetype)initWithConfirmAction:(ClickBlock)confirmBlock;

@end
