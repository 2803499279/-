//
//  YZPictureAddCell.m
//  JBHProject
//
//  Created by zyz on 2017/4/18.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZPictureAddCell.h"

@implementation YZPictureAddCell

- (void)dealloc
{
    self.addImageView = nil;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.addImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.addImageView];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.addImageView.frame = CGRectMake(0, 0, 75*YZAdapter, 75*YZAdapter);
    self.addImageView.layer.cornerRadius = 2.0*YZAdapter;
    self.addImageView.layer.masksToBounds = YES;
    self.addImageView.image = [UIImage imageNamed:@"YZBackCarImage"];
    
    
}


@end
