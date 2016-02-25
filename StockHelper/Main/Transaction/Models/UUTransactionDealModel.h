//
//  UUTransactionDealModel.h
//  StockHelper
//
//  Created by LiuRex on 15/7/30.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTransactionModel.h"
/*
 buySell = 0;
 code = 002600;
 name = "\U6c5f\U7c89\U78c1\U6750";
 orderID = 20150730000003;
 
 
 
 orderPrice = 8;
 resultAmount = 200;
 resultDate = "2015-07-30";
 resultID = 20150730000001;
 resultMoney = 1594;
 resultPrice = "7.97";
 resultTime = "10:54:05";
 
 
 resultID	String	成交单号
 code	String	股票代码
 name	String	股票名称
 buySell	int	成交类型：0-买 1-卖
 
 positionPrice	Double	持仓均价
 resultPrice	Double	成交价格
 resultAmount	Double	成交数量
 resultMoney	Double	成交金额
 resultDate	String	成交日期 yyyy-MM-dd格式
 resultTime	Double	成交时间 HH:mm:ss格式
 orderID	Sring	委托单号
 orderPrice	Double	委托价格
 positionPrice
 */

@protocol UUTransactionDealModel

@end

@interface UUTransactionDealModel : UUTransactionModel

@property (nonatomic,copy) NSString *resultID;
@property (nonatomic,copy) NSString *resultAmount;
@property (nonatomic,copy) NSString *resultDate;
@property (nonatomic,copy) NSString *resultTime;

@property (nonatomic,assign) double resultMoney;
@property (nonatomic,assign) double orderPrice;
@property (nonatomic,assign) double resultPrice;

@property (nonatomic,assign) NSString<Optional> *positionPrice;

@end



@interface UUTransactionListDealModel : BaseModel

@property (nonatomic, copy) NSArray<UUTransactionDealModel> *data;

@end

