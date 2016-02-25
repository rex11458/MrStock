//
//  UUTransactionHistoryProfitModel.h
//  StockHelper
//
//  Created by LiuRex on 15/9/7.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//
#import "BaseModel.h"
/*
 balance = 990438;
 marketValue = 9144;
 profitLoss = "-418";
 profitRate = "-0.0004";
 rank = 1;
 rights = 999582;
 tradeDate = "2015-07-30";
 tradeFee = 0;
 
 balance	Double	上日结存
 tradeFee	Double	手续费
 marketValue	Double	股票市值
 profitLoss	Double	总盈亏（总收益）
 profitRate	Double	盈亏率
 rights	Double	权益
 rank	Long	排名
 */

@protocol UUTransactionHistoryProfitModel

@end

@interface UUTransactionHistoryProfitModel : JSONModel

@property (nonatomic,assign) double balance;
@property (nonatomic,assign) double tradeFee;
@property (nonatomic,assign) double marketValue;
@property (nonatomic,assign) double profitLoss;
@property (nonatomic,assign) double profitRate;
@property (nonatomic,assign) double rights;
@property (nonatomic,assign) double rank;
@property (nonatomic, copy) NSString *tradeDate;


@end

@interface UUTransactionHistoryProfitListModel : BaseModel

@property (nonatomic, copy) NSArray<UUTransactionHistoryProfitModel> *data;


@end