//
//  YZSampleViewController.m
//  JBHProject
//
//  Created by zyz on 2017/5/15.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZSampleViewController.h"

@interface YZSampleViewController ()

@property (nonatomic, strong) UIView * operateView; //操作视图

@end

@implementation YZSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.7];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //必须在这里，否则动画无效
    [self showAlertView];
}


#pragma mark - 创建UI
- (void)showAlertView{
    /**
     *  操作区背景
     */
    _operateView = [[UIView alloc] init];
    _operateView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    _operateView.bounds = CGRectMake(0, 0, Screen_W, Screen_H);
    _operateView.backgroundColor = [UIColor clearColor];
    _operateView.layer.cornerRadius = 6;
    _operateView.clipsToBounds = YES;
    [self.view addSubview:_operateView];
}



-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:NO completion:nil];
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
