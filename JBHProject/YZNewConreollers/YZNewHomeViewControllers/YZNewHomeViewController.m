//
//  YZNewHomeViewController.m
//  JBHProject
//
//  Created by zyz on 2018/1/9.
//  Copyright © 2018年 聚宝汇. All rights reserved.
//

#import "YZNewHomeViewController.h"
#import "YZNewNewsViewController.h"
@interface YZNewHomeViewController ()<UIScrollViewDelegate,SGSegmentedControlDelegate>

@property (nonatomic, strong) SGSegmentedControl *SG;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic,strong)UIView *Red; // 消息标识
@property(nonatomic,strong) NSMutableDictionary *OrderDic; // 存放接受的推送消息
@property (nonatomic, strong) UIButton *EndBut;
@property (nonatomic, strong) NSString *index; // 获取当前所在页数
@property(nonatomic,strong)HomeNetWorking * manager;
@end

@implementation YZNewHomeViewController
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

- (void)viewWillAppear:(BOOL)animated {
    // 取消系统自带的导航条
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    // 判断是否需要把小红点展示出来
    NSString *RedPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Red.txt"];
    NSDictionary *RedDic = [NSDictionary dictionaryWithContentsOfFile:RedPath];
    if ([RedDic[@"Red"] isEqualToString:@"1"]) {
        self.Red = [[UIView alloc] initWithFrame:CGRectMake(_EndBut.frame.size.width-10*YZAdapter, 1*YZAdapter, 10*YZAdapter, 10*YZAdapter)];
        self.Red.layer.cornerRadius = 5;
        self.Red.layer.masksToBounds = YES;
        self.Red.backgroundColor = Red_Color;
        [_EndBut addSubview:self.Red];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    // 取消系统自带的导航条
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加自定义导航栏
    [self AddTabView];
    
    // 添加所有子控制器
    [self setupChildViewController];
    [self NetRequestUserInfo]; // 获取用户初始化信息
    //注册通知 接受推送数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserInfoNotification:) name:@"UserInfoNotification" object:nil];
}


#pragma mark - 添加自定义导航栏
- (void)AddTabView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 20)];
    headerView.backgroundColor = YZBackNavColor;
    
    [self.view addSubview:headerView];
}


- (void)setupSegmentedControl {
    
    NSArray *title_arr = [NSUSERDEFAULTS arrayForKey:Home_AdData];
    
    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, 20+44, Screen_W, Screen_H-69-44);
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * title_arr.count, 0);
    _mainScrollView.backgroundColor = [UIColor clearColor];
    // 开启分页
    _mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    UIView *BackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, Screen_W, 44)];
    BackGroundView.backgroundColor = YZBackNavColor;
    
    self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, 300*YZAdapter, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:title_arr];
    _SG.titleColorStateSelected = YZEssentialColor;
    _SG.indicatorColor = YZEssentialColor;
    [BackGroundView addSubview:_SG];
    
    UIView *divisionView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, Screen_W, 1)];
    divisionView.backgroundColor = YZDivisionColor;
    [BackGroundView addSubview:divisionView];
    
    self.EndBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _EndBut.frame = CGRectMake(Screen_W-42*YZAdapter, 22-15*YZAdapter, 30*YZAdapter, 30*YZAdapter);
//    [EndBut setBackgroundImage:[UIImage imageNamed:@"信息"] forState:(UIControlStateHighlighted)];
    [_EndBut setBackgroundImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
//    [EndBut setImage:[UIImage imageNamed:@"信息"] forState:UIControlStateNormal];
    _EndBut.backgroundColor = YZBackNavColor;
    
    [_EndBut addTarget:self action:@selector(handleEnd:) forControlEvents:UIControlEventTouchUpInside];
    [BackGroundView addSubview:_EndBut];
    
    [self.view addSubview:BackGroundView];

}


- (void)handleEnd:(UIButton *) sender {
    
    int i = 0;
    for (UIView *view in _EndBut.subviews) {
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


- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
    // 1 计算滚动的位置
    CGFloat offsetX = index * Screen_W;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
}

// 添加子控制器
- (void)setupChildController {
    
    [NSUSERDEFAULTS setObject:self.dataArray forKey:Home_AdData];
    [NSUSERDEFAULTS synchronize];
    
    NSArray *array = [NSUSERDEFAULTS arrayForKey:Home_AdData];
    
    for (int i = 0; i < array.count; i++) {
        
        YZNewNewsViewController *PropertyTVC = [YZNewNewsViewController new];
        
        PropertyTVC.index = [NSString stringWithFormat: @"%ld", (long)i];
        
        [self addChildViewController:PropertyTVC];
    }
    [self setupSegmentedControl];
}


// 添加所有子控制器
- (void)setupChildViewController {

    [self setupChildController];
    
    // 数据请求模块数据
    YZALLService *USER_REALNAMEVERIFYRequest = [YZALLService zwb_requestWithUrl:SY_ARTICLE_TYPE isPost:YES];

    [USER_REALNAMEVERIFYRequest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
        DLog(@"%@", message);
        if (success) {
            DLog(@"return success:%@", responseObject);
            NSString * code = responseObject[@"code"];

            if ([code integerValue] == 0) {

                self.dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];

                if (![self.dataArray isEqualToArray:[NSUSERDEFAULTS arrayForKey:Home_AdData]]) {
                    [self setupChildController];
                    
                }

            }else if ([code integerValue] == 900102) {
                LKHideBubble();
                [MBProgressHUD showAutoMessage:@"登录信息失效"];
                YZLoginViewController * vc = [[YZLoginViewController alloc]init];
                YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
                vc.AlertPhone = model.Usre_Phone;

                [[YZUserInfoManager sharedManager] didLoginOut];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([code integerValue] == 999999) {
                LKHideBubble();
            }

        } else {
            DLog(@"return failure");
            LKHideBubble();
            [MBProgressHUD showAutoMessage:@"保存失败, 请检查您的网络连接"];
        }
    } failure:^(NSError *error) {
        DLog(@"error == %@", error);
        LKHideBubble();
        [MBProgressHUD showAutoMessage:@"保存失败, 请检查您的网络连接"];
    }];

}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * Screen_W;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, Screen_W, Screen_H-69-44);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self showVc:index];
    
    // 2.把对应的标题选中
    [self.SG titleBtnSelectedWithScrollView:scrollView];
    
}


#pragma mark - 接受推送通知的传值
- (void)UserInfoNotification:(NSNotification *)Order{
    DLog(@"－－－－－接收到通知------");
    
    [self.OrderDic addEntriesFromDictionary:Order.userInfo];
    
    if ([Order.userInfo allKeys].count != 4 && [_OrderDic[@"MSGTYPE"] isEqualToString:@"NEWMSG"]){
        
        self.Red = [[UIView alloc] initWithFrame:CGRectMake(_EndBut.frame.size.width-10*YZAdapter, 1*YZAdapter, 10*YZAdapter, 10*YZAdapter)];
        self.Red.layer.cornerRadius = 5;
        self.Red.layer.masksToBounds = YES;
        self.Red.backgroundColor = Red_Color;
        [_EndBut addSubview:self.Red];
        
        // 把收到消息的值设置为1
        NSDictionary *RedDic= [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"Red", nil];;
        // 创建要写入字典的对象
        NSString *dicPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Red.txt"];
        // 写入
        BOOL isSuccess = [RedDic writeToFile:dicPath atomically:YES];
        DLog(@"%@", isSuccess ? @"写入成功" : @"写入失败");

    }
    
}

- (HomeNetWorking *)manager
{
    if (_manager == nil) {
        _manager = [HomeNetWorking sharedInstance];
    }
    return _manager;
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


@end
