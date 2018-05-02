//
//  RootViewViewController.m
//  NewJBHProject
//
//  Created by 李俊恒 on 2017/8/21.
//  Copyright © 2017年 李俊恒. All rights reserved.
//
/**
 * 根视图容器tabBar控制器
 */

#import "RootViewController.h"
#import "RootTabbarModel.h"
#import "YZNewHomeViewController.h"
#import "YZNewCaseController.h"
@interface RootViewController ()
@property (nonatomic,strong)NSMutableArray * tabBarModelArray;// 存放tabbar的model
@end

@implementation RootViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatTabBarModelArray];
        [self creatViewControllers];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
//    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//    // 给自定义 View 设置颜色
//    bgView.backgroundColor = [UIColor whiteColor];
//    // 将自定义 View 添加到 tabBar 上
//    [self.tabBar insertSubview:bgView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark =========== createModel
- (void)creatTabBarModelArray
{
    _tabBarModelArray = [[NSMutableArray alloc]init];
    RootTabbarModel * homeModel = [RootTabbarModel modelWithTitle:@"首页" className:@"YZNewHomeViewController" normalImageName:@"homePag" selectedImageName:@"homePage"];
    RootTabbarModel * ReconnaissanceModel = [RootTabbarModel modelWithTitle:@"听单" className:@"YZNewCaseController" normalImageName:@"YZCa" selectedImageName:@"YZCar"];
//    RootTabbarModel * classRoomModel = [RootTabbarModel modelWithTitle:@"课堂" className:@"SpeedClassController" normalImageName:@"YZSchoo" selectedImageName:@"YZSchool"];
    RootTabbarModel * myModel = [RootTabbarModel modelWithTitle:@"我的" className:@"MyViewController" normalImageName:@"YZPerso" selectedImageName:@"YZPerson"];
    [_tabBarModelArray addObject:homeModel];
    [_tabBarModelArray addObject:ReconnaissanceModel];
//    [_tabBarModelArray addObject:classRoomModel];
    [_tabBarModelArray addObject:myModel];
}
#pragma mark - UI -
- (void)creatViewControllers
{
    NSMutableArray * viewControllers = [NSMutableArray array];
    for (RootTabbarModel * model in self.tabBarModelArray) {
        NSString * className = model.className;
        UIViewController * viewController = [[NSClassFromString(className) alloc]init];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        nav.tabBarItem.title = model.title;
        nav.tabBarItem.image = [model normalImage];
        nav.tabBarItem.selectedImage = [model selectedImage];
        nav.tabBarController.tabBar.backgroundColor = [UIColor redColor];
        [viewControllers addObject:nav];
    }
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor jhUserInfoBlack],NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YZEssentialColor,NSForegroundColorAttributeName, nil] forState:(UIControlStateSelected)];
    self.viewControllers = viewControllers;
//    self.tabBar.backgroundColor = [UIColor clearColor];
//    self.tabBar.barTintColor = [UIColor clearColor];
}
@end
