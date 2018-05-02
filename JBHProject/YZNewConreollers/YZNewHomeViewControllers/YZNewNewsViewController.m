//
//  YZNewNewsViewController.m
//  JBHProject
//
//  Created by zyz on 2018/1/9.
//  Copyright © 2018年 聚宝汇. All rights reserved.
//

#import "YZNewNewsViewController.h"
#import "YZNewHomeZoneCell.h"
#import "YZNewHomeOneCell.h"
#import "YZNewHomeThereCell.h"
#import "YZNewHomeModel.h"
#import "YZDetailsController.h"

@interface YZNewNewsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YZNewHomeZoneCell *ZoneImageCell;
@property (nonatomic, strong) YZNewHomeOneCell *OneImageCell;
@property (nonatomic, strong) YZNewHomeThereCell *ThereImageCell;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic) NSInteger page;

@property (nonatomic, strong) UIView *BackView; // 提示页面
// 空白提示页面
@property (nonatomic, strong) YZNullView *nullView;
@end

@implementation YZNewNewsViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 刷新
    self.page = 0;
    
    // 创建UITableView,注册cell
    [self establishUITableViewAndCell];
    
    // 数据请求
    [self requesthomelise:YES];
    [self loadData];
    
}
- (void)loadData {
    WeakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requesthomelise:YES];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requesthomelise:NO];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma marh - 创建UITableView,注册cell
- (void)establishUITableViewAndCell {
    // 创建UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-69-44) style:(UITableViewStylePlain)];
    
    // 注册cell
    [self.tableView registerClass:[YZNewHomeZoneCell class] forCellReuseIdentifier:@"YZNewHomeZoneCell"];
    [self.tableView registerClass:[YZNewHomeOneCell class] forCellReuseIdentifier:@"YZNewHomeOneCell"];
    [self.tableView registerClass:[YZNewHomeThereCell class] forCellReuseIdentifier:@"YZNewHomeThereCell"];
    
    self.tableView.backgroundColor = YZBackNavColor;
    
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.OneImageCell = [tableView dequeueReusableCellWithIdentifier:@"YZNewHomeOneCell" forIndexPath:indexPath];
    
    self.OneImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArray.count != 0) {
        
        YZNewHomeModel *model = self.dataArray[indexPath.row];
        
        if (model.img.count == 1) {

            YZNewHomeModel *model = self.dataArray[indexPath.row];
            
            [self.OneImageCell setValueForSubViewsByAction:model];
            
            return self.OneImageCell;
        }else if(model.img.count == 0) {
            self.ZoneImageCell = [tableView dequeueReusableCellWithIdentifier:@"YZNewHomeZoneCell" forIndexPath:indexPath];
            
            self.ZoneImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return self.ZoneImageCell;
        }else {
            self.ThereImageCell = [tableView dequeueReusableCellWithIdentifier:@"YZNewHomeThereCell" forIndexPath:indexPath];
            
            self.ThereImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return self.ThereImageCell;
        }
        
    }

    return self.ZoneImageCell;
    
}

#pragma mark -  返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZNewHomeModel *model = self.dataArray[indexPath.row];
    
    if (model.img.count == 1) {
        return 102*YZAdapter;
    }else if(model.img.count == 0) {
        return [YZNewHomeZoneCell EvaluationCellHeightByEvaluation:model.name];
    }else {
        return [YZNewHomeThereCell EvaluationCellHeightByEvaluation:model.name];
    }
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LKWaitBubble(@"跳转中...");
    YZNewHomeModel *model = self.dataArray[indexPath.row];
    YZDetailsController *YZDetController = [[YZDetailsController alloc]init];
    YZDetController.urlStr = model.uri;
    YZDetController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:YZDetController animated:YES];
}


// 数据请求首页数据
- (void) requesthomelise:(BOOL)isRefresh{
    
    LKWaitBubble(@"加载中...");
    
    if (!isRefresh) {
        self.page++;
    }else {
        self.page = 0;
        [self.dataArray removeAllObjects];
    }
    
    YZHomePageResquest *ARTICLE_Resquest = [YZHomePageResquest zwb_requestWithUrl:SY_ARTICLE_LISTS isPost:YES];
    
    ARTICLE_Resquest.type = self.index;
    ARTICLE_Resquest.p = [NSString stringWithFormat:@"%ld", self.page];
    ARTICLE_Resquest.row = @"10";
    
    WeakSelf(self);
    [ARTICLE_Resquest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
        DLog(@"%@", message);
        if (success) {
            [weakSelf.nullView removeFromSuperview];
            DLog(@"return sruccess:%@", responseObject);
            NSString * code = responseObject[@"code"];
            if ([code integerValue] == 0) {
                LKHideBubble();
                [weakSelf.BackView removeFromSuperview];
                NSMutableArray *YZHomeArray = responseObject[@"data"][@"list"];
                
                for (NSDictionary *listDict in YZHomeArray) {
                    if ([listDict allKeys].count != 0) {
                        YZNewHomeModel *YZHomePageTM = [YZNewHomeModel modelWithDictionary:listDict];
                        [weakSelf.dataArray addObject:YZHomePageTM];
                    }
                }
                if (YZHomeArray.count == 0 && weakSelf.page>0) {
                    [MBProgressHUD showAutoMessage:@"到底了"];
                }
                
                if (weakSelf.dataArray.count == 0) {
                    weakSelf.nullView = [[YZNullView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
                    [weakSelf.tableView addSubview:weakSelf.nullView];
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
            }else if ([code integerValue] == 999999) {
                LKHideBubble();
            }
        } else {
            LKHideBubble();
            DLog(@"return failure");
            [MBProgressHUD showAutoMessage:@"请求失败, 请检查您的网络连接"];
        }
    } failure:^(NSError *error) {
        LKHideBubble();
        DLog(@"error == %@", error);
        
        [self addBackView];
        
//        [MBProgressHUD showAutoMessage:@"请求失败, 请检查您的网络连接"];
    }];
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
    
    [self requesthomelise:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
