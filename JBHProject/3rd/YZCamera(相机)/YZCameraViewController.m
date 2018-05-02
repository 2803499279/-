//
//  YZCameraViewController.m
//  JBHProject
//
//  Created by zyz on 2017/4/18.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YZCameraManager.h"
#import "UIButton+YZBlock.h"
#import "YZClipViewController.h"
@interface YZCameraViewController () <YZCameraManagerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, ClipViewControllerDelegate>
{
    UIImagePickerController * imagePicker;
    ClipType clipType;
}
@property (nonatomic,strong)YZCameraManager *manager;
@property (nonatomic, strong)UIView *VC;
@property (nonatomic, strong) NSData *webpData;
@property (nonatomic, strong) NSString* fullPathToFile;

@property (nonatomic, strong) UIImage *originImage;

@end

@implementation YZCameraViewController

/**
 *  在页面结束或出现记得开启／停止摄像
 *
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.manager.session isRunning]) {
        [self.manager.session startRunning];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.manager.session isRunning]) {
        [self.manager.session stopRunning];
    }
}

- (void)dealloc
{
    DLog(@"照相机释放了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
    [self initPickButton];
//    [self initFlashButton];
    [self initCameraFontOrBackButton];
    [self initDismissButton];
    [self initCameraButton];
}



- (void)initLayout
{
    self.view.backgroundColor = [UIColor blackColor];
    UIView *pickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    [self.view addSubview:pickView];
    YZCameraManager *manager = [[YZCameraManager alloc] init];
    // 传入View的frame 就是摄像的范围
    [manager configureWithParentLayer:pickView];
    manager.delegate = self;
    self.manager = manager;
}

/**
 *  拍照按钮
 */
- (void)initPickButton
{
    static CGFloat buttonW = 80;
    UIButton *button = [self buildButton:CGRectMake(Screen_W/2-buttonW/2, Screen_W+120+(Screen_H-Screen_W-100-20)/2 - buttonW/2, buttonW, buttonW)
                            normalImgStr:@"hVideo_take.png"
                         highlightImgStr:@"hVideo_take.png"
                          selectedImgStr:@""
                              parentView:self.view];
    WS(weak);
    [button  setExclusiveTouch :YES];
    __block UIButton *WButton = button;
    
    [button addActionBlock:^(id sender) {
        
       WButton.enabled = NO;
        
        [weak.manager takePhotoWithImageBlock:^(UIImage *originImage, UIImage *scaledImage, UIImage *croppedImage) {
            
            if (croppedImage) {
                weak.VC = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
                UIImageView *PhotoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
                [weak.VC addSubview:PhotoImage];
                PhotoImage.image = croppedImage;
                
                self.originImage = [self OriginImage:originImage scaleToSize:CGSizeMake(720, 1280)];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                [weak.VC addSubview:but];
                [but  setExclusiveTouch :YES];
                but.frame = CGRectMake(Screen_W/4- buttonW/2, Screen_W+120+(Screen_H-Screen_W-100-20)/2 - buttonW/2, buttonW, buttonW);
                [but setBackgroundImage:[UIImage imageNamed:@"hVideo_cancel.png"] forState:0];
                [but addTarget:self action:@selector(handleBtn) forControlEvents:UIControlEventTouchUpInside];
                
                CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"position.x"];
                
                // 添加动画
                // 从一个位置开始
                basic.fromValue = @(Screen_W/2);
                // 到一个位置
                basic.toValue = @(Screen_W/4);
                // 动画持续的时间
                basic.duration = 0.2;
                // 设置动画的重复次数
                basic.repeatCount = 1;
                [but.layer addAnimation:basic forKey:@"position.x"];
                
                
                UIButton *YESBTN = [UIButton buttonWithType:UIButtonTypeCustom];
                [weak.VC addSubview:YESBTN];
                [YESBTN  setExclusiveTouch :YES];
                YESBTN.frame = CGRectMake(Screen_W/4*3- buttonW/2, Screen_W+120+(Screen_H-Screen_W-100-20)/2 - buttonW/2, buttonW, buttonW);
                [YESBTN setBackgroundImage:[UIImage imageNamed:@"hVideo_confirm.png"] forState:0];
                [YESBTN addTarget:self action:@selector(handleYESBTN) forControlEvents:UIControlEventTouchUpInside];
                
                CABasicAnimation *basic1 = [CABasicAnimation animationWithKeyPath:@"position.x"];
                
                // 从一个位置开始
                basic1.fromValue = @(Screen_W/2);
                // 到一个位置
                basic1.toValue = @(Screen_W/4*3);
                // 动画持续的时间
                basic1.duration = 0.2;
                // 设置动画的重复次数
                basic.repeatCount = 1;
                [YESBTN.layer addAnimation:basic1 forKey:@"position.x"];
                
                [weak.view addSubview:weak.VC];
             
                WButton.enabled = YES;
            }
        }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
}


-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}



- (void)handleBtn {
    
    [self.VC removeFromSuperview];
}

- (void)handleYESBTN {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    
    
//    [self watermarkImage:self.originImage withName:nowtimeStr];
    
    if ([self.IDPhoto isEqualToString:@"SFZ"]) {
        [YZPhotoSingleton shareSingleton].SFZPhoto = [self watermarkImage:self.originImage withName:nowtimeStr];
    }else if ([self.IDPhoto isEqualToString:@"JSZ"]) {
        [YZPhotoSingleton shareSingleton].JSZPhoto = [self watermarkImage:self.originImage withName:nowtimeStr];
    }else if ([self.IDPhoto isEqualToString:@"XSZ"]) {
        [YZPhotoSingleton shareSingleton].XSZPhoto = [self watermarkImage:self.originImage withName:nowtimeStr];
    }else if ([self.IDPhoto isEqualToString:@"BXDD"]) {
        [YZPhotoSingleton shareSingleton].BXDDPhoto = [self watermarkImage:self.originImage withName:nowtimeStr];
    }else if ([self.IDPhoto isEqualToString:@"CLZQ"]) {
        [YZPhotoSingleton shareSingleton].CLZQPhoto = [self watermarkImage:self.originImage withName:nowtimeStr];
    }else if ([self.IDPhoto isEqualToString:@"CLYQ"]) {
        [YZPhotoSingleton shareSingleton].CLYQPhoto = [self watermarkImage:self.originImage withName:nowtimeStr];
    }else if ([self.IDPhoto isEqualToString:@"CLZH"]) {
        [YZPhotoSingleton shareSingleton].CLZHPhoto = [self watermarkImage:self.originImage withName:nowtimeStr];
    }else if ([self.IDPhoto isEqualToString:@"CLYH"]) {
        [YZPhotoSingleton shareSingleton].CLYHPhoto = [self watermarkImage:self.originImage withName:nowtimeStr];
    }else if ([self.IDPhoto isEqualToString:@"CLJH"]) {
        [YZPhotoSingleton shareSingleton].CLJHPhoto = [self watermarkImage:self.originImage withName:nowtimeStr];
    }else {
        [YZPhotoSingleton shareSingleton].ALLhoto = [self watermarkImage:self.originImage withName:nowtimeStr];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

/**
 *  切换闪光灯按钮
 */
//- (void)initFlashButton
//{
//    static CGFloat buttonW = 40;
//    UIButton *button = [self buildButton:CGRectMake(30, 50, buttonW, buttonW)
//                            normalImgStr:@"flashing_off.png"
//                         highlightImgStr:@""
//                          selectedImgStr:@""
//                              parentView:self.view];
//    WS(weak);
//    [button  setExclusiveTouch :YES];
//    [button addActionBlock:^(id sender) {
//        [weak.manager switchFlashMode:sender];
//    } forControlEvents:UIControlEventTouchUpInside];
//}
/**
 *  切换前后镜按钮
 */
- (void)initCameraFontOrBackButton
{
    static CGFloat buttonW = 40;
    UIButton *button = [self buildButton:CGRectMake(Screen_W-buttonW-30, 50, buttonW, buttonW)
                            normalImgStr:@"btn_video_flip_camera.png"
                         highlightImgStr:@""
                          selectedImgStr:@""
                              parentView:self.view];
    WS(weak);
    [button  setExclusiveTouch :YES];
    [button addActionBlock:^(id sender) {
        UIButton *bu = sender;
        bu.enabled = NO;
        bu.selected = !bu.selected;
        [weak.manager switchCamera:bu.selected didFinishChanceBlock:^{
            bu.enabled = YES;
        }];
    } forControlEvents:UIControlEventTouchUpInside];
}
- (void)initDismissButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button  setExclusiveTouch :YES];
    button.frame = CGRectMake(40*YZAdapter, Screen_W+120+(Screen_H-Screen_W-100-20)/2 - 11, 40*YZAdapter, 40*YZAdapter);
//    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"hVideo_back"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    WS(weak);
    [button addActionBlock:^(id sender) {
        [weak dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
/**
 *  点击进入相册
 */
- (void)initCameraButton
{
//    static CGFloat buttonW = 80;
    UIButton *button = [self buildButton:CGRectMake(Screen_W-80*YZAdapter,Screen_W+120+(Screen_H-Screen_W-100-20)/2 - 11, 40*YZAdapter, 40*YZAdapter)
                            normalImgStr:@"Browser.png"
                         highlightImgStr:@""
                          selectedImgStr:@""
                              parentView:self.view];
    [button  setExclusiveTouch :YES];
    WS(weak);
    [button addActionBlock:^(id sender) {
        // 图片选择视图控制器
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        // 图片来源
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        // 是否允许编辑
        //    picker.allowsEditing = YES;
        // 设置代理
        picker.delegate = weak;
        // 模态出视图
        [self presentViewController:picker animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - imagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    YZClipViewController * clipView = [[YZClipViewController alloc]initWithImage:info[@"UIImagePickerControllerOriginalImage"]];
    clipView.delegate = self;
    clipView.clipType = SQUARECLIP;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        //如果采自于摄像头（注意模拟器产生异常）
    }
    
//    self.webpData = UIImageJPEGRepresentation(info[@"UIImagePickerControllerOriginalImage"], 0.4);
//    
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* documentsDirectory = [paths objectAtIndex:0];
//    // Now we get the full path to the file
//    self.fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"jpgImage"];
//    [self.webpData  writeToFile:self.fullPathToFile atomically:NO];
//    
//    uint64_t fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.fullPathToFile error:nil] fileSize];
//    NSString *filesize =  [NSString stringWithFormat:@"JPG format file size: %.2f KB at %.f%% quality", (double)fileSize/1024, 100.0];
//    
//    DLog(@"-=-=-=-=============%@========", filesize);
    
    [picker pushViewController:clipView animated:YES];
    
}

#pragma mark - ClipViewControllerDelegate
-(void)ClipViewController:(YZClipViewController *)clipViewController FinishClipImage:(UIImage *)editImage
{
    [clipViewController dismissViewControllerAnimated:NO completion:^{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        //现在时间,你可以输出来看下是什么格式
        NSDate *datenow = [NSDate date];
        //----------将nsdate按formatter格式转成nsstring
        NSString *nowtimeStr = [formatter stringFromDate:datenow];
        
//        [self watermarkImage:editImage withName:nowtimeStr];
        
        if ([self.IDPhoto isEqualToString:@"SFZ"]) {
            [YZPhotoSingleton shareSingleton].SFZPhoto = [self watermarkImage:editImage withName:nowtimeStr];
        }else if ([self.IDPhoto isEqualToString:@"JSZ"]) {
            [YZPhotoSingleton shareSingleton].JSZPhoto = [self watermarkImage:editImage withName:nowtimeStr];
        }else if ([self.IDPhoto isEqualToString:@"XSZ"]) {
            [YZPhotoSingleton shareSingleton].XSZPhoto = [self watermarkImage:editImage withName:nowtimeStr];
        }else if ([self.IDPhoto isEqualToString:@"BXDD"]) {
            [YZPhotoSingleton shareSingleton].BXDDPhoto = [self watermarkImage:editImage withName:nowtimeStr];
        }else if ([self.IDPhoto isEqualToString:@"CLZQ"]) {
            [YZPhotoSingleton shareSingleton].CLZQPhoto = [self watermarkImage:editImage withName:nowtimeStr];
        }else if ([self.IDPhoto isEqualToString:@"CLYQ"]) {
            [YZPhotoSingleton shareSingleton].CLYQPhoto = [self watermarkImage:editImage withName:nowtimeStr];
        }else if ([self.IDPhoto isEqualToString:@"CLZH"]) {
            [YZPhotoSingleton shareSingleton].CLZHPhoto = [self watermarkImage:editImage withName:nowtimeStr];
        }else if ([self.IDPhoto isEqualToString:@"CLYH"]) {
            [YZPhotoSingleton shareSingleton].CLYHPhoto = [self watermarkImage:editImage withName:nowtimeStr];
        }else if ([self.IDPhoto isEqualToString:@"CLJH"]) {
            [YZPhotoSingleton shareSingleton].CLJHPhoto = [self watermarkImage:editImage withName:nowtimeStr];
        }else {
            [YZPhotoSingleton shareSingleton].ALLhoto = [self watermarkImage:editImage withName:nowtimeStr];
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

/**
 *  点击对焦
 *
 *  @param touches
 *  @param event
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self.manager focusInPoint:point];
}

- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
              parentView:(UIView*)parentView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn  setExclusiveTouch :YES];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:selectedImgStr] forState:UIControlStateSelected];
    }
    [parentView addSubview:btn];
    return btn;
}

#pragma -mark DJCameraDelegate
- (void)cameraDidFinishFocus
{
    DLog(@"对焦结束了");
}
- (void)cameraDidStareFocus
{
    DLog(@"开始对焦");
}

-(UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name {
    
    NSString* mark = name;
    
    int w = img.size.width;
    
    int h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    NSDictionary *attr = @{
                           
                           NSFontAttributeName: [UIFont boldSystemFontOfSize: 14*w/Screen_W],  //设置字体
                           
                           NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]   //设置字体颜色
                           
                           };
    
    //    [mark drawInRect:CGRectMake(, , , ) withAttributes:attr];         //左上角
    //
    //    [mark drawInRect:CGRectMake(w - , , , ) withAttributes:attr];      //右上角
    //
    //    [mark drawInRect:CGRectMake(w - , h - - , , ) withAttributes:attr];  //右下角
    
    [mark drawInRect:CGRectMake(w/5*3, h/15*14, w/5*2, h/15) withAttributes:attr];    //左下角
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return aimg;
    
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
