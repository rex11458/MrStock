//
//  UUKLineModel.m
//  StockHelper
//
//  Created by LiuRex on 15/5/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUKLineModel.h"


double max(double a,double b)
{
    return a>b ?a:b;
}

double min(double a,double b)
{
    return a>b ?b:a;
}


@implementation UUKLineModel

- (id)copyWithZone:(nullable NSZone *)zone
{
    UUKLineModel *copy = [[UUKLineModel alloc] init];
        if (copy) {
            
            copy.time = [self.time copyWithZone:zone];
            copy.openPrice = self.openPrice;
            copy.closePrice = self.closePrice;
            copy.highPrice = self.highPrice;
            copy.lowPrice = self.lowPrice;
            copy.money = self.money;
            copy.amount = self.amount;
        }
        
        return copy;
}

/*
 @property (nonatomic, copy) NSString *time;
 @property (nonatomic,assign) double openPrice;
 @property (nonatomic,assign) double highPrice;
 @property (nonatomic, copy) NSString *lowPrice;
 @property (nonatomic, copy) NSString *closePrice;
 @property (nonatomic, copy) NSString *amount;
 @property (nonatomic, copy) NSString *money;

 4,7,1.0
 time,openPrice,highPrice,lowPrice,closePrice,amount,money
 2015-05-19,22.85,23.6,22.08,23.19,2648800.0,6.155112E7
 2015-05-20,23.0,24.99,22.52,23.62,6492000.0,1.55663624E8
 2015-05-21,23.52,24.38,23.28,24.19,6157400.0,1.479572E8
 2015-05-22,24.0,24.28,23.01,23.31,3737500.0,8.816912E7
 */

+ (NSArray *)kLineModelArrayWithData:(NSData *)data
{
    NSMutableArray *returnArray = [NSMutableArray array];
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *array = [dataString componentsSeparatedByString:@"\n"];
    if (array.count == 0 ) {
        return nil;
    }
    array = [array subarrayWithRange:NSMakeRange(2, array.count - 3)];
    
    
    for (NSString *str in array) {
        NSArray *arr = [str componentsSeparatedByString:@","];
        UUKLineModel *lineModel = [[UUKLineModel alloc] init];
        lineModel.time = [arr objectAtIndex:0];
        lineModel.openPrice = [[arr objectAtIndex:1] doubleValue];
        lineModel.highPrice = [[arr objectAtIndex:2] doubleValue];
        lineModel.lowPrice = [[arr objectAtIndex:3] doubleValue];
        lineModel.closePrice = [[arr objectAtIndex:4] doubleValue];
        lineModel.amount = [[arr objectAtIndex:5] doubleValue];
        lineModel.money = [[arr objectAtIndex:6] doubleValue];
        
        [returnArray addObject:lineModel];
    }
    
    
    return [returnArray copy];
}


+ (NSArray *)kLineModelArrayWithAtribute:(UUCommAttribute *)attribute
{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    
    for (int offset = 0; offset < attribute->length; offset += sizeof(UUKData)) {

        UUKData *kData = (UUKData *)(attribute->cAttribute + offset);
        UUKLineModel *kLineModel = [[UUKLineModel alloc] init];
        kLineModel.time = [@(kData->m_lDate) stringValue];
        kLineModel.openPrice = kData->m_lOpenPrice / 1000.0f;
        kLineModel.highPrice = kData->m_lMaxPrice / 1000.0f;
        kLineModel.lowPrice = kData->m_lMinPrice / 1000.0f;
        kLineModel.closePrice = kData->m_lClosePrice / 1000.0f;
        kLineModel.amount = kData->m_lTotal / 100;
        kLineModel.money = kData->m_lMoney * 1000;
        [dataArray addObject:kLineModel];
    }
    return [dataArray copy];
}


+ (NSDictionary *)maDictionary:(NSArray *)lineModelArray
{
    NSArray *ma5Array = [UUKLineModel maArrayWithMAType:kMA5LineType lineModelArray:lineModelArray];
    NSArray *ma10Array = [UUKLineModel maArrayWithMAType:kMA10LineType lineModelArray:lineModelArray];
    NSArray *ma20Array = [UUKLineModel maArrayWithMAType:kMA20LineType lineModelArray:lineModelArray];
    
    
    
    
    return @{
             MA5_ARRAY  : ma5Array,
             MA10_ARRAY : ma10Array,
             MA20_ARRAY : ma20Array
             };
}


//5，10，20日平均价
+ (NSArray *)maArrayWithMAType:(kMALineType)type lineModelArray:(NSArray *)lineModelArray
{
    NSArray *maArray = [NSArray array];
    
    for (NSInteger i = type;i <= lineModelArray.count;i++)
    {// 0 ,1,2,3,4,5,6,7,8,9
        CGFloat ave = [UUKLineModel averageOfMAType:type withLineModelArray:[lineModelArray subarrayWithRange:NSMakeRange(i - type, type)]];
        maArray = [maArray arrayByAddingObject:@(ave)];
    }
    
    return maArray;
}

+ (CGFloat)averageOfMAType:(kMALineType)type withLineModelArray:(NSArray *)array
{
    CGFloat sum = 0;
    for (UUKLineModel *lineModel in array)
    {
        sum += lineModel.closePrice;
    }
    
    return (sum / type);
}


+ (NSDictionary *)macdDictionary:(NSArray *)lineModelArray
{
    NSArray *DEAArray = [NSArray array];
    NSArray *DIFArray = [NSArray array];
    NSArray *MACDArray = [NSArray array];
    double eMA12 = 0.0;
    double eMA26 = 0.0;
    double close = 0;
    double dIF = 0.0;
    double dEA = 0.0;
    double mACD = 0.0;
    
    for (NSInteger i = 0; i < lineModelArray.count; i++) {
        
        UUKLineModel *kLineModel = [lineModelArray objectAtIndex:i];
        
        close = kLineModel.closePrice;
        
        if (i == 0) {
            eMA12 = close;
            eMA26 = close;
        } else
        {
            eMA12 = eMA12 * 11 / 13 + close * 2 / 13;
            eMA26 = eMA26 * 25 / 27 + close * 2 / 27;
        }
        dIF = eMA12 - eMA26;
        dEA = dEA * 8 / 10 + dIF * 2 / 10;
        mACD = 2 * (dIF - dEA);
        
        DEAArray = [DEAArray arrayByAddingObject:[NSNumber numberWithDouble:dEA]];
        DIFArray = [DIFArray arrayByAddingObject:[NSNumber numberWithDouble:dIF]];
        MACDArray  = [MACDArray arrayByAddingObject:[NSNumber numberWithDouble:mACD]];
    }
    
    return @{
             DEA_ARRAY  : DEAArray,
             DIF_ARRAY : DIFArray,
             MACD_ARRAY : MACDArray
             };
}


+ (NSDictionary *)kdjDataDictionary:(NSArray *)lineModelArray
{
#warning --未解决
    return nil;
    NSArray *KArray = [NSArray array];
    NSArray *DArray = [NSArray array];
    NSArray *JArray = [NSArray array];
    
    CGFloat k = 0.0;
    CGFloat d = 0.0;
    CGFloat j = 0.0;
    CGFloat rSV = 0.0;
    
    UUKLineModel *kLineModel = [lineModelArray firstObject];
    CGFloat high = kLineModel.highPrice;
    CGFloat low = kLineModel.lowPrice;
    for (NSInteger i = 0; i < lineModelArray.count; i++) {
        kLineModel = [lineModelArray objectAtIndex:i];
        
        
        if (i > 0) {
            high = [UUKLineModel hightestArray:lineModelArray index:i];
            low =  [UUKLineModel lowestArray:lineModelArray index:i];
        }
        if (high != low) {
            //RSVt＝(Ct－L9)／(H9－L9)×100
            rSV = (kLineModel.closePrice - low) / (high - low) * 100;
        }
        
        if (i == 0) {
            k = rSV;
            d = k;
            
        } else {
            k = k * 2 / 3 + rSV / 3;
            d = d * 2 / 3 + k / 3;
        }
        j = 3 * k - 2 * d;
        
        
        KArray = [KArray arrayByAddingObject:@(k)];
        DArray = [DArray arrayByAddingObject:@(d)];
        JArray = [JArray arrayByAddingObject:@(j)];
        
    }
    
    NSDictionary *kdjDic = @{
                             K_ARRAY : KArray,
                             D_ARRAY : DArray,
                             J_ARRAY : JArray
                             };
    return kdjDic;
}

+ (CGFloat)hightestArray:(NSArray *)array index:(NSInteger)index
{
    //index = 299 newIndex = 0
    //index = 298 newIndex = 1
    //...
    //index = 291  newIndex =
    CGFloat maxValue = 0;
    NSInteger count = array.count  - index;
    NSArray *kLineModels = nil;
    if (count <= array.count - 9)
    {
        kLineModels = [array subarrayWithRange:NSMakeRange(index, count)];
    }
    else
    {
        kLineModels = [array subarrayWithRange:NSMakeRange(index, 9)];
    }
    
    
    for (NSInteger i = 0; i < kLineModels.count; i++) {
        UUKLineModel *kLineModel = [kLineModels objectAtIndex:i];
        if (kLineModel.highPrice > maxValue) {
            maxValue = kLineModel.highPrice;
        }
    }
    return maxValue;
}



+ (CGFloat)lowestArray:(NSArray *)array index:(NSInteger)index
{
    NSInteger count = array.count  - index;
    NSArray *kLineModels = nil;
    if (count < 9)
    {
        kLineModels = [array subarrayWithRange:NSMakeRange(index, count)];
    }
    else
    {
        kLineModels = [array subarrayWithRange:NSMakeRange(index, 9)];
    }
    
    UUKLineModel *kLineModel = [kLineModels firstObject];
    CGFloat minValue = kLineModel.lowPrice;
    for (NSInteger i = 1; i < kLineModels.count; i++) {
        UUKLineModel *kLineModel = [kLineModels objectAtIndex:i];
        if (kLineModel.lowPrice < minValue) {
            minValue = kLineModel.lowPrice;
        }
    }
    return minValue;
}


+ (NSDictionary *)rsiDataDictionary:(NSArray *)lineModelArray
{
    NSArray *rsi6Arry = [self rsiValueWithDateCount:RSI_N1 array:lineModelArray];
    NSArray *rsi12Arry = [self rsiValueWithDateCount:RSI_N2 array:lineModelArray];
    NSArray *rsi24Arry = [self rsiValueWithDateCount:RSI_N3 array:lineModelArray];
    
    
    
    return @{
             RSI6_ARRAY  : rsi6Arry,
             RSI12_ARRAY : rsi12Arry,
             RSI24_ARRAY : rsi24Arry
             };
}


+ (NSArray *)rsiValueWithDateCount:(NSInteger)count array:(NSArray *)lineModelArray
{
    NSArray *rsiArray = [NSArray array];
    double RSI = 0;
    
    
//    for (NSInteger i = type;i <= lineModelArray.count;i++)
//    {// 0 ,1,2,3,4,5,6,7,8,9
//        CGFloat ave = [UUKLineModel averageOfMAType:type withLineModelArray:[lineModelArray subarrayWithRange:NSMakeRange(i - type, type)]];
//        maArray = [maArray arrayByAddingObject:@(ave)];
//    }
    
    for (NSInteger i = count; i <= lineModelArray.count; i++)
    {
        double sumPositive = [self sumPositiveWithRange:NSMakeRange(i - count, count) withArray:lineModelArray];
        double sumNegative = [self sumNegativeWithRange:NSMakeRange(i - count, count) withArray:lineModelArray];
        
        if (sumPositive == 0 && sumNegative == 0)
        {
            RSI = 50;
        }
        else
        {
            RSI = 100 * sumPositive / (sumPositive + sumNegative);
            
        }
        rsiArray = [rsiArray arrayByAddingObject:[NSNumber numberWithDouble:RSI]];
    }
    return [rsiArray copy];
}


//正数和
+ (double)sumPositiveWithRange:(NSRange)range withArray:(NSArray *)lineModelArray
{
    double sumPositive = 0.0;
    
    NSArray *array = nil;
    if (range.location + range.length > lineModelArray.count)
    {
        array = lineModelArray;
    }
    else
    {
        array = [lineModelArray subarrayWithRange:range];
    }
    for (NSInteger i = 0; i < array.count - 1; i++) {
        UUKLineModel *stockModel = [array objectAtIndex:i];
        UUKLineModel *stockModel2 = [array objectAtIndex:i+1];
        sumPositive += max(0, stockModel.closePrice - stockModel2.closePrice);
    }
    
    return sumPositive;
}

//负数和
+ (double)sumNegativeWithRange:(NSRange)range withArray:(NSArray *)lineModelArray
{
    double sumNegative = 0.0;
    NSArray *array = [lineModelArray subarrayWithRange:range];
    for (NSInteger i = 0; i < array.count - 1; i++) {
        UUKLineModel *stockModel = [array objectAtIndex:i];
        UUKLineModel *stockModel2 = [array objectAtIndex:i+1];
        sumNegative +=fabs(min(0, stockModel.closePrice - stockModel2.closePrice));
    }
    
    return sumNegative;
}


@end
