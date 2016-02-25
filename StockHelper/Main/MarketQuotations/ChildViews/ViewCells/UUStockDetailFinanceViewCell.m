//
//  UUStockDetailFinanceViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/11/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailFinanceViewCell.h"

@implementation UUStockDetailFinanceViewCell

- (void)awakeFromNib
{
    _subContentView.layer.borderColor = k_LINE_COLOR.CGColor;
    _subContentView.layer.borderWidth = 0.5f;
}

@end


@implementation UUStockDetailFinanceHeaderView

- (void)awakeFromNib
{
    self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
