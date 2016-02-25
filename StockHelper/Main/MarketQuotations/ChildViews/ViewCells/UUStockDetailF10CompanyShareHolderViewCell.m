//
//  UUStockDetailF10CompanyShareHolderViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailF10CompanyShareHolderViewCell.h"

@interface UUStockDetailF10CompanyShareHolderViewCell ()
{
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UILabel *_accesoryLabel;
}
@end

@implementation UUStockDetailF10CompanyShareHolderViewCell


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
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = @"哈尔滨电器集团公司";
    

    _contentLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont systemFontOfSize:14.0f] textColor:k_BIG_TEXT_COLOR];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_contentLabel];
    
    _contentLabel.text = @"1.3亿";
    
    
    _accesoryLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont systemFontOfSize:14.0f] textColor:k_BIG_TEXT_COLOR];
    _accesoryLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_accesoryLabel];
    
    _accesoryLabel.text = @"21.235%";
}


- (void)layoutSubviews
{
    _titleLabel.frame = CGRectMake(18, 0, 125.0f - 18.0f, CGRectGetHeight(self.bounds));
    
    _contentLabel.frame = CGRectMake(169.0f, 0,100.0f, CGRectGetHeight(self.bounds));
    _accesoryLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - 100 - k_LEFT_MARGIN, 0,100.0f, CGRectGetHeight(self.bounds));
}
@end
