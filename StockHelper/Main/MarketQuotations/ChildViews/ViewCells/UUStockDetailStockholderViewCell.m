
//
//  UUStockDetailStockholderViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/11/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailStockholderViewCell.h"

@implementation UUStockDetailStockholderViewCell

- (void)awakeFromNib
{
    _bgView.layer.borderColor = k_LINE_COLOR.CGColor;
    _bgView.layer.borderWidth = 0.5f;
}

@end
