//
//  RouteModel.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "RouteModel.h"

@implementation RouteModel
+ (instancetype)RouteModelModelWith:(AMapNaviRoute *)naivRoute
{
    return [[self alloc]getModel:naivRoute];
}
- (instancetype)getModel:(AMapNaviRoute *)route
{
    NSString * lengthStr = [self timeFormatted:route.routeTime];
    NSString * time = [self routeLength:route.routeLength];
    self.titleLabelText = [NSString stringWithFormat:@"%@  %@",time,lengthStr];
    self.contentText = [NSString stringWithFormat:@"，途径红绿灯%ld个",route.routeSegments.count];
    return self;
}
- (NSString *)routeLength:(NSInteger)length
{
    if (length>1000) {
        CGFloat leng = (CGFloat)length/1000;
        return [NSString stringWithFormat:@"  全程%.2f公里，",leng];
    }
   return [NSString stringWithFormat:@"  全程%ld米，",length];
}
- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
//    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"预计用时%02ld小时%02ld分钟",hours, minutes];
}
@end
