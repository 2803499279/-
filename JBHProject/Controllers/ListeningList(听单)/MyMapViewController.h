//
//  MyMapViewController.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/12.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "BaseViewController.h"
#import "CellTopHeaderView.h"
#import "HomeTopTableViewCell.h"
#import "HomeCenterTableViewCell.h"
#import "HomeBottomTableViewCell.h"
#import "YZMaterialViewController.h" // 资料上传页面
#import "JHMapLocationView.h"// 定位+导航
#import "LocationAnnotationView.h"
#import "SelectableOverlay.h"
#import "RouteModel.h"
#import "MTWSimpleAlertView.h"
#import "YZOrderModel.h"
#define TOPCELLID @"Top"
#define CENTERCELLID @"Center"
#define BOOTOMCELLID @"Bottom"
#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3
@interface MyMapViewController : BaseViewController
@property (nonatomic,strong)UISwipeGestureRecognizer * recoginzerDown;// 下滑手势
@property (nonatomic,strong)UISwipeGestureRecognizer * recoginzerUp;// 上滑手势
@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic,strong)AMapNaviWalkManager * walkManager;// 骑行
@property (nonatomic,strong)RouteModel * routeModel;
@property (nonatomic,strong)SelectableOverlay * pathPolylines;
@property(nonatomic,strong)MTWSimpleAlertView * myAleartView;
@property(nonatomic,strong)YZOrderModel * orderModel;
@property(nonatomic,strong)UIView * coverView;
/**
 *路径规划是否成功
 */
@property(nonatomic,assign)BOOL ispathPolySuccess;
@end
