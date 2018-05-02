//
//  AppDelegate.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <Bugtags/Bugtags.h>
#import "ListeningList.h"
#import "YZLoginViewController.h"
#import "RootViewController.h"

#import <resolv.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <net/if.h>
#define TOKEN [[YZUserInfoManager sharedManager] currentUserInfo].token
#define UID [[YZUserInfoManager sharedManager] currentUserInfo].uid
// 正式版推送
//static NSString *const JPushAppKey = @"bfec8a8acb7777715dc60870";
//static NSString *const JPushAppSecret = @"745df32f2fec4ad7e1527a72";

// 测试版推送
//static NSString *const JPushAppKey = @"57541cf4e927fb0fc4ac86f2";
//static NSString *const JPushAppSecret = @"a7d9cc9b2bebedc0c04fc615";

// 迅赔推送
static NSString *const JPushAppKey = @"02743e92cde4673ef68eae3d";
static NSString *const JPushAppSecret = @"792f95c835b0c0787c5c6070";


// *************极光推送**********************
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// 引入 JSHARE 功能所需头文件
#import "JSHAREService.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import "LeaderViewController.h"

@interface AppDelegate () <JPUSHRegisterDelegate,YZLoginViewControllerDelegate,AMapLocationManagerDelegate>

@end

@implementation AppDelegate
{
    // iOS 10通知中心
    UNUserNotificationCenter *_notificationCenter;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"VersionUpData"];
    
    NSError *setCategoryErr =nil;
    NSError*activationErr  =nil;
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    
    [[AVAudioSession sharedInstance] setActive: YES error:&activationErr];
    
//    _timer =  [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(function) userInfo:nil repeats:YES];
    
#pragma mark - iOS之NDS解析
    Boolean result,bResolved;
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, "api.xunpei.net", kCFStringEncodingASCII);
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
    if (hostRef) {
        result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
        if (result == TRUE) {
            addresses = CFHostGetAddressing(hostRef, &result);
        }
    }
    bResolved = result == TRUE ? true : false;
    if(bResolved) {
        struct sockaddr_in* remoteAddr;
        for(int i = 0; i < CFArrayGetCount(addresses); i++) {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            if(remoteAddr != NULL)
            {
                //获取IP地址
                char ip[16];
                DLog(@"ip address is : %s",strcpy(ip, inet_ntoa(remoteAddr->sin_addr)));
                strcpy(ip, inet_ntoa(remoteAddr->sin_addr));
            }
        }
    }
//    CFRelease(hostNameRef);
//    CFRelease(hostRef);
    [AMapServices sharedServices].apiKey = MAPKEY;

#pragma mark - 开机启动图展示时间
    [NSThread sleepForTimeInterval:1.0];
#pragma mark - 更换跟控制器的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutSuccess:)  name:@"isRegisterSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutSuccess:)  name:@"isLogOutSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutSuccess:)  name:@"isForGetPassWordsSuccess" object:nil];
#pragma mark - 设置根视图控制器
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"Cell"];
    if (!isFirst) {
        LeaderViewController * vc = [[LeaderViewController alloc]init];
//        vc.delegate = self;
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
        [self.window makeKeyAndVisible];
    }else {
        YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
        
        if (model.token) {
            [self creatDrowLefViewController];
        }else {
            YZLoginViewController * vc = [[YZLoginViewController alloc]init];
            vc.delegate = self;
            self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
            [self.window makeKeyAndVisible];
        }
    }
    
//#pragma mark - 阿里云推送
//    // APNs注册，获取deviceToken并上报
//    [self registerAPNS:application];
//    // 初始化SDK
//    [self initCloudPush];
//    // 监听推送通道打开动作
//    [self listenerOnChannelOpened];
//    // 监听推送消息到达
//    [self registerMessageReceive];
//    // 点击通知将App从关闭状态启动时，将通知打开回执上报
//    // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
//    [CloudPushSDK sendNotificationAck:launchOptions];
    
#pragma mark - 极光推送
    // apn 内容获取：
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
//    if (remoteNotification) {
        //创建通知
        NSNotification *UserInfoNotification =[NSNotification notificationWithName:@"UserInfoNotification" object:nil userInfo:remoteNotification];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:UserInfoNotification];
//    }
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ((([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) ? YES : NO)) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            DLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            DLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    [JPUSHService crashLogON];
    
    // 点击进入APP角标设置为0
//    application.applicationIconBadgeNumber = 0;
//    [JPUSHService setBadge:0];    
    
#pragma mark - 极光统计
    JANALYTICSLaunchConfig * Jconfig = [[JANALYTICSLaunchConfig alloc] init];
    Jconfig.appKey = JPushAppKey;
    Jconfig.channel = @"App Store";
    [JANALYTICSService setupWithConfig:Jconfig];
    // 崩溃日志统计
    [JANALYTICSService crashLogON];
    // 设置是否打印sdk产生的Debug级log信息
//    [JANALYTICSService setDebug:YES];
    
#pragma mark - 友盟分享
//    /* 打开调试日志 */
//    [[UMSocialManager defaultManager] openLog:YES];
//    /* 设置友盟appkey */
//    [[UMSocialManager defaultManager] setUmSocialAppkey:UM_APPKEY];
//    [self configUSharePlatforms];
//    [self confitUShareSettings];
    
#pragma mark - bugtags
#ifdef DEBUG
    //do sth.
    [Bugtags startWithAppKey:@"eb75b4f3d2889f5ed76b5faa418f0878" invocationEvent:BTGInvocationEventNone];
#else
    //do sth.
#endif
    
#pragma mark - 极光分享
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = JPushAppKey;
    config.SinaWeiboAppKey = @"1557547009";
    config.SinaWeiboAppSecret = @"fdbdc3b62fc9a3d951b264201a4ccc5c";
    config.SinaRedirectUri = @"https://www.juins.com";
    config.QQAppId = @"1106101369";
    config.QQAppKey = @"ZAEQSjZJH6Ow2oR4";
    config.WeChatAppId = @"wx553f3916934c3442";
    config.WeChatAppSecret = @"89e9fa7f332f1cc9902a29d334ea68a3";
    //    config.isSupportWebSina = NO;
    // isProduction 是否生产环境. 如果为开发状态,设置为NO; 如果为生产状态,应改为 YES.默认为NO。
    config.isProduction = YES;
    [JSHAREService setupWithConfig:config];
//    [JSHAREService setDebug:YES];
    
#pragma mark =========== 存储30s上传位置的时间秒数
    [[NSUserDefaults standardUserDefaults]setObject:@"HomeCurrent" forKey:@"homeUpLoadUserLocationTime"];
#pragma mark ----------- 10s上传位置信息时间
    [[NSUserDefaults standardUserDefaults]setObject:@"MapViewCurrent" forKey:@"MyMapViewUpLoadLocation"];
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"isBackGround"];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    return YES;
}




//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
//    LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"发送失败" BubbleImage:@"YZPromptSubmit"], 2);
//    DLog(@"iOS10 前台收到本地通知:{\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",customizeField1,extras,content,userInfo);
//    
//}


- (void)creatDrowLefViewController
{
    self.window.rootViewController = [[RootViewController alloc]init];;
    [self.window makeKeyAndVisible];

}
#pragma mark - 极光推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"deviceToken%@", deviceToken);
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// NS_DEPRECATED_IOS(3_0, 10_0, "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    DLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
    
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    
    //创建通知
    NSNotification *UserInfoNotification =[NSNotification notificationWithName:@"UserInfoNotification" object:nil userInfo:userInfo];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:UserInfoNotification];
}

//iOS 7 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
//    application.applicationIconBadgeNumber = 0;
    
    DLog(@"this is iOS7 Remote Notification");
    
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    //创建通知
    NSNotification *UserInfoNotification =[NSNotification notificationWithName:@"UserInfoNotification" object:nil userInfo:userInfo];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:UserInfoNotification];
}


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    //创建通知
    NSNotification *UserInfoNotification =[NSNotification notificationWithName:@"UserInfoNotification" object:nil userInfo:userInfo];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:UserInfoNotification];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);  // 系统要求执行这个方法
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionSound|UIBackgroundFetchResultNewData); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    DLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    
    if ([userInfo[@"MSGTYPE"] isEqualToString:@"NEWTASK"]) {
        YZPromptViewController *YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
            [self.window.rootViewController.navigationController popViewControllerAnimated:YES];
        }];

        YZPromptController.IDStr = @"NEWTASK";
        [self.window.rootViewController presentViewController:YZPromptController animated:YES completion:nil];
    }else if ([userInfo[@"MSGTYPE"] isEqualToString:@"NEWMSG"]) {
        YZPromptViewController *YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
            [self.window.rootViewController.navigationController popViewControllerAnimated:YES];
        }];

        YZPromptController.IDStr = @"MSGTYPE";
        [self.window.rootViewController presentViewController:YZPromptController animated:YES completion:nil];
    }

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];
    
    // 前台收到通知的推送
    //创建通知
    NSNotification *UserInfoNotification =[NSNotification notificationWithName:@"UserInfoNotification" object:nil userInfo:userInfo];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:UserInfoNotification];
    
}
//#pragma mark - 阿里云推送
///**
// *    注册苹果推送，获取deviceToken用于推送
// *
// *    @param     application
// */
//- (void)registerAPNS:(UIApplication *)application {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        // iOS 8 Notifications
//        [application registerUserNotificationSettings:
//         [UIUserNotificationSettings settingsForTypes:
//          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
//                                           categories:nil]];
//        [application registerForRemoteNotifications];
//    }
//    else {
//        // iOS < 8 Notifications
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
//    }
//}
//
//- (void)initCloudPush {
//    // SDK初始化
//    [CloudPushSDK asyncInit:testAppKey appSecret:testAppSecret callback:^(CloudPushCallbackResult *res) {
//        if (res.success) {
//            DLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
//        } else {
//            DLog(@"Push SDK init failed, error: %@", res.error);
//        }
//    }];
//}
//
///*
// *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
// */
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
//        
////        DLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
////                          stringByReplacingOccurrencesOfString: @">" withString: @""]
////                         stringByReplacingOccurrencesOfString: @" " withString: @""]);
//        
//        if (res.success) {
//            DLog(@"Register deviceToken success.");
//        } else {
//            DLog(@"Register deviceToken failed, error: %@", res.error);
//        }
//    }];
//}
///*
// *  苹果推送注册失败回调
// */
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    DLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
//}
//
///**
// *    注册推送消息到来监听
// */
//- (void)registerMessageReceive {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onMessageReceived:)
//                                                 name:@"CCPDidReceiveMessageNotification"
//                                               object:nil];
//}
///**
// *    处理到来推送消息
// *
// *    @param     notification
// */
//- (void)onMessageReceived:(NSNotification *)notification {
//    CCPSysMessage *message = [notification object];
//    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
//    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
//    DLog(@"Receive message title: %@, content: %@.", title, body);
//}
//
//#pragma mark Channel Opened
///**
// *	注册推送通道打开监听
// */
//- (void)listenerOnChannelOpened {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onChannelOpened:)
//                                                 name:@"CCPDidChannelConnectedSuccess"
//                                               object:nil];
//}
//
///**
// *	推送通道打开回调
// *
// *	@param 	notification
// */
//- (void)onChannelOpened:(NSNotification *)notification {
//    DLog(@"打开推送通道");
//}
//
//
///*
// *  App处于启动状态时，通知打开回调
// */
//- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
//    DLog(@"Receive one notification.");
//    // 取得APNS通知内容
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    // 内容
//    NSString *content = [aps valueForKey:@"alert"];
//    // badge数量
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
//    // 播放声音
//    NSString *sound = [aps valueForKey:@"sound"];
//    // 取得Extras字段内容
//    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
//    DLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
//    // iOS badge 清0
//    application.applicationIconBadgeNumber = 0;
//    // 通知打开回执上报
//    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
//    [CloudPushSDK sendNotificationAck:userInfo];
//}

#pragma mark - 友盟分享
//- (void)confitUShareSettings
//{
//    /*
//     * 打开图片水印
//     */
//    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
//    
//    /*
//     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
//     <key>NSAppTransportSecurity</key>
//     <dict>
//     <key>NSAllowsArbitraryLoads</key>
//     <true/>
//     </dict>
//     */
//    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
//    
//}
//
//- (void)configUSharePlatforms
//{
//    /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
//    /*
//     * 移除相应平台的分享，如微信收藏
//     */
//    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
//    
//    /* 设置分享到QQ互联的appID
//     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//    
//    /* 设置新浪的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3330578906"  appSecret:@"c0cfb68ddf3ff20ebc4a3f7a4bfe086c" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
//    
//    /* 钉钉的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoamrmqlarxxqt9b1bh" appSecret:nil redirectURL:nil];
//    
//}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // 从前台进入后台
    
#pragma mark============== 进入后台发送通知前台清除定时器
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isBackGround"];
    // 在需要发送数据的.m文件中写入
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isenterBackGroundType" object:@"进入后台了"];
#pragma mark------------------
    
    UIApplication*  app =[UIApplication sharedApplication];
    
    __block    UIBackgroundTaskIdentifier bgTask;
    
    bgTask= [app beginBackgroundTaskWithExpirationHandler:^{
        
        dispatch_async(dispatch_get_main_queue(),^{if(bgTask !=UIBackgroundTaskInvalid)
            
        {
            
            bgTask=UIBackgroundTaskInvalid;
            
        }
            
        });
        
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        dispatch_async(dispatch_get_main_queue(),^{if(bgTask !=UIBackgroundTaskInvalid)
            
        {
            
            bgTask=UIBackgroundTaskInvalid;
            
        }
            
        });
     });
    NSString  * isBackGround = [[NSUserDefaults standardUserDefaults]objectForKey:@"isBackGround"];
    if ([isBackGround isEqualToString:@"YES"]) {
        [self BackGroundNetRequestUserInfo];
    }
   }

#pragma mark --------- 后台定位上传
#pragma mark --------- AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    DLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.locationStr  = [NSString stringWithFormat:@"%f %f",location.coordinate.longitude,location.coordinate.latitude];
    [self netRequestUploadBckGroundType];
}
- (void)netRequestUploadBckGroundType
{
    HomeNetWorking * manager = [HomeNetWorking sharedInstance];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"point"] = self.locationStr;
    NSString * url = @"location/renew";
    [manager uploadUserLocationPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {

        NSString * time = [JHTools getSystemTime];

        NSString * code = responsData[@"code"];
        if ([code integerValue] == 0) {
            DLog(@"上传用户地理位置信息%@",responsData);
            [[NSUserDefaults standardUserDefaults]setObject:[JHTools getSystemTime] forKey:@"homeUpLoadUserLocationTime"];
            NSString * time = [JHTools getSystemTime];
            DLog(@"位于前台的上传位置信息%@",time);
            DLog(@"成功了");
        }else if ([code integerValue] == 900102) {
            [self.locationManager stopUpdatingLocation];
        }

        
    } failed:^(NSError *error) {
        DLog(@"失败%@",error);
//        Log(@"失败了");
    }];
}

- (AMapLocationManager *)locationManager
{
    if (_locationManager == nil) {
        [AMapServices sharedServices].apiKey = MAPKEY;
        _locationManager = [[AMapLocationManager alloc] init];
        //设置期望定位精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        
        //设置不允许系统暂停定位
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        
        //设置允许在后台定位
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
        
        //设置定位超时时间
        [_locationManager setLocationTimeout:DefaultLocationTimeout];
        //设置逆地理超时时间
        [_locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
        [_locationManager setDelegate:self];
        _locationManager.distanceFilter = 200;
        
    }
    return _locationManager;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
//    [application cancelAllLocalNotifications];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 从后台进入前台
    //创建通知
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"isBackGround"];
    NSNotification *UserInfoNotification =[NSNotification notificationWithName:@"Notification" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:UserInfoNotification];
    
    // 点击进入APP角标设置为0
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];
    [self.locationManager stopUpdatingLocation];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"isenterBeforeType" object:@"进入前台了"];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"VersionUpData"];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str = nil;
    if ([NSPropertyListSerialization respondsToSelector:@selector(propertyListWithData:options:format:error:)]) {
        str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    } else{
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED <= 70000)
        str = [NSPropertyListSerialization propertyListFromData:tempData
                                               mutabilityOption:NSPropertyListImmutable
                                                         format:NULL
                                               errorDescription:NULL];
#endif
        
    }
    return str;
}
#pragma mark ------------ 更换跟控制器的代理
- (void)changeViewRootController:(UIViewController *)vc
{
    [self creatDrowLefViewController];
}
-(void) logOutSuccess:(NSNotification*)notification
{
    [self creatDrowLefViewController];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




//此方法会在设备横竖屏变化的时候调用
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    //   DLog(@"方向  =============   %ld", _allowRotate);
    if (_allowRotate == 1) {
        return UIInterfaceOrientationMaskAll;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}


// 返回是否支持设备自动旋转
- (BOOL)shouldAutorotate
{
    if (_allowRotate == 1) {
        return YES;
    }
    return NO;
}

#pragma mark ===========
// 获取初始信息
- (void)BackGroundNetRequestUserInfo
{
    
    HomeNetWorking * manager = [HomeNetWorking sharedInstance];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSString * url = @"user/start";
    [manager requestUserInfoPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
        NSString * code = responsData[@"code"];
        if ([code integerValue] == 0) {
            NSDictionary * dic = responsData[@"data"];
            NSDictionary * setting = dic[@"setting"];
            NSString * power = setting[@"acc_power"];
            if ([power integerValue]==1) {
                [self.locationManager startUpdatingLocation];
            }else
            {
                [self.locationManager stopUpdatingLocation];
            }
        }else if ([code integerValue] == 900102) {
            [MBProgressHUD showAutoMessage:@"登录信息失效"];
        }
    } failed:^(NSError *error) {

    }];
}


//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [JSHAREService handleOpenUrl:url];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    //    [JSHAREService handleOpenUrl:url];
//    return [JSHAREService handleOpenUrl:url];
//}


@end
