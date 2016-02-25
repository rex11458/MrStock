//
//  UUFavourisStockModel.h
//  StockHelper
//
//  Created by LiuRex on 15/7/27.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockModel.h"
#import "UUMarketStructs.h"
/*
 listID	long	数据主键
 code	String	股票代码
 name	String	股票名称
 amount	Double	持仓量
 cost	Double	持仓成本
 pos	int	排序字段
 
 3	市场	market	字符	2	SH/SZ
 4	最新价	price	数字	10.3
 5	涨跌额	deltaPrice	数字	10.3
 6	涨跌幅	deltaRate	数字	6.2	%
 
 {
 amount = 0;
 code = 000026;
 cost = 0;
 listID = 1;
 name = "";
 pos = 100;
 },
 */

@interface UUFavourisStockModel : UUStockModel
/*
 
 @property (nonatomic, copy) NSString *name;
 @property (nonatomic, copy) NSString *code;
 @property (nonatomic, copy) NSString *pinyin;   //拼音简称
 @property (nonatomic, assign) UUMarketDataType market;
 @property (nonatomic, copy) NSString *type;
 @property (nonatomic,copy) NSString *lstMarktDate; //市场最后交易日期
 
 @property (nonatomic,assign) BOOL isFav;  //是否为指数  0表示指数
 @property (nonatomic,assign) BOOL isRecrod;  //是否为最近搜索
 */


@property (nonatomic,copy) NSString *listID;

@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *deltaPrice;
@property (nonatomic,copy) NSString *deltaRate;


- (instancetype)initWithName:(NSString *)name code:(NSString *)code market:(UUMarketDataType)market;
+ (NSArray *)favourisStockModelWithJsonArray:(NSArray *)array;

@end



