//
//  YZMaterialViewController.m
//  JBHProject
//
//  Created by zyz on 2017/4/11.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZMaterialViewController.h"

@interface YZMaterialViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YZCertificateViewCell *YZCercell;
@property (nonatomic, strong) YZPictureViewController *YZPictureVC;
@property (nonatomic, strong) YZCarDamageViewCell *YZCarcell;
@property (nonatomic, strong) YZPromptViewCell *YZPromptVC;
@property (nonatomic, strong) YZInstructionsViewCell *YZInstructionsVC;
@property (nonatomic, strong) YZSubmitAuditViewCell *YZSubmitVC;
@end

@implementation YZMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customPushViewControllerNavBarTitle:@"准备材料照片" backGroundImageName:nil];
    
    // 创建UITableView,注册cell
    [self establishUITableViewAndCell];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"notice" object:nil];
    
}

-(void)notice:(id)sender{
    DLog(@"%@",sender);
    
    self.YZCarcell.contentView.frame = CGRectMake(self.YZCarcell.frame.origin.x, self.YZCarcell.frame.origin.y, self.YZPictureVC.pictureCollectonView.frame.size.width, self.YZPictureVC.pictureCollectonView.frame.size.height);
    self.YZCarcell.frame = CGRectMake(self.YZCarcell.frame.origin.x, self.YZCarcell.frame.origin.y, self.YZPictureVC.pictureCollectonView.frame.size.width, self.YZPictureVC.pictureCollectonView.frame.size.height);
    self.YZPromptVC.frame = CGRectMake(self.YZPromptVC.frame.origin.x, self.YZCarcell.frame.origin.y+self.YZPictureVC.pictureCollectonView.frame.size.height, self.YZPromptVC.frame.size.width, self.YZPromptVC.frame.size.height);
    self.YZInstructionsVC.frame = CGRectMake(self.YZInstructionsVC.frame.origin.x, self.YZCarcell.frame.origin.y+self.YZPictureVC.pictureCollectonView.frame.size.height+self.YZPromptVC.frame.size.height, self.YZInstructionsVC.frame.size.width, self.YZInstructionsVC.frame.size.height);
    self.YZSubmitVC.frame = CGRectMake(self.YZSubmitVC.frame.origin.x, self.YZCarcell.frame.origin.y+self.YZPictureVC.pictureCollectonView.frame.size.height+self.YZPromptVC.frame.size.height+self.YZInstructionsVC.frame.size.height, self.YZSubmitVC.frame.size.width, self.YZSubmitVC.frame.size.height);
   
}

#pragma marh - 创建UITableView,注册cell
- (void)establishUITableViewAndCell {
    // 创建UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Screen_W, Screen_H-64) style:(UITableViewStylePlain)];
    
    // 注册cell
    [self.tableView registerClass:[YZCertificateViewCell class] forCellReuseIdentifier:YZCERTIFICATEVIEWCELLID];
    [self.tableView registerClass:[YZIdentityViewCell class] forCellReuseIdentifier:YZIDENTITYVIEWCELLID];
    [self.tableView registerClass:[YZPromptViewCell class] forCellReuseIdentifier:YZPROMPTVIEWCELLID];
    [self.tableView registerClass:[YZCarDamageViewCell class] forCellReuseIdentifier:YZCARDAMAGEVIEWCELLID];
    [self.tableView registerClass:[YZInstructionsViewCell class] forCellReuseIdentifier:YZINSTRUCTIONSVIEWCELLID];
    [self.tableView registerClass:[YZSubmitAuditViewCell class] forCellReuseIdentifier:YZSUBMITAUDITVIEWCELLID];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 关闭tableView的自动适配布局 默认YES
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource代理方法
// 返回tabelView中section(分区)的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// 返回每个分区中cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        YZPromptViewCell *YZCercell = [tableView dequeueReusableCellWithIdentifier:YZPROMPTVIEWCELLID forIndexPath:indexPath];
        YZCercell.backgroundColor = LightFont_Color;
        return YZCercell;
        
    }else if(indexPath.row == 1) {
        
        self.YZCercell = [tableView dequeueReusableCellWithIdentifier:YZCERTIFICATEVIEWCELLID forIndexPath:indexPath];
        
        // UITapGestureRecognizer
        UITapGestureRecognizer *IdCardImagetapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleIdCardImage:)];
        // 设置轻拍触发方法时需要的点击次数
        IdCardImagetapGesture.numberOfTapsRequired = 1;
        // 设置轻拍需要的手指个数
        IdCardImagetapGesture.numberOfTouchesRequired = 1;
        // 向视图对象上添加手势
        [self.YZCercell.IdCardImage addGestureRecognizer:IdCardImagetapGesture];
        
        
        return self.YZCercell;
    }else if (indexPath.row == 2) {
        YZIdentityViewCell *YZCercell = [tableView dequeueReusableCellWithIdentifier:YZIDENTITYVIEWCELLID forIndexPath:indexPath];
        
        return YZCercell;
    }else if (indexPath.row == 3){
        
        YZPromptViewCell *YZCercell = [tableView dequeueReusableCellWithIdentifier:YZPROMPTVIEWCELLID forIndexPath:indexPath];
        YZCercell.backgroundColor = LightFont_Color;
        // 不同文字字体的颜色
        NSMutableAttributedString *CertificateNamestring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @"车辆四面照片"] attributes:nil];
        [CertificateNamestring addAttribute:NSForegroundColorAttributeName value:MainFont_Color range:NSMakeRange(0, 6)];
        [CertificateNamestring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 6)];
        YZCercell.PromptLabel.attributedText = CertificateNamestring;
        return YZCercell;
    }else if (indexPath.row == 4){
        
    }else if (indexPath.row == 5){
        
        YZPromptViewCell *YZCercell = [tableView dequeueReusableCellWithIdentifier:YZPROMPTVIEWCELLID forIndexPath:indexPath];
        YZCercell.backgroundColor = LightFont_Color;
        // 不同文字字体的颜色
        NSMutableAttributedString *CertificateNamestring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", @"车辆损坏照上传",  @"(请尽可能多角度拍摄)"] attributes:nil];
        [CertificateNamestring addAttribute:NSForegroundColorAttributeName value:MainFont_Color range:NSMakeRange(0, 7)];
        [CertificateNamestring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 7)];
        YZCercell.PromptLabel.attributedText = CertificateNamestring;
        return YZCercell;
    }else if (indexPath.row == 6){
        
        self.YZCarcell = [tableView dequeueReusableCellWithIdentifier:YZCARDAMAGEVIEWCELLID forIndexPath:indexPath];
        
        self.YZPictureVC = [[YZPictureViewController alloc] init];
        [self addChildViewController:self.YZPictureVC];
        self.YZCarcell.contentView.frame = self.YZPictureVC.view.frame;
        [self.YZCarcell.contentView addSubview:self.YZPictureVC.pictureCollectonView];
        self.YZCarcell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.YZCarcell;
        
    }else if (indexPath.row == 7){
        
        self.YZPromptVC = [tableView dequeueReusableCellWithIdentifier:YZPROMPTVIEWCELLID forIndexPath:indexPath];
        self.YZPromptVC.backgroundColor = LightFont_Color;
        // 不同文字字体的颜色
        NSMutableAttributedString *CertificateNamestring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@", @"其他情况说明",  @"(可留空)"] attributes:nil];
        [CertificateNamestring addAttribute:NSForegroundColorAttributeName value:MainFont_Color range:NSMakeRange(0, 7)];
        [CertificateNamestring addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(0, 7)];
        self.YZPromptVC.PromptLabel.attributedText = CertificateNamestring;
        return self.YZPromptVC;
    }else if (indexPath.row == 8){
        
        self.YZInstructionsVC = [tableView dequeueReusableCellWithIdentifier:YZINSTRUCTIONSVIEWCELLID forIndexPath:indexPath];
        
        self.YZInstructionsVC.placeholderView.delegate = self;
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
            
            self.automaticallyAdjustsScrollViewInsets = NO;
            
        }
        
        return self.YZInstructionsVC;
    }else if (indexPath.row == 9){
        self.YZSubmitVC = [tableView dequeueReusableCellWithIdentifier:YZSUBMITAUDITVIEWCELLID forIndexPath:indexPath];
        self.YZSubmitVC.backgroundColor = LightFont_Color;
        
        [self.YZSubmitVC.SubmitAudit addTarget:self action:@selector(handleSubmitAudit) forControlEvents:UIControlEventTouchUpInside];
        
        return self.YZSubmitVC;
    }
    YZCertificateViewCell *YZCercell = [tableView dequeueReusableCellWithIdentifier:YZCERTIFICATEVIEWCELLID forIndexPath:indexPath];
    
    return YZCercell;
}

//#pragma mark - 点击cell
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.row == 6){
////        if (self.YZPictureVC.itemsSectionPictureArray.count >= 4) {
//
//        self.YZCarcell.contentView.frame = CGRectMake(self.YZCarcell.frame.origin.x, self.YZCarcell.frame.origin.y, self.YZPictureVC.pictureCollectonView.frame.size.width, self.YZPictureVC.pictureCollectonView.frame.size.height*2);
//        self.YZCarcell.frame = CGRectMake(self.YZCarcell.frame.origin.x, self.YZCarcell.frame.origin.y, self.YZPictureVC.pictureCollectonView.frame.size.width, self.YZPictureVC.pictureCollectonView.frame.size.height*2);
//        self.YZPromptVC.frame = CGRectMake(self.YZPromptVC.frame.origin.x, self.YZCarcell.frame.origin.y+self.YZPictureVC.pictureCollectonView.frame.size.height*2, self.YZPromptVC.frame.size.width, self.YZPromptVC.frame.size.height);
////        }
//        
//    }
//}


#pragma mark -  返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row ==0 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7) {
        
        return 50*YZAdapter;
    }else if (indexPath.row == 1 || indexPath.row == 4){
        
        return 145*YZAdapter;
    }else if (indexPath.row == 2){
        return 120*YZAdapter;
    }else if (indexPath.row == 6) {
        return 100*YZAdapter;
    }else if (indexPath.row == 8) {
        return 100*YZAdapter;
    }else {
        return 66*YZAdapter;
    }
}

#pragma mark -  去掉cell左侧空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITextViewDelegate键盘管理和字数限制
- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger number = [textView.text length];
    
    if (number > 200) {
        
        textView.text = [textView.text substringToIndex:200];
        
        number = 200;
        
//        [MBProgressHUD showMessage:@"Loading..." ToView:nil];
//        MBProgressHUD *hud = [MBProgressHUD getMBProgressHUDWithView:nil];
//        hud.mode = MBProgressHUDModeText;
//        hud.label.text = @"超过字数限制";
//        [MBProgressHUD hideHUD:hud afterDelay:1];
        
    }
}

#pragma mark - 点击进入派单完成页面
- (void)handleSubmitAudit {
    
    // 提示框
//    YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
//        DLog(@"输入内容：%@", inputText);
//    }];
//    YZPromptController.IDStr = @"审核不通过";
//    [self presentViewController:YZPromptController animated:YES completion:nil];
    
//    YZCompleteViewController *YZCompleteController = [[YZCompleteViewController alloc] init];
//    [self.navigationController pushViewController:YZCompleteController animated:YES];
    
    YZLoginViewController *YZLoginController = [[YZLoginViewController alloc] init];
    [self.navigationController pushViewController:YZLoginController animated:YES];
    
    /*
    // 加载页面
    LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"等待受理中" BubbleImage:@"YZPromptSubmit"], 2);
    // 显示控件
    //    LKShowBubbleInfo(iconInfo);
    // 隐藏控件
    //    LKHideBubble();
     */
}

// 添加图片
- (void)handleIdCardImage:(id) sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self pickerImageFromCamera];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self pickerImageFromPhotoLibrary];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        nil;
    }];
    // 把事件对象添加到试图控制器alertVC上
    // (按照添加样式显示  但是取消一直在最下面 且只能由一个Cancel样式)
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    // 模态出提醒框 (自己不需要回收,按钮回自动回收实现 dismiss)
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 使用相机获取图片
- (void)pickerImageFromCamera {
    
    YZCameraViewController *VC = [YZCameraViewController new];
    [self presentViewController:VC animated:YES completion:nil];
    
}

// 代理方法
// 选择好图片之后这个方法就会触发
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // info中存储的就是我们想要的图片资源
    self.YZCercell.IdCardImage.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //如果采自于摄像头（注意模拟器产生异常）
        
    }
    
    //    [self scaleImage:self.oneButton.image toScale:0.01];
    
    UIGraphicsBeginImageContext(CGSizeMake(self.YZCercell.IdCardImage.image.size.width*0.1,self.YZCercell.IdCardImage.image.size.height*0.1));
    [self.YZCercell.IdCardImage.image drawInRect:CGRectMake(0,0, self.YZCercell.IdCardImage.image.size.width*0.1, self.YZCercell.IdCardImage.image.size.height*0.1)];
    self.YZCercell.IdCardImage.image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //    DLog(@"%@",NSStringFromCGSize(scaledImage.size));
    //    return scaledImage;
    
    NSData* imageData = UIImagePNGRepresentation(self.YZCercell.IdCardImage.image);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"IDImage"];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 从相册中获取图片
- (void)pickerImageFromPhotoLibrary {
    // 图片选择视图控制器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 图片来源
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 是否允许编辑
    picker.allowsEditing = YES;
    // 设置代理
    picker.delegate = self;
    // 模态出视图
    [self presentViewController:picker animated:YES completion:nil];
    
}
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSData *imageData = UIImagePNGRepresentation(tempImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

- (NSString *)documentFolderPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
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
