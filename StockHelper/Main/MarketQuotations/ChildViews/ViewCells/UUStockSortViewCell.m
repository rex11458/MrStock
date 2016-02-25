//
//  UUStockSortViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/11/21.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockSortViewCell.h"
#import "UUReportSortStockModel.h"
@implementation UUStockSortViewCell

- (void)setStockModel:(UUReportSortStockModel *)stockModel
{
    if (stockModel == nil || _stockModel == stockModel) {
        return;
    }
    _stockModel = stockModel;
    [self fillStockSortData];
}


- (void)fillStockSortData
{
    _nameLabel.text = [NSString stringWithFormat:@"%@(%@)",_stockModel.name,_stockModel.code];
    
    double upRaiseRate = _stockModel.value;
    if (_type == UUExchangeRateType) {
        upRaiseRate *= 10;
    }

    NSString *rate = [NSString stringWithFormat:@"%.2f%%",upRaiseRate];
    //文字颜色色
    UIColor *color = k_EQUAL_COLOR;
    if (upRaiseRate > 0){
        color = k_UPPER_COLOR;
        if (_type != UUExchangeRateType) {
            rate = [@"+" stringByAppendingString:rate];
        }
    }else if(upRaiseRate < 0){
        color = k_UNDER_COLOR;
    }
    
    NSMutableAttributedString *markUpRateString = [[NSMutableAttributedString alloc] initWithString:rate];
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName : color
                                 };
        [markUpRateString setAttributes:attributes range:NSMakeRange(0, 1)];

    _rateLabel.attributedText = markUpRateString;
    _rateLabel.textColor = color;

    
    _priceLabel.text = [NSString amountValueWithDouble:_stockModel.newPrice];
}

@end
