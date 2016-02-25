//
//  UUStockBlockModel.h
//  StockHelper
//
//  Created by LiuRex on 15/12/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUMarketStructs.h"
#import "UUStockModel.h"
@interface UUStockBlockModel : NSObject
/*
 UUMarketCodeInfo    codeInfo;			//代码
 int                 lNewPrice;		//最新价
 int                 lRiseRate;		//涨跌幅
 char                szStockCode[8];	//领涨股代码
 int                 lStockRiseRate;	//领涨股涨跌幅
 int                 lStockNewPrice;  //领涨股最新价
 */
@property (nonatomic, copy) NSString *blockName;   //板块名
@property (nonatomic, copy) NSString *blockCode;    //板块代码

@property (nonatomic,assign) double newPrice;       //最新价
@property (nonatomic,assign) double riseRate;       //涨跌幅

@property (nonatomic, copy) NSString *stockName;    //股票名
@property (nonatomic, copy) NSString *stockCode;    //领涨股代码
@property (nonatomic,assign) double stockRiseRate;  //领涨股涨跌幅
@property (nonatomic,assign) double stockNewPrice;  //领涨股涨跌幅

@property (nonatomic,strong) UUStockModel *stockModel;//领涨股票


+ (NSArray *)blockModelArrayWithReportBlock:(UUResReportBlock *)reportBlock;


@end
