//
//  YZViewJavaScriptBridge.h
//  JBHProject
//
//  Created by zyz on 2017/4/26.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YZViewJavaScriptBridge;

@protocol ViewJavaScriptBridgeDelegate <UIWebViewDelegate>

- (void)javascriptBridge:(YZViewJavaScriptBridge *)bridge receivedMessage:(NSString *)message fromWebView:(UIWebView *)webView;

@end


@interface YZViewJavaScriptBridge : NSObject <UIWebViewDelegate>

@property (nonatomic, assign) id <ViewJavaScriptBridgeDelegate> delegate;
+ (id)javascriptBridgeWithDelegate:(id <ViewJavaScriptBridgeDelegate>)delegate;
- (void)sendMessage:(NSString *)message toWebView:(UIWebView *)webView;

@end
