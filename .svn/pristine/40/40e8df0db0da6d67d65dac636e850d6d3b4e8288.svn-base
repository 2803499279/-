//
//  YZPictureCollectionViewCell.m
//  JBHProject
//
//  Created by zyz on 2017/4/18.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZPictureCollectionViewCell.h"

@implementation YZPictureCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.imageView = [[UIImageView alloc] init];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 75*YZAdapter, 75*YZAdapter);
}


@end
