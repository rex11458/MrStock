//
//  UUKLineModel.h
//  StockHelper
//
//  Created by LiuRex on 15/5/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUMarketStructs.h"

typedef enum : NSUInteger {
    kMA5LineType  = 5,
    kMA10LineType = 10,
    kMA20LineType = 20
} kMALineType;

#define MA5_ARRAY  @"ma5Array"
#define MA10_ARRAY @"ma10Array"
#define MA20_ARRAY @"ma20Array"

#define DEA_ARRAY   @"deaArray"
#define DIF_ARRAY   @"difArray"
#define MACD_ARRAY  @"macdArry"

#define K_ARRAY     @"kArray"
#define D_ARRAY     @"dArray"
#define J_ARRAY     @"jArray"


#define RSI6_ARRAY  @"rsi6Array"
#define RSI12_ARRAY @"rsi12Array"
#define RSI24_ARRAY @"rsi24Array"

#define RSI_N1 6
#define RSI_N2 12
#define RSI_N3 24

/*
 1	时间	time	数字	10	格式：yyyymmdd，如20150511
 2	开盘价	openPrice	数字	10.3
 3	最高价	highPrice	数字	10
 4	最低价	lowPrice	数字	10
 5	收盘价	closePrice	数字	10
 6	成交量	amount	数字	10
 7	成交金额	money	数字	12.2
 */
@interface UUKLineModel : NSObject<NSCopying>

@property (nonatomic, copy) NSString *time;
@property (nonatomic,assign) double openPrice;
@property (nonatomic,assign) double highPrice;
@property (nonatomic, assign) double lowPrice;
@property (nonatomic, assign) double closePrice;
@property (nonatomic, assign) double amount;
@property (nonatomic, assign) double money;

+ (NSArray *)kLineModelArrayWithData:(NSData *)data;

+ (NSArray *)kLineModelArrayWithAtribute:(UUCommAttribute *)attribute;


//移动平均线
+ (NSDictionary *)maDictionary:(NSArray *)lineModelArray;
//MACD
+ (NSDictionary *)macdDictionary:(NSArray *)lineModelArray;

//KDJ线
+ (NSDictionary *)kdjDataDictionary:(NSArray *)lineModelArray;

//RSI线
+ (NSDictionary *)rsiDataDictionary:(NSArray *)lineModelArray;

@end
