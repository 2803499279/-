//
//  NeiHanHelper.m
//  NeiHanDuanZiDemo1
//
//  Created by LJH on 15/11/13.
//  Copyright © 2015年 李俊恒. All rights reserved.
//

#import "JHTools.h"
#import "AppDelegate.h"
@implementation JHTools

+ (BOOL)isEqualeSystemDate:(NSString *)projectDate
{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *currentStr = [formatter stringFromDate:[NSDate date]];
    
    NSArray * currArray = [currentStr componentsSeparatedByString:@"-"];
    NSArray * projectArray = [projectDate componentsSeparatedByString:@"-"];
    
    NSInteger currentTime = [[currArray componentsJoinedByString:@""] integerValue];
    NSInteger projectTime = [[projectArray componentsJoinedByString:@""] integerValue];
    if (currentTime >= projectTime) {
        return YES;
    }
    else if (currentTime < projectTime)
    {
        return NO;
    }
    return nil;
}
+ (NSString *)converToFormatDate:(NSString *)data{
//    NSString * dataTime = [NSString stringWithFormat:@"%ld",[data integerValue]/1000];
    NSString * dataTime = [NSString stringWithFormat:@"%ld",[data integerValue]];
    //NSDate 代表时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dataTime doubleValue]];
    //NSDateFormatter 对时间进行格式化输出
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    //yyyy-MM-dd HH:mm:ss 年月日，时分秒
        format.dateFormat = @"MM-dd HH:mm";
//    format.dateFormat = @"HH:mm:ss";
    // 获取日期
    NSDateFormatter * senderFormat = [[NSDateFormatter alloc]init];
    senderFormat.dateFormat = @"MM-dd";
    NSString * senderStr = [senderFormat stringFromDate:date];
    
    // 当前时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd"];
    NSString *  currentTime =[dateformatter stringFromDate:senddate];
    
    if ([senderStr isEqualToString:currentTime]) {
         NSDateFormatter * fuckFormat = [[NSDateFormatter alloc]init];
        fuckFormat.dateFormat = @"HH:mm";
        return [fuckFormat stringFromDate:date];
    }
    else{
    return [format stringFromDate:date];
    }
    return @"00:00";
}

+ (NSString *)WYconverToFormatDate:(NSString *)data{
    NSString * dataTime = [NSString stringWithFormat:@"%ld",[data integerValue]/1000];
    //NSDate 代表时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dataTime doubleValue]];
    //NSDateFormatter 对时间进行格式化输出
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    //yyyy-MM-dd HH:mm:ss 年月日，时分秒
    //    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    format.dateFormat = @"yyyy.MM.dd";
    return [format stringFromDate:date];
}
// 时间转换
+ (NSString *)convertToFormatDateTime:(NSString *)dataFrom1970
{
    NSString * dataTime = [NSString stringWithFormat:@"%ld",[dataFrom1970 integerValue]/1000];
    //NSDate 代表时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dataTime doubleValue]];
    //NSDateFormatter 对时间进行格式化输出
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    //yyyy-MM-dd HH:mm:ss 年月日，时分秒
//    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    return [format stringFromDate:date];
}

+ (NSString *)getSystemTime{

    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
    //[dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    //NSString *  morelocationString=[dateformatter stringFromDate:senddate];
}
// 可变字符串
+ (NSAttributedString *)AttribytedStringWithstr:(NSString *)str changeStr:(NSString *)changeStr
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = [str rangeOfString:changeStr];
    
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor grayColor]
                   range:range];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Arial" size:13*YZAdapter]
                   range:range];
    
    return string;
}


+ (CGFloat)heightOfConttent:(NSString*)content fontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth
{
    // 计算包含文本的最小边框的大小
    //1、指定最大的大小，主要指定最大宽度2、如何计算NSStringDrawingUsesLineFragmentOrigin从左上角开始计算NSStringDrawingUsesFontLeading是包含行间距
    if (content.length==0) {
        return 0.0;
    }
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
  return [content boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
    
}

// 第一个参数是图片的宽度（是字符串类型哦）
// 第二个参数是图片的高度（也是字符串类型）
// 第三个参数是你自己定义的宽度哦
+ (CGSize) calculteImageSizeWidyh:(NSString *)orignilWidth height:(NSString *)orignilHeight width:(CGFloat)width;
{

    // 这里由于是图片真实的宽高数据是字符串类型，首先判断宽高是否为零，若果为零就返回CGSizeZero，也就是没有图片，不显示图片
    if ([orignilHeight floatValue] == 0 ||[orignilWidth floatValue] == 0) {
        
        return CGSizeZero;
    
    }
    
    // 得到在x轴上得缩放比例（width是你自己定义的控件的宽度，orignilWidth是图片真实的宽度）
    CGFloat scaleX = width/[orignilWidth floatValue];
    
    // 根据缩放比例得到图片的高度
    CGFloat imageHeight = [orignilHeight floatValue]*scaleX;
    
    // 返回的width还是参数里的width也就是你的自己定义的那个宽度，而高度是计算后得到的高度
    return CGSizeMake(width, imageHeight);
}

/**
 html字符串的标签替换
 <br>换行\n
 &nbsp空格\t
 */
+ (NSString *)htmlChangeWithNSString:(NSString *)htmlStr
{
//    NSMutableString * string = [NSMutableString stringWithFormat:@"%@",htmlStr];
    NSRange range1 = [htmlStr rangeOfString:@"<br>"];
    if (range1.location != NSNotFound) {
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    }
    return htmlStr;
}
+ (NSString *)bankNumberStrWithStr:(NSString *)str
{
    // 截取银行卡后四位
    NSString * bankNumStr = [str substringFromIndex:str.length- 4 ];
    return [NSString stringWithFormat:@"**** **** **** %@",bankNumStr];// 重新拼接返回
}

+ (UIImage *)JHdrawLineOfDashByImageView:(UIImageView *)imageView withSize:(CGSize)size withDirection:(BOOL)isV{
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {5,5};
    
    CGContextSetStrokeColorWithColor(line, [UIColor blackColor].CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    
    
    if (isV) {
        CGContextMoveToPoint(line, 0.0, 2.0);
        CGContextAddLineToPoint(line, Size_ratio*300*(size.width/320*Size_ratio), size.height);
    }else
    {
        CGContextMoveToPoint(line, 2.0, 0.0);
     CGContextAddLineToPoint(line,  size.width,Size_ratio*300*(size.height/320*Size_ratio));
    }
    
    CGContextStrokePath(line);
    
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}
// 获取秒数
+(NSString *)getNowTimeTimestamp2{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a =[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    ;
    return timeString;
}
+ (NSString *)getTaskUseTime:(NSString *)time
{
    NSString * str = [self getNowTimeTimestamp2];
    NSInteger timeValue = [str integerValue] - [time integerValue];
    
    NSString * timeStr = [self timeFormatted:timeValue];
    
    return [NSString stringWithFormat:@"已用时%@",timeStr];
}
// 秒数转换为时分秒
+ (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
//    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
//    NSInteger hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02ld分",minutes];
}
+ (NSMutableArray *)homeListOrderModelWithArray:(NSArray *)dataArray
{
    NSMutableArray * array = [NSMutableArray array];
    for (YZOrderModel * model in dataArray) {
        if([model.arise_datetime integerValue] >= [[self getNowTimeTimestamp2] integerValue]-3600){
            // 判断是否超时没有超时
            [array addObject:model];
        }else{
            if ([model.state isEqualToString:@"0"]) {
             [[YZDataBase shareDataBase] deleteOneMovieByOrderID:model.tid];   
            }else if([model.state isEqualToString:@"1"])
            {
                [array addObject:model];
            }
        }
    }
    return array;
}
/**
 * 将数据库的数据按时间顺序排序
 */
+ (NSMutableArray *)YZOrderModel:(NSArray *)dataArray{
   
    NSMutableArray * dictMutableArray = [NSMutableArray array];// 将时间作为key值model为value存入字典放入这个数组中
    for (YZOrderModel * model in dataArray) {
        NSDictionary * dict = @{model.arise_datetime:model};
        [dictMutableArray addObject:dict];
    }
    NSMutableArray * sortedArray = [NSMutableArray array];// 需要排序的数组按降序排列

    for (NSDictionary * dic in dictMutableArray) {
        NSArray * dicKey = [dic allKeys];
        [sortedArray addObject:[dicKey firstObject]];
    }
    //对数组进行排序
    NSArray *result = [sortedArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2]; //升序
    }];
    DLog(@"result=%@",result);
    
    NSMutableArray * myDataArray = [NSMutableArray array];
    for (NSString * key in result) {
        for (NSDictionary * dic in dictMutableArray) {
            if ([[[dic allKeys] firstObject]isEqualToString:key]) {
                NSString * value = dic[key];
                [myDataArray addObject:value];
            }
        }
    }
    
    NSMutableArray *listAry = [[NSMutableArray alloc]init];
    for (NSString *str in myDataArray) {
        if (![listAry containsObject:str]) {
            [listAry addObject:str];
        }
    }
    
    return listAry;
}

//+(NSString *)getRewardStr:(NSString *)reward
//{
//    NSRangerange = [stringrangeOfString:@"."];
//NSString * rewardStr = [reward su]
//}
#pragma mark======== 域名解析
+(NSString*)getIPWithHostName
{
//    const char *hostN= [JHHostName UTF8String];
//    struct hostent* phot;
//    
//    @try {
//        phot = gethostbyname(hostN);
//        
//    }
//    @catch (NSException *exception) {
//        return nil;
//    }
//    
//    struct in_addr ip_addr;
//    memcpy(&ip_addr, phot->h_addr_list[0], 4);
//    char ip[20] = {0};
//    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
//    
//    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
//    return strIPAddress;
    
    
    // iOS之NDS解析
    Boolean result,bResolved;
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    NSString *ipAddress = @"";
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
        char *ip_address = NULL;
        
        for(int i = 0; i < CFArrayGetCount(addresses); i++) {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            if(remoteAddr != NULL)
            {
                //获取IP地址
                char ip[16];
                DLog(@"ip address is : %s",strcpy(ip, inet_ntoa(remoteAddr->sin_addr)));
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
+ (NSString *)getCurrentSecondTime
{
    //获取当前时间
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    //    NSInteger year = [dateComponent year];
    //    NSInteger month = [dateComponent month];
    //    NSInteger day = [dateComponent day];
    //    NSInteger hour = [dateComponent hour];
    //    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    //    NSString * currentDate = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",year,month,day,hour,minute,second];
    
    return [NSString stringWithFormat:@"%ld",second];
}
@end
