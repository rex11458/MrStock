//
//  UUStockDetailModel.h
//  StockHelper
//
//  Created by LiuRex on 15/8/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUStockModel.h"
/*
	名称	代码	类型	长度	说明
 1	代码	code	字符	10	沪深代码长度6位
 2	名称	name	字符	20	沪深名称长度8位
 3	市场	market	字符	2	SH/SZ
 4	日期	date	字符	8	格式：yyyymmdd
 5	时间	time	字符	6	格式：hhmmss
 6	前收	lastClose	数字	10.3
 7	开盘价	openPrice	数字	10.3
 8	最高价	highPrice	数字	10
 9	最低价	lowPrice	数字	10
 10	最新价	newPrice	数字	10
 11	成交量	amount	数字	10
 12	成交金额	money	数字	12.2
 13	换手率	turnoverRate	数字	6.2
 14	市盈率	peRate	数字	6.2
 15	市净率	peRateNet	数字	6.2
 16	买1价	buyPrice1	数字	10.3
 17	买1量	buyAmount1	数字	10.2
 18	买2价	buyPrice2	数字	10.3
 19	买2量	buyAmount2	数字	10.2
 20	买3价	buyPrice3	数字	10.3
 21	买3量	buyAmount3	数字	10.2
 22	买4价	buyPrice4	数字	10.3
 23	买4量	buyAmount4	数字	10.2
 24	买5价	buyPrice5	数字	10.3
 25	买5量	buyAmount5	数字	10.2
 26	卖1价	sellPrice1	数字	10.3
 27	卖1量	sellAmount1	数字	10.2
 28	卖2价	sellPrice2	数字	10.3
 29	卖2量	sellAmount2	数字	10.2
 30	卖3价	sellPrice3	数字	10.3
 31	卖3量	sellAmount3	数字	10.2
 32	卖4价	sellPrice4	数字	10.3
 33	卖4量	sellAmount4	数字	10.2
 34	卖5价	sellPrice5	数字	10.3
 35	卖5量	sellAmount5	数字	10.2
 */

@interface UUStockDetailModel : UUStockModel

@property (nonatomic, copy) NSString *date;         //当前时间
@property (nonatomic,assign) double currentAmount;  //当前总手
@property (nonatomic,assign) double outside;        //外盘
@property (nonatomic,assign) double inside;         //内盘
@property (nonatomic,assign) double preClose;       //昨日收盘价
@property (nonatomic,assign) double tickCount;      // 分笔笔数,主推时使用,只限于股票

@property (nonatomic,assign) double openPrice;      //今开
@property (nonatomic,assign) double maxPrice;       //最高价
@property (nonatomic,assign) double minPrice;       //最低价
@property (nonatomic,assign) double newPrice;       //最新价
@property (nonatomic,assign) double amount;    //成交量
@property (nonatomic,assign) double money;     //成交额

@property (nonatomic,assign) double buyPrice1;      //买一价
@property (nonatomic,assign) double buyPrice2;      //买
@property (nonatomic,assign) double buyPrice3;      //买
@property (nonatomic,assign) double buyPrice4;      //买
@property (nonatomic,assign) double buyPrice5;      //买

@property (nonatomic,assign) double buyAmount1;      //买一量
@property (nonatomic,assign) double buyAmount2;      //买
@property (nonatomic,assign) double buyAmount3;      //买
@property (nonatomic,assign) double buyAmount4;      //买
@property (nonatomic,assign) double buyAmount5;      //买

@property (nonatomic,assign) double sellPrice1;       //卖一价
@property (nonatomic,assign) double sellPrice2;
@property (nonatomic,assign) double sellPrice3;
@property (nonatomic,assign) double sellPrice4;
@property (nonatomic,assign) double sellPrice5;

@property (nonatomic,assign) double sellAmount1;    //卖一量
@property (nonatomic,assign) double sellAmount2;    //
@property (nonatomic,assign) double sellAmount3;
@property (nonatomic,assign) double sellAmount4;    //
@property (nonatomic,assign) double sellAmount5;    //

@property (nonatomic,assign) double hand;           //每手股数
@property (nonatomic,assign) double nationalDebtRatio;  //国债利率，基金净值


+ (UUStockDetailModel *)stockDetailModelWithUUStockRealTime:(CommRealTimeData *)stockRealTime;


+ (UUStockDetailModel *)detailModelWithData:(NSData *)data;

@end
