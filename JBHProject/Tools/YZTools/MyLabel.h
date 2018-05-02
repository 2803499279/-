//
//  MyLabel.h
//  JBHProject
//
//  Created by zyz on 2018/1/10.
//  Copyright © 2018年 聚宝汇. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum {
    VerticalAlignmentTop = 0, //default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
    
} VerticalAlignment;

@interface MyLabel : UILabel {
    
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
