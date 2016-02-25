//
//  UUTransactionAssetModel.h
//  StockHelper
//
//  Created by LiuRex on 15/8/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "JSONModel.h"
/*
 balance	Double	资金余额
 usableBalance	Double	可用资金
 tradeFee	Double	手续费
 tradeFreeze	Double	交易冻结
 marketValue	Double	股票市值
 rights	Double	总资产
 profitLoss	Double	总盈亏
 profitRate	Double	收益率
 rank	Long	交易排名
 dayProfitLoss	Double	当日盈亏
 beforeRank	Long	上期排名
 
 winrate	Double	胜率
 weekProfit	Double	周收益率
 monthProfit	Double	月收益率
 beforeProfit	Double	上期收益率
 weekRank	Long	周排名
 monthRank	Long	月排名
 retracement	Double	最大回撤率
 avgTrade	Long	月均交易次数
 avgPosition	Long	平均持仓天数
 position	Double	仓位
 firstTradeDate	String	初次交易日期
 lastTradeDate	String	最近交易日期
*/

@interface UUTransactionAssetModel : JSONModel

@property (nonatomic,assign) long rank;
@property (nonatomic,assign) long beforeRank;

@property (nonatomic,assign) double balance;
@property (nonatomic,assign) double marketValue;
@property (nonatomic,assign) double profitLoss;
@property (nonatomic,assign) double profitRate;
@property (nonatomic,assign) double dayProfitLoss;
@property (nonatomic,assign) double rights;
@property (nonatomic,assign) double tradeFee;
@property (nonatomic,assign) double tradeFreeze;
@property (nonatomic,assign) double usableBalance;

@property (nonatomic,assign) double winrate;
@property (nonatomic,assign) double weekProfit;
@property (nonatomic,assign) double monthProfit;
@property (nonatomic,assign) double beforeProfit;
@property (nonatomic,assign) double weekRank;
@property (nonatomic,assign) double monthRank;
@property (nonatomic,assign) double retracement;
@property (nonatomic,assign) double avgTrade;
@property (nonatomic,assign) double avgPosition;
@property (nonatomic,assign) double position;
@property (nonatomic, copy) NSString *firstTradeDate;
@property (nonatomic, copy) NSString *lastTradeDate;

//当日收益率
@property (nonatomic,assign) double dayProfitRate;

@end
