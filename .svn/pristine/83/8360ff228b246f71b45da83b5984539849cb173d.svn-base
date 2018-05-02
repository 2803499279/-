//
//  HomeHeaderModel.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/22.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "HomeHeaderModel.h"

@implementation HomeHeaderModel
+ (instancetype)HomeHeaderModelWith:(id)respondsData
{
    
    return [[self alloc]getHomeHeaderModel:respondsData];
}
- (instancetype)getHomeHeaderModel:(id)responData
{
    NSDictionary * dict = responData[@"data"];
    NSDictionary * settingDict = dict[@"setting"];
    self.power = checkString(settingDict[@"power"]);
    self.accPower = checkString(settingDict[@"acc_power"]);
    self.time = settingDict[@"time"];
    self.address = checkString(settingDict[@"address"]);
    self.taskCount = dict[@"task_count"];
    self.taskAllreward = dict[@"task_allreward"];
    NSString * tmpStr = dict[@"task_rate"];
    self.point = checkString(settingDict[@"point"]);
    CGFloat rate = [tmpStr floatValue];
    self.taskRate = [NSString stringWithFormat:@"%.f%@",rate*100,@"%"];
    
    return self;
}

- (NSArray *)timeWithtimeStr:(NSString *)timeStr
{
    NSArray * array = [timeStr componentsSeparatedByString:@" "];
    return array;
}
@end
