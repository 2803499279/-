//
//  YZNewCarController.m
//  JBHProject
//
//  Created by zyz on 2018/1/9.
//  Copyright © 2018年 聚宝汇. All rights reserved.
//

#import "YZNewCarController.h"
#import "YZNewCaseCell.h"
#import "HomeTableViewCell.h"
#import "MyMapViewController.h"
#define HOMETABLCELLID @"homeCellId"
@interface YZNewCarController ()<UITableViewDataSource, UITableViewDelegate,HomeTableViewCellDelegate>



@property (nonatomic, strong) HomeTableViewCell *NewCaseCell;

@property(nonatomic,strong)NSMutableArray * OrderDataSource;

// 存放新的展示数组
@property(nonatomic,strong)NSMutableArray * NewOrderArray;
@property (nonatomic, strong) UIView *BackView; // 提示页面

@property (nonatomic, strong) NSString *service_tel;
// 空白提示页面
@property (nonatomic, strong) YZNullView *nullView;
@property(nonatomic,strong)HomeNetWorking * manager;
@end

@implementation YZNewCarController

- (HomeNetWorking *)manager
{
    if (_manager == nil) {
        _manager = [HomeNetWorking sharedInstance];
    }
    return _manager;
}

- (NSMutableArray *)OrderDataSource {
    if (!_OrderDataSource) {
        _OrderDataSource = [[NSMutableArray alloc] init];
    }
    return _OrderDataSource;
}
- (NSMutableArray *)NewOrderArray {
    if (!_NewOrderArray) {
        _NewOrderArray = [[NSMutableArray alloc] init];
    }
    return _NewOrderArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    // 创建UITableView,注册cell
    [self establishUITableViewAndCell];
    // 数据请求
    [self loadData];
    
    [self NetRequestUserInfo];
    
    //注册通知 接受推送数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listandcar:) name:@"listandcar" object:nil];
    
}

#pragma mark - 接受推送通知的传值
- (void)listandcar:(NSNotification *)Order{
    [self netRequestTaskUnsolved:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [self netRequestTaskUnsolved:YES];
}

- (void)loadData {
    WeakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netRequestTaskUnsolved:YES];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}


#pragma marh - 创建UITableView,注册cell
- (void)establishUITableViewAndCell {
    // 创建UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-69-44) style:(UITableViewStyleGrouped)];
    
    // 注册cell
    [self.tableView registerClass:[YZNewCaseCell class] forCellReuseIdentifier:@"YZNewCaseCell"];
    
    self.tableView.backgroundColor = YZBackNavColor;
    
    self.tableView.separatorStyle = NO;//隐藏分割线
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
    
    return _OrderDataSource.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    self.NewCaseCell = [tableView dequeueReusableCellWithIdentifier:@"YZNewCaseCell" forIndexPath:indexPath];
    self.NewCaseCell = [tableView dequeueReusableCellWithIdentifier:HOMETABLCELLID];
    if (self.NewCaseCell == nil) {
        self.NewCaseCell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HOMETABLCELLID];
    }
    // 立即处理
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 15*YZAdapter, 35*YZAdapter, 15*YZAdapter)];
    labelOne.text = @"立即";
    labelOne.textColor = WhiteColor;
    labelOne.textAlignment = NSTextAlignmentCenter;
    labelOne.backgroundColor = [UIColor clearColor];
    [self.NewCaseCell.RapBut addSubview:labelOne];
    
    UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 35*YZAdapter, 35*YZAdapter, 15*YZAdapter)];
    labelTwo.text = @"处理";
    labelTwo.textColor = WhiteColor;
    labelTwo.textAlignment = NSTextAlignmentCenter;
    labelTwo.backgroundColor = [UIColor clearColor];
    [self.NewCaseCell.RapBut addSubview:labelTwo];
    
    YZUserInfoModel *model1 = [[YZUserInfoManager sharedManager] currentUserInfo];
    
    NSArray *OrderArray = [[YZDataBase shareDataBase] selectUidOrder:model1.uid];
    
    [self.NewOrderArray removeAllObjects];
    for (int i = 0; i < OrderArray.count; i++) {
        YZOrderModel * model = OrderArray[i];
        if ([model.state isEqualToString:@"1"]) {
            [self.NewOrderArray addObject:model];
        }
    }
    
    [_OrderDataSource removeAllObjects];
    _OrderDataSource = [JHTools YZOrderModel:self.NewOrderArray];
    
    self.NewCaseCell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSArray * reversedArray = [[_OrderDataSource reverseObjectEnumerator] allObjects];
    YZOrderModel * model = reversedArray[indexPath.row];
    self.NewCaseCell.homeTableViewCellDelegate = self;
    self.NewCaseCell.cellModel = model;
    
//    [self.NewCaseCell.RapBut addTarget:self action:@selector(handleRapBut:) forControlEvents:UIControlEventTouchUpInside];
    
    self.NewCaseCell.RapView.layer.borderColor = [NewGreenButton_Color CGColor];
    [self.NewCaseCell.RapBut setTitle:@"" forState:UIControlStateNormal];
    [self.NewCaseCell.RapBut setBackgroundColor:NewGreenButton_Color];
    
    return self.NewCaseCell;
    
}


//- (void)handleRapBut:(UIButton *)sender {
//    
//   
//    
//}

- (void)NetRequestUserInfo
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSString * url = @"user/start";
    [self.manager requestUserInfoPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
        NSString * code = responsData[@"code"];
        if ([code integerValue] == 0){
            
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:responsData];
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:mDict[@"data"]];
            
            self.service_tel = dataDic[@"service_tel"];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.service_tel forKey:@"service_tel"];

        }else if ([code integerValue] == 900102) {
            [MBProgressHUD showAutoMessage:@"登录信息失效"];
            //            LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"登录信息失效" BubbleImage:@"YZPromptSubmit"], 1);
            
            YZLoginViewController * vc = [[YZLoginViewController alloc]init];
            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            vc.AlertPhone = model.Usre_Phone;
            
            [[YZUserInfoManager sharedManager] didLoginOut];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failed:^(NSError *error) {
        DLog(@"---------------");
        DLog(@"%@",error);
    }];
}


// 数据请求  获取正在处理的订单
- (void)netRequestTaskUnsolved: (BOOL)isRefresh {
    
    YZHomePageResquest *ARTICLE_Resquest = [YZHomePageResquest zwb_requestWithUrl:TD_CXKC_TASK_UNSOLVED isPost:YES];
    WeakSelf(self);
    [ARTICLE_Resquest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
        DLog(@"%@", message);
        if (success) {
            [self.nullView removeFromSuperview];
            DLog(@"return sruccess:%@", responseObject);
            NSString * code = responseObject[@"code"];
            if ([code integerValue] == 0) {
                
                YZOrderModel *model1 = [YZOrderModel modelWithDictionary:responseObject[@"data"]];
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
                    if ([model.state isEqualToString:@"1"]) {
                        [self.NewOrderArray addObject:model];
                    }
                }
                
                if (weakSelf.NewOrderArray.count == 0) {
                    self.nullView = [[YZNullView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
                    [self.tableView addSubview:self.nullView];
                }
                
#pragma mark------------ 超时删除
                [_OrderDataSource removeAllObjects];
                _OrderDataSource = [JHTools YZOrderModel:self.NewOrderArray];

                [weakSelf.tableView reloadData];
                
            }else if ([code integerValue] == 900102) {
                [MBProgressHUD showAutoMessage:@"登录信息失效"];
                
                YZLoginViewController * vc = [[YZLoginViewController alloc]init];
                YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
                vc.AlertPhone = model.Usre_Phone;
                
                [[YZUserInfoManager sharedManager] didLoginOut];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([code integerValue] == 999999) {
                
                self.nullView = [[YZNullView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
                [self.tableView addSubview:self.nullView];
                
                LKHideBubble();
            }else if ([code integerValue] == 217001) {
                
                self.nullView = [[YZNullView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
                [self.tableView addSubview:self.nullView];
                
                LKHideBubble();
            }
        } else {
            LKHideBubble();
            DLog(@"return failure");
            [self addBackView];
            
//            [MBProgressHUD showAutoMessage:@"请求失败, 请检查您的网络连接"];
        }
    } failure:^(NSError *error) {
        LKHideBubble();
        DLog(@"error == %@", error);
        
        [self addBackView];
        
        //        [MBProgressHUD showAutoMessage:@"请求失败, 请检查您的网络连接"];
    }];
}

// 设置表脚高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.NewOrderArray.count == 0) {
        return 0.01*YZAdapter;
    }else {
        return 15*YZAdapter;
    }
    
}
//
//添加标脚中的内容
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 15*YZAdapter)];
    footerView.backgroundColor = WhiteColor;
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 15*YZAdapter)];
    HeaderView.backgroundColor = WhiteColor;
    return HeaderView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.01*YZAdapter;
}


#pragma mark -  返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZOrderModel * model;
    model = _OrderDataSource[indexPath.row];
    return [HomeTableViewCell HomeCellHeightWithModel:model]+20*Size_ratio;;
}

#pragma mark -  去掉cell左侧空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark HomeTableViewCellViewDelegate
- (void)didSelectedHomeTableViewcell:(HomeTableViewCell *)cell{
    MyMapViewController * vc = [[MyMapViewController alloc]init];
    vc.orderModel = cell.cellModel;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) addBackView {
    self.BackView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.BackView.backgroundColor = YZColor(247, 247, 247);
    
    UIImageView *BackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(87*YZAdapter, 85*YZAdapter, 201*YZAdapter, 137*YZAdapter)];
    BackImageView.image = [UIImage imageNamed:@"YZRquestError"];
    [self.BackView addSubview:BackImageView];
    
    UILabel *BigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 248*YZAdapter, Screen_W, 20*YZAdapter)];
    BigLabel.text = @"网络连接异常";
    BigLabel.font = FONT(18);
    BigLabel.textColor = MainFont_Color;
    BigLabel.textAlignment = NSTextAlignmentCenter;
    [self.BackView addSubview:BigLabel];
    
    UILabel *XLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 284*YZAdapter, Screen_W, 13)];
    XLabel.font = FONT(12);
    XLabel.textAlignment = NSTextAlignmentCenter;
    XLabel.textColor = TimeFont_Color;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"请您检查网络或点击页面刷新"];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:GreenButton_Color
     
                          range:NSMakeRange(11, 2)];
    
    [AttributedStr addAttribute:NSUnderlineStyleAttributeName
     
                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
     
                          range:NSMakeRange(11, 2)];
    
    XLabel.attributedText = AttributedStr;
    
    
    [self.BackView addSubview:XLabel];
    
    UITapGestureRecognizer *BackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    BackGesture.numberOfTapsRequired = 1;
    BackGesture.numberOfTouchesRequired = 1;
    [self.BackView addGestureRecognizer:BackGesture];
    
    [self.tableView addSubview:self.BackView];
}




- (void)handleTapGesture:(UIButton *)sender {
    
    [self.BackView removeFromSuperview];
    
    LKWaitBubble(@"加载中...");
    
    [self netRequestTaskUnsolved:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
