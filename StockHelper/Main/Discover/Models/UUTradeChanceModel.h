//
//  UUTradeChanceModel.h
//  StockHelper
//
//  Created by LiuRex on 15/9/1.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseModel.h"
/*
 //userID	String	用户名
 userName	String	昵称
 userPic	String	头像地址
 //fans	Long	粉丝数量
 winrate	Double	胜率
 weekProfit	Double	周收益率
// monthProfit	Double	月收益率
 beforeProfit	Double	上期收益率
 retracement	Double	最大回撤率
 
 weekRank	Long	周排名
 monthRank	Long	月排名
 beforeRank	Long	上期排名
 avgTrade	Long	月均交易次数
 avgPosition	Long	平均持仓天数
 position	Double	仓位
 //code	String	股票代码
 //name	String	股票名称
 //buySell	int	0-买入 1-卖出
 //resultDate	String	成交日期
// resultTime	String	成交时间
 resultPrice	Double	成交价格
 
 
 //buySell = 0;
 //code = 600000;
 //fans = 6;
 messageType = 1;
 //monthProfit = "0.0392";
 //name = "\U6d66\U53d1\U94f6\U884c";
 orderID = 20151029000001;
 orderPrice = "16.5";
 //position = "0.2511";
 resultAmount = 2000;
// resultDate = "2015-10-29";
 resultID = 20151029000001;
 resultMoney = 33000;
 resultPrice = "16.5";
// resultTime = "10:14:29";
//userId = CAABE68686304D88873EC261C3147EF0;
 //userName = "\U6211\U4e0d\U662f\U4ef2\U5929\U742a12345";
 //userPic = "http://115.28.183.108/UserWeb/resources/headImg/8CCBDF4ABB9B4250B71B13BCD7EF1F39.jpg";
// winrate = 0;
 
 */

@protocol UUTradeChanceModel
@end

@interface UUTradeChanceModel : JSONModel

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPic;

@property (nonatomic,assign) long fans;
@property (nonatomic,assign) double winrate;
@property (nonatomic,assign) double weekProfit;
@property (nonatomic,assign) double monthProfit;
@property (nonatomic,assign) double beforeProfit;
@property (nonatomic,assign) double retracement;

@property (nonatomic,assign) long weekRank;
@property (nonatomic,assign) long monthRank;
@property (nonatomic,assign) long beforeRank;
@property (nonatomic,assign) long avgTrade;
@property (nonatomic,assign) double avgPosition;
@property (nonatomic,assign) double position;

@property (nonatomic, copy) NSString *code;
@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) NSInteger buySell;
@property (nonatomic, copy) NSString *resultDate;
@property (nonatomic, copy) NSString *resultTime;

@property (nonatomic, assign) double resultPrice;

@end

@interface UUTradeChanceListModel : BaseModel

@property (nonatomic, copy) NSArray<UUTradeChanceModel> *data;

@end

