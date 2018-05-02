//
//  MyViewController.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/8/23.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "MyViewController.h"
#import "MycenterHeaderView.h"
#import "LeftBarModel.h"
#import "LeftBodyTableViewCell.h"
#import "JHCompletedViewController.h"
#import "UserGuideViewController.h"
#import "YZRealNameViewController.h"
#import "AboutOurViewController.h"
#import "YZListenSetViewController.h"
#import "PersonalViewController.h"
#import "YZWalletViewController.h"

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,LeftBodyTableCellDelegate,MycenterHeaderViewDelegate>
@property(nonatomic,strong)UITableView * myTableView;// 个人中心的tableView
@property(nonatomic,strong)NSMutableArray * myTabDataSources;
@property(nonatomic,strong)MycenterHeaderView * myCenterHeaderView;
@end

@implementation MyViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // 显示系统自带的导航条
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    // 取消系统自带的导航条
    self.navigationController.navigationBarHidden = YES;
    
    [super viewWillAppear:animated];

    [self hiddenBootomLineView];
    [self customNavigationBarTitle:@"个人中心" backGroundImageName:nil];
    [self.view addSubview:self.myTableView];
    [self.myTableView reloadData];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    
    if (model.face_min) {
        _myCenterHeaderView.userImage.image = model.face_min;
    }else {
        if (![YZUtil isBlankString:model.face_min_url]) {
            [_myCenterHeaderView.userImage sd_setImageWithURL:[NSURL URLWithString:model.face_min_url] placeholderImage:[UIImage imageNamed:@"userIcone"]];
        }else {
            _myCenterHeaderView.userImage.image = [UIImage imageNamed:@"userIcone"];
        }
    }
    
    [_myCenterHeaderView.userName setTitle:[[YZUserInfoManager sharedManager] currentUserInfo].realname forState:UIControlStateNormal];
    [_myCenterHeaderView.userPhoneNumber setTitle:[[[[YZUserInfoManager sharedManager] currentUserInfo].Usre_Phone substringToIndex:3] stringByAppendingFormat:@"%@%@", @"****", [model.Usre_Phone substringFromIndex:7]] forState:UIControlStateNormal];
    
    self.navBarLineView.hidden = YES;
    self.navBarLineView.frame = CGRectMake(0, 0, 0, 0);
    self.navBarLineView.backgroundColor = YZEssentialColor;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark =========== View
- (MycenterHeaderView *)myCenterHeaderView
{
    if (_myCenterHeaderView == nil) {
        _myCenterHeaderView = [[MycenterHeaderView alloc]initWithFrame:CGRectMake(0, -20, Screen_W, 64+230*YZAdapter)];
        _myCenterHeaderView.dataSoucesArray = @[@"1",@"2"];
        _myCenterHeaderView.myCenterViewDelegate = self;
        UIView * headerLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+229*YZAdapter, Screen_W, 1)];
        headerLineView.backgroundColor = [UIColor jhBackGroundColor];
        
        UILabel * LabelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 44)];
        LabelView.backgroundColor = [UIColor clearColor];
        LabelView.text = @"个人中心";
        LabelView.font = FONT(18);
        LabelView.textColor = WhiteColor;
        LabelView.textAlignment = NSTextAlignmentCenter;
        [_myCenterHeaderView addSubview:LabelView];
        [_myCenterHeaderView addSubview:headerLineView];
        _myCenterHeaderView.backgroundColor = WhiteColor;
    }
    return _myCenterHeaderView;
}
- (UITableView *)myTableView
{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-64+20)];
        _myTableView.tableHeaderView = self.myCenterHeaderView;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.scrollEnabled = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myTableView registerClass:[LeftBodyTableViewCell class] forCellReuseIdentifier:@"cellId"];
        _myTableView.backgroundColor = WhiteColor;
    }
    return _myTableView;
}
#pragma mark ========== deatsources
- (NSMutableArray *)myTabDataSources
{
    if (_myTabDataSources == nil) {
        _myTabDataSources = [NSMutableArray array];
        LeftBarModel * model1 = [LeftBarModel leftBarModelWith:@"已完成案件" myLabelTitle:@"已完成案件"];
        LeftBarModel * model2 = [LeftBarModel leftBarModelWith:@"用户指南" myLabelTitle:@"用户指南"];
        LeftBarModel * model3 = [LeftBarModel leftBarModelWith:@"听单设置" myLabelTitle:@"听单设置"];
//        LeftBarModel * model4 = [LeftBarModel leftBarModelWith:@"我的信誉值" myLabelTitle:@"我的信誉值"];
        LeftBarModel * model5 = [LeftBarModel leftBarModelWith:@"资质认证" myLabelTitle:@"资质认证"];
        LeftBarModel * model6 = [LeftBarModel leftBarModelWith:@"关于我们" myLabelTitle:@"关于我们"];

        [_myTabDataSources addObject:model1];
        [_myTabDataSources addObject:model2];
        [_myTabDataSources addObject:model3];
//        [_myTabDataSources addObject:model4];
        [_myTabDataSources addObject:model5];
        [_myTabDataSources addObject:model6];

    }
    return _myTabDataSources;
}
#pragma mark ==========UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftBodyTableViewCell * cell = [self.myTableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[LeftBodyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@"cellId"];
    }
    cell.leftDelegate = self;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LeftBarModel * model = self.myTabDataSources[indexPath.row];
   
    switch (indexPath.row) {
        
        case 2:
        {
            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            NSString *dicStartPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"startdic.txt"];
            NSDictionary *readDic = [NSDictionary dictionaryWithContentsOfFile:dicStartPath];
            if(readDic!=nil){
                if (![YZUtil isBlankString:model.realname] || ![YZUtil isBlankString:model.cardno]){
                    NSString *  Mypower = [[readDic[@"data"] objectForKey:@"setting"]objectForKey:@"power"];
                    if ([Mypower integerValue]==1) {
                        cell.desLabel.text = @"已开启";
                    }else{
                        cell.desLabel.text = @"";
                        
                    }
                }
            }
        }
            break;
        case 3:
        {
             YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            if (![YZUtil isBlankString:model.realname] && ![YZUtil isBlankString:model.cardno]){
                cell.rowImageView.hidden = YES;
                cell.desLabel.text = @"已认证";
            }
        }
            break;
        
        default:
            break;
    }
    [cell createCellWith:model];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45*YZAdapter;
}
#pragma mark -------------LeftBodyTableCellDelegate
-(void)leftBodyButtonClicked:(LeftBodyTableViewCell *)Cell
{
    NSIndexPath * indexPath = [self.myTableView indexPathForCell:Cell];
        NSInteger row = indexPath.row;
    UIViewController * vc ;
        switch (row) {
            case 0:
            {
                DLog(@"已完成案件");
                vc = [[JHCompletedViewController alloc]init];
                
            }
                break;
            case 1:
            {
                DLog(@"用户指南");
               vc = [[UserGuideViewController alloc]init];
            }
                break;
            
            case 2:
            {
                DLog(@"听单设置");
                
                // 进行实名认证
                YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
                if ([YZUtil isBlankString:model.realname] || [YZUtil isBlankString:model.cardno]) {
                    YZAlertViewController * alertVC = [[YZAlertViewController alloc] initWithConfirmAction:^(NSString *inputText) {
                        //            [self.frostedViewController hideMenuViewController];
                        YZRealNameViewController * YZRealNameController = [[YZRealNameViewController alloc]init];
                        YZRealNameController.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:YZRealNameController animated:YES];
                    } andCancelAction:^{
                        
                    }];
                    alertVC.RealID = @"实名认证";
                    [self presentViewController:alertVC animated:YES completion:nil];
                }else{
                    vc = [[YZListenSetViewController alloc]init];
                }
            }
                break;
//            case 3:
//            {
//                DLog(@"我的信誉值");
//                NSString * desString = Cell.desLabel.text;
//                if (![desString isEqualToString:@"已认证"]) {
//                    vc = [[YZRealNameViewController alloc]init];
//                }
//            }
//                break;
            case 3:
            {
                DLog(@"资质认证");
                NSString * desString = Cell.desLabel.text;
                if (![desString isEqualToString:@"已认证"]) {
                    vc = [[YZRealNameViewController alloc]init];
                }
            }
                break;
            case 4:
            {
                DLog(@"关于我们");
                vc = [[AboutOurViewController alloc]init];
            }
                break;
                       break;
            default:
                break;
                
        }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    DLog(@"改变");
}
#pragma mark ----------- MycenterHeaderViewDelegate
- (void)didSelectedpushUserCenter:(UIButton *)sender
{
    PersonalViewController * vc = [[PersonalViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)didSelectedpushMyAccount:(UIButton *)sender
{

    YZWalletViewController * vc = [[YZWalletViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}
@end
