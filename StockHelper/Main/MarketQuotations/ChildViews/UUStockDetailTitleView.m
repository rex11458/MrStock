//
//  UUStockDetailTitleView.m
//  StockHelper
//
//  Created by LiuRex on 15/6/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailTitleView.h"

@interface UUStockDetailTitleView ()
{
    UILabel *_titleLabel;
    UILabel *_accsesoryLabel;
}
@end

@implementation UUStockDetailTitleView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self configSubViews];
    }
    
    return self;
}

- (void)configSubViews
{

    UILabel *titleLabel = [UIKitHelper labelWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) , 24.0f) Font:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0] textColor:[UIColor whiteColor]];
//    titleLabel.text = @"上证指数(000001)";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *accesoryLabel = [UIKitHelper labelWithFrame:CGRectMake(0,CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(self.bounds) , 20.0f) Font:[UIFont systemFontOfSize:12.0f] textColor:[UIColor whiteColor]];
//    accesoryLabel.text = @"已收盘 06-12 15:00:00";
    accesoryLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:accesoryLabel];
    _accsesoryLabel = accesoryLabel;
}

- (void)layoutSubviews
{
    _titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) , 24.0f);
    _accsesoryLabel.frame = CGRectMake(0,CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(self.bounds) , 20.0f);
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setAccesoryTitle:(NSString *)accesoryTitle
{
    _accesoryTitle = accesoryTitle;
    _accsesoryLabel.text = accesoryTitle;
    
}

@end
