//
//  UUStockModel.h
//  StockHelper
//
//  Created by LiuRex on 15/6/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UUCommStruct.h.h"
#import "UUMarketStructs.h"

/*
 股票代码	code	字符	10	沪深代码长度6位
 名称	name	字符	20	沪深名称长度8位
 市场	market	字符	2	SH/SZ
 类型	type	字符	3	EQA/EQB/IDX … …
 */


@interface UUStockModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *pinyin;   //拼音简称
@property (nonatomic, assign) UUMarketDataType market;
@property (nonatomic, copy) NSString *type;
@property (nonatomic,copy) NSString *lstMarktDate; //市场最后交易日期
@property (nonatomic, copy) NSString *time;

@property (nonatomic,assign) BOOL isFav;  //是否为指数  0表示指数   
@property (nonatomic,assign) BOOL isRecrod;  //是否为最近搜索

- (id)initWithName:(NSString *)name
              code:(NSString *)code
            pinyin:(NSString *)pinyin
            market:(UUMarketDataType )market
             isFav:(BOOL)isFav
          isRecord:(BOOL)isRecord;

+ (NSArray *)stockModelArrayWithAtributes:(UUCommAttribute *)attribute;

+ (instancetype)stockModelWithRealData:(CommRealTimeData *)realData;

@end
