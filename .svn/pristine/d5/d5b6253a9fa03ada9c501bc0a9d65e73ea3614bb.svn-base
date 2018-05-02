//
//  YZPictureViewController.m
//  JBHProject
//
//  Created by zyz on 2017/4/18.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZPictureViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "YZPictureCollectionViewCell.h"
#import "YZPictureAddCell.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>

@interface YZPictureViewController () <UICollectionViewDataSource,UICollectionViewDelegate,MJPhotoBrowserDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) YZPictureAddCell *addItemCell;

@property (nonatomic, strong) NSNotification * notice;

@end

@implementation YZPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemsSectionPictureArray = [[NSMutableArray alloc] init];
    
    //创建一个消息对象
    self.notice = [NSNotification notificationWithName:@"notice" object:nil userInfo:@{@"1":@"123"}];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(75*YZAdapter, 75*YZAdapter);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5*YZAdapter; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0.f*YZAdapter, 5*YZAdapter, 5.f*YZAdapter, 5*YZAdapter);
    
    //创建 UICollectionView
    self.pictureCollectonView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80*YZAdapter) collectionViewLayout:layout];
    
    [self.pictureCollectonView registerClass:[YZPictureCollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
    
    [self.pictureCollectonView registerClass:[YZPictureAddCell class] forCellWithReuseIdentifier:@"addItemCell"];
    
    self.pictureCollectonView.backgroundColor = WhiteColor;
    self.pictureCollectonView.delegate = self;
    self.pictureCollectonView.dataSource = self;
    self.pictureCollectonView.bounces = NO;
    [self.view addSubview:self.pictureCollectonView];

}

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
        
        if (self.itemsSectionPictureArray.count >= 4) {
            //发送消息
            [[NSNotificationCenter defaultCenter] postNotification:self.notice];
        }
        
        if (indexPath.row == 8) {
            self.addItemCell.addImageView.image = [UIImage imageNamed:@"1111"];
        }
        
        return cell;
    }
}

//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.itemsSectionPictureArray.count) {
        if (self.itemsSectionPictureArray.count > 8) {
            
            return;
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet showInView:self.view];
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
    NSMutableArray *cellArray = [NSMutableArray array];
    
    for (NSString *index1 in set) {
        [cellArray addObject:index1];
    }
    
    if (cellArray.count == 0) {
        
    }else if (cellArray.count == 1 && self.itemsSectionPictureArray.count == 1) {
        NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.itemsSectionPictureArray removeObjectAtIndex:indexPathTwo.row];
        [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPathTwo]];
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
            
            [self.itemsSectionPictureArray removeObjectAtIndex:indexPath.row];
            [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
    
    if (self.itemsSectionPictureArray.count >= 4) {
        //发送消息
        [[NSNotificationCenter defaultCenter] postNotification:self.notice];
    }
    
    if (self.itemsSectionPictureArray.count < 4) {
        self.pictureCollectonView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80*YZAdapter);
    }else if (self.itemsSectionPictureArray.count < 8)
    {
        self.pictureCollectonView.frame = CGRectMake(0, 0, self.view.frame.size.width, 160*YZAdapter);
    }else
    {
        self.pictureCollectonView.frame = CGRectMake(0, 0, self.view.frame.size.width, 240*YZAdapter);
    }
}

#pragma mark - 相册、相机调用方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        DLog(@"点击了从手机选择");

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
            imagePC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePC.delegate = self;
            imagePC.allowsEditing = YES;
            [self presentViewController:imagePC animated:YES completion:nil];
        } else {
            //        [MBProgressHUD showError:Localized(@"没有相册")];
        }
        
    }else if (buttonIndex == 2)
    {
        DLog(@"点击了拍照");
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            DLog(@"模拟无效,请真机测试");
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    
    [self.itemsSectionPictureArray addObject:image];
    __weak YZPictureViewController *wself = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
            if (wself.itemsSectionPictureArray.count <4) {
                wself.pictureCollectonView.frame = CGRectMake(0, 0, wself.view.frame.size.width, 80*YZAdapter);
            }else if (wself.itemsSectionPictureArray.count <8)
            {
                wself.pictureCollectonView.frame = CGRectMake(0, 0, wself.view.frame.size.width, 160*YZAdapter);
            }else
            {
                wself.pictureCollectonView.frame = CGRectMake(0, 0, wself.view.frame.size.width, 240*YZAdapter);
            }
            
            [wself.view layoutIfNeeded];
        } completion:nil];
        
        [self.pictureCollectonView performBatchUpdates:^{
            [wself.pictureCollectonView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:wself.itemsSectionPictureArray.count - 1 inSection:0]]];
        } completion:nil];
    }];
    
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
