//
//  UUStockDetailShortBriefViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/11/25.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailShortBriefViewCell.h"

@implementation UUStockDetailShortBriefViewCell

- (void)awakeFromNib
{
    _subContentView.layer.borderColor = k_LINE_COLOR.CGColor;
    _subContentView.layer.borderWidth = 0.5f;
}
@end
