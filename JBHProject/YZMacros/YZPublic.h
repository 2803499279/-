//
//  YZPublic.h
//  JBHProject
//
//  Created by zyz on 2017/4/27.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#ifndef YZPublic_h
#define YZPublic_h

/**********************YZ自定义的常用宏*************************/
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

// **********************比例尺寸*************************
#define  YZAdapter Screen_W/375  //(iPhone 6基准尺寸)


// **********************颜色*************************
#define YZColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
/**
 *字体颜色
 */
// 主色字 33 33 33
#define MainFont_Color [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
// 次主色字 66 66 66
#define TimeMainFont_Color [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
// 次色字 99 99 99
#define TimeFont_Color [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]

// 淡色字
#define LightFont_Color [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]
/**
 *按钮颜色
 */
// 绿色
#define GreenButton_Color [UIColor colorWithRed:26/255.0 green:172/255.0 blue:25/255.0 alpha:1.0]
// 黑色
#define BlackButton_Color [UIColor colorWithRed:38/255.0 green:42/255.0 blue:52/255.0 alpha:1.0]
// 白色
#define WhiteColor [UIColor whiteColor]
// 黄色
#define Yellow_Color [UIColor colorWithRed:227/255.0 green:113/255.0 blue:0/255.0 alpha:1.0]
// 红色
#define Red_Color [UIColor colorWithRed:244/255.0 green:67/255.0 blue:54/255.0 alpha:1.0]

// 新绿色
#define NewGreenButton_Color [UIColor colorWithRed:47/255.0 green:208/255.0 blue:189/255.0 alpha:1.0]



/**
 *边框颜色
 */
// 主色边框
#define MainLine_Color [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1.0]
// 次色边框
#define LightLine_Color [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]
/**
 *页面背景颜色
 */
#define BackGround_Color [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]

// **********************字体大小*************************
/**
 *字体大小
 */
#define FONT(s) [UIFont systemFontOfSize:(s*YZAdapter)]
#define FONTS(s) [UIFont boldSystemFontOfSize:(s*YZAdapter)]
//中文字体
#define CHINESE_FONT_NAME  @"Heiti SC"
#define CHINESE_SYSTEM(x) [UIFont fontWithName:CHINESE_FONT_NAME size:x]



// **********************迅赔颜色************************
// 导航条背景色
#define YZBackNavColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]
// 分割线颜色
#define YZDivisionColor [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0]
// 主色调颜色
#define YZEssentialColor [UIColor colorWithRed:255/255.0 green:95/255.0 blue:16/255.0 alpha:1.0]
// 次主色调颜色
#define YZLesserEssentialColor [UIColor colorWithRed:254/255.0 green:105/255.0 blue:0/255.0 alpha:1.0]
// 淡主色调颜色
#define YZThinEssentialColor [UIColor colorWithRed:255/255.0 green:153/255.0 blue:102/255.0 alpha:1.0]
// 蓝色
#define YZNewBlueColor [UIColor colorWithRed:52/255.0 green:179/255.0 blue:219/255.0 alpha:1.0]

// 页面颜色一
#define YZNewPageOneColor [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1.0]
// 页面颜色二
#define YZNewPageTwoColor [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0]
// 页面颜色三
#define YZNewPageThereColor [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]

#endif /* YZPublic_h */
