//
//  UUStockTImeEntity.m
//  StockHelper
//
//  Created by LiuRex on 15/5/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockTimeEntity.h"
#import <MTDates/NSDate+MTDates.h>
@implementation UUStockTimeEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

+ (NSArray *)stockTimeArrayWithData:(NSData *)data
{
    NSMutableArray *usefulArray = [NSMutableArray array];
    
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *tempArray = [tempString componentsSeparatedByString:@"\n"];
    if (tempArray == nil || tempArray.count < 3) {
        return nil;
    }
    NSArray *keys = [tempArray[1] componentsSeparatedByString:@","];
    
    for (NSInteger i = 2; i < tempArray.count - 1; i++) {
        NSArray *values = [tempArray[i] componentsSeparatedByString:@","];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
        UUStockTimeEntity *entity = [[UUStockTimeEntity alloc] initWithDictionary:dic];
        [usefulArray addObject:entity];
    }
    return [usefulArray copy];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
//-------------------------------------------------------------

//--通过结构体数据返回分时数据数组
+ (NSArray *)stockTimeArrayWithTrendData:(UUComTrendData *)trendData
{
    NSMutableArray *dataArray = [NSMutableArray array];

    double totalPrice = 0;
    
    for (NSInteger i = 0; i < trendData->m_nHisLen;i++) {
        PriceVolItem item = trendData->m_pHisData[i];
        UUStockTimeEntity *timeEntity = [[UUStockTimeEntity alloc] init];
        //------当前成交量
        if (i == 0)
        {
            //--第一个数据
            timeEntity.amount = item.m_lTotal / 100;
        }
        else
        {
            PriceVolItem tempItem = trendData->m_pHisData[i - 1];
            timeEntity.amount = (item.m_lTotal - tempItem.m_lTotal) / 100;
        }
        //价格
        timeEntity.price = item.m_lNewPrice / 1000.0f;
        //时间从9：30开始依次累加一分钟
        timeEntity.time = [self dateWithminutes:i];
        
        if (i != 0 && timeEntity.price == 0) {
            
            UUStockTimeEntity *entity = [dataArray lastObject];
            timeEntity.price = entity.price;
        }
        
        totalPrice += timeEntity.price;
        timeEntity.avgPrice = totalPrice / (i + 1);
        
        [dataArray addObject:timeEntity];
    }
    return [dataArray copy];
}

//分价数组
+ (NSArray *)stockTimeArrayWithAttribute:(UUCommAttribute *)attribute
{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (int offset = 0; offset < attribute->length;offset += sizeof(StockTick)) {
        
        StockTick *tick = (StockTick *)(attribute->cAttribute + offset);
        
        UUStockTimeEntity *timeEntity = [[UUStockTimeEntity alloc] init];
        
        //------当前成交量
        if (offset == 0)
        {
            //--第一个数据
            timeEntity.amount = tick->m_lCurrent / 100;
        }
        else
        {
            StockTick *tempTick = (StockTick *)(attribute->cAttribute + offset - sizeof(StockTick));
            timeEntity.amount = (tick->m_lCurrent - tempTick->m_lCurrent) / 100;
        }
        //价格
        timeEntity.price = tick->m_lNewPrice / 1000.0f;
        //时间
        timeEntity.time = [self dateWithminutes:tick->m_nTime];
        timeEntity.bs = tick->m_nBuyOrSell;

        [dataArray addObject:timeEntity];
        
    }
    
    return [dataArray copy];
}

- (id)initWithStockTick:(StockTick *)tick
{
    if (self = [super init]) {
//        /*
//        short		   	m_nTime;			   	// 当前时间（距开盘分钟数）
//        char 			m_nBuyOrSell; 		// 1 按买价 0 按卖价
//        char 			m_nSecond; 			//秒数
//        int		   		m_lNewPrice;        	// 成交价
//        unsigned int  	m_lCurrent;		   	/* 总成交量，需除以100转为手数，单笔成交量需
//                                             与前一笔数据进行相减，如相减后结果为0，
//                                             则自行抛弃掉该条数据
//                                             */
//        int		   		m_lBuyPrice;        	// 委买价
//        int		   		m_lSellPrice;       	// 委卖价
//        unsigned int  	m_nChiCangLiang;	   	// 持仓量,深交所股票单笔成交数,港股成交盘分类(Y,M,X等，根据数据源再确定）
//        
//        
//        @property (nonatomic, copy) NSString *time;       //时间
//        @property (nonatomic,assign) double price;       //价格
//        @property (nonatomic,assign) double amount;      //成交量
//        @property (nonatomic,assign) double money;
//        @property (nonatomic,assign) double avgPrice;    //均价
//        
//        @property (nonatomic,assign) NSInteger bs;    //买卖点
    }
    return self;
}

//+ (NSArray *)stockTimeArrayWithTickData:(UUCommStockTickData *)tickData
//{
//    NSMutableArray *dataArray = [NSMutableArray array];
//    
//    for (NSInteger i = 0; i < tickData->m_nSize; i++) {
//        
//        StockTick tick = tickData->m_traData[i];
//        UUStockTimeEntity *timeEntity = [[UUStockTimeEntity alloc] init];
//
//        //------当前成交量
//        if (i == 0)
//        {
//            //--第一个数据
//            timeEntity.amount = tick.m_lCurrent / 100;
//        }
//        else
//        {
//            StockTick temptick = tickData->m_traData[i - 1];
//            timeEntity.amount = (tick.m_lCurrent - temptick.m_lCurrent) / 100;
//        }
//        //价格
//        timeEntity.price = tick.m_lNewPrice / 1000.0f;
//        //时间
//        timeEntity.time = [self dateWithminutes:tick.m_nTime];
//        timeEntity.bs = tick.m_nBuyOrSell;
//        
//        [dataArray addObject:timeEntity];
//    }
//    return dataArray;
//}


//根据间隔分钟数获取到当前价格的时间
+ (NSString *)dateWithminutes:(NSInteger)minutes
{
    //开盘时间
    NSDate *startDate = [NSDate mt_dateFromISOString:k_STOCK_OPEN_DATE];
    
    //距离开盘时间的当前秒数
    NSInteger seconds = minutes * 60;
    //如果超过11:30 时间加上中午休市的90分钟
    if (seconds > 2*60*60) {
        seconds += 1.5*60*60;
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

@implementation UUStockQuoteEntity

- (id)initWithTimeArray:(NSArray *)array preClose:(double)preClose date:(NSString *)date
{
    if (self = [super init]) {
        self.stockTimeArray = array;
        self.preClosePrice = preClose;
        self.date = date;
    }
    return self;
}

+ (UUStockQuoteEntity *)stockQuoteEntityWithTimeArray:(NSArray *)array preClose:(double)preClose date:(NSString *)date
{
    return  [[self alloc] initWithTimeArray:array preClose:preClose date:date];
}

@end


