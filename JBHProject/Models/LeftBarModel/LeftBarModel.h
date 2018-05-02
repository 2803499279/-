//
//  LeftBarModel.h
//  NewTTY
//
//  Created by 李俊恒 on 2016/11/3.
//  Copyright © 2016年 sinze. All rights reserved.
//
/*
 * 左侧抽屉的数据模型
 */
#import <Foundation/Foundation.h>

@interface LeftBarModel : NSObject
/**
 *  标题
 */
@property(nonatomic,copy)NSString * myLabelTitle;
/**
 *  图片名字
 */
@property(nonatomic,copy)NSString * iconImageNameStr;

/**
 *  类方法，用来生成该对象的属性
 *
 *  @param iconImageNameStr 未选中的图片
 *  @param myLabelTitle     图片的描述文字
 *
 *  @return 返回一个设置好属性的实例对象
 */
+ (instancetype)leftBarModelWith:(NSString *)iconImageNameStr
                   myLabelTitle:(NSString *)myLabelTitle;
@end
