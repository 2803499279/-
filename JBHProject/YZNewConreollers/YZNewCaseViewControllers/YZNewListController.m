//
//  YZNewListController.m
//  JBHProject
//
//  Created by zyz on 2018/1/9.
//  Copyright © 2018年 聚宝汇. All rights reserved.
//

#import "YZNewListController.h"
#import "YZNewCaseCell.h"
#import "YZNewCarController.h"
#import "YZNewCaseController.h"
@interface YZNewListController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YZNewCaseCell *NewCaseCell;

@end

@implementation YZNewListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    // 创建UITableView,注册cell
    [self establishUITableViewAndCell];
    
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
    return 6;
}
// 返回每个分区中cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.NewCaseCell = [tableView dequeueReusableCellWithIdentifier:@"YZNewCaseCell" forIndexPath:indexPath];
    
    self.NewCaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        if (self.dataArray.count != 0) {
    //
    //            CarInformationModel *model = self.dataArray[indexPath.row];
    //
    //            [self.IngormationOneImageCellVC setValueForSubViewsByAction:model];
    //        }
    
    [self.NewCaseCell.RapBut addTarget:self action:@selector(handleRapBut:) forControlEvents:UIControlEventTouchUpInside];
    
    return self.NewCaseCell;
    
}

- (void)handleRapBut:(UIButton *)sender {
    
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

// 显示控制器的view
- (void)showVc:(NSInteger)index {

    CGFloat offsetX = index * Screen_W;
    
    YZNewCaseController *vc = (YZNewCaseController *)[[self.view.superview.superview.superview.subviews lastObject] nextResponder];

    YZNewCarController *CVC = vc.childViewControllers[1];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (CVC.isViewLoaded) return;
    UIScrollView *mainScrollView = (UIScrollView *)self.view.superview;
    [mainScrollView addSubview:CVC.view];
    CVC.view.frame = CGRectMake(offsetX, 0, Screen_W, Screen_H-69-44);
}
- (UIViewController *)viewController {
    
    return nil;
}


// 设置表脚高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (5 == section) {
        return 15*YZAdapter;
    }else {
        return 0.01;
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
    return  15*YZAdapter;
}


#pragma mark -  返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270*YZAdapter;
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
    // Dispose of any resources that can be recreated.
}

@end
