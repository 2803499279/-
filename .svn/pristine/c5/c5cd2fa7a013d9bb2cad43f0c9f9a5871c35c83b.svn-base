//
//  RideRouteViewController.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/20.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "RideRouteViewController.h"
#import "SpeechSynthesizer.h"
#import "AppDelegate.h"

@interface RideRouteViewController ()<AMapNaviRideViewDelegate,AMapNaviRideManagerDelegate>
@property(nonatomic,strong) AMapNaviRideView * rideView;
@end

@implementation RideRouteViewController
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    //1.获取 当前设备 实例
    UIDevice *device = [UIDevice currentDevice] ;
    /**
     *  2.取得当前Device的方向，Device的方向类型为Integer
     *
     *  必须调用beginGeneratingDeviceOrientationNotifications方法后，此orientation属性才有效，否则一直是0。orientation用于判断设备的朝向，与应用UI方向无关
     *
     *  @param device.orientation
     *
     */
    
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            DLog(@"屏幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            DLog(@"屏幕朝下平躺");
            break;
            
            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            DLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            DLog(@"屏幕向左横置");
            break;
            
        case UIDeviceOrientationLandscapeRight:
            DLog(@"屏幕向右橫置");
            break;
            
        case UIDeviceOrientationPortrait:
            DLog(@"屏幕直立");
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            DLog(@"屏幕直立，上下顛倒");
            break;
            
        default:
            DLog(@"无法辨识");
            break;
    }
    
}

#pragma mark --------- Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  开始生成 设备旋转 通知
     */
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    
    /**
     *  添加 设备旋转 通知
     *
     *  当监听到 UIDeviceOrientationDidChangeNotification 通知时，调用handleDeviceOrientationDidChange:方法
     *  @param handleDeviceOrientationDidChange: handleDeviceOrientationDidChange: description
     *
     *  @return return value description
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    

    [self initRideView];
    [self.view addSubview:self.rideView];
    [self.rideManager addDataRepresentative:self.rideView];
    self.rideManager.delegate = self;
//    [self initRideManager];
    //进行路径规划
}

-(void)dealloc
{
    /**
     *  结束 设备旋转通知
     *
     *  @return return value description
     */
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    
    /**
     *  销毁 设备旋转 通知
     *
     *  @return return value description
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil
     ];
    
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // do something before rotation
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        //        屏幕从竖屏变为横屏时执行
        
    }else{
        //        屏幕从横屏变为竖屏时执行
        
    }
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // do something after rotation
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //在视图出现的时候，将allowRotate改为1，
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    delegate.allowRotate = 1;
    

    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.toolbarHidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    delegate.allowRotate = 0;
//    
//    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
//    
//    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
//    
//    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    
//    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
//self.tabBarController.tabBar.hidden = NO;
    [self.rideManager stopNavi];
    [self.rideManager removeDataRepresentative:self.rideView];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    self.rideView.delegate = nil;
    self.rideManager.delegate = nil;
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.rideManager calculateRideRouteWithStartPoint:self.startPoint endPoint:self.endPoint];
}
- (void)viewWillLayoutSubviews
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        interfaceOrientation = self.interfaceOrientation;
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        [self.rideView setIsLandscape:NO];
    }
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        [self.rideView setIsLandscape:YES];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - Initalization

- (void)initRideView
{
    if (self.rideView == nil)
    {
        self.rideView = [[AMapNaviRideView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
        self.rideView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.rideView setDelegate:self];
        self.rideView.showMoreButton = NO;
        self.rideView.isLandscape = YES;

    }
}
- (AMapNaviRideManager *)rideManager
{
    if (_rideManager == nil)
    {
        _rideManager = [[AMapNaviRideManager alloc] init];
        [_rideManager setDelegate:self];
    }
    return _rideManager;
}
#pragma mark - Route Plan
#pragma mark - AMapNaviRideManagerDelegate

- (void)rideManager:(AMapNaviRideManager *)rideManager error:(NSError *)error
{
    DLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager;
{
    DLog(@"onCalculateRouteSuccess");
    //算路成功后开始GPS导航
    [self.rideManager startGPSNavi];
}

- (void)rideManager:(AMapNaviRideManager *)rideManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    DLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}
- (void)rideManagerOnArrivedDestination:(AMapNaviRideManager *)rideManager
{
    //停止导航
    [self.rideManager stopNavi];
    [self.rideManager removeDataRepresentative:self.rideView];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - AMapNaviRideViewDelegate

- (void)rideViewCloseButtonClicked:(AMapNaviRideView *)rideView
{
    //停止导航
    self.rideManager = nil;
    [self.rideManager stopNavi];
    [self.rideManager removeDataRepresentative:self.rideView];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
