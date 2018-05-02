//
//  YZBubbleInfo+Start.m
//  JBHProject
//
//  Created by zyz on 2017/4/14.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZBubbleInfo+Start.h"

@implementation YZBubbleInfo (Start)

+ (YZBubbleInfo *) StartBubbleTitle: (NSString *)Title BubbleImage:(NSString *) bubbleimage{
    
    YZBubbleInfo *iconInfo = [[YZBubbleInfo alloc] init];
    // 把图标数组里面设置只有一张图片即可单图固定图标
    iconInfo.iconArray = @[[UIImage imageNamed: bubbleimage]];
//    NSMutableArray<UIImage *> *icons = [[NSMutableArray alloc] init];
//    for (int i = 1 ; i <= 4; i ++) {
//        [icons addObject: [UIImage imageNamed: [NSString stringWithFormat: @"YZPromptSubmit%d" , i]]];
//    }
//    iconInfo.iconArray = icons;
//    // 在数组中依次放入多张图片即可实现多图循环播放
//    iconInfo.backgroundColor = [UIColor colorWithRed: 238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
//    // 动画的帧动画播放间隔
//    iconInfo.frameAnimationTime = 0.15;
    
    iconInfo.backgroundColor = WhiteColor;
    iconInfo.titleColor = MainFont_Color;
    iconInfo.locationStyle = BUBBLE_LOCATION_STYLE_CENTER;
    iconInfo.layoutStyle = BUBBLE_LAYOUT_STYLE_ICON_LEFT_TITLE_RIGHT;
    iconInfo.title = Title;
    iconInfo.proportionOfDeviation = 0.05;
    iconInfo.bubbleSize = CGSizeMake(280*YZAdapter, 90*YZAdapter);
    
    return iconInfo;
}

@end
