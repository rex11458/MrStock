//
//  UUStockShareView.h
//  StockHelper
//
//  Created by LiuRex on 15/5/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//


//  股票分时行情界面
@class UUStockQuoteEntity;

@interface UUStockShareView : UIView


@property (nonatomic, strong) UUStockQuoteEntity *stockQuoteEntity;

@property (nonatomic, copy,readonly) NSArray *stockTimeEntityArray;


@end
