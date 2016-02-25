//
//  UUIndexDetailModel.m
//  StockHelper
//
//  Created by LiuRex on 15/10/14.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUIndexDetailModel.h"
#import <MTDates/NSDate+MTDates.h>
@implementation UUIndexDetailModel

+ (UUIndexDetailModel *)indexDetailModelWith:(CommRealTimeData *)timeData
{
    if (timeData == NULL) {
        return nil;
    }
    
    UUIndexRealTime *indexRealTime = (UUIndexRealTime *)timeData->m_cNowData;
  
    UUIndexDetailModel *indexModel = [[UUIndexDetailModel alloc] init];
    //当前时间
    indexModel.time = [self dateWith:&(timeData->m_othData.m_sDetailTime)];
   
    //昨日收盘价
    indexModel.preClose = timeData->m_othData.m_lPreClose / 1000.0f;
    //今开
    indexModel.openPrice = indexRealTime->m_lOpen / 1000.0f;
    //最高价
    indexModel.maxPrice = indexRealTime->m_lMaxPrice / 1000.0f;
    //最低价
    indexModel.minPrice = indexRealTime->m_lMinPrice / 1000.0f;
    //最新价
    indexModel.newPrice =indexRealTime->m_lNewPrice / 1000.0f;
    //成交量(单位股)
    indexModel.amount = indexRealTime->m_lTotal * 100;
    //成交金额
    indexModel.avgPrice = indexRealTime->m_fAvgPrice * 100;
    
    //涨家数
    indexModel.raiseCount = indexRealTime->m_nRiseCount;
    //跌家数
    indexModel.fallCount = indexRealTime->m_nFallCount;
    //平家数
    
    //总家数
    indexModel.totalStock2 = indexRealTime->m_nTotalStock2;
    
    //股票代码
//    indexModel.code = [NSString stringWithCString:timeData->m_ciStockCode.m_cCode encoding:NSUTF8StringEncoding];
    //股票类型
    indexModel.market = timeData->m_ciStockCode.m_cCodeType;
    //--code
   indexModel.code = [NSString stringWithCString:timeData->m_ciStockCode.m_cCode encoding:NSASCIIStringEncoding];
    if (indexModel.code.length > 6) {
        indexModel.code = [indexModel.code substringToIndex:6];
    }

    return indexModel;
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


@end
