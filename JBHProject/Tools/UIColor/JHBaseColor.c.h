//
//  JHBaseColor.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/10.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>

#define perColor(z) z/255.0

struct JHColor{
    CGFloat JHRed;
    CGFloat JHGreen;
    CGFloat JHBlue;
    CGFloat JHAlph;
};
typedef struct JHColor JHColor;


//JHBaseBuleColor 具体参数
JHColor const jhBaseBuleColor ={
    perColor(55),
    perColor(168),
    perColor(225),
    1.0
};



JHColor const jhTodoCellTitleGary ={
    perColor(98),
    perColor(98),
    perColor(98),
    1.0
};

JHColor const jhTodoCellContentGray ={
    perColor(180),
    perColor(180),
    perColor(180),
    1.0
};

JHColor const jhTodoCellBackBlue ={
    perColor(244),
    perColor(251),
    perColor(255),
    1.0
};
//89 183 175新色调
JHColor const jhSureGreen ={
//    perColor(26),
//    perColor(172),
//    perColor(25),
//    1.0 绿色
    perColor(88),
    perColor(185),
    perColor(175),
    1.0
};

JHColor const jhUserInfoBlack ={
    perColor(102),
    perColor(102),
    perColor(102),
    1.0
};

JHColor const jhCancelRed ={
    perColor(232),
    perColor(98),
    perColor(98),
    1.0
};

JHColor const jhUserInfoContentBlue ={
    perColor(46),
    perColor(165),
    perColor(225),
    1.0
};

JHColor const jhUserInfoMarginGray ={
    perColor(153),
    perColor(153),
    perColor(153),
    1.0
};
/**
 * 导航蓝颜色
 */
JHColor const jhNavigationColor ={
    perColor(39),
    perColor(42),
    perColor(52),
    1.0
};
/**
 * 背景色
 */
JHColor const jhBackGroundColor ={
    perColor(238),
    perColor(238),
    perColor(238),
    1.0
};
/**
 * 按钮橙色
 */
JHColor const jhBaseOrangeColor ={
    perColor(227),
    perColor(113),
    perColor(0),
    1.0
};
