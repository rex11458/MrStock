//
//  UUStockDetailCurrentPriceView.m
//  StockHelper
//
//  Created by LiuRex on 15/6/19.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailCurrentPriceView.h"
#import "UUStockDetailModel.h"

#import "UUStockTimeEntity.h"
@interface UUStockDetailCurrentPriceView ()

@end

@implementation UUStockDetailCurrentPriceView


- (void)awakeFromNib
{
    self.backgroundColor = k_BG_COLOR;
}

- (void)setDetailModel:(UUStockDetailModel *)detailModel
{
    if (detailModel == nil || _detailModel == detailModel) {
        return;
    }
    _detailModel = detailModel;
    [self loadData];
}

- (void)setPriceModelArray:(NSArray *)priceModelArray
{
    if (priceModelArray == nil || _priceModelArray == priceModelArray) {
        return;
    }
    _priceModelArray = [priceModelArray copy];
    
    [self laodCurrentPriceLabel];
}

- (void)laodCurrentPriceLabel
{
    NSArray *tempArray = _priceModelArray;
    if (_currentTimeViewArray.count < _priceModelArray.count) {
        tempArray = [_priceModelArray subarrayWithRange:NSMakeRange(_priceModelArray.count - _currentTimeViewArray.count, _currentTimeViewArray.count)];
    }
    
    for (NSInteger i = tempArray.count - 1; i >= 0; i--) {
        UUStockTimeEntity *priceModel = [tempArray objectAtIndex:i];
        UILabel *timeLabel = [_currentTimeViewArray objectAtIndex:i];
        timeLabel.text = priceModel.time;
        UILabel *amountLabel = [_currentAmountArray objectAtIndex:i];
        amountLabel.text = [NSString stringWithFormat:@"%.0f",priceModel.amount];
        
        UILabel *priceLabel = [_currentPriceViewArray objectAtIndex:i];
        
        UIImageView *imageView = [_arrowImageViewArray objectAtIndex:i];
        imageView.hidden = NO;
        UIColor *color = k_EQUAL_COLOR;
        
        NSString *price = [NSString amountValueWithDouble:priceModel.price];
    
        if (priceModel.bs == 0) {
            imageView.image = [UIImage imageNamed:@"arrow_down"];
        }else{
            imageView.image = [UIImage imageNamed:@"arrow_up"];
        }
        
        
        if ([price doubleValue] > _detailModel.preClose) {
            color = k_UPPER_COLOR;
        }else if ([price doubleValue]< _detailModel.preClose){
            color = k_UNDER_COLOR;
        }else if([price doubleValue] == 0)
        {
            price = @"--";
            imageView.hidden = YES;
        }
        priceLabel.textColor = color;
        priceLabel.text = price;
    }
}

- (void)loadData
{
    NSArray *sellPriceArray = @[
                                [NSString amountValueWithDouble:_detailModel.sellPrice5],
                                [NSString amountValueWithDouble:_detailModel.sellPrice4],
                                [NSString amountValueWithDouble:_detailModel.sellPrice3],
                                [NSString amountValueWithDouble:_detailModel.sellPrice2],
                                [NSString amountValueWithDouble:_detailModel.sellPrice1]
                                ];
    
    NSArray *sellAmountArray = @[
                                 [@(_detailModel.sellAmount5) stringValue],
                                 [@(_detailModel.sellAmount4) stringValue],
                                 [@(_detailModel.sellAmount3) stringValue],
                                 [@(_detailModel.sellAmount2) stringValue],
                                 [@(_detailModel.sellAmount1) stringValue],
                                 ];
    
    for (NSInteger i = 0; i < _sellPriceViewArray.count; i++) {
        UILabel *priceLabel = [_sellPriceViewArray objectAtIndex:i];
        UILabel *amountLabel = [_sellAmountViewArray objectAtIndex:i];
        NSString *price = [sellPriceArray objectAtIndex:i];
        NSString *amount = [sellAmountArray objectAtIndex:i];
        UIColor *color = k_EQUAL_COLOR;
        if ([price doubleValue] > _detailModel.preClose) {
            color = k_UPPER_COLOR;
        }else if ([price doubleValue] < _detailModel.preClose){
            color = k_UNDER_COLOR;
        }else if([price doubleValue] == 0)
        {
            price = @"--";
        }
        
        priceLabel.textColor = color;
        priceLabel.text = price;
        amountLabel.text = amount;
    }
    NSArray *buyPriceArray =  @[
                                [NSString amountValueWithDouble:_detailModel.buyPrice1],
                                [NSString amountValueWithDouble:_detailModel.buyPrice2],
                                [NSString amountValueWithDouble:_detailModel.buyPrice3],
                                [NSString amountValueWithDouble:_detailModel.buyPrice4],
                                [NSString amountValueWithDouble:_detailModel.buyPrice5]
                                ];
    NSArray *buyAmountArray =  @[
                                 [@(_detailModel.buyAmount1) stringValue],
                                 [@(_detailModel.buyAmount2) stringValue],
                                 [@(_detailModel.buyAmount3) stringValue],
                                 [@(_detailModel.buyAmount4) stringValue],
                                 [@(_detailModel.buyAmount5) stringValue],
                                 ];
    
    for (NSInteger i = 0; i < _buyPriceViewArray.count; i++) {
        UILabel *priceLabel = [_buyPriceViewArray objectAtIndex:i];
        UILabel *amountLabel = [_buyAmountViewArray objectAtIndex:i];
        NSString *price = [buyPriceArray objectAtIndex:i];
        NSString *amount = [buyAmountArray objectAtIndex:i];
        UIColor *color = k_EQUAL_COLOR;
        if ([price doubleValue] > _detailModel.preClose) {
            color = k_UPPER_COLOR;
        }else if ([price doubleValue] < _detailModel.preClose){
            color = k_UNDER_COLOR;
        }else if([price doubleValue] == 0)
        {
            price = @"--";
        }
        priceLabel.textColor = color;
        priceLabel.text = price;
        amountLabel.text = amount;
    }
//    　　1、委比是金融或证券实盘操作中衡量某一时段买卖盘相对强度的指标，委比的取值自-100%到+100%，+100%表示全部的委托均是买盘，涨停的股票的委比一般是100%，而跌停是-100%。委比为0，意思是买入（托单）和卖出（压单）的数量相等，即委买：委卖=5:5。(比值为10的情况下)。
//    　　委比的计算公式为：
//    　　委比=(委买手数－委卖手数)/(委买手数+委卖手数)×100%
//    　　委买手数：所有个股委托买入上五档的总数量。
//    　　委卖手数：所有个股委托卖出下五档的总数量。
//    　　2、交易报价中委买委卖是最优的买卖盘的提示，现在大家能够看到的是队列的前5位，即买1～5，卖1～5。它是未成交的价和量，某种程度上讲，委买委卖的差值（即委差），是投资者意愿的体现，一定程度上反映了价格的发展方向。委差为正，价格上升的可能性就大；反之，下降的可能性就大。之所以加上“某种程度上”，是因为还有人为干扰的因素，比如主力制造的假象等。
//    　　委差 = 委买手数－委卖手数
//    　　委买手数：所有个股委托买入下五档之手数相加之总和。
//    　　委卖手数：所有个股委托卖出上五档之手数相加之总和。
    
    //委比
   __block double totalBuyAmount = 0;
    [buyAmountArray enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL * _Nonnull stop) {
        totalBuyAmount += [value doubleValue];
        
    }];
   __block double totalSellAmount = 0;
    [sellAmountArray enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL * _Nonnull stop) {
        totalSellAmount += [value doubleValue];
    }];
    
    double delegateRate = 0;
    if (totalBuyAmount != 0 && totalSellAmount != 0) {
      delegateRate = (totalBuyAmount - totalSellAmount) / (totalBuyAmount + totalSellAmount);
    }
    _delegateRate.text = [NSString stringWithFormat:@"委比:%.2f%%",delegateRate * 100];

    //委差
    double delegateValue = totalBuyAmount - totalSellAmount;

    _delegateValue.text = [NSString stringWithFormat:@"委差:%.0f",delegateValue];
}

@end
