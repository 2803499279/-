//
//  RootTabbarModel.m
//  NewJBHProject
//
//  Created by 李俊恒 on 2017/8/21.
//  Copyright © 2017年 李俊恒. All rights reserved.
//

#import "RootTabbarModel.h"

@implementation RootTabbarModel
- (id)initWithTitle:(NSString *)title className:(NSString *)className normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName{
    
    if (self = [super init]) {
        _className = className;
        _normalImageName = normalImageName;
        _selectedImageName = selectedImageName;
        _title = title;
    }
    
    return self;
}

+ (instancetype)modelWithTitle:(NSString *)title className:(NSString *)className normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName
{
    return [[self alloc]initWithTitle:title className:className normalImageName:normalImageName selectedImageName:selectedImageName];
}
- (UIImage *)normalImage
{
    return [[UIImage imageNamed:self.normalImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)selectedImage
{
    return [[UIImage imageNamed:self.selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

@end
