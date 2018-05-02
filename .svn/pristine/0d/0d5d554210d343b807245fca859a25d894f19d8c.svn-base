//
//  PersonalViewController.m
//  JBHProject
//
//  Created by zyz on 2017/4/27.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "PersonalViewController.h"
#import "YZLoginViewController.h"
#import "YZChangePasswordViewController.h"
#import "YZHeadViewController.h"
#import "YZRealNameViewController.h"
@interface PersonalViewController ()

@property(nonatomic, strong) UIImageView *HeaderImage;

@end

@implementation PersonalViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;

    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    if (model.face_min) {
        _HeaderImage.image = model.face_min;
    }else {
        
        if (![YZUtil isBlankString:model.face_min_url]) {
            [_HeaderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.face_min_url]] placeholderImage:nil];
            [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        }else {
            _HeaderImage.image = [UIImage imageNamed:@"userIcone"];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BackGround_Color;
    
    // 设置导航栏
    [self customPushViewControllerNavBarTitle:@"个人信息" backGroundImageName:nil];
    
    [self EditPage];
    
    [self customerGesturePop];
    // Do any additional setup after loading the view.
}
- (void)goBack
{
    [super goBack];
//    [self.view endEditing:YES];
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
    [super goBack];
//    [self.frostedViewController.view endEditing:YES];
//    // Present the view controller
//    [self.frostedViewController presentMenuViewController];
}


- (void)EditPage {
    
    // 背景视图
    UIView *BaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-64)];
    BaView.backgroundColor = BackGround_Color;
    
    // 头像
    UIButton *HeaderImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    HeaderImageView.frame = CGRectMake(0, 20*YZAdapter, Screen_W, 75*YZAdapter);
    [HeaderImageView setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
    HeaderImageView.backgroundColor = WhiteColor;
    
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 0, 70*YZAdapter, 75*YZAdapter)];
    HeaderLabel.text = @"头像";
    HeaderLabel.textColor = MainFont_Color;
    HeaderLabel.font = FONT(16);
    [HeaderImageView addSubview:HeaderLabel];
    
    // 返回按钮
    self.HeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_W - 75*YZAdapter, 12*YZAdapter, 50*YZAdapter, 50*YZAdapter)];
    
    [self.HeaderImage.layer setBorderWidth:1.0];
    self.HeaderImage.layer.borderColor=LightLine_Color.CGColor;
    
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    if (model.face_min) {
        _HeaderImage.image = model.face_min;
    }else {
        if (![YZUtil isBlankString:model.face_min_url]) {
            [_HeaderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.face_min_url]] placeholderImage:nil];
            [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        }else {
            _HeaderImage.image = [UIImage imageNamed:@"userIcone"];
        }
    }    
    
    _HeaderImage.userInteractionEnabled = YES;
    _HeaderImage.layer.cornerRadius = 25*YZAdapter;
    _HeaderImage.layer.masksToBounds = YES;
    [HeaderImageView addSubview:_HeaderImage];
    
    // 返回按钮
    UIImageView *CategoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_W - 20*YZAdapter, 30*YZAdapter, 7*YZAdapter, 16*YZAdapter)];
    CategoryImage.image = [UIImage imageNamed:@"YZFH"];
    CategoryImage.userInteractionEnabled = YES;
    [HeaderImageView addSubview:CategoryImage];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *CategoryViewtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCategoryView)];
    // 设置轻拍触发方法时需要的点击次数
    CategoryViewtapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    CategoryViewtapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [HeaderImageView addGestureRecognizer:CategoryViewtapGesture];
    
    [BaView addSubview:HeaderImageView];
    
    // 姓名
    UIView *NickNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 110*YZAdapter, Screen_W, 45*YZAdapter)];
    NickNameView.backgroundColor = WhiteColor;
    
    UILabel *NickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 0, 70*YZAdapter, 45*YZAdapter)];
    NickNameLabel.text = @"姓名";
    NickNameLabel.textColor = MainFont_Color;
    NickNameLabel.font = FONT(16);
    [NickNameView addSubview:NickNameLabel];
    
    UILabel *NickName = [[UILabel alloc] initWithFrame:CGRectMake(Screen_W - 195*YZAdapter, 0, 185*YZAdapter, 45*YZAdapter)];
//    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    NickName.text = model.realname;
    NickName.font = FONT(16);
    NickName.textAlignment = NSTextAlignmentRight;
    NickName.textColor = TimeFont_Color;
    [NickNameView addSubview:NickName];
    
    [BaView addSubview:NickNameView];
    
    
    // 身份证号
    UIView *NameView = [[UIView alloc] initWithFrame:CGRectMake(0, 156*YZAdapter, Screen_W, 45*YZAdapter)];
    NameView.backgroundColor = WhiteColor;
    
    UILabel *NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 0, 90*YZAdapter, 45*YZAdapter)];
    NameLabel.text = @"身份证号";
    NameLabel.textColor = MainFont_Color;
    NameLabel.font = FONT(16);
    [NameView addSubview:NameLabel];
    
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(Screen_W - 195*YZAdapter, 0, 185*YZAdapter, 45*YZAdapter)];
    if (model.cardno.length != 0) {
        NSRange ran = {1, 16};
        NSString *newString = [model.cardno stringByReplacingCharactersInRange:ran withString:@"****************"];
        Name.text = newString;
    }
    Name.font = FONT(16);
    Name.textAlignment = NSTextAlignmentRight;
    Name.textColor = TimeFont_Color;
    [NameView addSubview:Name];
    
    [BaView addSubview:NameView];
    
    
    // 手机号
    UIView *GenderView = [[UIView alloc] initWithFrame:CGRectMake(0, 220*YZAdapter, Screen_W, 45*YZAdapter)];
    GenderView.backgroundColor = WhiteColor;
    
    UILabel *GenderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 0, 70*YZAdapter, 45*YZAdapter)];
    GenderLabel.text = @"手机号";
    GenderLabel.textColor = MainFont_Color;
    GenderLabel.font = FONT(16);
    [GenderView addSubview:GenderLabel];
    
    UILabel *Gender = [[UILabel alloc] initWithFrame:CGRectMake(Screen_W - 195*YZAdapter, 0, 185*YZAdapter, 45*YZAdapter)];
    Gender.text = [[model.Usre_Phone substringToIndex:3] stringByAppendingFormat:@"%@%@", @"****", [model.Usre_Phone substringFromIndex:7]];
    Gender.font = FONT(16);
    Gender.textAlignment = NSTextAlignmentRight;
    Gender.textColor = TimeFont_Color;
    [GenderView addSubview:Gender];
    
    [BaView addSubview:GenderView];
    
    
    // 修改密码
    UIButton *AreaView = [UIButton buttonWithType:UIButtonTypeCustom];
    AreaView.frame = CGRectMake(0, 285*YZAdapter, Screen_W, 45*YZAdapter);
    [AreaView setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
    AreaView.backgroundColor = WhiteColor;
    
    UILabel *AreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 0, 100*YZAdapter, 45*YZAdapter)];
    AreaLabel.text = @"修改密码";
    AreaLabel.textColor = MainFont_Color;
    AreaLabel.font = FONT(16);
    [AreaView addSubview:AreaLabel];
    
    UIImageView *AreaImage = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_W - 20*YZAdapter, 15*YZAdapter, 7*YZAdapter, 16*YZAdapter)];
    AreaImage.image = [UIImage imageNamed:@"YZFH"];
    [AreaView addSubview:AreaImage];
    [BaView addSubview:AreaView];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *AreaViewtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAreaView:)];
    // 设置轻拍触发方法时需要的点击次数
    AreaViewtapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    AreaViewtapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [AreaView addGestureRecognizer:AreaViewtapGesture];

    // 退出登录
    UIView *BornDateView = [[UIView alloc] initWithFrame:CGRectMake(0, 350*YZAdapter, Screen_W, 45*YZAdapter)];
    BornDateView.backgroundColor = BackGround_Color;
    
    UIButton *ExitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ExitBtn  setExclusiveTouch :YES];
    ExitBtn.frame = CGRectMake(0, 0, Screen_W, 45*YZAdapter);
    [ExitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [ExitBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
    [ExitBtn setTitleColor:MainFont_Color forState:UIControlStateNormal];
//    ExitBtn.layer.cornerRadius = 5;
//    ExitBtn.layer.masksToBounds = YES;
    ExitBtn.backgroundColor = WhiteColor;
    [ExitBtn addTarget:self action:@selector(handdleExitBtn) forControlEvents:UIControlEventTouchUpInside];
    ExitBtn.titleLabel.font = FONT(16);

    [BornDateView addSubview:ExitBtn];
    [BaView addSubview:BornDateView];
    
    [self.view addSubview:BaView];
}

// 点击头像
- (void)handleCategoryView {
    
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    
    if (![YZUtil isBlankString:model.face_min_url]) {
        
        YZHeadViewController * YZHeadVController = [[YZHeadViewController alloc]init];
        YZHeadVController.IDStr = @"头像";
//        YZHeadVController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:YZHeadVController animated:YES];
        
    }else {
        YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
            
            YZHeadViewController * YZHeadVController = [[YZHeadViewController alloc]init];
            YZHeadVController.IDStr = @"头像";
//            YZHeadVController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:YZHeadVController animated:YES];
            
        }];
        YZPromptController.IDStr = @"头像示例";
        [self presentViewController:YZPromptController animated:YES completion:nil];
    }
}



#pragma mark - 退出登录
- (void) handdleExitBtn {
    
    YZAlertViewController * alertVC = [[YZAlertViewController alloc] initWithConfirmAction:^(NSString *inputText) {
        
        LKRightBubble(@"退出成功", 1);
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"VersionUpData"];
        
        YZLoginViewController * vc = [[YZLoginViewController alloc]init];
        
        YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
        vc.AlertPhone = model.Usre_Phone;
        
        [[YZUserInfoManager sharedManager] didLoginOut];
//        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } andCancelAction:^{
        
    }];
    alertVC.RealID = @"退出登录";
    [self presentViewController:alertVC animated:YES completion:nil];
        
}

// 点击修改密码
- (void)handleAreaView:(UIButton *)sender {
    
    YZChangePasswordViewController * YZChangePasswordController = [[YZChangePasswordViewController alloc]init];
//    YZChangePasswordController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:YZChangePasswordController animated:YES];
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
