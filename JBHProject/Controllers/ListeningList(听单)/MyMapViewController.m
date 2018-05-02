//
//  MyMapViewController.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/12.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "MyMapViewController.h"
#import "RideRouteViewController.h"
#import "DriveViewController.h"
#import "YZCancelInvestigateController.h"
//#import "YZMaterialViewController.h" // 资料上传页面 (暂时弃用)
#import "YZNewMaterialViewController.h" // 资料上传页面
#define TOPCELLID @"Top"
#define CENTERCELLID @"Center"
#define BOOTOMCELLID @"Bottom"
#define TABLE_Y self.orderModel.remark.length>26?Screen_H*0.5-70:Screen_H*0.5-55*YZAdapter
#define TABLE_HEIGHT self.orderModel.remark.length>26?Screen_H*0.5+70*YZAdapter:Screen_H*0.5+50*YZAdapter
@interface MyMapViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,CellTopHeaderViewDelegate,AMapNaviWalkManagerDelegate,JHMapLocationViewDelegate,MTWSimpleAlertViewDelegate,AMapLocationManagerDelegate,HomeTopTableViewCellDelegate>
@property(nonatomic,strong)MAMapView * mapView;// 地图
@property(nonatomic,strong)AMapSearchAPI * search;// 地图搜索API类
@property(nonatomic,assign)CLLocationCoordinate2D  currentLocation;// 当前位置
@property(nonatomic,copy)MAPointAnnotation * destinationPoint;// 选中的位置MAPointAnnotation

@property(nonatomic,strong)UITableView * mapTableView;// 订单详情展示
@property(nonatomic,strong)NSMutableArray * mapDataSources;// 列表数据
@property(nonatomic,strong)CellTopHeaderView * topHeaderView;// 列表的头视图
@property(nonatomic,assign)BOOL isSelectecd;

@property(nonatomic,strong)JHMapLocationView * jhLocationView;// 定位导航按钮

@property(nonatomic,strong)LocationAnnotationView * locationAnnotationView;// 当前位置大头针
@property(nonatomic, strong) AMapNaviPoint *startPoint;
@property(nonatomic, strong) AMapNaviPoint *endPoint;
@property(nonatomic,assign)BOOL isDrive;

@property(nonatomic,strong)HomeNetWorking * manager;
@property(nonatomic,strong)UIView * tableViewFootSectionView;
@property(nonatomic,strong)NSTimer * mapViewTimer;// 定时器
// 定时器
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger IDInt;

@end
@implementation MyMapViewController

#pragma mark ------- lifecircle
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
//    self.tabBarController.tabBar.translucent = YES;

    [self.view addSubview:self.mapView];
    [self.view addSubview:self.mapTableView];
    [self.view addSubview:self.jhLocationView];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {

        self.startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude
                                                    longitude:location.coordinate.longitude];

        [self initRideProperties];
    }];
    
    _IDInt = 0;
#pragma mark------------ 定位成功开启上传位置判断位置
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isenterMyMapView" object:@"进入到myMapView界面"];
    _mapViewTimer =  [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(mapViewFunction) userInfo:nil repeats:YES];
    [_mapViewTimer setFireDate:[NSDate distantPast]];// 开启定时器
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addServiceRightButton];
    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(searchStatusnetRequest) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
    [self searchStatusnetRequest];
    self.mapTableView.delaysContentTouches = NO;
    // 该方式相当于上面两个循环的合集，并且实现方式更加优雅，推荐使用它，而不是使用上面两个循环
    for (id obj in self.mapTableView.subviews) {
        if ([obj respondsToSelector:@selector(setDelaysContentTouches:)]) {
            [obj setDelaysContentTouches:NO];
        }
    }

    
    [self customPushViewControllerNavBarTitle:self.orderModel.custom_name backGroundImageName:nil];
    self.automaticallyAdjustsScrollViewInsets=NO;
       // 右划返回上一个页面
    [self customerGesturePop];
    


}

#pragma mark - Private Method 右划返回上一个页面
- (void)customerGesturePop {
    UISwipeGestureRecognizer *swipeGestuer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleOtherSwipeGesture)];
    swipeGestuer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestuer2];
}

- (void) handleOtherSwipeGesture {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.translucent = NO;

    [_mapViewTimer setFireDate:[NSDate distantFuture]];
    [_mapViewTimer invalidate];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isgoBackHomeView" object:@"退出myMapView界面"];

    _mapViewTimer = nil;
    self.mapView.delegate = nil;
    self.locationManager.delegate = nil;
    self.mapView = nil;
    
    // 停止定时器
    [self.timer invalidate];
//    self.tabBarController.tabBar.hidden = NO;

}
#pragma mark --------- fucntion
- (void)mapViewFunction{
    
    self.topHeaderView.userTimeStr = [JHTools getTaskUseTime:self.orderModel.arise_datetime];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        NSString * locationStr = [NSString stringWithFormat:@"%f %f",location.coordinate.longitude,location.coordinate.latitude];
        NSString * timeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyMapViewUpLoadLocation"];
        NSString * scendTime = [JHTools getCurrentSecondTime];
        int isZeor = abs([scendTime intValue]-[timeStr intValue]);
        DLog(@"%@",timeStr);
        if ([timeStr isEqualToString:@"MapViewCurrent"]||isZeor!=0) {
            [self uploadMyLocationWithPointStr:locationStr];
        }
        #pragma mark ========== 判断是否到达
            NSArray * locationArray = [self.orderModel.arise_point componentsSeparatedByString:@" "];
            CLLocationCoordinate2D location1 = CLLocationCoordinate2DMake([[locationArray lastObject] floatValue],[[locationArray firstObject] floatValue]);
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
            BOOL isContains = MACircleContainsCoordinate(location1, center, 200);
        
        if (isContains) {
                NSString * url = @"task/arrive";
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                dict[@"tid"] = self.orderModel.tid;
            dict[@"point"] = locationStr;
                [self.manager userArrivePOSTLocationPointWithURl:url Dictionary:dict Succes:^(id responsData) {
                    DLog(@"%@",responsData);
                   
                    UIButton * button = [self.tableViewFootSectionView viewWithTag:1111];
                    UIImageView * imageView = [self.tableViewFootSectionView viewWithTag:2222];
                    imageView.image = [UIImage imageNamed:@"details-Photograph"];
                    button.backgroundColor = YZEssentialColor;
                    button.titleLabel.textColor = [UIColor whiteColor];
                    button.layer.borderColor = [UIColor whiteColor].CGColor;
                    [_mapViewTimer setFireDate:[NSDate distantFuture]];
                    [_mapViewTimer invalidate];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isgoBackHomeView" object:@"退出myMapView界面"];
                    _mapViewTimer = nil;
                } failed:^(NSError *error) {
                    
                }];
            }else{
            }
    }];

}
- (void)uploadMyLocationWithPointStr:(NSString *)point
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"point"] = point;
    NSString * url = @"location/renew";
    [self.manager uploadUserLocationPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
        NSString * code = responsData[@"code"];
        if ([code integerValue] == 0) {
            [[NSUserDefaults standardUserDefaults]setObject:[JHTools getSystemTime] forKey:@"MyMapViewUpLoadLocation"];
            DLog(@"上传用户地理位置信息%@",responsData);
            NSString * time = [JHTools getSystemTime];
            DLog(@"位于前台的上传位置信息%@",time);
        }
//        else if ([code integerValue] == 900102) {
//            [_mapViewTimer setFireDate:[NSDate distantFuture]];
//            [_mapViewTimer invalidate];
//            _mapViewTimer = nil;
//            [MBProgressHUD showAutoMessage:@"登录信息失效"];
//            //                LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"登录信息失效" BubbleImage:@"YZPromptSubmit"], 1);
//            
//            YZLoginViewController * vc = [[YZLoginViewController alloc]init];
//            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
//            vc.AlertPhone = model.Usre_Phone;
//            
//            [[YZUserInfoManager sharedManager] didLoginOut];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }
    } failed:^(NSError *error) {
        DLog(@"失败%@",error);
    }];

}
#pragma mark =============== 查询订单状态task/status
- (void)searchStatusnetRequest{
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    dict[@"tid"] = self.orderModel.tid;
//    NSString * url = @"task/status";
//    [self.manager taskStatusPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
//       // 查询审核状态
//        DLog(@"查询审核状态结果%@",responsData);
//        
//    } failed:^(NSError *error) {
//        DLog(@"查询审核状态失败");
//    }];
    
    YZALLService *TaskStatusRequest = [YZALLService zwb_requestWithUrl:TASK_STATUS_URL isPost:YES];
    
    WeakSelf(self);
    
    TaskStatusRequest.tid = self.orderModel.tid;
    
    [TaskStatusRequest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
        DLog(@"%@", message);
        if (success) {
            
            DLog(@"return success:%@", responseObject);
            NSString * code = responseObject[@"code"];
            if ([code integerValue] == 0) {
                // 停止定时器
                [weakSelf.timer invalidate];
                // 关闭进度加载页面
                LKHideBubble();
                
                [YZPhotoSingleton shareSingleton].SFZPhoto = nil;
                [YZPhotoSingleton shareSingleton].JSZPhoto = nil;
                [YZPhotoSingleton shareSingleton].XSZPhoto = nil;
                [YZPhotoSingleton shareSingleton].BXDDPhoto = nil;
                [YZPhotoSingleton shareSingleton].CLZQPhoto = nil;
                [YZPhotoSingleton shareSingleton].CLYQPhoto = nil;
                [YZPhotoSingleton shareSingleton].CLZHPhoto = nil;
                [YZPhotoSingleton shareSingleton].CLYHPhoto = nil;
                [YZPhotoSingleton shareSingleton].CLJHPhoto = nil;
                [YZPhotoSingleton shareSingleton].ALLhoto = nil;
                
                // 删除已完成的派单
                [[YZDataBase shareDataBase] deleteOneMovieByOrderID:self.orderModel.tid];
                
                // 提示框
                YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
                    DLog(@"输入内容：%@", inputText);
                    // 进入派单完成界面
                    YZCompleteViewController *YZCompleteController = [[YZCompleteViewController alloc] init];
                    YZCompleteController.tid = self.orderModel.tid;
                    YZCompleteController.price = self.orderModel.reward;
                    YZCompleteController.share_title = responseObject[@"data"][@"share_title"];
                    YZCompleteController.share_content = responseObject[@"data"][@"share_content"];
                    YZCompleteController.share_pic = responseObject[@"data"][@"share_pic"];
                    YZCompleteController.share_link = responseObject[@"data"][@"share_link"];
                    YZCompleteController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:YZCompleteController animated:YES];
                }];
                YZPromptController.IDStr = @"材料照片审核通过";
                [self presentViewController:YZPromptController animated:YES completion:nil];
                
            }else if ([code integerValue] == 900102) {
                [MBProgressHUD showAutoMessage:@"登录信息失效"];
                
                YZLoginViewController * vc = [[YZLoginViewController alloc]init];
                YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
                vc.AlertPhone = model.Usre_Phone;
                
                [[YZUserInfoManager sharedManager] didLoginOut];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([code integerValue] == 205002) {
                
                NSDictionary *statusDic = responseObject[@"data"];
                
                if ([statusDic[@"status"] isEqualToString:@"TZJS"]) {
                    LKHideBubble();
                    DLog(@"通知已接收");
                    // 停止定时器
                    [weakSelf.timer invalidate];
                }else if ([statusDic[@"status"] isEqualToString:@"YJS_"]) {
                    LKHideBubble();
                    DLog(@"已接受，正在处理");
                    // 停止定时器
                    [weakSelf.timer invalidate];
                }else if ([statusDic[@"status"] isEqualToString:@"YDD_"]) {
                    LKHideBubble();
                    DLog(@"已到达，正在处理");
                    // 停止定时器
                    [weakSelf.timer invalidate];
                    
                }else if ([statusDic[@"status"] isEqualToString:@"YTJ_"]) {
                    DLog(@"已提交，正在审核");
                    _IDInt = _IDInt+1;
                    if (_IDInt == 1) {
                        LKWaitBubble(@"正在审核中");
                    }
                    
                }else if ([statusDic[@"status"] isEqualToString:@"SHBG"]) {
                    LKHideBubble();
                    DLog(@"审核不过，重新提交中");
                    YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
                        DLog(@"输入内容：%@", inputText);
                    }];
                    YZPromptController.IDStr = @"审核不通过";
                    YZPromptController.OrderError = responseObject[@"data"][@"status_name"];
                    [self presentViewController:YZPromptController animated:YES completion:nil];
                    // 停止定时器
                    [weakSelf.timer invalidate];
                }else if ([statusDic[@"status"] isEqualToString:@"SUCC"]) {
                    LKHideBubble();
                    DLog(@"已完成");
                }
                
            }else if ([code integerValue] == 205001) {
                [MBProgressHUD showAutoMessage:@"ID错误"];
            }
        } else {
            DLog(@"return failure");
            // 提示框
//            YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
//                DLog(@"输入内容：%@", inputText);
//            }];
//            YZPromptController.IDStr = @"审核不通过";
//            [self presentViewController:YZPromptController animated:YES completion:nil];
            [MBProgressHUD showAutoMessage:@"审核失败, 请检查您的网络连接"];
            // 停止定时器
            [weakSelf.timer invalidate];
            // 关闭进度加载页面
            LKHideBubble();
        }
    } failure:^(NSError *error) {
        DLog(@"error == %@", error);
        // 停止定时器
        [weakSelf.timer invalidate];
        // 关闭进度加载页面
        LKHideBubble();
    }];

    
}
#pragma mark ------- init
- (HomeNetWorking *)manager
{
    if (_manager == nil) {
        _manager = [HomeNetWorking sharedInstance];
    }
    return _manager;
}
- (AMapLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[AMapLocationManager alloc] init];
        //设置期望定位精度
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        
        //设置不允许系统暂停定位
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        
        //设置允许在后台定位
        [self.locationManager setAllowsBackgroundLocationUpdates:NO];
        
        //设置定位超时时间
        [self.locationManager setLocationTimeout:DefaultLocationTimeout];
        
        //设置逆地理超时时间
        [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
        [_locationManager setDelegate:self];
    }
    return _locationManager;
}

- (void)initRideProperties
{
    
    NSArray * locationArray = [self.orderModel.arise_point componentsSeparatedByString:@" "];
    
    self.endPoint   = [AMapNaviPoint locationWithLatitude:[[locationArray lastObject] floatValue]
                                                longitude:[[locationArray firstObject] floatValue]];
    _destinationPoint = [[MAPointAnnotation alloc] init];
    _destinationPoint.coordinate = CLLocationCoordinate2DMake([[locationArray lastObject] floatValue], [[locationArray firstObject] floatValue]);

    [self.mapView addAnnotation:_destinationPoint];
    
    [self.walkManager calculateWalkRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint]];
}

// 骑行
- (AMapNaviWalkManager *)walkManager
{
    if (_walkManager == nil)
    {
        _walkManager = [[AMapNaviWalkManager alloc] init];
        [_walkManager setDelegate:self];
    }
    return _walkManager;
}

- (JHMapLocationView *)jhLocationView
{
    if (_jhLocationView == nil) {
        _jhLocationView = [[JHMapLocationView alloc]initWithFrame:CGRectMake(0, self.mapTableView.frame.origin.y-55*Size_ratio, Screen_W, 50*Size_ratio)];
        _jhLocationView.delegate = self;
    }
    return _jhLocationView;
}
- (MAMapView *)mapView
{
    if (_mapView == nil) {
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, -Screen_H*0.25, Screen_W, Screen_H+64+Screen_H*0.25)];
        _mapView.mapType = MAMapTypeStandard;
        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_mapView setZoomLevel:(12.0f) animated:YES];
        _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
        _mapView.centerCoordinate = self.mapView.userLocation.coordinate;
        _mapView.pausesLocationUpdatesAutomatically = NO;
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;  
        _mapView.rotateEnabled = NO;
        _mapView.showTraffic = YES;
        _mapView.showsCompass= NO; // 设置成NO表示关闭指南针；YES表示显示指南针
        _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, Screen_H*0.25 + 10*Size_ratio);
        _mapView.scaleOrigin= CGPointMake(20*Size_ratio, Screen_H*0.25+10*Size_ratio);  //设置比例尺位置
        _mapView.showsScale= NO;  //设置成NO表示不显示比例尺；YES表示显示比例尺`
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
    return _mapView;
}
- (AMapSearchAPI *)search
{
    if (_search == nil) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}
- (CellTopHeaderView *)topHeaderView
{
    if (_topHeaderView == nil) {
        _topHeaderView = [[CellTopHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 40*YZAdapter)];
        _topHeaderView.typeName = self.orderModel.type_name;
        _topHeaderView.userTimeStr = [JHTools getTaskUseTime:self.orderModel.arise_datetime];
        
        _topHeaderView.cellTopHeaderViewDelegate = self;
#pragma mark ------------ 上滑
        _recoginzerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [_recoginzerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [_topHeaderView addGestureRecognizer:_recoginzerUp];
#pragma mark ------------- 下滑
        _recoginzerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [_recoginzerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [_topHeaderView addGestureRecognizer:_recoginzerDown];
    }
    return _topHeaderView;
}
- (UITableView *)mapTableView
{
    if (_mapTableView == nil) {
        if (iPhone5) {
            _mapTableView = [[UITableView alloc]initWithFrame:CGRectMake(10*Size_ratio, TABLE_Y, Screen_W-20*Size_ratio, TABLE_HEIGHT)];
        }else
        {
            _mapTableView = [[UITableView alloc]initWithFrame:CGRectMake(10*Size_ratio, TABLE_Y+10*YZAdapter, Screen_W-20*Size_ratio, TABLE_HEIGHT)];
        }
        
        _mapTableView.delegate = self;
        _mapTableView.dataSource = self;
        _mapTableView.scrollEnabled = NO;
        self.mapTableView.tableHeaderView = self.topHeaderView;
        self.mapTableView.tableFooterView = self.tableViewFootSectionView;
        _mapTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mapTableView registerClass:[HomeTopTableViewCell class] forCellReuseIdentifier:TOPCELLID];
        [_mapTableView registerClass:[HomeCenterTableViewCell class] forCellReuseIdentifier:CENTERCELLID];
        [_mapTableView registerClass:[HomeBottomTableViewCell class] forCellReuseIdentifier:BOOTOMCELLID];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_mapTableView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10*Size_ratio, 10*Size_ratio)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _mapTableView.bounds;
        maskLayer.path = maskPath.CGPath;
        _mapTableView.layer.mask = maskLayer;
        
#pragma mark ------------ 上滑
        _recoginzerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [_recoginzerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [_mapTableView addGestureRecognizer:_recoginzerUp];
#pragma mark ------------- 下滑
        _recoginzerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [_recoginzerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [_mapTableView addGestureRecognizer:_recoginzerDown];
    }
    return _mapTableView;
}
- (UIView *)tableViewFootSectionView
{
    if (_tableViewFootSectionView == nil) {
        _tableViewFootSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-20*Size_ratio, 50*Size_ratio)];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(110*Size_ratio, 15*Size_ratio, 20*Size_ratio, 20*Size_ratio)];
        
        imageView.image = [UIImage imageNamed:@"材料相机"];
        imageView.tag = 2222;
        
        _tableViewFootSectionView.backgroundColor = [UIColor whiteColor];
    
        UIButton * prepareDataBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*Size_ratio, 5*Size_ratio, Screen_W - 40*Size_ratio, 40*Size_ratio)];
        prepareDataBtn.tag = 1111;
        prepareDataBtn.backgroundColor = [UIColor whiteColor];
        [prepareDataBtn setTitleColor:YZEssentialColor forState:UIControlStateNormal];
        [prepareDataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [prepareDataBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg.png"] forState:UIControlStateHighlighted];
    
        [prepareDataBtn setTitle:@"准备材料照片" forState:UIControlStateNormal];
        prepareDataBtn.layer.borderWidth = 1*Size_ratio;
        prepareDataBtn.titleLabel.font = [UIFont systemFontOfSize:16*YZAdapter];
        prepareDataBtn.layer.borderColor = MainLine_Color.CGColor;
        [prepareDataBtn addTarget:self action:@selector(prepareDataBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewFootSectionView addSubview:prepareDataBtn];
        [_tableViewFootSectionView addSubview:imageView];
    }
    return _tableViewFootSectionView;

}
#pragma mark --------- Action

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        DLog(@"swipe down");
        _isSelectecd = !_isSelectecd;

        [self.topHeaderView.scrollerButton setBackgroundImage:[UIImage imageNamed:@"上"] forState:0];

        [UIView animateWithDuration:0.5 animations:^{
            self.mapTableView.frame = CGRectMake(10*Size_ratio, Screen_H*0.5 + 170*Size_ratio, Screen_W-20*Size_ratio, Screen_H*0.5-36*Size_ratio-64);
            
            self.jhLocationView.frame = CGRectMake(0, self.mapTableView.frame.origin.y-55*Size_ratio, Screen_W, 50*Size_ratio);
            
        }];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        DLog(@"swipe up");
        _isSelectecd = !_isSelectecd;

        [self.topHeaderView.scrollerButton setBackgroundImage:[UIImage imageNamed:@"下"] forState:0];

        [UIView animateWithDuration:0.5 animations:^{
            if (iPhone5) {
                self.mapTableView.frame = CGRectMake(10*Size_ratio, TABLE_Y, Screen_W-20*Size_ratio, TABLE_HEIGHT);

            }else
            {
                self.mapTableView.frame = CGRectMake(10*Size_ratio, TABLE_Y+10*Size_ratio, Screen_W-20*Size_ratio, TABLE_HEIGHT);
            }
            self.jhLocationView.frame = CGRectMake(0, self.mapTableView.frame.origin.y-55*Size_ratio, Screen_W, 50*Size_ratio);
        }];
        
    }
}
// 点击按钮进入资料上传页面
- (void)prepareDataBtnClick:(UIButton *)sender {
    
    YZNewMaterialViewController *YZNewMaterialController = [[YZNewMaterialViewController alloc] init];
    
    YZNewMaterialController.point = [NSString stringWithFormat:@"%f %f",_currentLocation.longitude,_currentLocation.latitude];
    
    YZNewMaterialController.tid = self.orderModel.tid;
    YZNewMaterialController.price = self.orderModel.reward;
    YZNewMaterialController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:YZNewMaterialController animated:YES];
}

// 反向地理编码
- (void)reGeoActionWith
{
    if (_destinationPoint) {
        AMapReGeocodeSearchRequest * request = [[AMapReGeocodeSearchRequest alloc]init];
        request.location = [AMapGeoPoint locationWithLatitude:_destinationPoint.coordinate.latitude
                                                    longitude:_destinationPoint.coordinate.longitude];
        [self.search AMapReGoecodeSearch:request];
    }
}
#pragma mark ---------MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
        if (!updatingLocation && _locationAnnotationView != nil)
        {
            [UIView animateWithDuration:0.1 animations:^{
                _locationAnnotationView.rotateDegree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            }];

        }
        if (_currentLocation.latitude != userLocation.coordinate.latitude || _currentLocation.longitude != userLocation.coordinate.longitude) {
    DLog(@"changed");
            _currentLocation = userLocation.coordinate;
        }
}
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView
{
    [self initRideProperties];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[LocationAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:userLocationStyleReuseIndetifier];
            
            annotationView.canShowCallout = YES;
        }
        
        _locationAnnotationView = (LocationAnnotationView *)annotationView;
        [_locationAnnotationView updateImage:[UIImage imageNamed:@"userPosition.png"]];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    [self reGeoActionWith];
}
// 点击后根据反向地理编码进行位置解读
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
//    if (_destinationPoint != nil) {
//        // 清理
//        [self.mapView removeAnnotation:_destinationPoint];
//        _destinationPoint = nil;
//    }
//    _destinationPoint = [[MAPointAnnotation alloc]init];
//    _destinationPoint.coordinate = coordinate;
//    [self.mapView addAnnotation:_destinationPoint];
//    [self reGeoActionWith];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {

        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.lineWidth = 8.f;

        polylineRenderer.lineCapType = kMALineCapArrow;
        polylineRenderer.lineJoinType = kMALineJoinRound;
        
        [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture0"]];
        return polylineRenderer;
    }
    return nil;
}
- (void)mapView:(MAMapView *)mapView didAddOverlayRenderers:(NSArray *)overlayRenderers
{
}
#pragma mark ------AMapSearchDelegate
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
//    AMapPath * path = response.route.paths;

}
// 逆向地理编码
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    DLog(@"respone:%@",response);
    NSString * title = response.regeocode.addressComponent.city;
    if (title.length == 0) {
        title = response.regeocode.addressComponent.province;
    }
    _destinationPoint.title = title;
    _destinationPoint.subtitle = response.regeocode.formattedAddress;
    
    
}

#pragma mark ----------- AMapNaviWalkManagerDelegate
- (void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error
{
    self.ispathPolySuccess = NO;
}
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager
{
    
    DLog(@"onCalculateRouteSuccess");
    
    
    AMapNaviRoute * aRoute = self.walkManager.naviRoute;
    
    self.routeModel = [RouteModel RouteModelModelWith:walkManager.naviRoute];
    NSUInteger count = [aRoute routeCoordinates].count;
    CLLocationCoordinate2D * coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < count; i++)
    {
        AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
        coords[i].latitude = [coordinate latitude];
        coords[i].longitude = [coordinate longitude];
    }
    
    // 拿到数据polylineWithCoordinates
    MAPolyline * polyline = [MAPolyline polylineWithCoordinates:coords count:count];
    [self.mapView addOverlay: polyline];
//    self.mapView.frame = CGRectMake(0, 0, Screen_W, Screen_H*0.5);

//    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
//    [self.mapView setZoomLevel:12.0f];
    // 上左下右
    [self.mapView showAnnotations:self.mapView.annotations edgePadding:UIEdgeInsetsMake(Screen_H*0.35,100*Size_ratio,Screen_H*0.45, 100*Size_ratio) animated:YES];
    self.ispathPolySuccess = YES;
//    self.mapView.zoomLevel = 12.0f;
}
#pragma mark ----------- UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    switch (index) {
        case 0:
        {
            HomeTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TOPCELLID];
            if (cell == nil) {
                cell = [[HomeTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TOPCELLID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.orderModel;
            cell.delegate = self;
            return cell;
        }
            break;
        case 1:
        {
            HomeCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CENTERCELLID];
            if (cell == nil) {
                cell = [[HomeCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CENTERCELLID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.orderModel;
            
            return cell;
        }
            break;
        case 2:
        {
            HomeBottomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:BOOTOMCELLID];
            if (cell == nil) {
                cell = [[HomeBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BOOTOMCELLID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return [HomeTopTableViewCell topCellHeight];
    }else if (indexPath.row == 1){
        return [HomeCenterTableViewCell centerCellHeightWithModel:self.orderModel];
    }else{
        return 100*Size_ratio;
    }
    return 0;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
////    UIView * backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-20*Size_ratio, 40*Size_ratio)];
////    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(70*Size_ratio, 14*Size_ratio, 25*Size_ratio, 20*Size_ratio)];
////    imageView.image = [UIImage imageNamed:@"details-Photograph"];
////    backGroundView.backgroundColor = [UIColor whiteColor];
////    UIButton * prepareDataBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*Size_ratio, 5*Size_ratio, Screen_W - 40*Size_ratio, 38*Size_ratio)];
////    prepareDataBtn.backgroundColor = [UIColor whiteColor];
////    [prepareDataBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    [prepareDataBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg.png"] forState:UIControlStateHighlighted];
////
////    [prepareDataBtn setTitle:@"准 备 材 料 照 片" forState:UIControlStateNormal];
////    prepareDataBtn.layer.borderWidth = 0.5*Size_ratio;
////    prepareDataBtn.titleLabel.font = [UIFont systemFontOfSize:15*YZAdapter];
////    prepareDataBtn.layer.borderColor = [UIColor jhUserInfoBlack].CGColor;
////    [prepareDataBtn addTarget:self action:@selector(prepareDataBtnClick:) forControlEvents:UIControlEventTouchUpInside];
////    [backGroundView addSubview:prepareDataBtn];
////    [backGroundView addSubview:imageView];
////    return backGroundView;
//    return self.tableViewFootSectionView;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 50*Size_ratio;
//}
#pragma mark --------- cellTopHeaderViewDelegate
// 申请退单
- (void)CellTopHeaderViewRefundBtn:(UIButton *)sender
{
    YZCancelInvestigateController * YZCancelInvestigate = [[YZCancelInvestigateController alloc]init];
    YZCancelInvestigate.hidesBottomBarWhenPushed = YES;
    YZCancelInvestigate.tid = self.orderModel.tid;
    [self.navigationController pushViewController:YZCancelInvestigate animated:YES];
}
- (void)CellTopHeaderViewButton:(UIButton *)sender
{
    _isSelectecd = !_isSelectecd;
    if(_isSelectecd) {
        [sender setBackgroundImage:[UIImage imageNamed:@"上"] forState:0];

        [UIView animateWithDuration:0.5 animations:^{
            self.mapTableView.frame = CGRectMake(10*Size_ratio, Screen_H*0.5 + 170*Size_ratio, Screen_W-20*Size_ratio, Screen_H*0.5-36*Size_ratio-64);
            
            self.jhLocationView.frame = CGRectMake(0, self.mapTableView.frame.origin.y-55*Size_ratio, Screen_W, 50*Size_ratio);
            
        }];

        }else {
        DLog(@"取消选中");
        [sender setBackgroundImage:[UIImage imageNamed:@"下"] forState:0];
            [UIView animateWithDuration:0.5 animations:^{
                
                if (iPhone5) {
                    self.mapTableView.frame = CGRectMake(10*Size_ratio, TABLE_Y, Screen_W-20*Size_ratio, TABLE_HEIGHT);
                    
                }else
                {
                    self.mapTableView.frame = CGRectMake(10*Size_ratio, TABLE_Y+10*Size_ratio, Screen_W-20*Size_ratio, TABLE_HEIGHT);
                }
                self.jhLocationView.frame = CGRectMake(0, self.mapTableView.frame.origin.y-55*Size_ratio, Screen_W, 50*Size_ratio);
            }];
    }
    
}
#pragma mark ------------ JHMapLocationViewDelegate
- (void)showCurrentLocation:(UIButton *)sender
{
    [self.mapView setCenterCoordinate:_currentLocation];
}
- (void)WalkRoutePlanLine:(UIButton *)sender
{
    
}
#pragma mark ----------- 自定义的弹框初始化
- (MTWSimpleAlertView *)myAleartView
{
    if (_myAleartView == nil) {
        _myAleartView = [[MTWSimpleAlertView alloc]init];
        _myAleartView.delegate = self;
    }
    return _myAleartView;
}
- (void)RideRoutePlanLine:(UIButton *)sender
{
    _isDrive = NO;
//    
//    [self.myAleartView configAletViewWithImage:[UIImage imageNamed:@"RideRoute.png"]
//                                         Title:@"骑行导航"
//                                       message:[NSString stringWithFormat:@"%@ %@",self.routeModel.titleLabelText,self.routeModel.contentText]
//                                  cancelButton:@"取消"
//                             actionButtonTitle:@"导航"
//                                     blurStyle:0];
//    [self.myAleartView showAlert];
    if (self.ispathPolySuccess) {
        YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
           
            [self actionButtonGoClicked];
            
        }];
        YZPromptController.IDStr = @"路径规划成功";
        YZPromptController.reloadIBStr = [NSString stringWithFormat:@"%@ %@",self.routeModel.titleLabelText,self.routeModel.contentText];
        
        [self presentViewController:YZPromptController animated:YES completion:nil];
    }
    else{
        YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
            
            
        }];
        YZPromptController.IDStr = @"路径规划失败";
        [self presentViewController:YZPromptController animated:YES completion:nil];
    }
    
}
#pragma mark ----------- 弹框的代理方法
//- (void)actionButtonBeenClickedFromView:(MTWSimpleAlertView *)simpleAlertView
- (void)actionButtonGoClicked
{
    if (_isDrive) {
        DriveViewController * vc = [[DriveViewController alloc]init];
        vc.startPoint = self.startPoint;
        vc.endPoint = self.endPoint;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        RideRouteViewController * vc = [[RideRouteViewController alloc]init];
        vc.startPoint = self.startPoint;
        vc.endPoint = self.endPoint;
//        vc.rideManager = self.rideManager;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)DriveRoutePlanLine:(UIButton *)sender
{
    _isDrive = YES;
//    [self.myAleartView configAletViewWithImage:[UIImage imageNamed:@"DriveRoute.png"]
//                                         Title:@"驾车导航"
//                                       message:[NSString stringWithFormat:@"%@ %@",self.routeModel.titleLabelText,self.routeModel.contentText]
//                                  cancelButton:@"取消"
//                             actionButtonTitle:@"导航"
//                                     blurStyle:0];
//    [self.myAleartView showAlert];
    if (self.ispathPolySuccess) {
        YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString * inputText) {
            
            [self actionButtonGoClicked];
            
        }];
        YZPromptController.IDStr = @"路径规划成功";
        YZPromptController.reloadIBStr = [NSString stringWithFormat:@"%@ %@",self.routeModel.titleLabelText,self.routeModel.contentText];
        
        [self presentViewController:YZPromptController animated:YES completion:nil];
    }
    else{
        YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
            [self initRideProperties];
            
        }];
        YZPromptController.IDStr = @"路径规划失败";
        [self presentViewController:YZPromptController animated:YES completion:nil];
    }

}
#pragma mark ----------- HomeTopTableViewCellDelegate
- (void)callUserPhoneButton:(HomeTopTableViewCell *)cell
{
    YZOrderModel * model = cell.model;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.custom_telphone];
    UIWebView* callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}
- (void)senderMessageUserPhoneButton:(HomeTopTableViewCell *)cell
{
    YZOrderModel * model = cell.model;

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",model.custom_telphone]]];
}
@end
