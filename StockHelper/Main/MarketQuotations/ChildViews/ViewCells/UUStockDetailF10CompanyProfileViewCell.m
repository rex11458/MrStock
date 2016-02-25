//
//  UUStockDetailF10CompanyProfileViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailF10CompanyProfileViewCell.h"

@interface UUStockDetailF10CompanyProfileViewCell ()
{
    UILabel *_titleLabel;
    UILabel *_contentLabel;
}
@end

@implementation UUStockDetailF10CompanyProfileViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _titleLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont systemFontOfSize:14.0f] textColor:[UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f]];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _titleLabel.text = @"公司名称:";

    
    _contentLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont systemFontOfSize:14.0f] textColor:k_BIG_TEXT_COLOR];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_contentLabel];
    
    _contentLabel.text = @"上海宝钢包装股份有限公司";
}


- (void)layoutSubviews
{
    _titleLabel.frame = CGRectMake(0, 0, 90.0f, CGRectGetHeight(self.bounds));
    
    _contentLabel.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame), 0,CGRectGetWidth(self.bounds) - CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(self.bounds));
    
}

@end
