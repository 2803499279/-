//
//  RootTabbarModel.h
//  NewJBHProject
//
//  Created by 李俊恒 on 2017/8/21.
//  Copyright © 2017年 李俊恒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootTabbarModel : NSObject
@property (nonatomic,copy)NSString * title;// 标题
@property (nonatomic,copy)NSString * className;// 类名
@property (nonatomic,copy)NSString * normalImageName; // 普通状态下的图片
@property (nonatomic,copy)NSString * selectedImageName;// 选中状态下的图片
// 构造方法
- (id)initWithTitle:(NSString *)title className:(NSString *)className normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName;
// 自动生成Model的类方法
+ (instancetype)modelWithTitle:(NSString *)title className:(NSString *)className normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName;

- (UIImage *)normalImage;
- (UIImage *)selectedImage;
@end
