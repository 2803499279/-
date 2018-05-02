//
//  YZDetailsController.m
//  JBHProject
//
//  Created by zyz on 2017/5/16.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZDetailsController.h"
#import "YZViewJavaScriptBridge.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

#import <objc/runtime.h>
#import <Aspects.h>

@interface YZDetailsController ()<UIWebViewDelegate, NSURLConnectionDelegate, ViewJavaScriptBridgeDelegate, NJKWebViewProgressDelegate>

{
    UIActivityIndicatorView *activityView;
}
@property (strong, nonatomic) YZViewJavaScriptBridge *bridge;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong)NJKWebViewProgress *progressProxy;
@property (nonatomic, strong)NJKWebViewProgressView *progressView;

@property (nonatomic, strong) UIView *BackView;
@property (nonatomic, strong) NSString *IDRequest;

@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@property (nonatomic, strong)NSMutableURLRequest *request;

@end

@implementation YZDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册网络请求拦截
    [NSURLProtocol registerClass:[YZRichURLProtocol class]];
    
    [self webviewRequest];
    // Do any additional setup after loading the view.
}

// webview页面加载
- (void) webviewRequest {
    LKWaitBubble(@"请求中...");
    
    self.view.backgroundColor = BackGround_Color;
    
    [self customPushViewControllerNavBarTitle:@"课堂" backGroundImageName:nil];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-64)];
    
    NSString *URLStr = [NSString stringWithFormat:@"%@", self.urlStr];
    
    NSURL *urlString = [NSURL URLWithString:URLStr];
    _request = [NSMutableURLRequest requestWithURL:urlString];

    [NSURLConnection connectionWithRequest:_request delegate:self];
    
    [self.webView loadRequest:_request];
    self.webView.backgroundColor = WhiteColor;
    [self.view addSubview:self.webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    if ([self.IDRequest isEqualToString:@"刷新"]) {
        CGRect barFrame = CGRectMake(0, 0, Screen_W, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    }else {
        CGRect barFrame = CGRectMake(0, 64, Screen_W, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    }
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.progressView];
    
    
    [self customerGesturePop];
    
}


#pragma mark -- WebViewJavascriptBridgeDelegate
- (void)javascriptBridge:(YZViewJavaScriptBridge *)bridge receivedMessage:(NSString *)message fromWebView:(UIWebView *)webView {
    
    DLog(@"message======%@", message);
}

#pragma mark - Private Method 右划返回上一个页面
- (void)customerGesturePop {
    UISwipeGestureRecognizer *swipeGestuer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleOtherSwipeGesture)];
    swipeGestuer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestuer2];
}
- (void) handleOtherSwipeGesture {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBack
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//加载网页动画
- (void)webViewDidStartLoad:(UIWebView *)webView{

    [self requestTaskSt];
//    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityView.backgroundColor = LightFont_Color;
//    activityView.color = MainFont_Color;
//    activityView.frame = CGRectMake((Screen_W-80*YZAdapter)/2, (Screen_H-80*YZAdapter)/2, 80*YZAdapter, 80*YZAdapter);
//    [self.view addSubview:activityView];
//    [activityView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    LKHideBubble();
    //去除长按后出现的文本选取框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //获取当前页面的title
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    //    NSLog(@"%@", title);
    
    if (![YZUtil isBlankString:title]) {
        self.naviTitle = title;
    }
    [_manager stopMonitoring];
}


-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(nonnull NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(nonnull NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
}

// 定时器中执行的方法
- (void)requestTaskSt {
    
    //1.获得网络监控的管理者
    _manager = [AFNetworkReachabilityManager sharedManager];
    //2.设置网络状态改变后的处理
    [_manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //当网络状态改变后，会调用这个方法
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                // 未知网络状态
                LKHideBubble();
                [MBProgressHUD showAutoMessage:@"网络未连接"];
                
                [self addBackView];
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                // 没有网络
                LKHideBubble();
                [MBProgressHUD showAutoMessage:@"网络未连接"];
                [self addBackView];
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //当前为3G/4G网络
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                //当前网络为WIFI环境
                
            }
                break;
            default:
                break;
        }
        
    }];
    //3 开始监测
    [_manager startMonitoring];
    
}


- (void) addBackView {
    self.BackView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.BackView.backgroundColor = YZColor(247, 247, 247);
    
    UIImageView *BackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(87*YZAdapter, 85*YZAdapter, 201*YZAdapter, 137*YZAdapter)];
    BackImageView.image = [UIImage imageNamed:@"YZRquestError"];
    [self.BackView addSubview:BackImageView];
    
    UILabel *BigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 248*YZAdapter, Screen_W, 20*YZAdapter)];
    BigLabel.text = @"网络连接异常";
    BigLabel.font = FONT(18);
    BigLabel.textColor = MainFont_Color;
    BigLabel.textAlignment = NSTextAlignmentCenter;
    [self.BackView addSubview:BigLabel];
    
    UILabel *XLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 284*YZAdapter, Screen_W, 13)];
    XLabel.font = FONT(12);
    XLabel.textAlignment = NSTextAlignmentCenter;
    XLabel.textColor = TimeFont_Color;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"请您检查网络或点击页面刷新"];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:GreenButton_Color
     
                          range:NSMakeRange(11, 2)];
    
    [AttributedStr addAttribute:NSUnderlineStyleAttributeName
     
                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
     
                          range:NSMakeRange(11, 2)];
    
    XLabel.attributedText = AttributedStr;
    
    
    [self.BackView addSubview:XLabel];
    
    UITapGestureRecognizer *BackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    BackGesture.numberOfTapsRequired = 1;
    BackGesture.numberOfTouchesRequired = 1;
    [self.BackView addGestureRecognizer:BackGesture];
    
    [self.view addSubview:self.BackView];
}




- (void)handleTapGesture:(UIButton *)sender {
    
    self.IDRequest = @"刷新";
    
    [self webviewRequest];
    
    [self.BackView removeFromSuperview];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    //取消注册网络请求拦截
    [NSURLProtocol unregisterClass:[YZRichURLProtocol class]];
    
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
    
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
