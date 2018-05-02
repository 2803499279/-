//
//  DriveViewController.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/20.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "DriveViewController.h"
#import "SpeechSynthesizer.h"
#import "AppDelegate.h"

@interface DriveViewController ()<AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>

@end

@implementation DriveViewController
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
    
    [self initDriveView];
    
    [self initDriveManager];
    
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
//    self.tabBarController.tabBar.hidden = NO;
    [self.driveManager stopNavi];
    [self.driveManager removeDataRepresentative:self.driveView];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    self.driveView.delegate = nil;
    self.driveManager.delegate = nil;
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self calculateRoute];
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
        [self.driveView setIsLandscape:NO];
    }
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        [self.driveView setIsLandscape:YES];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Initalization

- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
        
//        [self.driveManager setAllowsBackgroundLocationUpdates:YES];
//        [self.driveManager setPausesLocationUpdatesAutomatically:NO];
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [self.driveManager addDataRepresentative:self.driveView];
    }
}

- (void)initDriveView
{
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.driveView setDelegate:self];
        self.driveView.showMoreButton = NO;
        self.driveView.isLandscape = YES;
        [self.view addSubview:self.driveView];
    }  
}


#pragma mark - Route Plan

- (void)calculateRoute
{
    //进行路径规划
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]
                                                wayPoints:nil
                                          drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

#pragma mark - AMapNaviDriveManager Delegate

- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
    DLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    DLog(@"onCalculateRouteSuccess");
    
    //算路成功后开始GPS导航
    [self.driveManager startGPSNavi];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{
    DLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{
    DLog(@"didStartNavi");
}

- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager
{
    DLog(@"needRecalculateRouteForYaw");
}

- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    DLog(@"needRecalculateRouteForTrafficJam");
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    DLog(@"onArrivedWayPoint:%d", wayPointIndex);
}

- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    DLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager
{
    DLog(@"didEndEmulatorNavi");
}

- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager
{
    DLog(@"onArrivedDestination");
    [self.driveManager stopNavi];
    [self.driveManager removeDataRepresentative:self.driveView];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AMapNaviWalkViewDelegate

- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView
{
  
        //停止导航
        [self.driveManager stopNavi];
        [self.driveManager removeDataRepresentative:self.driveView];
        //停止语音
        [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
        [self.navigationController popViewControllerAnimated:YES];
}


- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView
{
    DLog(@"TrunIndicatorViewTapped");
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode
{
    DLog(@"didChangeShowMode:%ld", (long)showMode);
}

#pragma mark - MoreMenu Delegate
@end
