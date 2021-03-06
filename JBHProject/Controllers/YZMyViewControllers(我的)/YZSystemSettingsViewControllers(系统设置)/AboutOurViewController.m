//
//  AboutOurViewController.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/5/15.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "AboutOurViewController.h"

@interface AboutOurViewController ()
@property(nonatomic,strong)UIImageView * iconImageView;// appIcon
@property(nonatomic,strong)UILabel * versionLabel;// 版本信息
@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic,strong)UILabel * bottomLabel;// 底部的版权信息
@end

@implementation AboutOurViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
//    self.tabBarController.tabBar.translucent = YES;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
//    self.tabBarController.tabBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customPushViewControllerNavBarTitle:@"迅赔" backGroundImageName:nil];
    self.view.backgroundColor = [UIColor jhBackGroundColor];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.bottomLabel];
    [self customerGesturePop];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)customerGesturePop {
    UISwipeGestureRecognizer *swipeGestuer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleOtherSwipeGesture)];
    swipeGestuer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestuer2];
}
- (void) handleOtherSwipeGesture {
    [super goBack];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 200*Size_ratio)];
        _iconImageView.image = [UIImage imageNamed:@"AbountMine"];
        _iconImageView.backgroundColor = [UIColor jhBackGroundColor];
//        _iconImageView.layer.cornerRadius = 10*Size_ratio;
//        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}
- (UILabel *)versionLabel
{
    if (_versionLabel == nil) {
        _versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_W*0.5-65*Size_ratio, 200*Size_ratio, 130*Size_ratio, 20*Size_ratio)];
         NSString * str = [self getAppCurVersionNum];
        _versionLabel.text = [NSString stringWithFormat:@"版本:V%@ for iOS",str];
       
        _versionLabel.textColor = [UIColor grayColor];
//        _versionLabel.backgroundColor = LJHColor(204, 204, 204);
//        _versionLabel.layer.cornerRadius = 8*Size_ratio;
//        _versionLabel.layer.masksToBounds = YES;
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = [UIFont systemFontOfSize:12*YZAdapter];
    }
    return _versionLabel;
}
- (UILabel *)contentLabel
{
    
    if (_contentLabel == nil) {
        CGFloat LabelY =  self.versionLabel.frame.origin.y+self.versionLabel.frame.size.height+40*Size_ratio;
        
        NSString * str = @"迅赔专注于打造事故勘查及理赔网络服务平台，倡导“人人都是速勘员”，快速处理事故勘查工作，迅速恢复交通，让您的出行不再为事故而阻挡，减少社会时间损失，从而为社会创造更大价值！";
        
        CGFloat LabelH = [JHTools heightOfConttent:str fontSize:12*YZAdapter maxWidth:Screen_W-50*Size_ratio];
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(25*Size_ratio,LabelY, Screen_W-50*Size_ratio, LabelH)];
        _contentLabel.numberOfLines = 0;
//        _contentLabel.text = str;
        
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = [UIFont systemFontOfSize:12*YZAdapter];
       
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:10*Size_ratio];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        _contentLabel.attributedText = attributedString;
        
        [_contentLabel sizeToFit];

    }
    
    return _contentLabel;
    
}
- (UILabel *)bottomLabel
{
    if (_bottomLabel == nil) {
        _bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Screen_H-120*Size_ratio, Screen_W, 20*Size_ratio)];
        _bottomLabel.textColor = [UIColor grayColor];
        _bottomLabel.text = @"宁波迅赔科技有限公司 ©版权所有";
        _bottomLabel.font = [UIFont systemFontOfSize:10*YZAdapter];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}
#pragma mark============ 版本号
/**
 获取当前版本号
 */
- (NSString *)getAppCurVersionNum{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：2.0.7
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    DLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    DLog(@"当前应用版本号码：%@",appCurVersionNum);
    return appCurVersion;
}

@end
