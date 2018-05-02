//
//  YZDataBase.m
//  JBHProject
//
//  Created by zyz on 2017/4/26.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZDataBase.h"
#import "FMDB.h"
#import "YZOrderModel.h"

@interface YZDataBase ()

@property (nonatomic, strong) FMDatabase *OrderDB; // 数据库对象

@end


@implementation YZDataBase

static YZDataBase *single = nil;

// 创建单例的接口
+ (YZDataBase *)shareDataBase {
    
    @synchronized(self) {
        
        if (!single) {
            
            single = [[YZDataBase alloc] init];
            
            // 单例对象以创建成功就拥有数据库并打开
            [single ceratDataBase];
        }
    }
    return single;
}

// 创建数据库的方法
- (void)ceratDataBase {
    
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dbPath = [documents stringByAppendingPathComponent:@"db.sqlite"];
    
    // 初始化数据库对象
    self.OrderDB = [FMDatabase databaseWithPath:dbPath];
    
    // 打开数据库, 并创建数据库文件
    [self.OrderDB open];
    
    // 调用创建订单表格的方法
    [self creatOrderTable];
    
    // 调用创建新消息通知表格的方法
    [self creatPushTable];

}

#pragma mark - 电影表格
// 创建存放订单的表格
- (void)creatOrderTable {
    
    BOOL isSuccess = [self.OrderDB executeUpdate:@"create table if not exists YZOrderModel(id integer primary key autoincrement, tid text,type text,type_name text,custom_name text,custom_telphone text,arise_datetime text,arise_nearby text,arise_address text,arise_point text,distance text,reward text,remark text,cts_uid text,cts_name text,cts_avator text,state text,user_id text,license_plate text,vehicle_model text)"];
    
    DLog(@"%@", isSuccess ? @"订单表格创建成功" : @"订单表格创建失败");
    
}

// 创建添加订单的接口
- (void)insertOrder:(YZOrderModel *)Order {
    
    // 获取用户的uid
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    
    BOOL isSuccess = [self.OrderDB executeUpdate:@"insert into YZOrderModel(tid,type,type_name,custom_name,custom_telphone,arise_datetime,arise_nearby,arise_address,arise_point,distance,reward,remark,cts_uid,cts_name,cts_avator,state,user_id,license_plate,vehicle_model)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", Order.tid, Order.type, Order.type_name, Order.custom_name, Order.custom_telphone, Order.arise_datetime, Order.arise_nearby, Order.arise_address, Order.arise_point, Order.distance, Order.reward, Order.remark, Order.cts_uid, Order.cts_name, Order.cts_avator, Order.state, model.uid, Order.license_plate, Order.vehicle_model];
    
    DLog(@"%@", isSuccess ? @"插入订单成功" : @"插入订单失败");
    
}

// 取出订单表格中所有的订单
- (NSArray *)selectAllOrder {
    
    // 存放找到的数据
    NSMutableArray *array = [NSMutableArray array];
    
    // 查询整个表
    FMResultSet *set = [self.OrderDB executeQuery:@"select * from YZOrderModel"];

    // 结构化查询
    while ([set next]) {
        
        // 取出每个字段下的数据order
        NSString *tid = [set stringForColumn:@"tid"];
        NSString *type = [set stringForColumn:@"type"];
        NSString *type_name = [set stringForColumn:@"type_name"];
        NSString *custom_name = [set stringForColumn:@"custom_name"];
        NSString *custom_telphone = [set stringForColumn:@"custom_telphone"];
        NSString *arise_datetime = [set stringForColumn:@"arise_datetime"];
        NSString *arise_nearby = [set stringForColumn:@"arise_nearby"];
        NSString *arise_address = [set stringForColumn:@"arise_address"];
        NSString *arise_point = [set stringForColumn:@"arise_point"];
        NSString *distance = [set stringForColumn:@"distance"];
        NSString *reward = [set stringForColumn:@"reward"];
        NSString *remark = [set stringForColumn:@"remark"];
        NSString *cts_uid = [set stringForColumn:@"cts_uid"];
        NSString *cts_name = [set stringForColumn:@"cts_name"];
        NSString *cts_avator = [set stringForColumn:@"cts_avator"];
        NSString *state = [set stringForColumn:@"state"];
        NSString *license_plate = [set stringForColumn:@"license_plate"];
        NSString *vehicle_model = [set stringForColumn:@"vehicle_model"];
        
        // 创建订单对象
        YZOrderModel *order = [[YZOrderModel alloc] init];
        order.tid = tid;
        order.type = type;
        order.type_name = type_name;
        order.custom_name = custom_name;
        order.custom_telphone = custom_telphone;
        order.arise_datetime = arise_datetime;
        order.arise_nearby = arise_nearby;
        order.arise_address = arise_address;
        order.arise_point = arise_point;
        order.distance = distance;
        order.reward = reward;
        order.remark = remark;
        order.cts_uid = cts_uid;
        order.cts_name = cts_name;
        order.cts_avator = cts_avator;
        order.state = state;
        order.license_plate = license_plate;
        order.vehicle_model = vehicle_model;
        
        // 把订单对象添加到数组中
        [array addObject:order];
        
    }
    [set close];
    return array;
    
    
}

// 根据uid取出订单表格中的相应订单
- (NSArray *)selectUidOrder:(NSString *)uid {
    
    // 存放找到的数据
    NSMutableArray *array = [NSMutableArray array];
    
    // 查询整个表
    FMResultSet *set = [self.OrderDB executeQuery:@"select*from YZOrderModel where user_id = ?", uid];
    
    // 结构化查询
    while ([set next]) {
        
        // 取出每个字段下的数据order
        NSString *tid = [set stringForColumn:@"tid"];
        NSString *type = [set stringForColumn:@"type"];
        NSString *type_name = [set stringForColumn:@"type_name"];
        NSString *custom_name = [set stringForColumn:@"custom_name"];
        NSString *custom_telphone = [set stringForColumn:@"custom_telphone"];
        NSString *arise_datetime = [set stringForColumn:@"arise_datetime"];
        NSString *arise_nearby = [set stringForColumn:@"arise_nearby"];
        NSString *arise_address = [set stringForColumn:@"arise_address"];
        NSString *arise_point = [set stringForColumn:@"arise_point"];
        NSString *distance = [set stringForColumn:@"distance"];
        NSString *reward = [set stringForColumn:@"reward"];
        NSString *remark = [set stringForColumn:@"remark"];
        NSString *cts_uid = [set stringForColumn:@"cts_uid"];
        NSString *cts_name = [set stringForColumn:@"cts_name"];
        NSString *cts_avator = [set stringForColumn:@"cts_avator"];
        NSString *state = [set stringForColumn:@"state"];
        
        NSString *license_plate = [set stringForColumn:@"license_plate"];
        NSString *vehicle_model = [set stringForColumn:@"vehicle_model"];
        
        // 创建订单对象
        YZOrderModel *order = [[YZOrderModel alloc] init];
        order.tid = tid;
        order.type = type;
        order.type_name = type_name;
        order.custom_name = custom_name;
        order.custom_telphone = custom_telphone;
        order.arise_datetime = arise_datetime;
        order.arise_nearby = arise_nearby;
        order.arise_address = arise_address;
        order.arise_point = arise_point;
        order.distance = distance;
        order.reward = reward;
        order.remark = remark;
        order.cts_uid = cts_uid;
        order.cts_name = cts_name;
        order.cts_avator = cts_avator;
        order.state = state;
        
        order.license_plate = license_plate;
        order.vehicle_model = vehicle_model;
        
        // 把电影对象添加到数组中
        [array addObject:order];
        
    }
    [set close];
    return array;
    
    
}

// 根据tid取出订单表格中的相应订单
- (NSArray *)selectTidOrder:(NSString *)tid Uid:(NSString *)uid {
    
    // 存放找到的数据
    NSMutableArray *array = [NSMutableArray array];
    
    // 查询整个表
    FMResultSet *set = [self.OrderDB executeQuery:@"select*from YZOrderModel where tid = ? and user_id = ?", tid, uid];
    
    // 结构化查询
    while ([set next]) {
        
        // 取出每个字段下的数据order
        NSString *tid = [set stringForColumn:@"tid"];
        NSString *type = [set stringForColumn:@"type"];
        NSString *type_name = [set stringForColumn:@"type_name"];
        NSString *custom_name = [set stringForColumn:@"custom_name"];
        NSString *custom_telphone = [set stringForColumn:@"custom_telphone"];
        NSString *arise_datetime = [set stringForColumn:@"arise_datetime"];
        NSString *arise_nearby = [set stringForColumn:@"arise_nearby"];
        NSString *arise_address = [set stringForColumn:@"arise_address"];
        NSString *arise_point = [set stringForColumn:@"arise_point"];
        NSString *distance = [set stringForColumn:@"distance"];
        NSString *reward = [set stringForColumn:@"reward"];
        NSString *remark = [set stringForColumn:@"remark"];
        NSString *cts_uid = [set stringForColumn:@"cts_uid"];
        NSString *cts_name = [set stringForColumn:@"cts_name"];
        NSString *cts_avator = [set stringForColumn:@"cts_avator"];
        NSString *state = [set stringForColumn:@"state"];
        
        NSString *license_plate = [set stringForColumn:@"license_plate"];
        NSString *vehicle_model = [set stringForColumn:@"vehicle_model"];
        
        // 创建订单对象
        YZOrderModel *order = [[YZOrderModel alloc] init];
        order.tid = tid;
        order.type = type;
        order.type_name = type_name;
        order.custom_name = custom_name;
        order.custom_telphone = custom_telphone;
        order.arise_datetime = arise_datetime;
        order.arise_nearby = arise_nearby;
        order.arise_address = arise_address;
        order.arise_point = arise_point;
        order.distance = distance;
        order.reward = reward;
        order.remark = remark;
        order.cts_uid = cts_uid;
        order.cts_name = cts_name;
        order.cts_avator = cts_avator;
        order.state = state;
        order.license_plate = license_plate;
        order.vehicle_model = vehicle_model;
        // 把电影对象添加到数组中
        [array addObject:order];
        
    }
    [set close];
    return array;
    
}



// 删除订单的接口
- (void)deleteOneMovieByOrderID:(NSString *)tid {
    
    BOOL isSuccess = [self.OrderDB executeUpdate:@"delete from YZOrderModel where tid = ?", tid];
    DLog(@"%@", isSuccess ? @"删除成功" : @"删除失败");
}

// 修改订单
- (void)ModifyTheOrder:(NSString *)state Tid:(NSString *)tid Uid:(NSString *)uid {
    
    BOOL isSuccess = [self.OrderDB executeUpdate:@"update YZOrderModel set state = ? where tid = ? and user_id = ?", state, tid, uid];
    _isSuccessSteState = isSuccess;
    DLog(@"%@", isSuccess ? @"修改成功" : @"修改失败");
}


// ********************************************************新通知消息*******************************************************

#pragma mark - 接受新通知消息的接口

// 创建存放通知消息的表格
- (void)creatPushTable {
    
    BOOL isSuccess = [self.OrderDB executeUpdate:@"create table if not exists YZPushModel(id integer primary key autoincrement, mid text,title text,content text,link text,pic text,user_id text,datetime text)"];
    
    DLog(@"%@", isSuccess ? @"消息表格创建成功" : @"消息表格创建失败");
    
}


// 创建添加通知消息的接口
- (void)insertPush:(YZPushModel *)Push {
    
    // 获取用户的uid
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    
    BOOL isSuccess = [self.OrderDB executeUpdate:@"insert into YZPushModel(mid,title,content,link,pic,user_id,datetime)values(?,?,?,?,?,?,?)", Push.mid, Push.title, Push.content, Push.link, Push.pic, model.uid, Push.datetime];
    
    DLog(@"%@", isSuccess ? @"插入消息成功" : @"插入消息失败");
}

// 根据uid取出通知消息表格中的相应订单
- (NSArray *)selectUidPush:(NSString *)uid {
    
    // 存放找到的数据
    NSMutableArray *array = [NSMutableArray array];
    
    // 查询整个表
    FMResultSet *set = [self.OrderDB executeQuery:@"select*from YZPushModel where user_id = ?", uid];
    
    // 结构化查询
    while ([set next]) {
        
        // 取出每个字段下的数据order
        NSString *mid = [set stringForColumn:@"mid"];
        NSString *title = [set stringForColumn:@"title"];
        NSString *content = [set stringForColumn:@"content"];
        NSString *link = [set stringForColumn:@"link"];
        NSString *pic = [set stringForColumn:@"pic"];
        NSString *datetime = [set stringForColumn:@"datetime"];
        
        // 创建订单对象
        YZPushModel *push = [[YZPushModel alloc] init];
        push.mid = mid;
        push.title = title;
        push.content = content;
        push.link = link;
        push.pic = pic;
        push.datetime = datetime;
        
        // 把电影对象添加到数组中
        [array addObject:push];
    }
    [set close];
    return array;
    
}

// 删除通知消息的接口
- (void)deleteOneMovieByPushID:(NSString *)mid {
    
    BOOL isSuccess = [self.OrderDB executeUpdate:@"delete from YZPushModel where mid = ?", mid];
    DLog(@"%@", isSuccess ? @"删除消息成功" : @"删除消息失败");
    
}







@end
