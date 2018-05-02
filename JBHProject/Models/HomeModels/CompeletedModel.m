//
//  CompeletedModel.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/28.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "CompeletedModel.h"

@implementation CompeletedModel
+ (NSMutableArray *)parseRespondsData:(id)respondsData
{
    NSMutableArray * dataArray = [NSMutableArray array];
    
    NSArray * array = respondsData[@"data"];
    
    if (array.count != 0) {
        
        for (NSDictionary * dic  in array) {
            
            CompeletedModel * model = [[CompeletedModel alloc]init];
            model.type_name = checkString(dic[@"type_name"]);
            model.arise_datetime = checkString(dic[@"arise_datetime"]);;
            model.distance = checkString(dic[@"distance"]);
            model.arise_address = checkString(dic[@"arise_address"]);
            model.reward = checkString(dic[@"reward"]);
            model.remark = checkString(dic[@"remark"]);;
            [dataArray addObject:model];
        }
        DLog(@"请求到的数据%@",dataArray);
        return dataArray;
    }
    return nil;
}

@end
