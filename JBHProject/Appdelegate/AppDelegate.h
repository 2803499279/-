//
//  AppDelegate.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZListenSetViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign)NSInteger allowRotate;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,strong)AMapLocationManager * locationManager;// 开启定位
@property(nonatomic,copy)NSString * locationStr;// 经纬度

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

