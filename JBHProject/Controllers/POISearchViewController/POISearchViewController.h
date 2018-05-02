//
//  POISearchViewController.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/14.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "BaseViewController.h"
#import "POISearchModel.h"

@protocol POISearchViewControllerDelegate <NSObject>
/**
 *  @Description 选中cell后发送model信息
 *  @sender 点击的位置信息的Model
 */
- (void)POISearchViewcellSenderInfo:(POISearchModel *)model;
@end
@interface POISearchViewController : BaseViewController
@property (nonatomic,strong)UISwipeGestureRecognizer * recoginzerDown;// 下滑手势
@property (nonatomic,strong)UISwipeGestureRecognizer * recoginzerUp;// 上滑手势
@property(nonatomic,weak)id<POISearchViewControllerDelegate>delegate;
@property(nonatomic,assign)BOOL isLocated;
@property(nonatomic,copy)NSString * locationPointStr;
@property(nonatomic,assign)BOOL isSelectedCell;
/**
 * 选中的位置
 */
@property(nonatomic,strong)POISearchModel * selectedModel ;
@end
