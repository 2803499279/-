//
//  YZNewMaterialViewController.m
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZNewMaterialViewController.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "YZPictureCollectionViewCell.h"
#import "YZPictureAddCell.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>
#import "YZClipViewController.h"
#import "YZPlaceholderTextView.h"
#import "YZAlertViewController.h"
#import "YZSampleViewController.h"

@interface YZNewMaterialViewController () <UIScrollViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate,MJPhotoBrowserDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDelegateFlowLayout, UITextViewDelegate, ClipViewControllerDelegate>

{
    UIImagePickerController * imagePicker;
    ClipType clipType;

 
}

@property (nonatomic, strong) UIScrollView *MianScrollView;
@property (nonatomic, strong) YZPictureAddCell *addItemCell;
@property (nonatomic, strong) UIView *DamageView;  // 损坏视图

@property (nonatomic, strong) UIView *InstructionsView;  // 其他情况说明文字提示视图
@property (nonatomic, strong) YZPlaceholderTextView *YZPlaceholderView;  // 其他情况说明填写视图
@property (nonatomic, strong) UIButton *SubmitAuditButton;  //提交材料视图

// 证件照片点击按钮
@property (nonatomic, strong) UIImageView *IdCardImage;
@property (nonatomic, strong) UIImageView *DrivingImage;
@property (nonatomic, strong) UIImageView *RunImage;
@property (nonatomic, strong) UIImageView *BillImage;
@property (nonatomic, strong) UIImageView *beforeImage;
@property (nonatomic, strong) UIImageView *afterImage;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIImageView *rightImage;

@property (nonatomic, strong) UIImageView *ChassisImage;

@property (nonatomic, strong) NSData *webpData;
@property (nonatomic, strong) NSString* fullPathToFile;
@property (nonatomic, strong) NSString* fullPathToF;

// 存放第一组证件照照片
@property (nonatomic, strong) NSMutableArray *IDArray;
@property (nonatomic, strong) NSMutableDictionary *IDDic;

// 定时器
@property (nonatomic, strong) NSTimer *timer;
// 判断图片是否上传
@property (nonatomic, assign)NSInteger num;

// 判断图片上传错误次数
@property (nonatomic, assign)NSInteger numError;

// 分享参数
@property (nonatomic, strong) NSString *share_title;
@property (nonatomic, strong) NSString *share_content;
@property (nonatomic, strong) NSString *share_pic;
@property (nonatomic, strong) NSString *share_link;


@end

@implementation YZNewMaterialViewController

- (NSMutableArray *)IDArray {
    if (!_IDArray) {
        _IDArray = [[NSMutableArray alloc] init];
    }
    return _IDArray;
}

- (NSMutableDictionary *)IDDic {
    if (!_IDDic) {
        _IDDic = [[NSMutableDictionary alloc] init];
    }
    return _IDDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _num = 0;
    _numError = 0;
    self.itemsSectionPictureArray = [[NSMutableArray alloc] init];
    self.IDDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 设置导航栏
    [self customPushViewControllerNavBarTitle:@"准备材料照片" backGroundImageName:nil];
    
    // 添加底层视图
    [self createUI];
    
    // 添加控件
    [self ADDControl];
    
    // 右划返回上一个页面
    [self customerGesturePop];
    
    self.MianScrollView.delaysContentTouches = NO;
    // 该方式相当于上面两个循环的合集，并且实现方式更加优雅，推荐使用它，而不是使用上面两个循环
    for (id obj in self.MianScrollView.subviews) {
        if ([obj respondsToSelector:@selector(setDelaysContentTouches:)]) {
            [obj setDelaysContentTouches:NO];
        }
    }
    
}

#pragma mark - Private Method 右划返回上一个页面
- (void)customerGesturePop {
    UISwipeGestureRecognizer *swipeGestuer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleOtherSwipeGesture)];
    swipeGestuer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestuer2];
}

- (void) handleOtherSwipeGesture {
    YZAlertViewController * alertVC = [[YZAlertViewController alloc] initWithConfirmAction:^(NSString *inputText) {
        
    } andCancelAction:^{
        [self.navigationController popViewControllerAnimated:YES];
        [YZPhotoSingleton shareSingleton].SFZPhoto = nil;
        [YZPhotoSingleton shareSingleton].JSZPhoto = nil;
        [YZPhotoSingleton shareSingleton].XSZPhoto = nil;
        [YZPhotoSingleton shareSingleton].BXDDPhoto = nil;
        [YZPhotoSingleton shareSingleton].CLZQPhoto = nil;
        [YZPhotoSingleton shareSingleton].CLYQPhoto = nil;
        [YZPhotoSingleton shareSingleton].CLZHPhoto = nil;
        [YZPhotoSingleton shareSingleton].CLYHPhoto = nil;
        [YZPhotoSingleton shareSingleton].CLJHPhoto = nil;
        [YZPhotoSingleton shareSingleton].ALLhoto = nil;
        //    [self.itemsSectionPictureArray removeAllObjects];
    }];
    alertVC.RealID = @"order";
    [self presentViewController:alertVC animated:YES completion:nil];
}


/**
 *  取消输入
 */
- (void)viewTapped{
    [self.view endEditing:YES];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    self.view.frame = CGRectMake(0, 0-200*YZAdapter, Screen_W,Screen_H);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.view.frame = CGRectMake(0, 64, Screen_W, Screen_H-64);
}


- (void)goBack {
        
    YZAlertViewController * alertVC = [[YZAlertViewController alloc] initWithConfirmAction:^(NSString *inputText) {
    } andCancelAction:^{
        [self.navigationController popViewControllerAnimated:YES];
        [YZPhotoSingleton shareSingleton].SFZPhoto = nil;
        [YZPhotoSingleton shareSingleton].JSZPhoto = nil;
        [YZPhotoSingleton shareSingleton].XSZPhoto = nil;
        [YZPhotoSingleton shareSingleton].BXDDPhoto = nil;
        [YZPhotoSingleton shareSingleton].CLZQPhoto = nil;
        [YZPhotoSingleton shareSingleton].CLYQPhoto = nil;
        [YZPhotoSingleton shareSingleton].CLZHPhoto = nil;
        [YZPhotoSingleton shareSingleton].CLYHPhoto = nil;
        [YZPhotoSingleton shareSingleton].CLJHPhoto = nil;
        [YZPhotoSingleton shareSingleton].ALLhoto = nil;
        //    [self.itemsSectionPictureArray removeAllObjects];
    }];
    alertVC.RealID = @"order";
    [self presentViewController:alertVC animated:YES completion:nil];
}


#pragma mark - 添加底层视图
- (void)createUI {
    self.MianScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 1090*YZAdapter+64)];
    self.MianScrollView.contentSize =CGSizeMake(Screen_W, 1090*YZAdapter+64);
    
    [_MianScrollView setFrame:CGRectMake(0, 0, Screen_W, 1090*YZAdapter+64)];
    [_MianScrollView setContentSize:CGSizeMake(_MianScrollView.frame.size.width, _MianScrollView.frame.size.height+280*YZAdapter+64)];
    
    self.MianScrollView.bounces =YES;
    self.MianScrollView.showsVerticalScrollIndicator = NO;
    self.MianScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.MianScrollView];
    [self.MianScrollView setDelegate:self];
    self.MianScrollView.delegate = self;
}

#pragma mark - 添加控件
- (void)ADDControl {
    
    /************证件信息照上传",  @"(请拍摄清晰的照片)*********/
    // 证件信息照上传文字提示视图
    UIView *PromptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 40*YZAdapter)];
    [_MianScrollView addSubview:PromptView];
    
    UILabel *PromptLabel = [UILabel new];
    PromptLabel.frame = CGRectMake(12*YZAdapter, 15*YZAdapter, 295*YZAdapter, 16*YZAdapter);
    PromptLabel.font = FONT(10);
    PromptLabel.textColor = TimeMainFont_Color;
    // 不同文字字体的颜色
    NSMutableAttributedString *CertificateNamestring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", @"证件信息照上传",  @"(请拍摄清晰的照片)"] attributes:nil];
    [CertificateNamestring addAttribute:NSForegroundColorAttributeName value:MainFont_Color range:NSMakeRange(0, 7)];
    [CertificateNamestring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 7)];
    PromptLabel.attributedText = CertificateNamestring;
    [PromptView addSubview:PromptLabel];
    
//    UIButton *PromptImage = [UIButton buttonWithType:UIButtonTypeCustom];
//    PromptImage.frame = CGRectMake(Screen_W - 55*YZAdapter, 13*YZAdapter, 40*YZAdapter, 20*YZAdapter);
//    [PromptImage setTitle:@"示例" forState:UIControlStateNormal];
//    [PromptImage setTitleColor:TimeFont_Color forState:UIControlStateNormal];
//    PromptImage.backgroundColor = [UIColor clearColor];
//    [PromptImage addTarget:self action:@selector(handdlePromptImage) forControlEvents:UIControlEventTouchUpInside];
//    PromptImage.titleLabel.font = FONT(14);
//    // 边框颜色
//    [PromptImage.layer setBorderWidth:1.0]; // 边框宽度
//    PromptImage.layer.borderColor=LightLine_Color.CGColor;
//    // 切圆角
//    PromptImage.layer.cornerRadius = 5.0;
//    PromptImage.layer.masksToBounds = YES;
//    [PromptView addSubview:PromptImage];
    
    
    
    // 证件信息照片视图
    UIView *CerPhotoView = [[UIView alloc] initWithFrame:CGRectMake(10*YZAdapter, PromptView.frame.size.height, Screen_W-20*YZAdapter, 150*YZAdapter)];
    CerPhotoView.backgroundColor = WhiteColor;
    CerPhotoView.layer.cornerRadius = 10;
    CerPhotoView.layer.masksToBounds = YES;
    [_MianScrollView addSubview:CerPhotoView];
    
    self.IdCardImage = [UIImageView new];
    self.IdCardImage.frame = CGRectMake(10*YZAdapter, 10*YZAdapter, 77*YZAdapter, 77*YZAdapter);
    self.IdCardImage.userInteractionEnabled = YES;
    [self.IdCardImage setContentMode:UIViewContentModeScaleAspectFill];
    self.IdCardImage.clipsToBounds = YES;
    self.IdCardImage.image = [UIImage imageNamed:@"YZBackCarImage"];
    self.IdCardImage.layer.cornerRadius = 2.0*YZAdapter;
    self.IdCardImage.layer.masksToBounds = YES;
    [CerPhotoView addSubview:self.IdCardImage];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *IdCardImagetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleIdCardImage:)];
    // 设置轻拍触发方法时需要的点击次数
    IdCardImagetapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    IdCardImagetapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [self.IdCardImage addGestureRecognizer:IdCardImagetapGesture];
    
    
    UILabel *IdCardLabel = [UILabel new];
    IdCardLabel.frame = CGRectMake(10*YZAdapter, self.IdCardImage.frame.size.height+20*YZAdapter, 77*YZAdapter, 25*YZAdapter);
    IdCardLabel.text = @"身份证";
    IdCardLabel.textAlignment = NSTextAlignmentCenter;
    IdCardLabel.font = FONT(14);
    IdCardLabel.textColor = MainFont_Color;
//    IdCardLabel.backgroundColor = YZColor(74, 77, 91);
    [CerPhotoView addSubview:IdCardLabel];
    
    self.DrivingImage = [UIImageView new];
    self.DrivingImage.frame = CGRectMake(self.IdCardImage.frame.size.width+20*YZAdapter, 10*YZAdapter, 77*YZAdapter, 77*YZAdapter);
    self.DrivingImage.userInteractionEnabled = YES;
    [self.DrivingImage setContentMode:UIViewContentModeScaleAspectFill];
    self.DrivingImage.clipsToBounds = YES;
    self.DrivingImage.image = [UIImage imageNamed:@"YZBackCarImage"];
    self.DrivingImage.layer.cornerRadius = 2.0*YZAdapter;
    self.DrivingImage.layer.masksToBounds = YES;
    [CerPhotoView addSubview:self.DrivingImage];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *DrivingImagetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrivingImage:)];
    // 设置轻拍触发方法时需要的点击次数
    DrivingImagetapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    DrivingImagetapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [self.DrivingImage addGestureRecognizer:DrivingImagetapGesture];
    
    UILabel *DrivingLabel = [UILabel new];
    DrivingLabel.frame = CGRectMake(self.IdCardImage.frame.size.width+20*YZAdapter, self.DrivingImage.frame.size.height+20*YZAdapter, 77*YZAdapter, 25*YZAdapter);
    DrivingLabel.text = @"驾驶证";
    DrivingLabel.textAlignment = NSTextAlignmentCenter;
    DrivingLabel.font = FONT(14);
    DrivingLabel.textColor = MainFont_Color;
//    DrivingLabel.backgroundColor = YZColor(74, 77, 91);
    [CerPhotoView addSubview:DrivingLabel];
    
    self.RunImage = [UIImageView new];
    self.RunImage.frame = CGRectMake(self.DrivingImage.frame.size.width*2+30*YZAdapter, 10*YZAdapter, 77*YZAdapter, 77*YZAdapter);
    self.RunImage.userInteractionEnabled = YES;
    [self.RunImage setContentMode:UIViewContentModeScaleAspectFill];
    self.RunImage.clipsToBounds = YES;
    self.RunImage.image = [UIImage imageNamed:@"YZBackCarImage"];
    self.RunImage.layer.cornerRadius = 2.0*YZAdapter;
    self.RunImage.layer.masksToBounds = YES;
    [CerPhotoView addSubview:self.RunImage];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *RunImagetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRunImage:)];
    // 设置轻拍触发方法时需要的点击次数
    RunImagetapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    RunImagetapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [self.RunImage addGestureRecognizer:RunImagetapGesture];
    
    
    UILabel *RunLabel = [UILabel new];
    RunLabel.frame = CGRectMake(self.DrivingImage.frame.size.width*2+30*YZAdapter, self.RunImage.frame.size.height+20*YZAdapter, 77*YZAdapter, 25*YZAdapter);
    RunLabel.text = @"行驶证";
    RunLabel.textAlignment = NSTextAlignmentCenter;
    RunLabel.font = FONT(14);
    RunLabel.textColor = MainFont_Color;
//    RunLabel.backgroundColor = YZColor(74, 77, 91);
    [CerPhotoView addSubview:RunLabel];
    
    self.BillImage = [UIImageView new];
    self.BillImage.frame = CGRectMake(self.RunImage.frame.size.width*3+40*YZAdapter, 10*YZAdapter, 77*YZAdapter, 77*YZAdapter);
    self.BillImage.userInteractionEnabled = YES;
    [self.BillImage setContentMode:UIViewContentModeScaleAspectFill];
    self.BillImage.clipsToBounds = YES;
    self.BillImage.image = [UIImage imageNamed:@"YZBackCarImage"];
    self.BillImage.layer.cornerRadius = 2.0*YZAdapter;
    self.BillImage.layer.masksToBounds = YES;
    [CerPhotoView addSubview:self.BillImage];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *BillImagetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBillImage:)];
    // 设置轻拍触发方法时需要的点击次数
    BillImagetapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    BillImagetapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [self.BillImage addGestureRecognizer:BillImagetapGesture];
    
    UILabel *BillLabel = [UILabel new];
    BillLabel.frame = CGRectMake(self.RunImage.frame.size.width*3+40*YZAdapter, self.BillImage.frame.size.height+20*YZAdapter, 77*YZAdapter, 25*YZAdapter);
    BillLabel.text = @"保险大单";
    BillLabel.textAlignment = NSTextAlignmentCenter;
    BillLabel.font = FONT(14);
    BillLabel.textColor = MainFont_Color;
//    BillLabel.backgroundColor = YZColor(74, 77, 91);
    [CerPhotoView addSubview:BillLabel];
    
    /************车辆四面照上传",  @"(请拍摄清晰的照片)*********/
    // 证件信息照上传文字提示视图
    UIView *AllAroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CerPhotoView.frame.size.height+CerPhotoView.frame.origin.y, Screen_W, 40*YZAdapter)];
    [_MianScrollView addSubview:AllAroundView];
    
    UILabel *AllAroundLabel = [UILabel new];
    AllAroundLabel.frame = CGRectMake(12*YZAdapter, 15*YZAdapter, 295*YZAdapter, 16*YZAdapter);
    AllAroundLabel.font = FONT(10);
    AllAroundLabel.textColor = TimeMainFont_Color;
    // 不同文字字体的颜色
    NSMutableAttributedString *AllAroundLabelNamestring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @"车辆四面照上传"] attributes:nil];
    [AllAroundLabelNamestring addAttribute:NSForegroundColorAttributeName value:MainFont_Color range:NSMakeRange(0, 7)];
    [AllAroundLabelNamestring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 7)];
    AllAroundLabel.attributedText = AllAroundLabelNamestring;
    [AllAroundView addSubview:AllAroundLabel];
    
//    UIImageView *AllAroundImage = [UIImageView new];
//    AllAroundImage.frame = CGRectMake(Screen_W - 40*YZAdapter, 15*YZAdapter, 15*YZAdapter, 15*YZAdapter);
//    AllAroundImage.image = [UIImage imageNamed:@"YZwarning"];
//    [AllAroundView addSubview:AllAroundImage];
    
//    UIButton *AllAroundImage = [UIButton buttonWithType:UIButtonTypeCustom];
//    AllAroundImage.frame = CGRectMake(Screen_W - 55*YZAdapter, 13*YZAdapter, 40*YZAdapter, 20*YZAdapter);
//    [AllAroundImage setTitle:@"示例" forState:UIControlStateNormal];
//    [AllAroundImage setTitleColor:TimeFont_Color forState:UIControlStateNormal];
//    AllAroundImage.backgroundColor = [UIColor clearColor];
//    [AllAroundImage addTarget:self action:@selector(handdleAllAroundImage) forControlEvents:UIControlEventTouchUpInside];
//    AllAroundImage.titleLabel.font = FONT(14);
//    // 边框颜色
//    [AllAroundImage.layer setBorderWidth:1.0]; // 边框宽度
//    AllAroundImage.layer.borderColor=LightLine_Color.CGColor;
//    // 切圆角
//    AllAroundImage.layer.cornerRadius = 5.0;
//    AllAroundImage.layer.masksToBounds = YES;
//    [AllAroundView addSubview:AllAroundImage];
    
    
    
    // 证件信息照片视图
    UIView *AroundPhotoView = [[UIView alloc] initWithFrame:CGRectMake(10*YZAdapter, AllAroundView.frame.size.height+AllAroundView.frame.origin.y, Screen_W-20*YZAdapter, 150*YZAdapter)];
    AroundPhotoView.backgroundColor = WhiteColor;
    AroundPhotoView.layer.cornerRadius = 10;
    AroundPhotoView.layer.masksToBounds = YES;
    [_MianScrollView addSubview:AroundPhotoView];
    
    self.beforeImage = [UIImageView new];
    self.beforeImage.frame = CGRectMake(10*YZAdapter, 10*YZAdapter, 77*YZAdapter, 77*YZAdapter);
    self.beforeImage.userInteractionEnabled = YES;
    [self.beforeImage setContentMode:UIViewContentModeScaleAspectFill];
    self.beforeImage.clipsToBounds = YES;
    self.beforeImage.image = [UIImage imageNamed:@"YZCarLeft"];
    self.beforeImage.layer.cornerRadius = 2.0*YZAdapter;
    self.beforeImage.layer.masksToBounds = YES;
    [AroundPhotoView addSubview:self.beforeImage];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *beforeImagetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlebeforeImage:)];
    // 设置轻拍触发方法时需要的点击次数
    beforeImagetapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    beforeImagetapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [self.beforeImage addGestureRecognizer:beforeImagetapGesture];
    
    UILabel *beforeLabel = [UILabel new];
    beforeLabel.frame = CGRectMake(10*YZAdapter, self.IdCardImage.frame.size.height+20*YZAdapter, 77*YZAdapter, 25*YZAdapter);
    beforeLabel.text = @"远照(车辆A)";
    beforeLabel.textAlignment = NSTextAlignmentCenter;
    beforeLabel.font = FONT(10);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"远照(车辆A)"];
    [attrStr addAttribute:NSFontAttributeName
                    value:FONTS(14)
                    range:NSMakeRange(0, 2)];
    beforeLabel.attributedText = attrStr;
    beforeLabel.textColor = MainFont_Color;
//    beforeLabel.backgroundColor = YZColor(74, 77, 91);
    [AroundPhotoView addSubview:beforeLabel];
    
    self.afterImage = [UIImageView new];
    self.afterImage.frame = CGRectMake(self.IdCardImage.frame.size.width+20*YZAdapter, 10*YZAdapter, 77*YZAdapter, 77*YZAdapter);
    self.afterImage.userInteractionEnabled = YES;
    [self.afterImage setContentMode:UIViewContentModeScaleAspectFill];
    self.afterImage.clipsToBounds = YES;
    self.afterImage.image = [UIImage imageNamed:@"YZCarRight"];
    self.afterImage.layer.cornerRadius = 2.0*YZAdapter;
    self.afterImage.layer.masksToBounds = YES;
    [AroundPhotoView addSubview:self.afterImage];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *afterImagetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleafterImage:)];
    // 设置轻拍触发方法时需要的点击次数
    afterImagetapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    afterImagetapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [self.afterImage addGestureRecognizer:afterImagetapGesture];
    
    UILabel *afterLabel = [UILabel new];
    afterLabel.frame = CGRectMake(self.IdCardImage.frame.size.width+20*YZAdapter, self.DrivingImage.frame.size.height+20*YZAdapter, 77*YZAdapter, 25*YZAdapter);
    afterLabel.text = @"远照(车辆B)";
    afterLabel.textAlignment = NSTextAlignmentCenter;
    afterLabel.font = FONT(10);
    afterLabel.textColor = MainFont_Color;
    
    NSMutableAttributedString *afterattrStr = [[NSMutableAttributedString alloc] initWithString:@"远照(车辆B)"];
    [afterattrStr addAttribute:NSFontAttributeName
                    value:FONTS(14)
                    range:NSMakeRange(0, 2)];
    afterLabel.attributedText = afterattrStr;
    
//    afterLabel.backgroundColor = YZColor(74, 77, 91);
    [AroundPhotoView addSubview:afterLabel];
    
    self.leftImage = [UIImageView new];
    self.leftImage.frame = CGRectMake(self.DrivingImage.frame.size.width*2+30*YZAdapter, 10*YZAdapter, 77*YZAdapter, 77*YZAdapter);
    self.leftImage.userInteractionEnabled = YES;
    [self.leftImage setContentMode:UIViewContentModeScaleAspectFill];
    self.leftImage.clipsToBounds = YES;
    self.leftImage.image = [UIImage imageNamed:@"YZCarTop"];
    self.leftImage.layer.cornerRadius = 2.0*YZAdapter;
    self.leftImage.layer.masksToBounds = YES;
    [AroundPhotoView addSubview:self.leftImage];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *leftImagetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleleftImage:)];
    // 设置轻拍触发方法时需要的点击次数
    leftImagetapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    leftImagetapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [self.leftImage addGestureRecognizer:leftImagetapGesture];
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.frame = CGRectMake(self.DrivingImage.frame.size.width*2+30*YZAdapter, self.RunImage.frame.size.height+20*YZAdapter, 77*YZAdapter, 25*YZAdapter);
    leftLabel.text = @"近照(车辆A)";
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.font = FONT(10);
    leftLabel.textColor = MainFont_Color;
    
    NSMutableAttributedString *leftattrStr = [[NSMutableAttributedString alloc] initWithString:@"近照(车辆A)"];
    [leftattrStr addAttribute:NSFontAttributeName
                    value:FONTS(14)
                    range:NSMakeRange(0, 2)];
    leftLabel.attributedText = leftattrStr;
    
//    leftLabel.backgroundColor = YZColor(74, 77, 91);
    [AroundPhotoView addSubview:leftLabel];
    
    self.rightImage = [UIImageView new];
    self.rightImage.frame = CGRectMake(self.RunImage.frame.size.width*3+40*YZAdapter, 10*YZAdapter, 77*YZAdapter, 77*YZAdapter);
    self.rightImage.userInteractionEnabled = YES;
    [self.rightImage setContentMode:UIViewContentModeScaleAspectFill];
    self.rightImage.clipsToBounds = YES;
    self.rightImage.image = [UIImage imageNamed:@"YZCarBotoom"];
    self.rightImage.layer.cornerRadius = 2.0*YZAdapter;
    self.rightImage.layer.masksToBounds = YES;
    [AroundPhotoView addSubview:self.rightImage];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *rightImagetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerightImage:)];
    // 设置轻拍触发方法时需要的点击次数
    rightImagetapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    rightImagetapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [self.rightImage addGestureRecognizer:rightImagetapGesture];
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.frame = CGRectMake(self.RunImage.frame.size.width*3+40*YZAdapter, self.BillImage.frame.size.height+20*YZAdapter, 77*YZAdapter, 25*YZAdapter);
    rightLabel.text = @"近照(车辆B)";
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.font = FONT(10);
    rightLabel.textColor = MainFont_Color;
    
    NSMutableAttributedString *rightattrStr = [[NSMutableAttributedString alloc] initWithString:@"近照(车辆B)"];
    [rightattrStr addAttribute:NSFontAttributeName
                        value:FONTS(14)
                        range:NSMakeRange(0, 2)];
    rightLabel.attributedText = rightattrStr;
    
//    rightLabel.backgroundColor = YZColor(74, 77, 91);
    [AroundPhotoView addSubview:rightLabel];
    
    
    
    /************其他资料上传*********/
    // 证件信息照上传文字提示视图
    UIView *OtherAroundView = [[UIView alloc] initWithFrame:CGRectMake(0, AroundPhotoView.frame.size.height+AroundPhotoView.frame.origin.y, Screen_W, 40*YZAdapter)];
    [_MianScrollView addSubview:OtherAroundView];
    
    UILabel *OtherAroundLabel = [UILabel new];
    OtherAroundLabel.frame = CGRectMake(12*YZAdapter, 15*YZAdapter, 295*YZAdapter, 16*YZAdapter);
    OtherAroundLabel.font = FONT(10);
    OtherAroundLabel.textColor = TimeMainFont_Color;
    // 不同文字字体的颜色
    NSMutableAttributedString *OtherAroundLabelNamestring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @"其他资料上传"] attributes:nil];
    [OtherAroundLabelNamestring addAttribute:NSForegroundColorAttributeName value:MainFont_Color range:NSMakeRange(0, 6)];
    [OtherAroundLabelNamestring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 6)];
    OtherAroundLabel.attributedText = OtherAroundLabelNamestring;
    [OtherAroundView addSubview:OtherAroundLabel];
    
    //    UIImageView *AllAroundImage = [UIImageView new];
    //    AllAroundImage.frame = CGRectMake(Screen_W - 40*YZAdapter, 15*YZAdapter, 15*YZAdapter, 15*YZAdapter);
    //    AllAroundImage.image = [UIImage imageNamed:@"YZwarning"];
    //    [AllAroundView addSubview:AllAroundImage];
    
//    UIButton *OtherAroundImage = [UIButton buttonWithType:UIButtonTypeCustom];
//    OtherAroundImage.frame = CGRectMake(Screen_W - 55*YZAdapter, 13*YZAdapter, 40*YZAdapter, 20*YZAdapter);
//    [OtherAroundImage setTitle:@"示例" forState:UIControlStateNormal];
//    [OtherAroundImage setTitleColor:TimeFont_Color forState:UIControlStateNormal];
//    OtherAroundImage.backgroundColor = [UIColor clearColor];
//    [OtherAroundImage addTarget:self action:@selector(handdleOtherAroundImage) forControlEvents:UIControlEventTouchUpInside];
//    OtherAroundImage.titleLabel.font = FONT(14);
//    // 边框颜色
//    [OtherAroundImage.layer setBorderWidth:1.0]; // 边框宽度
//    OtherAroundImage.layer.borderColor=LightLine_Color.CGColor;
//    // 切圆角
//    OtherAroundImage.layer.cornerRadius = 5.0;
//    OtherAroundImage.layer.masksToBounds = YES;
//    [OtherAroundView addSubview:OtherAroundImage];
    
    
    
    // 证件信息照片视图
    UIView *ChassisPhotoView = [[UIView alloc] initWithFrame:CGRectMake(10*YZAdapter, OtherAroundView.frame.size.height+OtherAroundView.frame.origin.y, Screen_W-20*YZAdapter, 150*YZAdapter)];
    ChassisPhotoView.backgroundColor = WhiteColor;
    ChassisPhotoView.layer.cornerRadius = 10;
    ChassisPhotoView.layer.masksToBounds = YES;
    [_MianScrollView addSubview:ChassisPhotoView];
    
    self.ChassisImage = [UIImageView new];
    self.ChassisImage.frame = CGRectMake(10*YZAdapter, 10*YZAdapter, 77*YZAdapter, 77*YZAdapter);
    self.ChassisImage.userInteractionEnabled = YES;
    [self.ChassisImage setContentMode:UIViewContentModeScaleAspectFill];
    self.ChassisImage.clipsToBounds = YES;
    self.ChassisImage.image = [UIImage imageNamed:@"YZBackCarImage"];
    self.ChassisImage.layer.cornerRadius = 2.0*YZAdapter;
    self.ChassisImage.layer.masksToBounds = YES;
    [ChassisPhotoView addSubview:self.ChassisImage];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *ChassisImagetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChassisImage:)];
    // 设置轻拍触发方法时需要的点击次数
    ChassisImagetapGesture.numberOfTapsRequired = 1;
    // 设置轻拍需要的手指个数
    ChassisImagetapGesture.numberOfTouchesRequired = 1;
    // 向视图对象上添加手势
    [self.ChassisImage addGestureRecognizer:ChassisImagetapGesture];
    
    UILabel *ChassisLabel = [UILabel new];
    ChassisLabel.frame = CGRectMake(10*YZAdapter, self.IdCardImage.frame.size.height+20*YZAdapter, 77*YZAdapter, 25*YZAdapter);
    ChassisLabel.text = @"车架号";
    ChassisLabel.textAlignment = NSTextAlignmentCenter;
    ChassisLabel.font = FONT(14);
    ChassisLabel.textColor = MainFont_Color;
//    ChassisLabel.backgroundColor = YZColor(74, 77, 91);
    [ChassisPhotoView addSubview:ChassisLabel];


    
    /************车辆损坏照上传*********/
    // 车辆损坏照上传文字提示视图
    self.DamageView = [[UIView alloc] initWithFrame:CGRectMake(0, ChassisPhotoView.frame.size.height+ChassisPhotoView.frame.origin.y, Screen_W, 40*YZAdapter)];
    [_MianScrollView addSubview:self.DamageView];
    
    UILabel *DamageLabel = [UILabel new];
    DamageLabel.frame = CGRectMake(12*YZAdapter, 15*YZAdapter, 295*YZAdapter, 16*YZAdapter);
    DamageLabel.font = FONT(10);
    DamageLabel.textColor = TimeMainFont_Color;
    // 不同文字字体的颜色
    NSMutableAttributedString *DamageNamestring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", @"车辆损坏照上传",  @"(请尽可能多角度拍摄)"] attributes:nil];
    [DamageNamestring addAttribute:NSForegroundColorAttributeName value:MainFont_Color range:NSMakeRange(0, 7)];
    [DamageNamestring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 7)];
    DamageLabel.attributedText = DamageNamestring;
    [self.DamageView addSubview:DamageLabel];
    
//    UIImageView *DamageImage = [UIImageView new];
//    DamageImage.frame = CGRectMake(Screen_W - 40*YZAdapter, 15*YZAdapter, 15*YZAdapter, 15*YZAdapter);
//    DamageImage.image = [UIImage imageNamed:@"YZwarning"];
//    [self.DamageView addSubview:DamageImage];

//    UIButton *DamageImage = [UIButton buttonWithType:UIButtonTypeCustom];
//    DamageImage.frame = CGRectMake(Screen_W - 55*YZAdapter, 13*YZAdapter, 40*YZAdapter, 20*YZAdapter);
//    [DamageImage setTitle:@"示例" forState:UIControlStateNormal];
//    [DamageImage setTitleColor:TimeFont_Color forState:UIControlStateNormal];
//    DamageImage.backgroundColor = [UIColor clearColor];
//    [DamageImage addTarget:self action:@selector(handdleDamageImage) forControlEvents:UIControlEventTouchUpInside];
//    DamageImage.titleLabel.font = FONT(14);
//    // 边框颜色
//    [DamageImage.layer setBorderWidth:1.0]; // 边框宽度
//    DamageImage.layer.borderColor=LightLine_Color.CGColor;
//    // 切圆角
//    DamageImage.layer.cornerRadius = 5.0;
//    DamageImage.layer.masksToBounds = YES;
//    [self.DamageView addSubview:DamageImage];
    
    // 损坏照片页面
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(75*YZAdapter, 75*YZAdapter);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5*YZAdapter; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(10.f*YZAdapter, 10*YZAdapter, 10.f*YZAdapter, 10*YZAdapter);
    
    //创建 UICollectionView
    self.pictureCollectonView = [[UICollectionView alloc] initWithFrame:CGRectMake(10*YZAdapter, self.DamageView.frame.size.height+self.DamageView.frame.origin.y, Screen_W-20*YZAdapter, 95*YZAdapter) collectionViewLayout:layout];
    
    [self.pictureCollectonView registerClass:[YZPictureCollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
    [self.pictureCollectonView registerClass:[YZPictureAddCell class] forCellWithReuseIdentifier:@"addItemCell"];
    
    self.pictureCollectonView.backgroundColor = WhiteColor;
    self.pictureCollectonView.layer.cornerRadius = 10;
    self.pictureCollectonView.layer.masksToBounds = YES;
    self.pictureCollectonView.scrollEnabled = NO;
    self.pictureCollectonView.delegate = self;
    self.pictureCollectonView.dataSource = self;
    self.pictureCollectonView.bounces = NO;
    [_MianScrollView addSubview:self.pictureCollectonView];
    
    
    /************其他情况说明*********/
    // 车辆损坏照上传文字提示视图
    self.InstructionsView = [[UIView alloc] initWithFrame:CGRectMake(0, _pictureCollectonView.frame.size.height+_pictureCollectonView.frame.origin.y, Screen_W, 40*YZAdapter)];
    [_MianScrollView addSubview:self.InstructionsView];
    
    UILabel *InstructionsLabel = [UILabel new];
    InstructionsLabel.frame = CGRectMake(12*YZAdapter, 15*YZAdapter, 295*YZAdapter, 16*YZAdapter);
    InstructionsLabel.font = FONT(10);
    InstructionsLabel.textColor = TimeMainFont_Color;
    // 不同文字字体的颜色
    NSMutableAttributedString *InstructionsNamestring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", @"其他情况说明",  @"(可留空)"] attributes:nil];
    [InstructionsNamestring addAttribute:NSForegroundColorAttributeName value:MainFont_Color range:NSMakeRange(0, 7)];
    [InstructionsNamestring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 7)];
    InstructionsLabel.attributedText = InstructionsNamestring;
    [self.InstructionsView addSubview:InstructionsLabel];
    
//    UIImageView *InstructionsImage = [UIImageView new];
//    InstructionsImage.frame = CGRectMake(Screen_W - 40*YZAdapter, 15*YZAdapter, 15*YZAdapter, 15*YZAdapter);
//    InstructionsImage.image = [UIImage imageNamed:@"YZwarning"];
//    [self.InstructionsView addSubview:InstructionsImage];

//    UIButton *InstructionsImage = [UIButton buttonWithType:UIButtonTypeCustom];
//    InstructionsImage.frame = CGRectMake(Screen_W - 55*YZAdapter, 13*YZAdapter, 40*YZAdapter, 20*YZAdapter);
//    [InstructionsImage setTitle:@"示例" forState:UIControlStateNormal];
//    [InstructionsImage setTitleColor:TimeFont_Color forState:UIControlStateNormal];
//    InstructionsImage.backgroundColor = [UIColor clearColor];
//    [InstructionsImage addTarget:self action:@selector(handdleInstructionsImage) forControlEvents:UIControlEventTouchUpInside];
//    InstructionsImage.titleLabel.font = FONT(14);
//    // 边框颜色
//    [InstructionsImage.layer setBorderWidth:1.0]; // 边框宽度
//    InstructionsImage.layer.borderColor=LightLine_Color.CGColor;
//    // 切圆角
//    InstructionsImage.layer.cornerRadius = 5.0;
//    InstructionsImage.layer.masksToBounds = YES;
//    [self.InstructionsView addSubview:InstructionsImage];
    
    
    
    // 添加意见输入框
    // 留言
    self.YZPlaceholderView = [[YZPlaceholderTextView alloc] initWithFrame:CGRectMake(10*YZAdapter, self.InstructionsView.frame.size.height+self.InstructionsView.frame.origin.y, Screen_W-20*YZAdapter, 113*YZAdapter)];
    //    _originalTextView.layer.borderWidth = 1.0;
    //    _originalTextView.layer.borderColor = LIGHTGRAY_COLOR.CGColor;
    _YZPlaceholderView.layer.cornerRadius = 10.0;
    _YZPlaceholderView.layer.masksToBounds = YES;
    
    self.YZPlaceholderView.backgroundColor = WhiteColor;
    _YZPlaceholderView.placeholder = @"若有其他情况, 请填写在这里";
//    _YZPlaceholderView.textColor =TimeFont_Color;
    _YZPlaceholderView.returnKeyType = UIReturnKeyNext;
    self.YZPlaceholderView.delegate = self;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    [_MianScrollView addSubview:self.YZPlaceholderView];
    
    // 提交按钮
    self.SubmitAuditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.SubmitAuditButton  setExclusiveTouch :YES];
    self.SubmitAuditButton.frame =  CGRectMake(10*YZAdapter, self.YZPlaceholderView.frame.size.height+self.YZPlaceholderView.frame.origin.y+20*YZAdapter, Screen_W-20*YZAdapter, 45*YZAdapter);
//    [self.SubmitAuditButton setImage:[UIImage imageNamed:@"gjZY"] forState:UIControlStateNormal];
    [self.SubmitAuditButton setTitle:@"提交实时审核" forState:UIControlStateNormal];
    self.SubmitAuditButton.backgroundColor = YZEssentialColor;
    // 高亮状态
    [self.SubmitAuditButton setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
    [self.SubmitAuditButton setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
    // 正常状态
//    [self.SubmitAuditButton setImage:[UIImage imageNamed:@"green-1"] forState:UIControlStateNormal];
//    self.SubmitAuditButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5*YZAdapter, 0, 0);
//    self.SubmitAuditButton.imageEdgeInsets = UIEdgeInsetsMake(10*YZAdapter,self.SubmitAuditButton.titleLabel.bounds.size.width, 10*YZAdapter, -self.SubmitAuditButton.titleLabel.bounds.size.width);
    self.SubmitAuditButton.tintColor = [UIColor whiteColor];
//    self.SubmitAuditButton.layer.cornerRadius = 5;
//    self.SubmitAuditButton.layer.masksToBounds = YES;
    self.SubmitAuditButton.titleLabel.font = FONT(17);
    self.SubmitAuditButton.layer.cornerRadius = 2.0*YZAdapter;
    [self.SubmitAuditButton addTarget:self action:@selector(handleSubmitAuditButton) forControlEvents:UIControlEventTouchUpInside];
    [_MianScrollView addSubview:self.SubmitAuditButton];
    
}

#pragma mark - UITextViewDelegate键盘管理和字数限制
- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger number = [textView.text length];
    if (number > 200) {
        [self.YZPlaceholderView resignFirstResponder];
        textView.text = [textView.text substringToIndex:200];
        number = 200;
        // 加载页面
        [MBProgressHUD showAutoMessage:@"超过字数限制"];
//        LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"超过字数限制" BubbleImage:@"YZPromptSubmit"], 1);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.YZPlaceholderView resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.YZPlaceholderView resignFirstResponder];
}


/******************************车辆损坏照片的布局*************************/
#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemsSectionPictureArray.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.itemsSectionPictureArray.count) {
        static NSString *addItem = @"addItemCell";
        
        self.addItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:addItem forIndexPath:indexPath];
        
        return self.addItemCell;
    }else
    {
        static NSString *identify = @"cell";
        YZPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.imageView.image = self.itemsSectionPictureArray[indexPath.row];
        
        if (indexPath.row == 7) {
            self.addItemCell.addImageView.image = [UIImage imageNamed:@"1111"];
        }
        
        return cell;
    }
}

//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.itemsSectionPictureArray.count) {
        if (self.itemsSectionPictureArray.count > 7) {
            
            return;
        }
        
        YZCameraViewController *YZCameraController = [YZCameraViewController new];
        [self presentViewController:YZCameraController animated:YES completion:nil];

    }else
    {
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        for (int i = 0;i< self.itemsSectionPictureArray.count; i ++) {
            UIImage *image = self.itemsSectionPictureArray[i];
            
            MJPhoto *photo = [MJPhoto new];
            photo.image = image;
            YZPictureCollectionViewCell *cell = (YZPictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            photo.srcImageView = cell.imageView;
            [photoArray addObject:photo];
        }
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = indexPath.row;
        browser.photos = photoArray;
        [browser show];
        
    }
}

-(void)deletedPictures:(NSSet *)set Str:(NSString *)IDStr
{
    if ([IDStr isEqualToString:@"清除"]) {
        self.SFZ = nil;
        self.JSZ = nil;
        self.XSZ = nil;
        self.BXDD = nil;
        self.CLZQ = nil;
        self.CLYQ = nil;
        self.CLZH = nil;
        self.CLYH = nil;
        self.CLJH = nil;
    }
    
    NSMutableArray *cellArray = [NSMutableArray array];
    
    for (NSString *index1 in set) {
        [cellArray addObject:index1];
    }
    
    if (cellArray.count == 0) {
        
    }else if (cellArray.count == 1 && self.itemsSectionPictureArray.count == 1) {
        
        if (self.SFZ) {
            [YZPhotoSingleton shareSingleton].SFZPhoto = nil;
            self.IdCardImage.image = [UIImage imageNamed:@"YZBackCarImage"];
            [_IDDic removeObjectForKey:@"SFZ"];
            self.SFZ = nil;
        }else if (self.JSZ) {
            [YZPhotoSingleton shareSingleton].JSZPhoto = nil;
            self.DrivingImage.image = [UIImage imageNamed:@"YZBackCarImage"];
            [_IDDic removeObjectForKey:@"JSZ"];
            self.JSZ = nil;
        }else if (self.XSZ) {
            [YZPhotoSingleton shareSingleton].XSZPhoto = nil;
            self.RunImage.image = [UIImage imageNamed:@"YZBackCarImage"];
            [_IDDic removeObjectForKey:@"XSZ"];
            self.XSZ = nil;
        }else if (self.BXDD) {
            [YZPhotoSingleton shareSingleton].BXDDPhoto = nil;
            self.BillImage.image = [UIImage imageNamed:@"YZBackCarImage"];
            [_IDDic removeObjectForKey:@"BXDD"];
            self.BXDD = nil;
        }else if (self.CLZQ) {
            [YZPhotoSingleton shareSingleton].CLZQPhoto = nil;
            self.beforeImage.image = [UIImage imageNamed:@"YZBackCarImage"];
            [_IDDic removeObjectForKey:@"CLZQ"];
            self.CLZQ = nil;
        }else if (self.CLYQ) {
            [YZPhotoSingleton shareSingleton].CLYQPhoto = nil;
            self.afterImage.image = [UIImage imageNamed:@"YZBackCarImage"];
            [_IDDic removeObjectForKey:@"CLYQ"];
            self.CLYQ = nil;
        }else if (self.CLZH) {
            [YZPhotoSingleton shareSingleton].CLZHPhoto = nil;
            self.leftImage.image = [UIImage imageNamed:@"YZBackCarImage"];
            [_IDDic removeObjectForKey:@"CLZH"];
            self.CLZH = nil;
        }else if (self.CLYH) {
            [YZPhotoSingleton shareSingleton].CLYHPhoto = nil;
            self.rightImage.image = [UIImage imageNamed:@"YZBackCarImage"];
            [_IDDic removeObjectForKey:@"CLYH"];
            self.CLYH = nil;
        }else if (self.CLJH) {
            [YZPhotoSingleton shareSingleton].CLJHPhoto = nil;
            self.ChassisImage.image = [UIImage imageNamed:@"YZBackCarImage"];
            [_IDDic removeObjectForKey:@"CLJH"];
            self.CLJH = nil;
        }else {
            NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.itemsSectionPictureArray removeObjectAtIndex:indexPathTwo.row];
            [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPathTwo]];
            
            NSString *Str = [NSString stringWithFormat:@"CLXH_0%ld", (long)indexPathTwo.row];
            [_IDDic removeObjectForKey:Str];
        }
        
    }else{
        
        for (int i = 0; i<cellArray.count-1; i++) {
            for (int j = 0; j<cellArray.count-1-i; j++) {
                if ([cellArray[j] intValue]<[cellArray[j+1] intValue]) {
                    NSString *temp = cellArray[j];
                    cellArray[j] = cellArray[j+1];
                    cellArray[j+1] = temp;
                }
            }
        }
        
        for (int b = 0; b<cellArray.count; b++) {
            int idexx = [cellArray[b] intValue]-1;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idexx inSection:0];
            
                if (self.SFZ) {
                    [YZPhotoSingleton shareSingleton].SFZPhoto = nil;
                    self.IdCardImage.image = [UIImage imageNamed:@"YZBackCarImage"];
                    [_IDDic removeObjectForKey:@"SFZ"];
                    self.SFZ = nil;
                }else if (self.JSZ) {
                    [YZPhotoSingleton shareSingleton].JSZPhoto = nil;
                    self.DrivingImage.image = [UIImage imageNamed:@"YZBackCarImage"];
                    [_IDDic removeObjectForKey:@"JSZ"];
                    self.JSZ = nil;
                }else if (self.XSZ) {
                    [YZPhotoSingleton shareSingleton].XSZPhoto = nil;
                    self.RunImage.image = [UIImage imageNamed:@"YZBackCarImage"];
                    [_IDDic removeObjectForKey:@"XSZ"];
                    self.XSZ = nil;
                }else if (self.BXDD) {
                    [YZPhotoSingleton shareSingleton].BXDDPhoto = nil;
                    self.BillImage.image = [UIImage imageNamed:@"YZBackCarImage"];
                    [_IDDic removeObjectForKey:@"BXDD"];
                    self.BXDD = nil;
                }else if (self.CLZQ) {
                    [YZPhotoSingleton shareSingleton].CLZQPhoto = nil;
                    self.beforeImage.image = [UIImage imageNamed:@"YZBackCarImage"];
                    [_IDDic removeObjectForKey:@"CLZQ"];
                    self.CLZQ = nil;
                }else if (self.CLYQ) {
                    [YZPhotoSingleton shareSingleton].CLYQPhoto = nil;
                    self.afterImage.image = [UIImage imageNamed:@"YZBackCarImage"];
                    [_IDDic removeObjectForKey:@"CLYQ"];
                    self.CLYQ = nil;
                }else if (self.CLZH) {
                    [YZPhotoSingleton shareSingleton].CLZHPhoto = nil;
                    self.leftImage.image = [UIImage imageNamed:@"YZBackCarImage"];
                    [_IDDic removeObjectForKey:@"CLZH"];
                    self.CLZH = nil;
                }else if (self.CLYH) {
                    [YZPhotoSingleton shareSingleton].CLYHPhoto = nil;
                    self.rightImage.image = [UIImage imageNamed:@"YZBackCarImage"];
                    [_IDDic removeObjectForKey:@"CLYH"];
                    self.CLYH = nil;
                }else if (self.CLJH) {
                    [YZPhotoSingleton shareSingleton].CLJHPhoto = nil;
                    self.ChassisImage.image = [UIImage imageNamed:@"YZBackCarImage"];
                    [_IDDic removeObjectForKey:@"CLJH"];
                    self.CLJH = nil;
                }else {
                    [self.itemsSectionPictureArray removeObjectAtIndex:indexPath.row];
                    [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPath]];
                    
                    NSString *Str = [NSString stringWithFormat:@"CLXH_0%ld", (long)indexPath.row];
                    [_IDDic removeObjectForKey:Str];
                }
        }
    }
    
    if (self.itemsSectionPictureArray.count < 8) {
        self.addItemCell.addImageView.image = [UIImage imageNamed:@"YZBackCarImage.png"];
    }
    

    if (self.itemsSectionPictureArray.count < 4) {
        self.pictureCollectonView.frame = CGRectMake(10*YZAdapter, self.DamageView.frame.size.height+self.DamageView.frame.origin.y, Screen_W-20*YZAdapter, 95*YZAdapter);
        [_MianScrollView setFrame:CGRectMake(0, 0, Screen_W, 1090*YZAdapter+64)];
        [_MianScrollView setContentSize:CGSizeMake(_MianScrollView.frame.size.width, _MianScrollView.frame.size.height+280*YZAdapter+64)];
        self.InstructionsView.frame = CGRectMake(0, _pictureCollectonView.frame.size.height+_pictureCollectonView.frame.origin.y, Screen_W, 40*YZAdapter);
        self.YZPlaceholderView.frame = CGRectMake(10*YZAdapter, self.InstructionsView.frame.size.height+self.InstructionsView.frame.origin.y, Screen_W-20*YZAdapter, 113*YZAdapter);
        self.SubmitAuditButton.frame =  CGRectMake(10*YZAdapter, self.YZPlaceholderView.frame.size.height+self.YZPlaceholderView.frame.origin.y+20*YZAdapter, Screen_W-20*YZAdapter, 45*YZAdapter);
        
    }else if (self.itemsSectionPictureArray.count < 9)
    {
        self.pictureCollectonView.frame = CGRectMake(10*YZAdapter, self.DamageView.frame.size.height+self.DamageView.frame.origin.y, Screen_W-20*YZAdapter, 185*YZAdapter);
        [_MianScrollView setFrame:CGRectMake(0, 0, Screen_W, 1490*YZAdapter+20)];
        [_MianScrollView setContentSize:CGSizeMake(_MianScrollView.frame.size.width, _MianScrollView.frame.size.height + 375*YZAdapter+64)];
        self.InstructionsView.frame = CGRectMake(0, _pictureCollectonView.frame.size.height+_pictureCollectonView.frame.origin.y, Screen_W, 40*YZAdapter);
        self.YZPlaceholderView.frame = CGRectMake(10*YZAdapter, self.InstructionsView.frame.size.height+self.InstructionsView.frame.origin.y, Screen_W-20*YZAdapter, 113*YZAdapter);
        self.SubmitAuditButton.frame =  CGRectMake(10*YZAdapter, self.YZPlaceholderView.frame.size.height+self.YZPlaceholderView.frame.origin.y+20*YZAdapter, Screen_W-20*YZAdapter, 45*YZAdapter);
        
    }else
    {
        self.pictureCollectonView.frame = CGRectMake(10*YZAdapter, self.DamageView.frame.size.height+self.DamageView.frame.origin.y, Screen_W-20*YZAdapter, 185*YZAdapter);
        [_MianScrollView setFrame:CGRectMake(0, 0, Screen_W, 1490*YZAdapter+64)];
        [_MianScrollView setContentSize:CGSizeMake(_MianScrollView.frame.size.width, _MianScrollView.frame.size.height + 375*YZAdapter+64)];
    }
}

/***************************证件照点击事件*************************/
// 身份证
- (void)handleIdCardImage:(id) sender {
    
    
    if (![YZPhotoSingleton shareSingleton].SFZPhoto) {
        YZCameraViewController *YZCameraController = [YZCameraViewController new];
        YZCameraController.IDPhoto = @"SFZ";
        [self presentViewController:YZCameraController animated:YES completion:nil];
        
    }else {
        self.SFZ = @"SFZ";
        
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        UIImage *image = [YZPhotoSingleton shareSingleton].SFZPhoto;
        
        MJPhoto *photo = [MJPhoto new];
        photo.image = image;

        UIImageView *SFZImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75*YZAdapter, 75*YZAdapter)];
        SFZImageView.image = image;
        photo.srcImageView = SFZImageView;
        [photoArray addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = 0;
        browser.photos = photoArray;
        [browser show];
    }
}
// 驾驶证
- (void)handleDrivingImage:(id) sender {
    
    if (![YZPhotoSingleton shareSingleton].JSZPhoto) {
        YZCameraViewController *YZCameraController = [YZCameraViewController new];
        YZCameraController.IDPhoto = @"JSZ";
        [self presentViewController:YZCameraController animated:YES completion:nil];
        
    }else {
        self.JSZ = @"JSZ";
        
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        UIImage *image = [YZPhotoSingleton shareSingleton].JSZPhoto;
        
        MJPhoto *photo = [MJPhoto new];
        photo.image = image;
        
        UIImageView *SFZImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75*YZAdapter, 75*YZAdapter)];
        SFZImageView.image = image;
        photo.srcImageView = SFZImageView;
        [photoArray addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = 0;
        browser.photos = photoArray;
        [browser show];
    }
    
    
    
}
// 行驶证
- (void)handleRunImage:(id) sender {
    if (![YZPhotoSingleton shareSingleton].XSZPhoto) {
        YZCameraViewController *YZCameraController = [YZCameraViewController new];
        YZCameraController.IDPhoto = @"XSZ";
        [self presentViewController:YZCameraController animated:YES completion:nil];
        
    }else {
        self.XSZ = @"XSZ";
        
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        UIImage *image = [YZPhotoSingleton shareSingleton].XSZPhoto;
        
        MJPhoto *photo = [MJPhoto new];
        photo.image = image;
        
        UIImageView *SFZImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75*YZAdapter, 75*YZAdapter)];
        SFZImageView.image = image;
        photo.srcImageView = SFZImageView;
        [photoArray addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = 0;
        browser.photos = photoArray;
        [browser show];
    }
    
}
// 保险大单
- (void)handleBillImage:(id) sender {
    if (![YZPhotoSingleton shareSingleton].BXDDPhoto) {
        YZCameraViewController *YZCameraController = [YZCameraViewController new];
        YZCameraController.IDPhoto = @"BXDD";
        [self presentViewController:YZCameraController animated:YES completion:nil];
        
    }else {
        self.BXDD = @"BXDD";
        
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        UIImage *image = [YZPhotoSingleton shareSingleton].BXDDPhoto;
        
        MJPhoto *photo = [MJPhoto new];
        photo.image = image;
        
        UIImageView *SFZImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75*YZAdapter, 75*YZAdapter)];
        SFZImageView.image = image;
        photo.srcImageView = SFZImageView;
        [photoArray addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = 0;
        browser.photos = photoArray;
        [browser show];
    }
    
    
}
// 车辆左前处
- (void)handlebeforeImage:(id) sender {
    if (![YZPhotoSingleton shareSingleton].CLZQPhoto) {
        YZCameraViewController *YZCameraController = [YZCameraViewController new];
        YZCameraController.IDPhoto = @"CLZQ";
        [self presentViewController:YZCameraController animated:YES completion:nil];
        
    }else {
        self.CLZQ = @"CLZQ";
        
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        UIImage *image = [YZPhotoSingleton shareSingleton].CLZQPhoto;
        
        MJPhoto *photo = [MJPhoto new];
        photo.image = image;
        
        UIImageView *SFZImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75*YZAdapter, 75*YZAdapter)];
        SFZImageView.image = image;
        photo.srcImageView = SFZImageView;
        [photoArray addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = 0;
        browser.photos = photoArray;
        [browser show];
    }
    
    
}
// 车辆左后处
- (void)handleafterImage:(id) sender {
    if (![YZPhotoSingleton shareSingleton].CLYQPhoto) {
        YZCameraViewController *YZCameraController = [YZCameraViewController new];
        YZCameraController.IDPhoto = @"CLYQ";
        [self presentViewController:YZCameraController animated:YES completion:nil];
        
    }else {
        self.CLYQ = @"CLYQ";
        
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        UIImage *image = [YZPhotoSingleton shareSingleton].CLYQPhoto;
        
        MJPhoto *photo = [MJPhoto new];
        photo.image = image;
        
        UIImageView *SFZImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75*YZAdapter, 75*YZAdapter)];
        SFZImageView.image = image;
        photo.srcImageView = SFZImageView;
        [photoArray addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = 0;
        browser.photos = photoArray;
        [browser show];
    }
    
    
}
// 车辆右前处
- (void)handleleftImage:(id) sender {
    if (![YZPhotoSingleton shareSingleton].CLZHPhoto) {
        YZCameraViewController *YZCameraController = [YZCameraViewController new];
        YZCameraController.IDPhoto = @"CLZH";
        [self presentViewController:YZCameraController animated:YES completion:nil];
        
    }else {
        self.CLZH = @"CLZH";
        
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        UIImage *image = [YZPhotoSingleton shareSingleton].CLZHPhoto;
        
        MJPhoto *photo = [MJPhoto new];
        photo.image = image;
        
        UIImageView *SFZImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75*YZAdapter, 75*YZAdapter)];
        SFZImageView.image = image;
        photo.srcImageView = SFZImageView;
        [photoArray addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = 0;
        browser.photos = photoArray;
        [browser show];
    }
    
    
}
// 车辆右后处
- (void)handlerightImage:(id) sender {
    if (![YZPhotoSingleton shareSingleton].CLYHPhoto) {
        YZCameraViewController *YZCameraController = [YZCameraViewController new];
        YZCameraController.IDPhoto = @"CLYH";
        [self presentViewController:YZCameraController animated:YES completion:nil];
        
    }else {
        self.CLYH = @"CLYH";
        
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        UIImage *image = [YZPhotoSingleton shareSingleton].CLYHPhoto;
        
        MJPhoto *photo = [MJPhoto new];
        photo.image = image;
        
        UIImageView *SFZImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75*YZAdapter, 75*YZAdapter)];
        SFZImageView.image = image;
        photo.srcImageView = SFZImageView;
        [photoArray addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = 0;
        browser.photos = photoArray;
        [browser show];
    }
    
    
}

// 车架号
- (void)handleChassisImage:(id) sender {
    if (![YZPhotoSingleton shareSingleton].CLJHPhoto) {
        YZCameraViewController *YZCameraController = [YZCameraViewController new];
        YZCameraController.IDPhoto = @"CLJH";
        [self presentViewController:YZCameraController animated:YES completion:nil];
        
    }else {
        self.CLJH = @"CLJH";
        
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        UIImage *image = [YZPhotoSingleton shareSingleton].CLJHPhoto;
        
        MJPhoto *photo = [MJPhoto new];
        photo.image = image;
        
        UIImageView *SFZImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75*YZAdapter, 75*YZAdapter)];
        SFZImageView.image = image;
        photo.srcImageView = SFZImageView;
        [photoArray addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = 0;
        browser.photos = photoArray;
        [browser show];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
//    self.tabBarController.tabBar.translucent = NO;

}
- (void)viewWillAppear:(BOOL)animated {
    
    self.IDDic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    self.tabBarController.tabBar.hidden = YES;
//    self.tabBarController.tabBar.translucent = YES;

    if ([YZPhotoSingleton shareSingleton].SFZPhoto) {
        self.IdCardImage.image = [YZPhotoSingleton shareSingleton].SFZPhoto;
        [_IDDic setObject:self.IdCardImage.image forKey:@"SFZ"];
    }
    if ([YZPhotoSingleton shareSingleton].JSZPhoto) {
        self.DrivingImage.image = [YZPhotoSingleton shareSingleton].JSZPhoto;
        [_IDDic setObject:self.DrivingImage.image forKey:@"JSZ"];
    }
    if ([YZPhotoSingleton shareSingleton].XSZPhoto) {
        self.RunImage.image = [YZPhotoSingleton shareSingleton].XSZPhoto;
        [_IDDic setObject:self.RunImage.image forKey:@"XSZ"];
    }
    if ([YZPhotoSingleton shareSingleton].BXDDPhoto) {
        self.BillImage.image = [YZPhotoSingleton shareSingleton].BXDDPhoto;
        [_IDDic setObject:self.BillImage.image forKey:@"BXDD"];
    }
    if ([YZPhotoSingleton shareSingleton].CLZQPhoto) {
        self.beforeImage.image = [YZPhotoSingleton shareSingleton].CLZQPhoto;
        [_IDDic setObject:self.beforeImage.image forKey:@"CLZQ"];
    }
    if ([YZPhotoSingleton shareSingleton].CLYQPhoto) {
        self.afterImage.image = [YZPhotoSingleton shareSingleton].CLYQPhoto;
        [_IDDic setObject:self.afterImage.image forKey:@"CLYQ"];
    }
    if ([YZPhotoSingleton shareSingleton].CLZHPhoto) {
        self.leftImage.image = [YZPhotoSingleton shareSingleton].CLZHPhoto;
        [_IDDic setObject:self.leftImage.image forKey:@"CLZH"];
    }
    if ([YZPhotoSingleton shareSingleton].CLYHPhoto) {
        self.rightImage.image = [YZPhotoSingleton shareSingleton].CLYHPhoto;
        [_IDDic setObject:self.rightImage.image forKey:@"CLYH"];
    }
    if ([YZPhotoSingleton shareSingleton].CLJHPhoto) {
        self.ChassisImage.image = [YZPhotoSingleton shareSingleton].CLJHPhoto;
        [_IDDic setObject:self.ChassisImage.image forKey:@"CLJH"];
    }
    
    if ([YZPhotoSingleton shareSingleton].ALLhoto) {
        [self.itemsSectionPictureArray addObject:[YZPhotoSingleton shareSingleton].ALLhoto];
        __weak YZNewMaterialViewController *wself = self;
        
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
            if (wself.itemsSectionPictureArray.count <4) {
                wself.pictureCollectonView.frame = CGRectMake(10*YZAdapter, self.DamageView.frame.size.height+self.DamageView.frame.origin.y, Screen_W-20*YZAdapter, 95*YZAdapter);
                
                [_MianScrollView setFrame:CGRectMake(0, 0, Screen_W, 1090*YZAdapter+64)];
                [_MianScrollView setContentSize:CGSizeMake(_MianScrollView.frame.size.width, _MianScrollView.frame.size.height+280*YZAdapter+64)];
                wself.InstructionsView.frame = CGRectMake(0, _pictureCollectonView.frame.size.height+_pictureCollectonView.frame.origin.y, Screen_W, 40*YZAdapter);
                wself.YZPlaceholderView.frame = CGRectMake(10*YZAdapter, self.InstructionsView.frame.size.height+self.InstructionsView.frame.origin.y, Screen_W-20*YZAdapter, 113*YZAdapter);
                wself.SubmitAuditButton.frame =  CGRectMake(10*YZAdapter, self.YZPlaceholderView.frame.size.height+self.YZPlaceholderView.frame.origin.y+20*YZAdapter, Screen_W-20*YZAdapter, 45*YZAdapter);
                
            }else if (wself.itemsSectionPictureArray.count <9)
            {
                wself.pictureCollectonView.frame = CGRectMake(10*YZAdapter, self.DamageView.frame.size.height+self.DamageView.frame.origin.y, Screen_W-20*YZAdapter, 185*YZAdapter);
                
                [_MianScrollView setFrame:CGRectMake(0, 0, Screen_W, 1490*YZAdapter+64)];
                [_MianScrollView setContentSize:CGSizeMake(_MianScrollView.frame.size.width, _MianScrollView.frame.size.height + 375*YZAdapter+64)];
                wself.InstructionsView.frame = CGRectMake(0, _pictureCollectonView.frame.size.height+_pictureCollectonView.frame.origin.y, Screen_W, 40*YZAdapter);
                wself.YZPlaceholderView.frame = CGRectMake(10*YZAdapter, self.InstructionsView.frame.size.height+self.InstructionsView.frame.origin.y, Screen_W-20*YZAdapter, 113*YZAdapter);
                wself.SubmitAuditButton.frame =  CGRectMake(10*YZAdapter, self.YZPlaceholderView.frame.size.height+self.YZPlaceholderView.frame.origin.y+20*YZAdapter, Screen_W-20*YZAdapter, 45*YZAdapter);
                
            }
            else
            {
                wself.pictureCollectonView.frame = CGRectMake(10*YZAdapter, self.DamageView.frame.size.height+self.DamageView.frame.origin.y, Screen_W-20*YZAdapter, 185*YZAdapter);
                [_MianScrollView setFrame:CGRectMake(0, 0, Screen_W, 1490*YZAdapter+64)];
                [_MianScrollView setContentSize:CGSizeMake(_MianScrollView.frame.size.width, _MianScrollView.frame.size.height + 375*YZAdapter+64)];
            }
            
            [wself.view layoutIfNeeded];
        } completion:nil];
        
        [self.pictureCollectonView performBatchUpdates:^{
            [wself.pictureCollectonView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:wself.itemsSectionPictureArray.count - 1 inSection:0]]];
        } completion:nil];

        [YZPhotoSingleton shareSingleton].ALLhoto = nil;
    }
    
}

// 使用相机获取图片
//- (void)pickerImageFromCamera {
//    [self loadDataUploadPhoto];
//}

// 从相册中获取图片
- (void)pickerImageFromPhotoLibrary {
    // 图片选择视图控制器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 图片来源
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 是否允许编辑
//    picker.allowsEditing = YES;
    // 设置代理
    picker.delegate = self;
    // 模态出视图
    [self presentViewController:picker animated:YES completion:nil];
}



#pragma mark - 点击进入派单完成页面
- (void)handleSubmitAuditButton {
    
    // 提示框
//        YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
//            DLog(@"输入内容：%@", inputText);
//        }];
//        YZPromptController.IDStr = @"审核不通过";
//        [self presentViewController:YZPromptController animated:YES completion:nil];
    
    // 提交审核[204] task/submit
    [self requestTaskSubmit];

}



#pragma mark - 提交审核[204] task/submit
- (void)requestTaskSubmit {
    _numError = 0;
    if ([_IDDic allKeys].count >= 9) {
        for (int i = 0; i < self.itemsSectionPictureArray.count; i++) {
            NSString *Key = [NSString stringWithFormat:@"CLXH_0%d", (i+1)];
            [_IDDic setObject:self.itemsSectionPictureArray[i] forKey:Key];
        }
        LKWaitBubble(@"请求中...");
        for (int i = 0; i < [_IDDic allKeys].count; i++) {
            NSString *str = [_IDDic allKeys][i];
            [self loadDataUploadPhoto:_IDDic[str] Key:str I:i+1];
        }
    }else {
        // 加载页面
        [MBProgressHUD showAutoMessage:@"请将照片补充完善"];
    }
}


#pragma mark - 照片识别信息[203] task/picToInfo
- (void)requestTaskPicInfo {
    
    YZALLService *TaskPicInfoRequest = [YZALLService zwb_requestWithUrl:TASK_PICTOINFO_URL isPost:YES];
//    WeakSelf(self);
    [TaskPicInfoRequest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
        DLog(@"%@", message);
        if (success) {
            
            DLog(@"return success:%@", responseObject);
//            NSDictionary * dic = responseObject[@"data"];
        } else {
            DLog(@"return failure");
        }
    } failure:^(NSError *error) {
        DLog(@"error == %@", error);
    }];
}

#pragma mark - 查询审核状态[205]  task/status
- (void)requestTaskStatus {
    
    YZALLService *TaskStatusRequest = [YZALLService zwb_requestWithUrl:TASK_STATUS_URL isPost:YES];
    
    WeakSelf(self);
    
    TaskStatusRequest.tid = self.tid;
    
    [TaskStatusRequest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
        DLog(@"%@", message);
        if (success) {
            
            DLog(@"return success:%@", responseObject);
            NSString * code = responseObject[@"code"];
            if ([code integerValue] == 0) {
                // 停止定时器
                [weakSelf.timer invalidate];
                // 关闭进度加载页面
                LKHideBubble();
                
                [YZPhotoSingleton shareSingleton].SFZPhoto = nil;
                [YZPhotoSingleton shareSingleton].JSZPhoto = nil;
                [YZPhotoSingleton shareSingleton].XSZPhoto = nil;
                [YZPhotoSingleton shareSingleton].BXDDPhoto = nil;
                [YZPhotoSingleton shareSingleton].CLZQPhoto = nil;
                [YZPhotoSingleton shareSingleton].CLYQPhoto = nil;
                [YZPhotoSingleton shareSingleton].CLZHPhoto = nil;
                [YZPhotoSingleton shareSingleton].CLYHPhoto = nil;
                [YZPhotoSingleton shareSingleton].CLJHPhoto = nil;
                [YZPhotoSingleton shareSingleton].ALLhoto = nil;
                
                // 删除已完成的派单
                [[YZDataBase shareDataBase] deleteOneMovieByOrderID:self.tid];
                
                // 提示框
                YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
                    DLog(@"输入内容：%@", inputText);
                    // 进入派单完成界面
                    YZCompleteViewController *YZCompleteController = [[YZCompleteViewController alloc] init];
                    YZCompleteController.tid = self.tid;
                    YZCompleteController.price = self.price;
                    YZCompleteController.share_title = self.share_title;
                    YZCompleteController.share_content = self.share_content;
                    YZCompleteController.share_pic = self.share_pic;
                    YZCompleteController.share_link = self.share_link;
                    YZCompleteController.hidesBottomBarWhenPushed = YES;

                    [self.navigationController pushViewController:YZCompleteController animated:YES];
                }];
                YZPromptController.IDStr = @"材料照片审核通过";
                [self presentViewController:YZPromptController animated:YES completion:nil];
                
            }else if ([code integerValue] == 900102) {
                [MBProgressHUD showAutoMessage:@"登录信息失效"];
                
                YZLoginViewController * vc = [[YZLoginViewController alloc]init];
                YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
                vc.AlertPhone = model.Usre_Phone;
                
                [[YZUserInfoManager sharedManager] didLoginOut];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([code integerValue] == 205002) {
                
                NSDictionary *statusDic = responseObject[@"data"];
                
                if ([statusDic[@"status"] isEqualToString:@"SHBG"]) {
                    LKHideBubble();
                    DLog(@"审核不过，重新提交中");
                    YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
                        DLog(@"输入内容：%@", inputText);
                    }];
                    YZPromptController.IDStr = @"审核不通过";
                    YZPromptController.OrderError = responseObject[@"data"][@"status_name"];
                    [self presentViewController:YZPromptController animated:YES completion:nil];
                    // 停止定时器
                    [weakSelf.timer invalidate];
                }
            }
        } else {
            DLog(@"return failure");
            
            // 提示框
//            YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
//                DLog(@"输入内容：%@", inputText);
//            }];
//            YZPromptController.IDStr = @"审核不通过";
//            [self presentViewController:YZPromptController animated:YES completion:nil];
            [MBProgressHUD showAutoMessage:@"审核失败, 请检查您的网络连接"];
            // 停止定时器
            [weakSelf.timer invalidate];
            // 关闭进度加载页面
            LKHideBubble();
        }
    } failure:^(NSError *error) {
        DLog(@"error == %@", error);
        // 提示框
//        YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
//            DLog(@"输入内容：%@", inputText);
//        }];
//        YZPromptController.IDStr = @"审核不通过";
//        [self presentViewController:YZPromptController animated:YES completion:nil];
        [MBProgressHUD showAutoMessage:@"审核失败, 请检查您的网络连接"];
        // 停止定时器
        [weakSelf.timer invalidate];
        // 关闭进度加载页面
        LKHideBubble();
    }];
}


#pragma mark - 数据请求上传图片接口
- (void)loadDataUploadPhoto: (UIImage *)image Key:(NSString *)key I:(NSInteger) i {
    
    self.webpData = UIImageJPEGRepresentation(image, 0.4);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    self.fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"jpgImage"];
    [self.webpData  writeToFile:self.fullPathToFile atomically:NO];
    uint64_t fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.fullPathToFile error:nil] fileSize];
    NSString *filesize =  [NSString stringWithFormat:@"JPG format file size: %.2f KB at %.f%% quality", (double)fileSize/1024, 100.0];
    DLog(@"-=-=-=-=============%@========", filesize);
    
    YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
    NSString* filepath = self.fullPathToFile;
    NSDictionary* param1 = @{@"uid":model.uid,@"token":model.token,@"tid":self.tid, @"tag":key};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 6;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    [manager POST:TASK_UPLOAD_URL parameters:param1 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //文件部分
        NSString *filename = [filepath lastPathComponent];
        [formData appendPartWithFileData:self.webpData name:@"uploadfile" fileName:[filename stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"发送成功");
        
        if (_num == 0) {
            // 关闭进度加载页面
            LKHideBubble();
        }
        
        DLog(@"responseObject == %@", responseObject);
        NSString * code = responseObject[@"code"];
        if ([code integerValue] == 0) {
            
            // 记载进度
//            YZBubbleInfo *iconInfo = [[YZBubbleInfo alloc] init];
//            // 把图标数组里面设置只有一张图片即可单图固定图标
//            iconInfo.iconArray = @[[UIImage imageNamed: @"YZPromptSubmit1"]];
//            iconInfo.backgroundColor = [UIColor colorWithRed: 0.95 green:0.95 blue:0.95 alpha:1];
//            iconInfo.titleColor = [UIColor darkGrayColor];
//            iconInfo.locationStyle = BUBBLE_LOCATION_STYLE_CENTER;
//            iconInfo.layoutStyle = BUBBLE_LAYOUT_STYLE_ICON_LEFT_TITLE_RIGHT;
//            iconInfo.title = [NSString stringWithFormat:@"照片上传中 %ld/%lu", _num, [_IDDic allKeys].count];
//            iconInfo.proportionOfDeviation = 0.05;
//            iconInfo.bubbleSize = CGSizeMake(280*YZAdapter, 90*YZAdapter);
//            // 显示控件
//            LKShowBubbleInfo(iconInfo);
            
            NSString *Title = [NSString stringWithFormat:@"照片上传中 %ld/%lu", _num, [_IDDic allKeys].count];;
            LKWaitBubble(Title);
            
            _num = _num + 1;
            
            DLog(@"=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=%@", key);
            
            if (_num == [_IDDic allKeys].count) {

                [self editRequest];
            }
        }else if ([code integerValue] == 900102) {
            // 关闭进度加载页面
            LKHideBubble();
            
            _numError = _numError+1;
            if (_numError == 1) {
                [MBProgressHUD showAutoMessage:@"登录信息失效"];                
                YZLoginViewController * vc = [[YZLoginViewController alloc]init];
                YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
                vc.AlertPhone = model.Usre_Phone;
                
                [[YZUserInfoManager sharedManager] didLoginOut];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if ([code integerValue] == 202004) {
            // 关闭进度加载页面
            LKHideBubble();
            
            [MBProgressHUD showAutoMessage:@"图片类型无效，必须为JPG/PNG/WEBP"];
//            LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"图片类型无效，必须为JPG/PNG/WEBP" BubbleImage:@"YZPromptSubmit"], 1);

        }else {
            // 关闭进度加载页面
            LKHideBubble();
            
            _numError = _numError+1;
            if (_numError == 1) {
                // 关闭进度加载页面
                [MBProgressHUD showAutoMessage:@"发送失败, 请重试"];
            }
            
//            LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"发送失败" BubbleImage:@"YZPromptSubmit"], 1);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 关闭进度加载页面
        LKHideBubble();
        
        DLog(@"发送失败");
        _numError = _numError+1;
        if (_numError == 1) {
            // 关闭进度加载页面
            [MBProgressHUD showAutoMessage:@"发送失败, 请检查您的网络连接"];
        }
//        LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"发送失败, 请检查您的网络连接" BubbleImage:@"YZPromptSubmit"], 1);
    }];
}

#pragma mark - 提交审核
- (void)editRequest {
    
    _num = 0;
    
    YZALLService *TaskSubmitRequest = [YZALLService zwb_requestWithUrl:TASK_SUBMIT_URL isPost:YES];
    
    TaskSubmitRequest.tid = self.tid;
    TaskSubmitRequest.note = self.YZPlaceholderView.text;
    TaskSubmitRequest.point = self.point;
    
    WeakSelf(self);
    
    [TaskSubmitRequest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
        DLog(@"%@", message);
        if (success) {
            
            DLog(@"return success:%@", responseObject);
            NSString * code = responseObject[@"code"];
            if ([code integerValue] == 0) {
                weakSelf.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(requestTaskStatus) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];
                
                NSDictionary *ShareDic = responseObject[@"data"];
                
                self.share_title = ShareDic[@"share_title"];
                self.share_content = ShareDic[@"share_content"];
                self.share_pic = ShareDic[@"share_pic"];
                self.share_link = ShareDic[@"share_link"];
                
                
                // 记载进度
//                YZBubbleInfo *iconInfo = [[YZBubbleInfo alloc] init];
//                // 把图标数组里面设置只有一张图片即可单图固定图标
//                iconInfo.iconArray = @[[UIImage imageNamed: @"YZPromptSubmit1"]];
//                iconInfo.backgroundColor = [UIColor colorWithRed: 0.95 green:0.95 blue:0.95 alpha:1];
//                iconInfo.titleColor = [UIColor darkGrayColor];
//                iconInfo.locationStyle = BUBBLE_LOCATION_STYLE_CENTER;
//                iconInfo.layoutStyle = BUBBLE_LAYOUT_STYLE_ICON_LEFT_TITLE_RIGHT;
//                iconInfo.title = @"正在审核中";
//                iconInfo.proportionOfDeviation = 0.05;
//                iconInfo.bubbleSize = CGSizeMake(280*YZAdapter, 90*YZAdapter);
//                // 显示控件
//                LKShowBubbleInfo(iconInfo);
                
                LKWaitBubble(@"正在审核中");
                
            }else if ([code integerValue] == 900102) {
                // 关闭进度加载页面
                LKHideBubble();
                
                [MBProgressHUD showAutoMessage:@"登录信息失效"];
//                LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"登录信息失效" BubbleImage:@"YZPromptSubmit"], 1);
                
                YZLoginViewController * vc = [[YZLoginViewController alloc]init];
                YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
                vc.AlertPhone = model.Usre_Phone;
                
                [[YZUserInfoManager sharedManager] didLoginOut];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([code integerValue] == 204001) {
                // 关闭进度加载页面
                LKHideBubble();
                
                [MBProgressHUD showAutoMessage:@"任务ID错误"];
//                LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"任务ID错误" BubbleImage:@"YZPromptSubmit"], 1);
                
            }else if ([code integerValue] == 204002) {
                // 关闭进度加载页面
                LKHideBubble();
                
                [MBProgressHUD showAutoMessage:@"坐标错误"];
//                LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"坐标错误" BubbleImage:@"YZPromptSubmit"], 1);
            }
            
        } else {
            DLog(@"return failure");
            // 关闭进度加载页面
            LKHideBubble();
            
            [MBProgressHUD showAutoMessage:@"提交失败"];
//            LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"提交失败" BubbleImage:@"YZPromptSubmit"], 1);
        }
    } failure:^(NSError *error) {
        // 关闭进度加载页面
        LKHideBubble();
        
        DLog(@"error == %@", error);
        [MBProgressHUD showAutoMessage:@"提交失败"];
//        LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"提交失败" BubbleImage:@"YZPromptSubmit"], 1);
    }];
}

#pragma mark - 点击进入证件信息照片上传示例页面
- (void)handdlePromptImage {
    
    YZSampleViewController *YZSampleController = [YZSampleViewController new];    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        YZSampleController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    YZSampleController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:YZSampleController animated:NO completion:nil];
    
}

#pragma mark - 点击进入车辆四面照片上传示例页面
- (void)handdleAllAroundImage {
    
    
    
}

#pragma mark - 点击进入车辆损坏照片上传示例页面
- (void)handdleDamageImage {
    
    
}

#pragma mark - 点击进入其他情况说明上传示例页面
- (void)handdleInstructionsImage {
    
    
    
}

- (void)handdleOtherAroundImage {
    
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