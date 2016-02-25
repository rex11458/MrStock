//
//  UUTransactionHoldModel.h
//  StockHelper
//
//  Created by LiuRex on 15/7/31.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseModel.h"

@protocol UUTransactionHoldModel
@end

@interface UUTransactionHoldModel : JSONModel
/*
 code	String	股票代码
 name	String	股票名称
 amount	Double	持仓量
 price	Double	持仓均价
 newPrice	Double	最新价
 tradeFreeze	Double	交易冻结量
 amountToday	Double	今日持仓量
 marketValue	Double	股票市值
 profitLoss	Double	盈亏
 rank	Long	交易排名

*/

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic,assign) double amount;
@property (nonatomic,assign) double price;
@property (nonatomic,assign) double newPrice;
@property (nonatomic,assign) double tradeFreeze;
@property (nonatomic,assign) double amountToday;
@property (nonatomic,assign) double marketValue;
@property (nonatomic,assign) double profitLoss;
//@property (nonatomic,assign) long   rank;
@end

@interface UUTransactionHoldListModel : BaseModel

@property (nonatomic, copy) NSArray<UUTransactionHoldModel> *data;


@end