//
//  YZSetringViewController.m
//  JBHProject
//
//  Created by zyz on 2017/4/27.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZSetringViewController.h"
#import "YZListenSetViewController.h"
#import "YZRealNameViewController.h"
#import "AboutOurViewController.h"
#import "YZCompleteViewController.h"
@interface YZSetringViewController ()

@property (nonatomic, strong) UIButton *CategoryView;
@property (nonatomic, strong) UIButton *InstitutionsView;
@end

@implementation YZSetringViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.CategoryView.backgroundColor = WhiteColor;
    self.InstitutionsView.backgroundColor = WhiteColor;
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = BackGround_Color;
    
    // 设置导航栏
    [self customPushViewControllerNavBarTitle:@"系统设置" backGroundImageName:nil];
    
    // 添加控件
    [self EditPage];
    
    [self customerGesturePop];
}
- (void)goBack
{
    
    [self.view endEditing:YES];
    [super goBack];
//    [self.frostedViewController.view endEditing:YES];
//    // Present the view controller
//    [self.frostedViewController presentMenuViewController];
}
#pragma mark - Private Method 右划返回上一个页面
- (void)customerGesturePop {
    UISwipeGestureRecognizer *swipeGestuer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleOtherSwipeGesture)];
    swipeGestuer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestuer2];
}

- (void) handleOtherSwipeGesture {
//    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
//    [self.frostedViewController.view endEditing:YES];
//    // Present the view controller
//    [self.frostedViewController presentMenuViewController];
}


#pragma mark - 添加控件
- (void)EditPage {
    // 听单设置
    self.CategoryView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.CategoryView.frame = CGRectMake(0, 20*YZAdapter, Screen_W, 47*YZAdapter);
    [self.CategoryView setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
    _CategoryView.backgroundColor = WhiteColor;
    
    UILabel *CategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 0, 100*YZAdapter, 47*YZAdapter)];
    CategoryLabel.text = @"听单设置";
    CategoryLabel.font = FONT(16);
    [_CategoryView addSubview:CategoryLabel];
    CategoryLabel.textColor = MainFont_Color;
    
    UIImageView *CategoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_W - 30*YZAdapter, 17*YZAdapter, 7*YZAdapter, 16*YZAdapter)];
    CategoryImage.image = [UIImage imageNamed:@"fh"];
    [_CategoryView addSubview:CategoryImage];
    [self.view addSubview:_CategoryView];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *CategoryViewtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCategoryView:)];
    // 设置轻拍触发方法时需要的点击次数
    CategoryViewtapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    CategoryViewtapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [_CategoryView addGestureRecognizer:CategoryViewtapGesture];
    
    
    // 给我们好评
    self.InstitutionsView = [UIButton buttonWithType:UIButtonTypeCustom];;
    self.InstitutionsView.frame = CGRectMake(0, 87*YZAdapter, Screen_W, 47*YZAdapter);
    [self.InstitutionsView setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
    _InstitutionsView.backgroundColor = WhiteColor;
    
    UILabel *InstitutionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 0, 100*YZAdapter, 47*YZAdapter)];
    InstitutionsLabel.text = @"关于我们";
    InstitutionsLabel.font = FONT(16);
    [_InstitutionsView addSubview:InstitutionsLabel];
    InstitutionsLabel.textColor = MainFont_Color;
    
    UIImageView *InstitutionsImage = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_W - 30*YZAdapter, 17*YZAdapter, 7*YZAdapter, 16*YZAdapter)];
    InstitutionsImage.image = [UIImage imageNamed:@"fh"];
    [_InstitutionsView addSubview:InstitutionsImage];
    [self.view addSubview:_InstitutionsView];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *InstitutionsViewtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleInstitutionsView:)];
    // 设置轻拍触发方法时需要的点击次数
    InstitutionsViewtapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    InstitutionsViewtapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [_InstitutionsView addGestureRecognizer:InstitutionsViewtapGesture];
    
//    // 修改密码
//    UIView *AreaView = [[UIView alloc] initWithFrame:CGRectMake(0, 129*YZAdapter, Screen_W, 47*YZAdapter)];
//    AreaView.backgroundColor = WhiteColor;
//    
//    UILabel *AreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*YZAdapter, 0, 100*YZAdapter, 47*YZAdapter)];
//    AreaLabel.text = @"修改密码";
//    AreaLabel.textColor = MainFont_Color;
//    AreaLabel.font = FONT(15);
//    [AreaView addSubview:AreaLabel];
//    
//    UIImageView *AreaImage = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_W - 30*YZAdapter, 17*YZAdapter, 6*YZAdapter, 12*YZAdapter)];
//    AreaImage.image = [UIImage imageNamed:@"fh"];
//    [AreaView addSubview:AreaImage];
//    [self.view addSubview:AreaView];
//    
//    // UITapGestureRecognizer
//    UITapGestureRecognizer *AreaViewtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAreaView:)];
//    // 设置轻拍触发方法时需要的点击次数
//    AreaViewtapGesture.numberOfTapsRequired = 1;
//    // 设置轻拍需要的手指个数
//    AreaViewtapGesture.numberOfTouchesRequired = 1;
//    // 向视图对象上添加手势
//    [AreaView addGestureRecognizer:AreaViewtapGesture];
}


// 点击听单设置
- (void)handleCategoryView:(UIButton *)sender {
    
    self.CategoryView.backgroundColor = BackGround_Color;
    
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    if (![YZUtil isBlankString:model.realname] && ![YZUtil isBlankString:model.cardno]){
    YZListenSetViewController * YZListenController = [[YZListenSetViewController alloc]init];
        YZListenController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:YZListenController animated:YES];
    }else
    {
        YZRealNameViewController * YZRealNameController = [[YZRealNameViewController alloc]init];
        YZRealNameController.BankID = @"Order";
        YZRealNameController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:YZRealNameController animated:YES];
    }
}

// 点击给我们好评
- (void)handleInstitutionsView:(UIButton *)sender {
    
    self.InstitutionsView.backgroundColor = BackGround_Color;
    
    AboutOurViewController * aboutOurController = [[AboutOurViewController alloc]init];
    aboutOurController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutOurController animated:YES];
    
}

// 点击修改密码
- (void)handleAreaView:(UIButton *)sender {
    
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
