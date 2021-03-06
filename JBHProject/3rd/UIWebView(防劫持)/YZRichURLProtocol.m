//
//  YZRichURLProtocol.m
//  JBHProject
//
//  Created by zyz on 2017/6/13.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZRichURLProtocol.h"

#import <objc/runtime.h>
#import <Aspects.h>

static NSString * const RichURLProtocolHandledKey = @"RichURLProtocolHandledKey";

@interface YZRichURLProtocol()<NSURLSessionDelegate, NSURLConnectionDelegate>

@property (atomic,strong,readwrite) NSURLSessionDataTask *task;
@property (nonatomic,strong) NSURLSession *session;

@end



@implementation YZRichURLProtocol


+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        //        NSLog(@"====>%@",request.URL);
        
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:RichURLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        
        return YES;
    }
    return NO;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    /** 可以在此处添加头等信息  */
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    return mutableReqeust;
}
- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    
    // request截取重定向
//    if (![[self getIPAddress:mutableReqeust.URL.host] isEqualToString:[self getIPAddress:@"api-nat.juins.com"]])
//    {
//        NSString *urlStr = [mutableReqeust.URL.absoluteString stringByReplacingOccurrencesOfString:mutableReqeust.URL.host withString:[self getIPAddress:@"api-nat.juins.com"]];
//        mutableReqeust.URL = [NSURL URLWithString:urlStr];
//        NSMutableDictionary *dic = (NSMutableDictionary *)mutableReqeust.allHTTPHeaderFields;
//        [dic setObject:@"api-nat.juins.com" forKey:@"host"];
//        mutableReqeust.allHTTPHeaderFields = dic;
//        [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
//        
//    }
    
    NSLog(@"*--------------------%@", mutableReqeust);
    
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:RichURLProtocolHandledKey inRequest:mutableReqeust];
    
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    self.session  = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:queue];
    self.task = [self.session dataTaskWithRequest:mutableReqeust];
    [self.task resume];
}

- (NSString *)getIPAddress:(NSString *) url{
    
    // iOS之NDS解析
    Boolean result,bResolved;
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    NSString *ipAddress = @"";
    CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, [url UTF8String], kCFStringEncodingASCII);
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
        char *ip_address = NULL;
        for(int i = 0; i < CFArrayGetCount(addresses); i++) {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            if(remoteAddr != NULL)
            {
                //获取IP地址
                char ip[16];
//                DLog(@"ip address is : %s",strcpy(ip, inet_ntoa(remoteAddr->sin_addr)));
                strcpy(ip, inet_ntoa(remoteAddr->sin_addr));
                ip_address = inet_ntoa(remoteAddr->sin_addr);
            }
            ipAddress = [NSString stringWithCString:ip_address encoding:NSUTF8StringEncoding];
        }
    }
    CFRelease(hostNameRef);
    CFRelease(hostRef);
    return ipAddress;
}



- (void)stopLoading
{
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != nil) {
        [self.client URLProtocol:self didFailWithError:error];
    }else
    {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    completionHandler(proposedResponse);
}

//TODO: 重定向
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSMutableURLRequest* redirectRequest;
    redirectRequest = [newRequest mutableCopy];
    
//    NSMutableDictionary *dic = (NSMutableDictionary *)redirectRequest.allHTTPHeaderFields;
//    [dic setObject:@"api-nat.juins.com" forKey:@"host"];
//    redirectRequest.allHTTPHeaderFields = dic;
//    [NSURLConnection connectionWithRequest:redirectRequest delegate:self];
    
    [[self class] removePropertyForKey:RichURLProtocolHandledKey inRequest:redirectRequest];
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    
    [self.task cancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

#pragma mark - NSURLConnectionDataDelegate 代理方法
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    /* 使用AOP方式,指定可信任的域名, 以支持:直接使用ip访问特定https服务器.*/
    [AFURLSessionManager aspect_hookSelector:@selector(trustHostnames) withOptions:AspectPositionInstead usingBlock: ^(id<AspectInfo> info){
        __autoreleasing NSArray * trustHostnames = @[YZIP];
        
        NSInvocation *invocation = info.originalInvocation;
        [invocation setReturnValue:&trustHostnames];
    }error:NULL];
    
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    
    /* 添加可信任的域名,以支持:直接使用ip访问特定https服务器.
     Add trusted domain name to support: direct use of IP access specific HTTPS server.*/
    for (NSString * trustHostname  in [self trustHostnames]) {
        serverTrust = AFChangeHostForTrust(serverTrust, trustHostname);
    }
    
    // 判断是否是信任服务器证书
    if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        // 告诉服务器，客户端信任证书
        // 创建凭据对象
        NSURLCredential *credntial = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 告诉服务器信任证书
        [challenge.sender useCredential:credntial forAuthenticationChallenge:challenge];
    }
    
}

#pragma mark============= 自定义
static inline SecTrustRef AFChangeHostForTrust(SecTrustRef trust, NSString * trustHostname)
{
    if ( ! trustHostname || [trustHostname isEqualToString:@""]) {
        return trust;
    }
    
    CFMutableArrayRef newTrustPolicies = CFArrayCreateMutable(
                                                              kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
    
    SecPolicyRef sslPolicy = SecPolicyCreateSSL(true, (CFStringRef)trustHostname);
    
    CFArrayAppendValue(newTrustPolicies, sslPolicy);
    
    
#ifdef MAC_BACKWARDS_COMPATIBILITY
    /* This technique works in OS X (v10.5 and later) */
    
    SecTrustSetPolicies(trust, newTrustPolicies);
    CFRelease(oldTrustPolicies);
    
    return trust;
#else
    /* This technique works in iOS 2 and later, or
     OS X v10.7 and later */
    
    CFMutableArrayRef certificates = CFArrayCreateMutable(
                                                          kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
    
    /* Copy the certificates from the original trust object */
    CFIndex count = SecTrustGetCertificateCount(trust);
    CFIndex i=0;
    for (i = 0; i < count; i++) {
        SecCertificateRef item = SecTrustGetCertificateAtIndex(trust, i);
        CFArrayAppendValue(certificates, item);
    }
    
    /* Create a new trust object */
    SecTrustRef newtrust = NULL;
    if (SecTrustCreateWithCertificates(certificates, newTrustPolicies, &newtrust) != errSecSuccess) {
        /* Probably a good spot to log something. */
        
        return NULL;
    }
    
    return newtrust;
#endif
}


//- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client
//{
//    
//    NSMutableURLRequest* redirectRequest;
//    redirectRequest = [request mutableCopy];
//    
//    //添加认证信息
//    NSString *authString = [[[NSString stringWithFormat:@"%@:%@", kGlobal.userInfo.sAccount, kGlobal.userInfo.sPassword] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
//    authString = [NSString stringWithFormat: @"Basic %@", authString];
//    [redirectRequest setValue:authString forHTTPHeaderField:@"Authorization"];
//    NSLog(@"拦截的请求:%@",request.URL.absoluteString);
//    
//    self = [super initWithRequest:redirectRequest cachedResponse:cachedResponse client:client];
//    if (self) {
//        
//        // Some stuff
//    }
//    return self;
//}
//
//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
//    
//    NSLog(@"自定义Protocol开始认证...");
//    NSString *authMethod = [[challenge protectionSpace] authenticationMethod];
//    NSLog(@"%@认证...",authMethod);
//    
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
//        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
//    }
//    
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodNTLM]) {
//        if ([challenge previousFailureCount] == 0) {
//            NSURLCredential *credential = [NSURLCredential credentialWithUser:kGlobal.userInfo.sAccount password:kGlobal.userInfo.sPassword persistence:NSURLCredentialPersistenceForSession];
//            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
//        }else{
//            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
//        }
//    }
//    
//    NSLog(@"自定义Protocol认证结束");
//}



@end
