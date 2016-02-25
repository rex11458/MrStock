//
//  UUStockDetailModel.m
//  StockHelper
//
//  Created by LiuRex on 15/8/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailModel.h"
#import <MTDates/NSDate+MTDates.h>

@implementation UUStockDetailModel


+ (UUStockDetailModel *)stockDetailModelWithUUStockRealTime:(CommRealTimeData *)stockRealTime
{
    UUStockRealTime *m_stocknowData = (UUStockRealTime *)stockRealTime->m_cNowData;
    
    UUStockDetailModel *stockDetailModel = [[UUStockDetailModel alloc] init];
    //当前时间
    stockDetailModel.time = [self dateWith:&(stockRealTime->m_othData.m_sDetailTime)];
    //现在总手
    stockDetailModel.currentAmount = stockRealTime->m_othData.m_lCurrent;
    //外盘,个股需除以100再使用
    stockDetailModel.outside = stockRealTime->m_othData.m_lOutside / 100;
    //内盘，个股需除以100后使用
    stockDetailModel.inside = stockRealTime->m_othData.m_lInside / 100;
    //昨日收盘价
    stockDetailModel.preClose = stockRealTime->m_othData.m_lPreClose / 1000.0f;
    // 分笔笔数,主推时使用,只限于股票
    stockDetailModel.tickCount = stockRealTime->m_othData.m_lTickCount;
    //今开
    stockDetailModel.openPrice = m_stocknowData->m_lOpen / 1000.0f;
    //最高价
    stockDetailModel.maxPrice = m_stocknowData->m_lMaxPrice / 1000.0f;
    //最低价
    stockDetailModel.minPrice = m_stocknowData->m_lMinPrice / 1000.0f;
    //最新价
    stockDetailModel.newPrice =m_stocknowData->m_lNewPrice / 1000.0f;
    //成交量(单位股)
    stockDetailModel.amount = m_stocknowData->m_lTotal / 100.0f;
    //成交金额
    stockDetailModel.money = m_stocknowData->m_fAvgPrice;
    //买一价
    stockDetailModel.buyPrice1 = m_stocknowData->m_lBuyPrice1 / 1000.0f;
    //买一量
    stockDetailModel.buyAmount1 = m_stocknowData->m_lBuyCount1 / 100;
    //买二价
    stockDetailModel.buyPrice2 = m_stocknowData->m_lBuyPrice2 / 1000.0f;
    //买二量
    stockDetailModel.buyAmount2 = m_stocknowData->m_lBuyCount2 / 100;
    //买三价
    stockDetailModel.buyPrice3 = m_stocknowData->m_lBuyPrice3 / 1000.0f;
    //买三量
    stockDetailModel.buyAmount3 = m_stocknowData->m_lBuyCount3 / 100;
    //买四价
    stockDetailModel.buyPrice4 = m_stocknowData->m_lBuyPrice4 / 1000.0f;
    //买四量
    stockDetailModel.buyAmount4 = m_stocknowData->m_lBuyCount4 / 100;
    //买五价
    stockDetailModel.buyPrice5 = m_stocknowData->m_lBuyPrice5 / 1000.0f;
    //买五量
    stockDetailModel.buyAmount5 = m_stocknowData->m_lBuyCount5 / 100;
    
    //卖一价
    stockDetailModel.sellPrice1 = m_stocknowData->m_lSellPrice1 / 1000.0f;
    //卖一量
    stockDetailModel.sellAmount1 = m_stocknowData->m_lSellCount1 / 100;
    //卖二价
    stockDetailModel.sellPrice2 = m_stocknowData->m_lSellPrice2 / 1000.0f;
    //卖二量
    stockDetailModel.sellAmount2 = m_stocknowData->m_lSellCount2 / 100;
    //卖三价
    stockDetailModel.sellPrice3 = m_stocknowData->m_lSellPrice3 / 1000.0f;
    //卖三量
    stockDetailModel.sellAmount3 = m_stocknowData->m_lSellCount3 / 100;
    //卖四价
    stockDetailModel.sellPrice4 = m_stocknowData->m_lSellPrice4 / 1000.0f;
    //卖四量
    stockDetailModel.sellAmount4 = m_stocknowData->m_lSellCount4 / 100;
    //卖五价
    stockDetailModel.sellPrice5 = m_stocknowData->m_lSellPrice5 / 1000.0f;
    //卖五量
    stockDetailModel.sellAmount5 = m_stocknowData->m_lSellCount5 / 100;
    //每手股数
    stockDetailModel.hand = m_stocknowData->m_nHand;
    //国债利率，基金净值
    stockDetailModel.nationalDebtRatio = m_stocknowData->m_lNationalDebtRatio;
    
    //--code
    stockDetailModel.code = [NSString stringWithCString:stockRealTime->m_ciStockCode.m_cCode encoding:NSASCIIStringEncoding] ;
    if (stockDetailModel.code.length > 6) {
        stockDetailModel.code = [stockDetailModel.code substringToIndex:6];
    }
    //类型
    stockDetailModel.market = stockRealTime->m_ciStockCode.m_cCodeType;
    
    return stockDetailModel;
}

//根据TimeDate获取到当前时间
+ (NSString *)dateWith:(TimeDate *)timeDate
{
    //开盘时间
    NSDate *startDate = [NSDate mt_dateFromISOString:k_STOCK_OPEN_DATE];
    
    //距离9:30开盘时间的当前秒数
    NSTimeInterval seconds = timeDate->m_nSecond + timeDate->m_nTime * 60;
    //开盘距离11:30的秒数
    NSTimeInterval SECONDS_1130 = 2 * 60 * 60;
    //开盘距离13:00的秒数
    NSTimeInterval SECONDS_1300 = SECONDS_1130 + 1.5 * 60;
    
    
    if (seconds > SECONDS_1130)
    {
        if ( seconds < SECONDS_1300)
        {
            seconds = SECONDS_1130;
        }else{
            seconds += SECONDS_1130;
        }
    }
    //当前时间
    NSDate *date = [[NSDate alloc] initWithTimeInterval:seconds sinceDate:startDate];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    date = [date dateByAddingTimeInterval:-interval];
    
    NSString *currentDate = [date mt_stringFromDateWithHourAndMinuteFormat:MTDateHourFormat24Hour];
    
    return currentDate;
}


//-----------------------------

+ (UUStockDetailModel *)detailModelWithData:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *arr = [string componentsSeparatedByString:@"\n"];
    if (arr.count < 4) {
        return nil;
    }
    
    NSArray *keys = [arr[1] componentsSeparatedByString:@","];
    NSArray *values = [arr[2] componentsSeparatedByString:@","];
    if (keys.count != values.count) {
        return nil;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        NSString *value = values[i];

        [dic setValue:value forKey:key];
    }
    UUStockDetailModel *detailModel = [[UUStockDetailModel alloc] init];
    [detailModel setValuesForKeysWithDictionary:dic];
    return detailModel;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
