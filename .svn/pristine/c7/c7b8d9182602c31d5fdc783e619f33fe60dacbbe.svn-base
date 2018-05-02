//
//  POISearchModel.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/17.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "POISearchModel.h"

@implementation POISearchModel
+ (NSMutableArray *)poiSearchModelWith:(AMapPOISearchResponse *)response
{
    NSMutableArray * poiArray = [NSMutableArray array];
    
    for(AMapPOI *poi in response.pois){
        DLog(@"%@地址：%@",poi.name,poi.address);
        DLog(@"%@",poi.description);
        POISearchModel * model = [[POISearchModel alloc]init];

        model.poiName = checkString(poi.name);
        model.poiAddress = checkString(poi.address);
        model.selectedLocation = poi.location;
        [poiArray addObject:model];
    }

    return poiArray;
}
+ (NSMutableArray *)poiInputModelWith:(AMapInputTipsSearchResponse *)response
{
    NSMutableArray * poiArray = [NSMutableArray array];
    
    for(AMapTip * tips in response.tips){
        DLog(@"%@地址：%@",tips.name,tips.address);
        DLog(@"%@",tips.description);
        POISearchModel * model = [[POISearchModel alloc]init];
        
        model.poiName = checkString(tips.name);
        model.poiAddress = checkString(tips.address);
        model.selectedLocation = tips.location;
        [poiArray addObject:model];
    }
    
    return poiArray;

}
+ (instancetype)poiModelWith:(NSString *)name address:(NSString *)address
{
    POISearchModel * model = [[POISearchModel alloc]init];
    model.poiName = name;
    model.poiAddress = address;
    return model;
}
@end
