//
//  UUStockTImeEntity.h
//  StockHelper
//
//  Created by LiuRex on 15/5/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUMarketStructs.h"
/*
 242,4,1.0,14.68
 time,price,amount,money,avgPrice
 09:30,14.68,20375.0,2.9747945E7,14.61
 09:31,14.62,5961.0,8733300.0,14.61
 09:32,14.65,6085.0,8904600.0,14.61
 09:33,14.64,5227.0,7659100.0,14.62
 09:34,14.64,3494.0,5114296.0,14.62
 09:35,14.7,11971.0,1.75336E7,14.62
 09:36,14.68,8670.0,1.2719504E7,14.63
 09:37,14.68,3883.0,5701504.0,14.63
 09:38,14.7,6087.0,8940992.0,14.64
 09:39,14.72,4101.0,6031704.0,14.64
 09:40,14.72,4048.0,5960400.0,14.64
 09:41,14.69,2677.0,3935800.0,14.65
 09:42,14.7,6331.0,9312192.0,14.65
 09:43,14.71,3051.0,4487504.0,14.65
 09:44,14.7,6133.0,9019312.0,14.65
 */
@interface UUStockTimeEntity : NSObject

@property (nonatomic, copy) NSString *time;       //时间
@property (nonatomic,assign) double price;       //价格
@property (nonatomic,assign) double amount;      //成交量
@property (nonatomic,assign) double money;
@property (nonatomic,assign) double avgPrice;    //均价

@property (nonatomic,assign) NSInteger bs;    //买卖点

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)stockTimeArrayWithData:(NSData *)data;

//--通过结构体数据返回分时数据数组
+ (NSArray *)stockTimeArrayWithTrendData:(UUComTrendData *)trendData;

//分价数组
+ (NSArray *)stockTimeArrayWithAttribute:(UUCommAttribute *)attribute;




@end

@interface UUStockQuoteEntity : NSObject
/*
 1	代码	code	字符	10	沪深代码长度6位
 2	名称	name	字符	20	沪深名称长度8位
 3	市场	market	字符	2	SH/SZ
 4	最新价	price	数字	10.3
 5	涨跌额	deltaPrice	数字	10.3
 6	涨跌幅	deltaRate	数字	6.2	%
 */

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *market;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *deltaPrice;
@property (nonatomic, copy) NSString *deltaRate;
@property (nonatomic, copy) NSArray  *stockTimeArray;

@property (nonatomic, assign) double preClosePrice;

- (instancetype)initWithTimeArray:(NSArray *)array preClose:(double)preClose date:(NSString *)date;
+ (UUStockQuoteEntity *)stockQuoteEntityWithTimeArray:(NSArray *)array preClose:(double)preClose date:(NSString *)date;

//

@end
