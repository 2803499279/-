//
//  YZNewCaseController.m
//  JBHProject
//
//  Created by zyz on 2018/1/9.
//  Copyright © 2018年 聚宝汇. All rights reserved.
//

#import "YZNewCaseController.h"
#import "YZNewListController.h"
#import "YZNewCarController.h"
#import "ListeningList.h"

@interface YZNewCaseController ()<UIScrollViewDelegate,SGSegmentedControlDelegate>


@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YZNewCaseController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    // 取消系统自带的导航条
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    // 显示系统自带的导航条
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    // 添加自定义导航栏
    [self AddTabView];
    
    // 添加所有子控制器
    [self setupChildViewController];
}

#pragma mark - 添加自定义导航栏
- (void)AddTabView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 20)];
    headerView.backgroundColor = YZBackNavColor;
    
    [self.view addSubview:headerView];
}


- (void)setupSegmentedControl {
    
    NSArray *title_arr = self.dataArray;
    
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
    
    self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, Screen_W/2, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:title_arr];
    _SG.titleColorStateSelected = YZEssentialColor;
    _SG.indicatorColor = YZEssentialColor;
    [BackGroundView addSubview:_SG];
    
    UIView *divisionView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, Screen_W, 1)];
    divisionView.backgroundColor = YZDivisionColor;
    [BackGroundView addSubview:divisionView];
    
    UIButton *EndBut = [UIButton buttonWithType:UIButtonTypeCustom];
    EndBut.frame = CGRectMake(Screen_W-47*YZAdapter, 0, 35*YZAdapter, 43);

    [EndBut setImage:[UIImage imageNamed:@"已完成订单"] forState:UIControlStateNormal];
    [EndBut setTitle:@"已完成" forState:UIControlStateNormal];
    EndBut.titleLabel.font = FONT(10);
    [EndBut setTitleColor:MainFont_Color forState:UIControlStateNormal];
    EndBut.backgroundColor = YZBackNavColor;
    
    EndBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [EndBut setTitleEdgeInsets:UIEdgeInsetsMake(EndBut.imageView.frame.size.height+2*YZAdapter ,-EndBut.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [EndBut setImageEdgeInsets:UIEdgeInsetsMake(-EndBut.titleLabel.bounds.size.height, 0.0,0.0, -EndBut.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边

    [EndBut addTarget:self action:@selector(handleEnd:) forControlEvents:UIControlEventTouchUpInside];
    [BackGroundView addSubview:EndBut];
    [self.view addSubview:BackGroundView];
}

- (void)handleEnd:(UIButton *) sender {
    
    JHCompletedViewController *JHCViewController = [[JHCompletedViewController alloc]init];
    JHCViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:JHCViewController animated:YES];
}


- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
    // 1 计算滚动的位置
    CGFloat offsetX = index * Screen_W;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
    
    //    self.index = [NSString stringWithFormat: @"%ld", (long)index];
    
}

// 添加所有子控制器
- (void)setupChildViewController {
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"听单",@"车险勘察", nil];
 
    // 听单
    ListeningList *YZNewListVC = [ListeningList new];

    YZNewCarController *YZNewCarVC = [YZNewCarController new];
    
    [self addChildViewController:YZNewListVC];
    [self addChildViewController:YZNewCarVC];
    
    [self setupSegmentedControl];

}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * Screen_W;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
//    if (vc.isViewLoaded) return;
    [vc.view reloadInputViews];
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
    
    //    self.index = [NSString stringWithFormat: @"%ld", (long)index];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
