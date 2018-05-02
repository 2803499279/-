//
//  YZNewMaterialViewController.h
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "BaseViewController.h"

#import "YZPictureViewController.h"
#import "YZCameraViewController.h"
#import "UIImage+WebP.h"
#import "YZCompleteViewController.h"
#import "YZPromptViewController.h"

@interface YZNewMaterialViewController : BaseViewController

@property(nonatomic,strong)UICollectionView *pictureCollectonView;
@property(nonatomic,strong)NSMutableArray *itemsSectionPictureArray;

@property (nonatomic, strong) NSString *point; // 获取地理位置
@property (nonatomic, strong) NSString *tid; // 获取地理位置
@property (nonatomic, strong) NSString *price; // 获取地理位置

@property (nonatomic, strong) NSString *SFZ;
@property (nonatomic, strong) NSString *JSZ;
@property (nonatomic, strong) NSString *XSZ;
@property (nonatomic, strong) NSString *BXDD;
@property (nonatomic, strong) NSString *CLZQ;
@property (nonatomic, strong) NSString *CLYQ;
@property (nonatomic, strong) NSString *CLZH;
@property (nonatomic, strong) NSString *CLYH;

@property (nonatomic, strong) NSString *CLJH;

@end
