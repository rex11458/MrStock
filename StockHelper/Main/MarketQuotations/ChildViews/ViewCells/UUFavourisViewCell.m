//
//  UUFavourisViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFavourisViewCell.h"
#import "UUFavourisStockModel.h"
@interface UUFavourisViewCell ()


@end

@implementation UUFavourisViewCell


- (void)setStockModel:(UUFavourisStockModel *)stockModel
{
    if (stockModel == nil) {
        return;
    }
    _stockModel = stockModel;
    [self fillData];
}

- (void)fillData
{
    NSString *stockCode = _stockModel.code.length <= 6 ? _stockModel.code : [_stockModel.code substringToIndex:6];
    
    _stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",_stockModel.name,stockCode];
    
    if ([_stockModel.price floatValue] == 0) {

        _stockPriceLabel.text = @"--";
        _markUpLabel.text = @"--";
        _markUpLabel.textColor = k_EQUAL_COLOR;
    }
    else
    {
        
        _stockPriceLabel.text = _stockModel.price;
        
        
        CGFloat rate = [_stockModel.deltaRate floatValue]*100;
        NSString *rateString = [NSString stringWithFormat:@"%.2f%%",rate];
        
        if (rate == 0) {
            _markUpLabel.textColor = k_EQUAL_COLOR;
        }else if (rate < 0){
            _markUpLabel.textColor = k_UNDER_COLOR;
            
        }else{
            _markUpLabel.textColor = k_UPPER_COLOR;
            rateString = [@"+" stringByAppendingString:rateString];
        }
        
        _markUpLabel.text = rateString;
    }
}


@end
