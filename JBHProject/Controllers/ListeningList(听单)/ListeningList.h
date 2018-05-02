//
//  HomeViewController.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//
 
#import "BaseViewController.h"
#import "HomeHeaderModel.h"
#import "RealNameTableViewCell.h"
#import "RealNameModel.h"
#import "YZWalletViewController.h"
#import "JHCompletedViewController.h"
#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3
@interface ListeningList : BaseViewController
@property(nonatomic,strong)UISwipeGestureRecognizer * recoginzerRight;// 下滑手势
@property(nonatomic,strong)UISwipeGestureRecognizer * recoginzerLeft;// 上滑手势
@property(nonatomic,strong)HomeHeaderModel * headerModel;
//@property(nonatomic,strong)NSArray * oldLocation;
//@property(nonatomic,strong)NSArray * newLocation;
@property(nonatomic,strong)UIView * infoBlackView;
@property(nonatomic,strong)UILabel * loadingLabel;
@property(nonatomic,copy)NSString * power;
@end
