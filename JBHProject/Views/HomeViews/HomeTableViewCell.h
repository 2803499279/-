//
//  HomeTableViewCell.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZOrderModel.h"
@class HomeTableViewCell;
@protocol HomeTableViewCellDelegate <NSObject>
/**
 *  @Description item选中跳转对应的控制器
 *  @sender 点击的立即抢单按钮
 */
- (void)didSelectedHomeTableViewcell:(HomeTableViewCell *)cell;
@end

@interface HomeTableViewCell : UITableViewCell
@property(nonatomic,strong)YZOrderModel * cellModel;
@property(nonatomic,assign)BOOL isAddHeight;
//@property(nonatomic,strong)UIButton * immediatelyBtn;// 立即抢单
+ (CGFloat)HomeCellHeightWithModel:(YZOrderModel *)model;
@property(nonatomic,weak)id<HomeTableViewCellDelegate> homeTableViewCellDelegate;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *BID;

@property (nonatomic, strong) UIImageView *NameImg;
@property (nonatomic, strong) UILabel *Name;
@property (nonatomic, strong) UILabel *Nam;

@property (nonatomic, strong) UIImageView *PhoneImg;
@property (nonatomic, strong) UILabel *Phone;
@property (nonatomic, strong) UILabel *Phon;

@property (nonatomic, strong) UIImageView *CarImg;
@property (nonatomic, strong) UILabel *Car;
@property (nonatomic, strong) UILabel *Ca;

@property (nonatomic, strong) UIImageView *CarNumImg;
@property (nonatomic, strong) UILabel *CarNum;
@property (nonatomic, strong) UILabel *CarNu;

@property (nonatomic, strong) UIImageView *CompanyImg;
@property (nonatomic, strong) UILabel *Company;
@property (nonatomic, strong) MyLabel *Compan;

@property (nonatomic, strong) UIImageView *AddressImg;
@property (nonatomic, strong) UILabel *Address;
@property (nonatomic, strong) MyLabel *Addres;

@property (nonatomic, strong) UIView *RapView;

@property (nonatomic, strong) UIButton *RapBut;



@end
