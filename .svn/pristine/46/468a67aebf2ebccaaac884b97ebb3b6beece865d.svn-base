//
//  JHCustomPickView.h
//  DataPickViewDemo
//
//  Created by 李俊恒 on 2017/4/26.
//  Copyright © 2017年 聚保汇. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol JHCustomPickViewDelegate <NSObject>
//
//- (void)sureButtonSenderInfo:(NSMutableArray * )array;
//@end
typedef void(^senderTimes)(NSMutableArray * timeArray);
@interface JHCustomPickView : UIView
//@property(nonatomic,weak)id<JHCustomPickViewDelegate>delegate;
@property(nonatomic,strong)NSMutableArray * timeArray;
@property (nonatomic,copy) senderTimes timeInfo;
@property(nonatomic,strong)UIViewController * controller;
@end
