//
//  UURemindButton.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UURemindButton.h"

@implementation UURemindButton

- (void)setFrame:(CGRect)frame
{
    [self addRemindImageView];

    [super setFrame:frame];
    
}

- (void)addRemindImageView
{
    UIImage *image = [UIImage imageNamed:@"Me_fans_remaind"];
    
    _remindImageView = [[UIImageView alloc] initWithImage:image];
    _remindImageView.hidden = YES;
    [self addSubview:_remindImageView];
}

- (void)setShowRemind:(BOOL)showRemind
{
    _showRemind = showRemind;
    _remindImageView.hidden = !_showRemind;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _remindImageView.center = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(_remindImageView.frame) * 0.5, CGRectGetHeight(_remindImageView.frame) * 0.5);
}

@end
