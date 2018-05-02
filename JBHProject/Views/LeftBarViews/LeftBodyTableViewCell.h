//
//  LeftBodyTableViewCell.h
//  NewTTY
//
//  Created by 李俊恒 on 2016/11/14.
//  Copyright © 2016年 sinze. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeftBodyTableViewCell;
#import "LeftBarModel.h"
@protocol LeftBodyTableCellDelegate <NSObject>
/**
 *  @Description item选中跳转对应的控制器
 */
- (void)leftBodyButtonClicked:(LeftBodyTableViewCell *)Cell;
@end

@interface LeftBodyTableViewCell : UITableViewCell

- (void)createCellWith:(LeftBarModel *)model;
@property(nonatomic,strong)LeftBarModel * model;
@property(nonatomic,strong)UIImageView * rowImageView;
@property(nonatomic,strong)UILabel * desLabel;// 认证或者开启
@property(nonatomic,assign)BOOL isOpenList;// 是否开启听单
@property(nonatomic,weak)id<LeftBodyTableCellDelegate> leftDelegate;
@end
