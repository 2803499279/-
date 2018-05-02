//
//  HomeViewController.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//
/**
 *  fileName
 *  模块名称：派单列表
 *  作者：李俊恒
 *  版本：V:1.0
 *  创建日期：2017/04/10
 *  备注：
 *  修改日期：
 *  修改人：
 *  修改内容
 *  Sequence    Date    Author  Version     Description(why & what)
 *   编号        日期     作者    版本号         修改原因及内容描述
 *
 */

#import "ListeningList.h"
#import "HomeHeaderView.h"
#import "HomeTableViewCell.h"
#import "MyMapViewController.h"
#import "YZListenSetViewController.h"
#import "POISearchViewController.h"
#import "HomeNetWorking.h"
#import "YZUserInfoManager.h"
#import "YZUserInfoModel.h"
#import "YZOrderModel.h"
#import "YZRealNameViewController.h"
#import "YZNewPushViewController.h"

#import "YZNewCarController.h"
#import "YZNewCaseController.h"
#define acViewTAG 10
#define MESSAGELABELTAG 20
#define HOMETABLCELLID @"homeCellId"
#define REALNAMECELLID @"realNameCellID"
#define TOKEN [[YZUserInfoManager sharedManager] currentUserInfo].token
#define UID [[YZUserInfoManager sharedManager] currentUserInfo].uid
@interface ListeningList ()<UITableViewDelegate,UITableViewDataSource,HomeHeaderViewDelegate,HomeTableViewCellDelegate,AMapLocationManagerDelegate>
@property(nonatomic,strong)UITableView * homeTableView;// 列表
@property(nonatomic,strong)NSMutableArray * datasource;// 数据源
@property(nonatomic,strong)HomeHeaderView * headerView;// 顶部显示视图
@property(nonatomic,strong)UILabel * listenLabel;// 听单设置

@property(nonatomic,strong)HomeNetWorking * manager;
@property(nonatomic,strong)AMapLocationManager * locationManager;// 开启定位
@property(nonatomic,copy)NSString * locationStr;// 经纬度

@property(nonatomic,strong)NSMutableArray * OrderDataSource;
@property(nonatomic,strong) NSMutableDictionary *OrderDic;
@property(nonatomic,strong)NSMutableArray * StartOrderDataSource;
@property(nonatomic,strong)UIButton * rightButton;
@property(nonatomic,strong)NSTimer * timer;// 定时器
@property(nonatomic,strong)UIImageView * loadingView;
@property(nonatomic,strong)YZOrderModel * mapModel;
@property(nonatomic,strong)UIView *Red;
/**
 AppStore版本号
 */
@property (nonatomic,copy)NSString * appStoreCurVersion;

// 存放新的展示数组
@property(nonatomic,strong)NSMutableArray * NewOrderArray;

@end

@implementation ListeningList
static NSNumber * Mypower;

- (NSMutableArray *)StartOrderDataSource {
    if (!_StartOrderDataSource) {
        _StartOrderDataSource = [[NSMutableArray alloc] init];
    }
    return _StartOrderDataSource;
}
- (NSMutableArray *)NewOrderArray {
    if (!_NewOrderArray) {
        _NewOrderArray = [[NSMutableArray alloc] init];
    }
    return _NewOrderArray;
}
- (NSMutableDictionary *)OrderDic {
    if (!_OrderDic) {
        _OrderDic = [[NSMutableDictionary alloc] init];
    }
    return _OrderDic;
}

#pragma mark ========== lifecircle
- (instancetype)init
{
    if (self = [super init]) {
        _OrderDataSource = [[NSMutableArray alloc] init];
        _locationStr = @"";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    _timer = [NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(Homefunction) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer setFireDate:[NSDate distantPast]];// 开启定时器

    [self NetRequestUserInfo];
//    [self netRequestTaskUnsolved];
#pragma mark ======== 初始化界面数据
    _datasource = [NSMutableArray array];
    RealNameModel * model1 = [RealNameModel RealNameModelWith:@"请先进行实名认证" iconImageNameStr:@"提示" pushImageNameStr:@"fh"];
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    if ([YZUtil isBlankString:model.realname] || [YZUtil isBlankString:model.cardno]){
        [_datasource addObject:model1];
    }
//    // 创建要写入字典的对象
    NSString *dicStartPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"startdic.txt"];
    NSDictionary *readDic = [NSDictionary dictionaryWithContentsOfFile:dicStartPath];
    if(readDic!=nil){
    if (![YZUtil isBlankString:model.realname] || ![YZUtil isBlankString:model.cardno]){
            Mypower = [[readDic[@"data"] objectForKey:@"setting"]objectForKey:@"power"];
            if ([Mypower integerValue]==0) {
                RealNameModel * model2 = [RealNameModel RealNameModelWith:@"请先开启听单" iconImageNameStr:@"设置" pushImageNameStr:@"fh"];
                [_datasource addObject:model2];
                self.loadingView.hidden = YES;
                self.listenLabel.hidden = YES;
                self.loadingLabel.hidden = YES;
            }
        }
    }
    HomeHeaderModel * model3 = [HomeHeaderModel HomeHeaderModelWith:readDic];
    self.headerView.model = model3;
#pragma mark ---------- 数据存放完毕
    [self.view addSubview:self.homeTableView];
    [self.homeTableView addSubview:self.listenLabel];
    [self.homeTableView addSubview:self.loadingView];
    self.loadingView.hidden = YES;
    self.listenLabel.hidden = YES;
    self.loadingLabel.hidden = YES;
    if (![YZUtil isBlankString:model.realname] || ![YZUtil isBlankString:model.cardno]){
    }
    
    NSArray *OrderArray = [[YZDataBase shareDataBase] selectUidOrder:model.uid];
    
    [self.NewOrderArray removeAllObjects];
    for (int i = 0; i < OrderArray.count; i++) {
        YZOrderModel * model = OrderArray[i];
        if ([model.state isEqualToString:@"0"]) {
            [self.NewOrderArray addObject:model];
        }
    }
    
    [_OrderDataSource removeAllObjects];
    _OrderDataSource = [JHTools YZOrderModel:self.NewOrderArray];
    
    [self.homeTableView reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}
- (void)Homefunction
{
    DLog(@"定时器时间到");
    if (![TOKEN isEqualToString:@""]||![UID isEqualToString:@""]) {
        NSString  * isBackGround = [[NSUserDefaults standardUserDefaults]objectForKey:@"isBackGround"];
        if ([isBackGround isEqualToString:@"NO"]) {
            [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                self.locationStr  = [NSString stringWithFormat:@"%f %f",location.coordinate.longitude,location.coordinate.latitude];
                NSString * timeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"homeUpLoadUserLocationTime"];
                NSString * scendTime = [JHTools getCurrentSecondTime];
                int isZeor = abs([scendTime intValue]-[timeStr intValue]);
                DLog(@"%@",timeStr);
                if ([timeStr isEqualToString:@"HomeCurrent"]||isZeor!=0) {
                    [self netRequestUpload];
                }    }];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * versionUpdata = [[NSUserDefaults standardUserDefaults]objectForKey:@"VersionUpData"];
    if ([versionUpdata integerValue]==1) {
        [self performSelector:@selector(compareVersion) withObject:self afterDelay:1.0];
    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self refreshNewData];

    //注册通知 接受推送数据
    [self pullNewNoticList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserInfoNotification:) name:@"UserInfoNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notification:) name:@"Notification" object:nil];
    
    [self customNavigationBarTitle:@"听单" backGroundImageName:nil];
    self.view.backgroundColor = [UIColor jhBackGroundColor];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
    
#pragma mark============ 就进入后台的通知
    // 在需要接收通知消息的.m文件中写入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackGroundType)  name:@"isenterBackGroundType" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isenterBeforeType)  name:@"isenterBeforeType" object:nil];
    
#pragma mark ============ 进入详情页面关闭定时器
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterMyMapView)  name:@"isenterMyMapView" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackHomeView)  name:@"isgoBackHomeView" object:nil];
    
//    [self addNavigationBarRightButton];// 添加右边刷新按钮
    
    // 判断是否需要把小红点展示出来
//    NSString *RedPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Red.txt"];
//    NSDictionary *RedDic = [NSDictionary dictionaryWithContentsOfFile:RedPath];
//    if ([RedDic[@"Red"] isEqualToString:@"1"]) {
//        self.Red = [[UIView alloc] initWithFrame:CGRectMake(_rightButton.frame.size.width-5*YZAdapter, -5*YZAdapter, 10*YZAdapter, 10*YZAdapter)];
//        self.Red.layer.cornerRadius = 5;
//        self.Red.layer.masksToBounds = YES;
//        self.Red.backgroundColor = Red_Color;
//        [_rightButton addSubview:self.Red];
//    }
    
}

- (void)networkDidSetup:(NSNotification *)notification {
    DLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    DLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    DLog(@"%@", [notification userInfo]);
    DLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    DLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
    DLog(@"%@", currentContent);
    
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    DLog(@"%@", error);
}
// ***********************************

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark =========== Event
- (void)navLeftItemAction
{
//    [super navLeftItemAction];
//    [self.view endEditing:YES];
//    [self.frostedViewController.view endEditing:YES];
//    // Present the view controller
//    [self.frostedViewController presentMenuViewController];

}


- (void)rightBarButtonClick:(UIButton *)sender {
//     int i = 0;
//    for (UIView *view in _rightButton.subviews) {
//        i = i+1;
//        if (i != 1) {
//            [view removeFromSuperview];
//        }
//    }
//    // 进入新消息通知列表把收到消息的值设置为0
//    NSDictionary *RedDic= [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"Red", nil];;
//    // 创建要写入字典的对象
//    NSString *dicPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Red.txt"];
//    // 写入
//    BOOL isSuccess = [RedDic writeToFile:dicPath atomically:YES];
//    DLog(@"%@", isSuccess ? @"写入成功" : @"写入失败");
//    
//    YZNewPushViewController * YZNewPushController = [[YZNewPushViewController alloc]init];
//    [self.navigationController pushViewController:YZNewPushController animated:YES];
}

#pragma mark =========== Notify
- (void)enterMyMapView
{
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}
- (void)goBackHomeView
{
    if (_timer==nil) {
        _timer = [NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(Homefunction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [_timer setFireDate:[NSDate distantPast]];// 开启定时器
    }
}
- (void)enterBackGroundType
{
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}
- (void)isenterBeforeType
{
    if (_timer==nil) {
        _timer = [NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(Homefunction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [_timer setFireDate:[NSDate distantPast]];// 开启定时器
    }
    
}

#pragma mark =========== Fouction

#pragma mark ----------- HandleModelDatasource

#pragma mark ----------- HandleView
- (UIView *)infoBlackView
{
    if (_infoBlackView == nil) {
        _infoBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, Screen_W, Screen_H)];
        _infoBlackView.backgroundColor = [UIColor blackColor];
        _infoBlackView.alpha = 0.5;
    }
    return _infoBlackView;
}
//- (UIButton *)rightButton
//{
//    if (_rightButton == nil) {
//        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
////        [_rightButton setFrame:CGRectMake(0, 5*YZAdapter, 40*YZAdapter, 20*YZAdapter)];
////        [_rightButton setTitle:@"消息" forState:0];
//        [_rightButton setTitleColor:[UIColor jhUserInfoBlack] forState:0];
//        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16*Size_ratio];
////        [_rightButton setBackgroundImage:[UIImage imageNamed:@"信息"] forState:0];
//        [_rightButton  setExclusiveTouch :YES];
//        [_rightButton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _rightButton;
//}
//
//- (void)addNavigationBarRightButton
//{
////    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
////    self.navigationItem.rightBarButtonItem = rightItem;
//}

- (AMapLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[AMapLocationManager alloc] init];
        //设置期望定位精度
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        
        //设置不允许系统暂停定位
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        
        //设置允许在后台定位
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        
        //设置定位超时时间
        [self.locationManager setLocationTimeout:DefaultLocationTimeout];
        
        //设置逆地理超时时间
        [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
        [_locationManager setDelegate:self];
    }
    return _locationManager;
}

- (UITableView *)homeTableView
{
    if (_homeTableView == nil) {
        _homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_W, Screen_H- 64 - 49) style:UITableViewStyleGrouped];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.sectionHeaderHeight = 0.0;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.homeTableView.tableHeaderView = self.headerView;
        self.homeTableView.delaysContentTouches = NO;
        // 该方式相当于上面两个循环的合集，并且实现方式更加优雅，推荐使用它，而不是使用上面两个循环
        for (id obj in self.homeTableView.subviews) {
            if ([obj respondsToSelector:@selector(setDelaysContentTouches:)]) {
                [obj setDelaysContentTouches:NO];
            }
        }

        [_homeTableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:HOMETABLCELLID];
        [_homeTableView registerClass:[RealNameTableViewCell class] forCellReuseIdentifier:REALNAMECELLID];
        _homeTableView.backgroundColor = YZBackNavColor;
        [_homeTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _homeTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, Screen_W - 145*YZAdapter);
    }
    return _homeTableView;
}
- (HomeHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[HomeHeaderView alloc]initWithFrame:CGRectMake(10,64 + 20*Size_ratio,Screen_W-20, 120*Size_ratio)];
        _headerView.backgroundColor = [UIColor jhBackGroundColor];
        _headerView.homeHeaderViewDelegate = self;

    }
    return _headerView;
}

- (UIImageView *)loadingView
{
    if (_loadingView == nil) {
        _loadingView = [[UIImageView  alloc]initWithFrame:CGRectMake(Screen_W*0.5-80*YZAdapter, Screen_H*0.45-64-130*YZAdapter, 160*YZAdapter, 150*YZAdapter)];
        _loadingView.image = [UIImage imageNamed:@"loading.png"];
    }
    return _loadingView;
}
- (UILabel *)loadingLabel
{
    if (_loadingLabel == nil) {
        _loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_W*0.5-30*YZAdapter, Screen_H*0.5+15*YZAdapter-64, 60*YZAdapter, 30*YZAdapter)];
        _loadingLabel.adjustsFontSizeToFitWidth = YES;
        _loadingLabel.textColor = [UIColor jhTodoCellContentGray];
    }
    return _loadingLabel;
}
- (UILabel *)listenLabel
{
    if (_listenLabel == nil) {
        _listenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.loadingView.frame.origin.y+self.loadingView.frame.size.height+5*YZAdapter, Screen_W, 60*YZAdapter)];
        _listenLabel.text = @"听单模式已开启，系统将为您派单";
        _listenLabel.backgroundColor = YZBackNavColor;
        _listenLabel.textColor = [UIColor jhTodoCellContentGray];
        _listenLabel.textAlignment = NSTextAlignmentCenter;
        _listenLabel.font = [UIFont systemFontOfSize:18*YZAdapter];
        
    }
    return _listenLabel;
}

#pragma mark =========== delegate
#pragma mark =========== AMapLocationManagerDelegate

#pragma mark =========== UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.datasource.count == 0 ||self.datasource == nil) {
        return 1;
    }else{
        return 2;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([Mypower integerValue]!=0){
        self.loadingView.hidden = NO;
        self.listenLabel.hidden = NO;
        self.loadingLabel.hidden = NO;
    }
        if (self.datasource.count==0||self.datasource== nil) {
            return _OrderDataSource.count;
        }else{
            if (section == 0) {
                return self.datasource.count;
            }else if (section == 1){
            return _OrderDataSource.count;
            }
        }
       return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasource.count == 0||self.datasource== nil) {
        self.loadingView.hidden = YES;
        self.listenLabel.hidden = YES;
        self.loadingLabel.hidden = YES;
        [self.loadingView.layer removeAllAnimations];//停止动画
        
        // 数据刷新后加载抢单页面
        HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HOMETABLCELLID];
        if (cell == nil) {
            cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HOMETABLCELLID];
        }
        NSArray * reversedArray = [[_OrderDataSource reverseObjectEnumerator] allObjects];
        YZOrderModel * model = reversedArray[indexPath.row];
        cell.homeTableViewCellDelegate = self;
        cell.cellModel = model;
//        cell.isAddHeight = YES;

        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }else{
    if (indexPath.section == 0) {
    RealNameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:REALNAMECELLID];
    if (cell == nil) {
        cell = [[RealNameTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REALNAMECELLID];
    }
    RealNameModel * model = self.datasource[indexPath.row];
    cell.realNamemodel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    }else if(indexPath.section ==1)
    {
        self.loadingView.hidden = YES;
        self.listenLabel.hidden = YES;
        self.loadingLabel.hidden = YES;
        [self.loadingView.layer removeAllAnimations];//停止动画

        // 数据刷新后加载抢单页面
        HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HOMETABLCELLID];
        if (cell == nil) {
            cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HOMETABLCELLID];
        }
        NSArray * reversedArray = [[_OrderDataSource reverseObjectEnumerator] allObjects];
        YZOrderModel * model = reversedArray[indexPath.row];
        cell.homeTableViewCellDelegate = self;
        cell.cellModel = model;
//        cell.isAddHeight = NO;

        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZOrderModel * model;
    NSArray * reversedArray = [[_OrderDataSource reverseObjectEnumerator] allObjects];

    if(reversedArray!=nil&&reversedArray.count!=0){
        model = reversedArray[indexPath.row];
    }
    if (self.datasource.count== 0||self.datasource== nil) {
        return [HomeTableViewCell HomeCellHeightWithModel:model]+20*Size_ratio;
    }else{
    if (indexPath.section == 0) {
        return 64*YZAdapter;
    }if (indexPath.section ==1) {
    return [HomeTableViewCell HomeCellHeightWithModel:model]+20*Size_ratio;
    }
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.datasource.count == 0||self.datasource==nil) {
        
    }
    else
    {
        if (indexPath.section == 0) {
            RealNameModel * model = _datasource[indexPath.row];
            if ([model.contentStr isEqualToString:@"请先进行实名认证"]) {
                YZRealNameViewController * YZRealNameController = [[YZRealNameViewController alloc]init];
                YZRealNameController.BankID = @"Order";
                YZRealNameController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:YZRealNameController animated:YES];
            }else if([model.contentStr isEqualToString:@"请先开启听单"]){
                
                YZListenSetViewController * vc = [[YZListenSetViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}
#pragma mark =========== HomeHeaderViewDelegate跳转我的钱包
- (void)didSelectedpushMoneyView:(UIButton *)sender
{
    YZWalletViewController * vc = [[YZWalletViewController alloc]init];
    vc.isHomePush = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didSelectedpushCompletedTaskView:(UIButton *)sender
{
    JHCompletedViewController * vc = [[JHCompletedViewController alloc]init];
    vc.isHomePushVc = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark HomeTableViewCellViewDelegate
- (void)didSelectedHomeTableViewcell:(HomeTableViewCell *)cell
{
    
    UIButton * sender = cell.RapBut;
    [sender setExclusiveTouch:YES];
    
    self.mapModel = cell.cellModel;
    NSString * titleString = sender.titleLabel.text;
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                DLog(@"未知网络");
            {
            [MBProgressHUD showAutoMessage:@"网络未知错误"];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                DLog(@"没有网络(断网)");
            {
            [MBProgressHUD showAutoMessage:@"网络未连接"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                DLog(@"手机自带网络");
            {
               
                if ([titleString isEqualToString:@"抢单"]) {
#pragma mark ------------ 删除按钮上的活动指示器
                    NSArray * array = sender.subviews;
                    for(id tmpView in array)
                    {
                        //找到要删除的子视图的对象
                        if([tmpView isKindOfClass:[UIActivityIndicatorView class]])
                        {
                            UIActivityIndicatorView * activeView = (UIActivityIndicatorView *)tmpView;
                            if(activeView.tag == 10)   //判断是否满足自己要删除的子视图的条件
                            {
                                [activeView removeFromSuperview]; //删除子视图
                                break;  //跳出for循环，因为子视图已经找到，无须往下遍历
                            }
                        }
                    }
#pragma mark ------------- 开始做抢单请求
                    [self netRequestGetTask:sender TaskTid:cell.cellModel.tid];
                    sender.backgroundColor = [UIColor whiteColor];
                    sender.layer.borderWidth = 0.5*YZAdapter;
                    sender.layer.borderColor = [UIColor jhUserInfoBlack].CGColor;
                    UIActivityIndicatorView * acView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(160*YZAdapter, 15*YZAdapter, 20, 20)];
                    acView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
                    acView.color = [UIColor blackColor];
                    acView.hidesWhenStopped = NO;
                    [acView startAnimating];
                    acView.tag = acViewTAG;
                    [sender addSubview:acView];
                }

            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                DLog(@"WIFI");
            {
               
                if ([titleString isEqualToString:@"抢单"]) {
#pragma mark ------------ 删除按钮上的活动指示器
                    NSArray * array = sender.subviews;
                    for(id tmpView in array)
                    {
                        //找到要删除的子视图的对象
                        if([tmpView isKindOfClass:[UIActivityIndicatorView class]])
                        {
                            UIActivityIndicatorView * activeView = (UIActivityIndicatorView *)tmpView;
                            if(activeView.tag == 10)   //判断是否满足自己要删除的子视图的条件
                            {
                                [activeView removeFromSuperview]; //删除子视图
                                break;  //跳出for循环，因为子视图已经找到，无须往下遍历
                            }
                        }
                    }
#pragma mark ------------- 开始做抢单请求
                    [self netRequestGetTask:sender TaskTid:cell.cellModel.tid];
                    sender.backgroundColor = [UIColor whiteColor];
                    sender.layer.borderWidth = 0.5*YZAdapter;
                    sender.layer.borderColor = [UIColor jhUserInfoBlack].CGColor;
                    UIActivityIndicatorView * acView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(160*YZAdapter, 15*YZAdapter, 20, 20)];
                    acView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
                    acView.color = [UIColor blackColor];
                    acView.hidesWhenStopped = NO;
                    [acView startAnimating];
                    acView.tag = acViewTAG;
                    [sender addSubview:acView];
                }
                
            }
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
     if ([titleString isEqualToString:@"继续处理"]){
        DLog(@"跳转地图中");
         
        MyMapViewController * vc = [[MyMapViewController alloc]init];
        vc.orderModel = cell.cellModel;
         vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
   }

- (void)delayMothed:(UIButton *)sender
{
//    [sender setTitle:@"继续处理" forState:UIControlStateNormal];
    sender.backgroundColor = YZEssentialColor;
    sender.layer.borderWidth = 0;
    sender.layer.borderColor = [UIColor whiteColor].CGColor;
    UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_W/3*0.5, Screen_H - 200*YZAdapter, Screen_W*2/3, 40*YZAdapter)];
    messageLabel.text = @"抢单成功，赶快处理吧";
    messageLabel.backgroundColor = [UIColor jhNavigationColor];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.tag = MESSAGELABELTAG;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.layer.cornerRadius = 20*YZAdapter;
    messageLabel.layer.masksToBounds = YES;
    [self.view addSubview:messageLabel];

    [self performSelector:@selector(hidenMessageLabel:) withObject:messageLabel afterDelay:0.75];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    
}
- (void)hidenMessageLabel:(UILabel *)label
{
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    NSArray *OrderArray = [[YZDataBase shareDataBase] selectUidOrder:model.uid];
    [self.NewOrderArray removeAllObjects];
    for (int i = 0; i < OrderArray.count; i++) {
        YZOrderModel * model = OrderArray[i];
        if ([model.state isEqualToString:@"0"]) {
            [self.NewOrderArray addObject:model];
        }
    }
    [_OrderDataSource removeAllObjects];
    _OrderDataSource = [JHTools YZOrderModel:self.NewOrderArray];
    [self.homeTableView reloadData];
    
    label.hidden = YES;
    MyMapViewController * vc =[[MyMapViewController alloc]init];
    vc.orderModel = self.mapModel;
    if (self.mapModel.arise_point.length !=0&&![self.mapModel.arise_point isEqualToString:@"NIL"]) {
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        
        // 移动到车险勘察页面
        
        // 1 计算滚动的位置
        CGFloat offsetX = 1 * Screen_W;
        
        UIScrollView *mainScrollView = (UIScrollView *)self.view.superview;
        
        [UIView animateWithDuration:0.4 animations:^{
            mainScrollView.contentOffset = CGPointMake(offsetX, 0);
        }];
        // 2.给对应位置添加对应子控制器
        [self showVc:1];
        
        SGSegmentedControl *new = [[self.view.superview.superview.subviews lastObject].subviews firstObject];
        
        // 2.把对应的标题选中
        [new titleBtnSelectedWithScrollView:mainScrollView];
        
    }
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    //创建通知
    NSNotification *UserInfoNotification =[NSNotification notificationWithName:@"listandcar" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:UserInfoNotification];
    
    CGFloat offsetX = index * Screen_W;
    
    YZNewCaseController *vc = (YZNewCaseController *)[[self.view.superview.superview.superview.subviews lastObject] nextResponder];
    
    YZNewCarController *CVC = vc.childViewControllers[1];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (CVC.isViewLoaded) return;
    UIScrollView *mainScrollView = (UIScrollView *)self.view.superview;
    [mainScrollView addSubview:CVC.view];
    CVC.view.frame = CGRectMake(offsetX, 0, Screen_W, Screen_H-69-44);
}

#pragma mark =============== AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    DLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

#pragma mark ================ NetWork
#pragma mark ----------- NetRequest

- (HomeNetWorking *)manager
{
    if (_manager == nil) {
        _manager = [HomeNetWorking sharedInstance];
    }
    return _manager;
}
- (void)refreshNewData
{
    __weak typeof(self) weakSelf = self;
    
    self.homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf NetRequestUserInfo];
        [weakSelf pullNewNoticList];
        
    }];
//    [self.homeTableView.mj_header beginRefreshing];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.homeTableView.mj_header.automaticallyChangeAlpha = YES;
    
}
// 获取正在处理订单
- (void)netRequestTaskUnsolved
{
    // 获取正在处理的订单
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString * url = @"task/unsolved";
    [self.manager userTaskUnsolvedPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
        DLog(@"获取正在处理的订单%@",responsData);
        if ([responsData[@"code"] integerValue] == 0) {
            
            YZOrderModel *model1 = [YZOrderModel modelWithDictionary:responsData[@"data"]];
            model1.state = @"1";
            
            // 禁止相同数据插入
            YZUserInfoModel *usermodel = [[YZUserInfoManager sharedManager] currentUserInfo];
            NSArray *TidArray = [[YZDataBase shareDataBase] selectTidOrder:model1.tid  Uid:usermodel.uid];
            if (TidArray.count == 1) {
                
                if (![YZUtil isBlankString:model1.tid]) {
                    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
                    [[YZDataBase shareDataBase] ModifyTheOrder:@"1" Tid:model1.tid Uid:model.uid];// 成功后修改状态
                }
                
            }else if (TidArray.count == 0){
                // 插入数据库
                [[YZDataBase shareDataBase] insertOrder:model1];
            }
            
            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            NSArray *OrderArray = [[YZDataBase shareDataBase] selectUidOrder:model.uid];
            
            [self.NewOrderArray removeAllObjects];
            for (int i = 0; i < OrderArray.count; i++) {
                YZOrderModel * model = OrderArray[i];
                if ([model.state isEqualToString:@"0"]) {
                    [self.NewOrderArray addObject:model];
                }
            }
#pragma mark------------ 超时删除
            [_OrderDataSource removeAllObjects];
            _OrderDataSource = [JHTools YZOrderModel:self.NewOrderArray];
            
            [self.homeTableView reloadData];

            
        }else if ([responsData[@"code"] integerValue] == 217001)
        {
        // 没有未处理的订单
            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            NSArray *OrderArray = [[YZDataBase shareDataBase] selectUidOrder:model.uid];
            [_OrderDataSource removeAllObjects];
            _OrderDataSource = [NSMutableArray arrayWithArray:OrderArray];
            // 取出所有数据遍历数组
            for (YZOrderModel * model in _OrderDataSource) {
                if ([model.state isEqualToString:@"1"]) {
                    [[YZDataBase shareDataBase] deleteOneMovieByOrderID:model.tid];
                }
            }
            [self.homeTableView reloadData];

        }
        DLog(@"获取成功");
    } failed:^(NSError *error) {
        DLog(@"获取失败");
    }];
}
// 拉取新的通知消息
- (void)pullNewNoticList
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSString * url = @"task/notice";
    WeakSelf(self);
    [self.manager requestPullNewNoticeListenPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
        DLog(@"---------------------拉取新的通知消息成功---------------------");
#pragma mark ------------- 拉取新的通知消息成功
        NSString * code = responsData[@"code"];
        if ([code integerValue] == 0) {
            NSArray *dataArr = responsData[@"data"];
            NSArray * reversedArray = [[dataArr reverseObjectEnumerator] allObjects];
            for (NSDictionary *listDict in reversedArray) {
                YZOrderModel *model = [YZOrderModel modelWithDictionary:listDict];
                [weakSelf.StartOrderDataSource addObject:model];
                // 禁止相同数据插入
                YZUserInfoModel *model1 = [[YZUserInfoManager sharedManager] currentUserInfo];
                NSArray *TidArray = [[YZDataBase shareDataBase] selectTidOrder:model.tid Uid:model1.uid];
                if (TidArray.count == 1) {
                    
                }else {
                    // 插入数据库
                    [[YZDataBase shareDataBase] insertOrder:model];
                }
            }
            // 如果数据等于十条重新进行数据请求
            if (dataArr.count == 10) {
                [weakSelf pullNewNoticList];
            }
            
            [_OrderDataSource removeAllObjects];
            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            NSArray *OrderArray = [[YZDataBase shareDataBase] selectUidOrder:model.uid];
            [_OrderDataSource removeAllObjects];
#pragma mark------------ 超时删除
            [self.NewOrderArray removeAllObjects];
            for (int i = 0; i < OrderArray.count; i++) {
                YZOrderModel * model = OrderArray[i];
                if ([model.state isEqualToString:@"0"]) {
                    [self.NewOrderArray addObject:model];
                }
            }
            
            _OrderDataSource = [JHTools YZOrderModel:self.NewOrderArray];
            [self.homeTableView reloadData];
            DLog(@"%@",responsData);
            [self.homeTableView.mj_header endRefreshing];
        }
        DLog(@"%@",responsData);
    } failed:^(NSError *error) {
        [self.homeTableView.mj_header endRefreshing];
        DLog(@"---------------------拉取新的通知消息失败---------------------");
        DLog(@"%@",error);
    }];
}
// 获取初始信息
- (void)NetRequestUserInfo
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSString * url = @"user/start";
    [self.manager requestUserInfoPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
        [self.homeTableView.mj_header endRefreshing];
        DLog(@"获取用户初始信息---------------------------");
        NSString * code = responsData[@"code"];
        if ([code integerValue] == 0) {
            
            // 创建要写入字典的对象
            NSString *dicStartPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"startdic.txt"];
            
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:responsData];
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:mDict[@"data"]];
            NSMutableDictionary *settingDic = [NSMutableDictionary dictionaryWithDictionary:dataDic[@"setting"]];
            [settingDic setObject:@"" forKey:@"time"];
            [dataDic setObject:settingDic forKey:@"setting"];
            [mDict setObject:dataDic forKey:@"data"];
            NSDictionary *StartDic = mDict;
            // 写入
            BOOL isSuc = [StartDic writeToFile:dicStartPath atomically:YES];
            DLog(@"%@", isSuc ? @"写入成功" : @"写入失败");

            Mypower = [[responsData[@"data"] objectForKey:@"setting"]objectForKey:@"power"];
            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            if ([YZUtil isBlankString:model.realname] || [YZUtil isBlankString:model.cardno])
        {
        }else
        {
            if ([Mypower integerValue]==0&&_datasource.count==0) {
                RealNameModel * model2 = [RealNameModel RealNameModelWith:@"请先开启听单" iconImageNameStr:@"设置" pushImageNameStr:@"箭头"];
                        [_datasource addObject:model2];
                
                self.loadingView.hidden = YES;
                self.listenLabel.hidden = YES;
                self.loadingLabel.hidden = YES;
            }
        }
            HomeHeaderModel * model3 = [HomeHeaderModel HomeHeaderModelWith:responsData];
            self.headerView.model = model3;
        
            [self.homeTableView reloadData];
        DLog(@"初始化信息%@",responsData);
        
        // 把支持的银行字典存到本地
        NSDictionary *ListArray = responsData[@"data"][@"bankList"];
        // 创建要写入字典的对象
        NSString *dicPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"dictionary.txt"];
        // 写入
        BOOL isSuccess = [ListArray writeToFile:dicPath atomically:YES];
        DLog(@"%@", isSuccess ? @"写入成功" : @"写入失败");
        }
        else if ([code integerValue] == 900102) {
            [MBProgressHUD showAutoMessage:@"登录信息失效"];
            
            YZLoginViewController * vc = [[YZLoginViewController alloc]init];
            
            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            vc.AlertPhone = model.Usre_Phone;
            
            [[YZUserInfoManager sharedManager] didLoginOut];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failed:^(NSError *error) {
        DLog(@"---------------");
        [self.homeTableView.mj_header endRefreshing];
        DLog(@"%@",error);
    }];
}
// 上传用户位置信息
- (void)netRequestUpload
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"point"] = self.locationStr;
    NSString * url = @"location/renew";
    [self.manager uploadUserLocationPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
        DLog(@"--------------------------上传用户地理位置信息");
        NSString * code = responsData[@"code"];
        if ([code integerValue] == 0) {
        DLog(@"上传用户地理位置信息%@",responsData);
            [[NSUserDefaults standardUserDefaults]setObject:[JHTools getSystemTime] forKey:@"homeUpLoadUserLocationTime"];
        NSString * time = [JHTools getSystemTime];
        DLog(@"位于前台的上传位置信息%@",time);
        DLog(@"成功了");
        }

    } failed:^(NSError *error) {
        DLog(@"失败%@",error);
        DLog(@"失败了");
    }];
}
// 立即抢单
- (void)netRequestGetTask:(UIButton*)sender TaskTid:(NSString *)tid
{
    sender.enabled = NO;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"tid"] = tid;
    NSString * url = @"task/grab";
    dict[@"point"] = _locationStr;
    [self.manager requestImmediatelyGetTaskPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
        DLog(@"立即抢单%@",responsData);
        NSString * codeStr = responsData[@"code"];
       if ([codeStr integerValue] == 900102) {
           [MBProgressHUD showAutoMessage:@"登录信息失效"];
           
           YZLoginViewController * vc = [[YZLoginViewController alloc]init];
           YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
           vc.AlertPhone = model.Usre_Phone;
           
           [[YZUserInfoManager sharedManager] didLoginOut];
           vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
       }else{
        [self chooseShowView:[codeStr integerValue] changeBtn:sender taskTid:tid];

       }
        
    } failed:^(NSError *error){
        DLog(@"%@",error);
        
    }];
}


- (void)chooseShowView:(NSInteger)code changeBtn:(UIButton *)sender taskTid:(NSString *)tid
{
    UIActivityIndicatorView * acView = [sender viewWithTag:acViewTAG];
    [acView stopAnimating];
    acView.hidesWhenStopped = YES;
    switch (code) {
        case 0:
        {
            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            [[YZDataBase shareDataBase] ModifyTheOrder:@"1" Tid:tid  Uid:model.uid];// 成功后修改状态
//            [self.homeTableView reloadData];
            if ([YZDataBase shareDataBase].isSuccessSteState) {
                [self performSelector:@selector(delayMothed:) withObject:sender afterDelay:0.5];
            }
        }
            break;
        case 207001:
            sender.enabled = YES;
            [self showMyYZAlerateView:@"抢单失败 请重试" changeButton:sender Tid:tid];
            break;
        case 207002:
            sender.enabled = YES;
            [self showMyYZAlerateView:@"抢单失败 请重试" changeButton:sender Tid:tid];
            break;
        case 207003:
        {
            sender.enabled = YES;
            [self showMyYZAlerateView:@"已被抢走" changeButton:sender Tid:tid];
            
        }
            break;
        case 207004:{
            sender.enabled = YES;
            [self showMyYZAlerateView:@"抢单失败 请重试" changeButton:sender Tid:tid];
            
        }
            break;
        case 207005:{
            sender.enabled = YES;
            [self showMyYZAlerateView:@"请先处理正在进行的任务" changeButton:sender Tid:tid];
        }
            break;
        default:
            break;
    }
    
}
// 提示框
- (void)showMyYZAlerateView:(NSString *)title changeButton:(UIButton *)sender Tid:(NSString *)tid
{
    YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
        DLog(@"输入内容：%@", inputText);
        [sender setBackgroundColor:[UIColor jhBaseOrangeColor]];
        WeakSelf(self);
        if ([title isEqualToString:@"已被抢走"]) {
            [[YZDataBase shareDataBase] deleteOneMovieByOrderID:tid];
            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            NSArray *OrderArray = [[YZDataBase shareDataBase] selectUidOrder:model.uid];
            [_OrderDataSource removeAllObjects];
            _OrderDataSource = [JHTools YZOrderModel:OrderArray];
            
            [self.homeTableView reloadData];
        }
        sender.layer.borderWidth = 0;
        sender.layer.borderColor = [UIColor whiteColor].CGColor;
        [weakSelf.homeTableView reloadData];
    }];
    YZPromptController.IDStr = title;
    [self presentViewController:YZPromptController animated:YES completion:nil];
    
}

#pragma mark - 接受推送通知的传值
- (void)UserInfoNotification:(NSNotification *)Order{
    DLog(@"－－－－－接收到通知------");
    
    [self.OrderDic addEntriesFromDictionary:Order.userInfo];
    
    if ([Order.userInfo allKeys].count != 4 && [_OrderDic[@"MSGTYPE"] isEqualToString:@"NEWTASK"]) {
        // 派单消息
        [_OrderDataSource removeAllObjects];
        
        YZOrderModel *Order = [[YZOrderModel alloc] init];
        
        Order.tid = _OrderDic[@"tid"];
        Order.type = _OrderDic[@"type"];
        Order.type_name = _OrderDic[@"type_name"];
        Order.custom_name = _OrderDic[@"custom_name"];
        Order.custom_telphone = _OrderDic[@"custom_telphone"];
        Order.arise_datetime = _OrderDic[@"arise_datetime"];
        Order.arise_nearby = _OrderDic[@"arise_nearby"];
        Order.arise_address = _OrderDic[@"arise_address"];
        Order.arise_point = _OrderDic[@"arise_point"];
        Order.distance = _OrderDic[@"distance"];
        Order.reward = _OrderDic[@"reward"];
        Order.remark = _OrderDic[@"remark"];
        Order.cts_uid = _OrderDic[@"cts_uid"];
        Order.cts_name = _OrderDic[@"cts_name"];
        Order.cts_avator = _OrderDic[@"cts_avator"];
        
        Order.license_plate = _OrderDic[@"license_plate"];
        Order.vehicle_model = _OrderDic[@"vehicle_model"];
        
        Order.state = @"0";
        
        // 禁止相同数据插入
        YZUserInfoModel *model1 = [[YZUserInfoManager sharedManager] currentUserInfo];
        NSArray *TidArray = [[YZDataBase shareDataBase] selectTidOrder:Order.tid Uid:model1.uid];
        if (TidArray.count == 1) {
            
        }else {
            // 插入数据库
            [[YZDataBase shareDataBase] insertOrder:Order];
        }
        [self.NewOrderArray removeAllObjects];
        
        YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
        // 根据uid取出数据库中的元素
        NSArray *OrderArray = [[YZDataBase shareDataBase] selectUidOrder:model.uid];
        
        for (int i = 0; i < OrderArray.count; i++) {
            YZOrderModel * model = OrderArray[i];
            if ([model.state isEqualToString:@"0"]) {
                [self.NewOrderArray addObject:model];
            }
        }

        [_OrderDataSource removeAllObjects];
        _OrderDataSource = [JHTools YZOrderModel:self.NewOrderArray];
        [self.homeTableView reloadData];
        
    }
}

#pragma mark - 从后台进入前台判断token是否失效
- (void)Notification:(NSNotification *)Order{
 
}


- (void)dealloc {
    [self unObserveAllNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

#pragma mark ============ 版本号
- (void)compareVersion
{
    // 获取appStore版本号
    NSString *url = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"1240808896"];
    [self Postpath:url];
    
}
/**
 获取当前版本号
 */
- (NSString *)getAppCurVersionNum{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：2.0.7
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    DLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    DLog(@"当前应用版本号码：%@",appCurVersionNum);
    return appCurVersion;
}
//
-(void)Postpath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue]>0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
                
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
        
        [self performSelectorOnMainThread:@selector(getAppStoreCurVersionNumreceiveData:) withObject:receiveStatusDic waitUntilDone:NO];
    }];
}


-(void)getAppStoreCurVersionNumreceiveData:(id)sender
{
    DLog(@"receiveData=%@",sender);
    self.appStoreCurVersion = sender[@"version"];
//    [self aleartActionAppVersion];
    
}
/**
 比较版本号
 */
- (void)aleartActionAppVersion{
    
    if ([self isHaveNewVersion]) {
        // 版本号不同就弹出弹框，让他选择是否更新
//        [self swithUIAlertController:@"暂不更新" topTitle:[NSString stringWithFormat:@"有新版本%@可以更新\n当前版本%@",self.appStoreCurVersion,[self getAppCurVersionNum]] rightTitle:@"立即更新"];
        YZAlertViewController * alertView = [[YZAlertViewController alloc] initWithConfirmAction:^(NSString *inputText) {
            // 跳转AppStore更新
            NSString *webLink = @"https://itunes.apple.com/cn/app/lin-ye-ping-tai/id1240808896";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webLink]];
            
        } andCancelAction:^{
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"VersionUpData"];
            
            }];
            alertView.RealID = @"新版本";
        alertView.OldVersion = [self getAppCurVersionNum];
        alertView.NewVersion = self.appStoreCurVersion;
            [self presentViewController:alertView animated:YES completion:nil];    }
}
// 判断是否有最新版本
- (BOOL)isHaveNewVersion{
    NSString * appVersion = [self getAppCurVersionNum];
    NSArray * appVersionArray = [appVersion componentsSeparatedByString:@"."];
    NSArray * appStoreArray = [self.appStoreCurVersion componentsSeparatedByString:@"."];
    NSString * str1 = [appVersionArray componentsJoinedByString:@""];// 系统版本
    NSString * str2 = [appStoreArray componentsJoinedByString:@""];// AppStore版本
    if ([str1 integerValue] < [str2 integerValue]) {
        return YES;
    }
    return NO;
}
// 弹出提示框
- (void)swithUIAlertController:(NSString *)leftTitle topTitle:(NSString *)topTitle rightTitle:(NSString *)rightTitle
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:topTitle
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:leftTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [self dismissViewControllerAnimated:alertController completion:nil];
                                                             [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"VersionUpData"];

                                                         }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:rightTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         // 跳转AppStore更新
                                                         NSString *webLink = @"https://itunes.apple.com/cn/app/lin-ye-ping-tai/id1240808896";
                                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webLink]];
                                                     }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// **************表头表尾*****************
// 设置表脚高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (_OrderDataSource.count == 0) {
        return 0.01*YZAdapter;
    }else {
        return 15*YZAdapter;
    }
}
//
//添加标脚中的内容
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 15*YZAdapter)];
    
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    NSString *dicStartPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"startdic.txt"];
    NSDictionary *readDic = [NSDictionary dictionaryWithContentsOfFile:dicStartPath];
    if(readDic!=nil){
        if (![YZUtil isBlankString:model.realname] || ![YZUtil isBlankString:model.cardno]){
            Mypower = [[readDic[@"data"] objectForKey:@"setting"]objectForKey:@"power"];
            if ([Mypower integerValue]==0) {
                if (section == 0) {
                    footerView.backgroundColor = YZBackNavColor;
                }else {
                    footerView.backgroundColor = WhiteColor;
                }
            }else {
                footerView.backgroundColor = WhiteColor;
            }
        }else {
            if (section == 0) {
               footerView.backgroundColor = YZBackNavColor;
            }else {
                footerView.backgroundColor = WhiteColor;
            }
        }
    }else {
        footerView.backgroundColor = WhiteColor;
    }    
    
    return footerView;
}



@end
