//
//  YZNewHomeModel.h
//  JBHProject
//
//  Created by zyz on 2018/1/17.
//  Copyright © 2018年 聚宝汇. All rights reserved.
//

#import "YZBaseModel.h"

@interface YZNewHomeModel : YZBaseModel

@property (nonatomic, copy) NSString *name; // 文章名称
@property (nonatomic, copy) NSString *text; // 文章类型
@property (nonatomic, copy) NSMutableArray *img; // 图片数组
@property (nonatomic, copy) NSString *id; // 文章id
@property (nonatomic, copy) NSString *ctime; // 文章显示时间

@property (nonatomic, copy) NSString *uri; // 文章显示时间


@end
