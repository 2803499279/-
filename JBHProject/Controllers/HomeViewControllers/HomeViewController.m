//
//  HomeViewController.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/8/22.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "HomeViewController.h"

#import "YZNewPushViewController.h"
#import "YZHomePageOneViewCell.h"
#import "YZHomePageTwoViewCell.h"
#import "YZHomePageThereViewCell.h"
#import "SDCycleScrollView.h"
#import "YZHomePageOneModel.h"
#import "YZHomePageTwoModel.h"
#import "YZHomePageThereModel.h"
#import "YZHomePageResquest.h"
#import "YZDetailsController.h"
#import "YZRealNameViewController.h"
#import "YZListenSetViewController.h"
#import "JHCompletedViewController.h"
#import "YZWalletViewController.h"


@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate>
{
    UIButton *withdrawal;
}

@property(nonatomic,strong)UIButton * rightButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITableViewCell *UITableVC;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *DArray;

@property (nonatomic, strong) NSMutableArray *imagesURLStrings;

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSMutableArray *LinkArray;

@property(nonatomic,strong)HomeNetWorking * manager;
//@property (nonatomic, strong) NSMutableArray *UIImageArray; // 存储本地图片
//
//@property (nonatomic, strong) NSMutableArray *imageURLArray; // 存储本地图片

@property (nonatomic, strong) NSNumber *power;

@property(nonatomic,strong)UIView *Red; // 消息标识

@property(nonatomic,strong) NSMutableDictionary *OrderDic; // 存放接受的推送消息

@end

@implementation HomeViewController

#pragma mark - Lazyload
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableDictionary *)OrderDic {
    if (!_OrderDic) {
        _OrderDic = [[NSMutableDictionary alloc] init];
    }
    return _OrderDic;
}

- (NSMutableArray *)DArray {
    if (!_DArray) {
        _DArray = [[NSMutableArray alloc] init];
    }
    return _DArray;
}

- (NSMutableArray *)imagesURLStrings {
    if (!_imagesURLStrings) {
        _imagesURLStrings = [[NSMutableArray alloc] init];
    }
    return _imagesURLStrings;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [[NSMutableArray alloc] init];
    }
    return _titles;
}

- (NSMutableArray *)LinkArray {
    if (!_LinkArray) {
        _LinkArray = [[NSMutableArray alloc] init];
    }
    return _LinkArray;
}

- (HomeNetWorking *)manager
{
    if (_manager == nil) {
        _manager = [HomeNetWorking sharedInstance];
    }
    return _manager;
}
//- (NSMutableArray *)UIImageArray {
//    if (!_UIImageArray) {
//        _UIImageArray = [[NSMutableArray alloc] init];
//    }
//    return _UIImageArray;
//}
//
//- (NSMutableArray *)imageURLArray {
//    if (!_imageURLArray) {
//        _imageURLArray = [[NSMutableArray alloc] init];
//    }
//    return _imageURLArray;
//}

- (void)viewWillAppear:(BOOL)animated {
    // 数据请求
    [self WALLET_LOGRequest:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    // 判断是否需要把小红点展示出来
    NSString *RedPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Red.txt"];
    NSDictionary *RedDic = [NSDictionary dictionaryWithContentsOfFile:RedPath];
    if ([RedDic[@"Red"] isEqualToString:@"1"]) {
        self.Red = [[UIView alloc] initWithFrame:CGRectMake(_rightButton.frame.size.width-10*YZAdapter, 1*YZAdapter, 10*YZAdapter, 10*YZAdapter)];
        self.Red.layer.cornerRadius = 5;
        self.Red.layer.masksToBounds = YES;
        self.Red.backgroundColor = Red_Color;
        [_rightButton addSubview:self.Red];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationBarTitle:@"聚保汇" backGroundImageName:nil];
    self.view.backgroundColor = BackGround_Color;
    
    [self addNavigationBarRightButton];// 添加右边银行卡按钮
    
    [self customerGesturePop]; // 优化返回上一个页面
    
    // 创建UITableView,注册cell
    [self establishUITableViewAndCell];
    
    self.tableView.delaysContentTouches = NO;
    // 该方式相当于上面两个循环的合集，并且实现方式更加优雅，推荐使用它，而不是使用上面两个循环
    for (id obj in self.tableView.subviews) {
        if ([obj respondsToSelector:@selector(setDelaysContentTouches:)]) {
            [obj setDelaysContentTouches:NO];
        }
    }

    // 下拉刷新
    [self loadData];
    
    //注册通知 接受推送数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserInfoNotification:) name:@"UserInfoNotification" object:nil];
    
//    // 判断是否需要把小红点展示出来
//    NSString *RedPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Red.txt"];
//    NSDictionary *RedDic = [NSDictionary dictionaryWithContentsOfFile:RedPath];
//    if ([RedDic[@"Red"] isEqualToString:@"1"]) {
//        self.Red = [[UIView alloc] initWithFrame:CGRectMake(_rightButton.frame.size.width-10*YZAdapter, 1*YZAdapter, 10*YZAdapter, 10*YZAdapter)];
//        self.Red.layer.cornerRadius = 5;
//        self.Red.layer.masksToBounds = YES;
//        self.Red.backgroundColor = Red_Color;
//        [_rightButton addSubview:self.Red];
//    }
    
    [self NetRequestUserInfo]; // 获取用户初始化信息
    
    // Do any additional setup after loading the view.
}

- (void)loadData {
    WeakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf WALLET_LOGRequest:YES];
        [weakSelf.tableView.mj_header endRefreshing];
    }];

}


- (UIButton *)rightButton
{
    if (_rightButton == nil) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rightButton  setExclusiveTouch :YES];
        [_rightButton setFrame:CGRectMake(0, 0, 60*Size_ratio, 30*Size_ratio)];
        [_rightButton setTitle:@"    消息" forState:UIControlStateNormal];
        _rightButton.tintColor = MainFont_Color;
        [_rightButton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (void)addNavigationBarRightButton
{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBarButtonClick:(UIButton *)sender
{
    int i = 0;
    for (UIView *view in _rightButton.subviews) {
        i = i+1;
        if (i != 1) {
            [view removeFromSuperview];
        }
    }
    // 进入新消息通知列表把收到消息的值设置为0
    NSDictionary *RedDic= [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"Red", nil];;
    // 创建要写入字典的对象
    NSString *dicPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Red.txt"];
    // 写入
    BOOL isSuccess = [RedDic writeToFile:dicPath atomically:YES];
    DLog(@"%@", isSuccess ? @"写入成功" : @"写入失败");
    
    YZNewPushViewController * YZNewPushController = [[YZNewPushViewController alloc]init];
    YZNewPushController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:YZNewPushController animated:YES];
}

- (void) handleOtherSwipeGesture {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Private Method 右划返回上一个页面
- (void)customerGesturePop {
    UISwipeGestureRecognizer *swipeGestuer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleOtherSwipeGesture)];
    swipeGestuer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestuer2];
}


#pragma marh - 创建UITableView,注册cell
- (void)establishUITableViewAndCell {
    // 创建UITableView
   
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-64-49) style:(UITableViewStylePlain)];
    self.tableView.showsVerticalScrollIndicator = NO;
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerClass:[YZHomePageOneViewCell class] forCellReuseIdentifier:@"YZHomePageOneViewCell"];
    [self.tableView registerClass:[YZHomePageTwoViewCell class] forCellReuseIdentifier:@"YZHomePageTwoViewCell"];
    [self.tableView registerClass:[YZHomePageThereViewCell class] forCellReuseIdentifier:@"YZHomePageThereViewCell"];

    self.tableView.backgroundColor = BackGround_Color;
    // 隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.bounces = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource代理方法
// 返回tabelView中section(分区)的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
// 返回每个分区中cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3+self.DArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        self.UITableVC = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        
//        self.UITableVC.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 添加轮播图控件
        [self addShufflingViewOne];
        
        // 添加分割视图
        [self AddBackView];
        
        return self.UITableVC;
    }else if(indexPath.row == 1) {
        
        YZHomePageOneViewCell *YZHomePageOneVC = [tableView dequeueReusableCellWithIdentifier:@"YZHomePageOneViewCell" forIndexPath:indexPath];
        
        YZHomePageOneVC.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.dataArray.count != 0) {
            
            YZHomePageOneModel *YZHomePageOneM = self.dataArray[0];
            
            [YZHomePageOneVC setValueForSubViewsByAction:YZHomePageOneM];
        }
        
        UIButton *countButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [countButton  setExclusiveTouch :YES];
        [countButton setFrame:CGRectMake(0, 0, 125*YZAdapter, 93*Size_ratio)];
        [countButton setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        countButton.backgroundColor = [UIColor clearColor];
        [countButton addTarget:self action:@selector(countButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [YZHomePageOneVC addSubview:countButton];
        
        UIButton *rateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [rateButton  setExclusiveTouch :YES];
        [rateButton setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [rateButton setFrame:CGRectMake(125*YZAdapter, 0, 125*YZAdapter, 93*Size_ratio)];
        rateButton.backgroundColor = [UIColor clearColor];
        [rateButton addTarget:self action:@selector(rateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [YZHomePageOneVC addSubview:rateButton];
        
        return YZHomePageOneVC;
        
    }else if(indexPath.row == 2) {
        
        YZHomePageTwoViewCell *YZHomePageTwoVC = [tableView dequeueReusableCellWithIdentifier:@"YZHomePageTwoViewCell" forIndexPath:indexPath];
        
        YZHomePageTwoVC.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *prompt = [[UILabel alloc] initWithFrame:CGRectMake(12*YZAdapter, 16*YZAdapter, Screen_W-24*YZAdapter, 17)];
        prompt.text = @"最新资讯";
        prompt.font = FONT(16);
        prompt.textColor = MainFont_Color;
        [YZHomePageTwoVC.contentView addSubview:prompt];
        
        return YZHomePageTwoVC;
        
    }else {
       
        YZHomePageThereViewCell *YZHomePageThereVC = [tableView dequeueReusableCellWithIdentifier:@"YZHomePageThereViewCell" forIndexPath:indexPath];
        
        if (self.DArray.count != 0) {
            
            YZHomePageTwoModel *YZHomePageTwoM = self.DArray[indexPath.row-3];
            
            [YZHomePageThereVC setValueForSubViewsByAction:YZHomePageTwoM];
        }        
        return YZHomePageThereVC;
    }
    
}

- (void) countButtonClick: (UIButton *)sender {
    
    JHCompletedViewController *JHCViewController = [[JHCompletedViewController alloc]init];
    JHCViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:JHCViewController animated:YES];
}

- (void) rateButtonClick: (UIButton *)sender {
    
    YZWalletViewController *YZWViewController = [[YZWalletViewController alloc]init];
    YZWViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:YZWViewController animated:YES];
    
}

#pragma mark - 添加轮播图控件
- (void)addShufflingViewOne {
    
    UIScrollView *demoContainerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    demoContainerView.frame = CGRectMake(0, 0, Screen_W, 135*YZAdapter);
    [self.UITableVC addSubview:demoContainerView];
        
    if (self.imagesURLStrings.count == 0) {
        for (int i = 1; i < self.dataArray.count; i++) {
            YZHomePageThereModel *YZHomePageTM = self.dataArray[i];
            [self.imagesURLStrings addObject:YZHomePageTM.img_uri];
            [self.titles addObject:YZHomePageTM.title];
            [self.LinkArray addObject:YZHomePageTM.link_uri];
        }
    }

    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Screen_W, 135*YZAdapter) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.titlesGroup = self.titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [demoContainerView addSubview:cycleScrollView2];
    
    //         --- 模拟加载延迟
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = self.imagesURLStrings;
//    });
    
    // block监听点击方式
     cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
     NSLog(@">>>>>  %ld", (long)index);
         
         LKWaitBubble(@"跳转中...");
         YZDetailsController *YZDetController = [[YZDetailsController alloc]init];
         YZDetController.urlStr = self.LinkArray[index];
         YZDetController.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:YZDetController animated:YES];
         
     };
}

// 把网络图片地址转为UIimage格式
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    NSLog(@"执行图片下载函数");
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
    return result;
}



- (void)AddBackView {
    
    UIView *BackView = [[UIView alloc] initWithFrame:CGRectMake(0, 135*YZAdapter, Screen_W, 15*YZAdapter)];
    BackView.backgroundColor = YZColor(245, 245, 245);
    [self.UITableVC addSubview:BackView];
}


// 去掉cell左侧空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

// 返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 150*YZAdapter;
    }else if(indexPath.row == 1) {
        return 107*YZAdapter;
    }else if(indexPath.row == 2) {
        return 48*YZAdapter;
    }else {
        return 97*YZAdapter;
    }
    
}

// 设置表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ([self.power.stringValue isEqualToString:@"0"]) {
        return 32*YZAdapter;
    }else {
        return 0;
    }
}

//添加标头中的内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([self.power.stringValue isEqualToString:@"0"]) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 32*YZAdapter)];
        headerView.backgroundColor = YZColor(255, 250, 182);
        
        withdrawal = [UIButton buttonWithType:UIButtonTypeSystem];
        [withdrawal  setExclusiveTouch :YES];
        withdrawal.frame = CGRectMake(13*YZAdapter, 10*YZAdapter, Screen_W - 13*YZAdapter, 13*YZAdapter);
        [withdrawal setTitle:@"温馨提示: 您的听单设置没有开启, 现在是否开启听单?" forState:UIControlStateNormal];
        [withdrawal setTintColor:MainFont_Color];
        // 高亮状态
        [withdrawal setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        // 正常状态
        //    [withdrawal setImage:[UIImage imageNamed:@"green-1"] forState:UIControlStateNormal];
        [withdrawal addTarget:self action:@selector(handleWithdrawal) forControlEvents:UIControlEventTouchUpInside];
        withdrawal.titleLabel.font = FONT(12);
        withdrawal.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [headerView addSubview:withdrawal];
        
        return headerView;
        
    }else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 0)];
        return headerView;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= 3) {
        LKWaitBubble(@"跳转中...");
        YZDetailsController *YZDetController = [[YZDetailsController alloc]init];
        
        YZHomePageTwoModel *YZHomePageTwoM = self.DArray[indexPath.row-3];
        
        YZDetController.urlStr = YZHomePageTwoM.link_uri;
        YZDetController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:YZDetController animated:YES];
    }
}

#pragma mark - 点击前往设置听单页面
- (void) handleWithdrawal {
    
    // 进行实名认证
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    if ([YZUtil isBlankString:model.realname] || [YZUtil isBlankString:model.cardno]) {
        
        YZRealNameViewController * YZRealNameController = [[YZRealNameViewController alloc]init];
        YZRealNameController.BankID = @"Order";
        YZRealNameController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:YZRealNameController animated:YES];
    }else {
        YZListenSetViewController * YZListenController = [[YZListenSetViewController alloc]init];
        YZListenController.RealName = @"实名认证";
        YZListenController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:YZListenController animated:YES];
    }
    
}


#pragma mark - 数据请求首页数据
- (void)WALLET_LOGRequest:(BOOL)isRefresh {

    YZHomePageResquest *YZHP_Resquest = [YZHomePageResquest zwb_requestWithUrl:Main_Start isPost:YES];
    
    WeakSelf(self);
    [YZHP_Resquest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
        DLog(@"%@", message);
        if (success) {
            
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.DArray removeAllObjects];
            
            DLog(@"return sruccess:%@", responseObject);
            NSString * code = responseObject[@"code"];
            if ([code integerValue] == 0) {
                
                self.power = responseObject[@"data"][@"setting"][@"power"];
                
                YZHomePageOneModel *YZHomePageOM = [YZHomePageOneModel modelWithDictionary:responseObject[@"data"]];
                [weakSelf.dataArray addObject:YZHomePageOM];
                
                [[NSUserDefaults standardUserDefaults] setObject:YZHomePageOM.service_tel forKey:@"service_tel"];
                
                NSArray *bannerArray = responseObject[@"data"][@"banner"];
                
                for (NSDictionary *listDict in bannerArray) {
                    if ([listDict allKeys].count != 0) {
                        YZHomePageThereModel *YZHomePageTM = [YZHomePageThereModel modelWithDictionary:listDict];
                        [weakSelf.dataArray addObject:YZHomePageTM];
                    }
                }
                
                NSArray *LArray = responseObject[@"data"][@"news"][@"data"];
                for (NSDictionary *listDict in LArray) {
                    if ([listDict allKeys].count != 0) {
                        YZHomePageTwoModel *YZHomePageTwoM = [YZHomePageTwoModel modelWithDictionary:listDict];
                        [weakSelf.DArray addObject:YZHomePageTwoM];
                    }
                }
                
                [weakSelf.tableView reloadData];
                
            }else if ([code integerValue] == 900102) {
                [MBProgressHUD showAutoMessage:@"登录信息失效"];
                
                YZLoginViewController * vc = [[YZLoginViewController alloc]init];
                YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
                vc.AlertPhone = model.Usre_Phone;
                
                [[YZUserInfoManager sharedManager] didLoginOut];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            DLog(@"return failure");
            [MBProgressHUD showAutoMessage:@"请求失败, 请检查您的网络连接"];
        }
    } failure:^(NSError *error) {
        DLog(@"error == %@", error);
        [MBProgressHUD showAutoMessage:@"请求失败, 请检查您的网络连接"];
    }];
}

#pragma mark - 接受推送通知的传值
- (void)UserInfoNotification:(NSNotification *)Order{
    DLog(@"－－－－－接收到通知------");
    
    [self.OrderDic addEntriesFromDictionary:Order.userInfo];
    
    if ([Order.userInfo allKeys].count != 4 && [_OrderDic[@"MSGTYPE"] isEqualToString:@"NEWMSG"]){
    
        self.Red = [[UIView alloc] initWithFrame:CGRectMake(_rightButton.frame.size.width-10*YZAdapter, 1*YZAdapter, 10*YZAdapter, 10*YZAdapter)];
        self.Red.layer.cornerRadius = 5;
        self.Red.layer.masksToBounds = YES;
        self.Red.backgroundColor = Red_Color;
        [_rightButton addSubview:self.Red];
        
        // 把收到消息的值设置为1
        NSDictionary *RedDic= [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"Red", nil];;
        // 创建要写入字典的对象
        NSString *dicPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Red.txt"];
        // 写入
        BOOL isSuccess = [RedDic writeToFile:dicPath atomically:YES];
        DLog(@"%@", isSuccess ? @"写入成功" : @"写入失败");
        
//        YZPushModel *Push = [[YZPushModel alloc] init];
//        
//        Push.mid = _OrderDic[@"mid"];
//        Push.title = _OrderDic[@"title"];
//        Push.content = _OrderDic[@"content"];
//        Push.link = _OrderDic[@"link"];
//        Push.pic = _OrderDic[@"pic"];
//        Push.datetime = _OrderDic[@"datetime"];
//        
//        // 删除数据库中的相同数据
//        [[YZDataBase shareDataBase] deleteOneMovieByPushID:Push.mid];
//        // 插入数据库
//        [[YZDataBase shareDataBase] insertPush:Push];
//        
//        //创建通知
//        NSNotification *PushNotification =[NSNotification notificationWithName:@"PushNotification" object:nil userInfo:nil];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:PushNotification];
//        
    }
    
}


// 获取初始信息
- (void)NetRequestUserInfo{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSString * url = @"user/start";
    [self.manager requestUserInfoPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
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
            //            [self.frostedViewController hideMenuViewController];
        }
        
    } failed:^(NSError *error) {
        DLog(@"---------------");
        DLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
