//
//  MycenterHeaderView.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/8/23.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MycenterHeaderViewDelegate <NSObject>
/**
 *  @Description item跳转到钱包界面
 *  @sender 点击的立即抢单按钮
 */
- (void)didSelectedpushMyAccount:(UIButton *)sender;
/**
 * 跳转到个人中心
 */
- (void)didSelectedpushUserCenter:(UIButton *)sender;
@end

@interface MycenterHeaderView : UIView

@property(nonatomic,strong)UIButton * userIcon;// 用户头像
@property(nonatomic,strong)UIImageView * userImage;// 用户头像
@property(nonatomic,strong)UIButton * userName;// 用户名
@property(nonatomic,strong)UIButton * userPhoneNumber;//电话号


@property(nonatomic,strong)NSArray * dataSoucesArray;
@property(nonatomic,weak)id<MycenterHeaderViewDelegate> myCenterViewDelegate;
@end
