//
//  UUStockBlockModel.m
//  StockHelper
//
//  Created by LiuRex on 15/12/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockBlockModel.h"
#import "UUDatabaseManager.h"
@implementation UUStockBlockModel

- (instancetype)initWithReportBlockData:(UUCommReportBlockData *)data
{
    if (self = [super init]) {
        
    /*
     UUMarketCodeInfo    codeInfo;			//代码
     int                 lNewPrice;		//最新价
     int                 lRiseRate;		//涨跌幅
     char                szStockCode[8];	//领涨股代码
     int                 lStockRiseRate;	//领涨股涨跌幅
     int                 lStockNewPrice;  //领涨股最新价
     
        @property (nonatomic,assign) double newPrice;       //最新价
        @property (nonatomic,assign) double riseRate;       //涨跌幅
        @property (nonatomic, copy) NSString *stockCode;    //领涨股代码
        @property (nonatomic,assign) double stockRiseRate;  //领涨股涨跌幅
        @property (nonatomic,assign) double stockNewPrice;  //领涨股涨跌幅
        
        @property (nonatomic,strong) UUStockModel *stockModel;//领涨股票

     */
        
        self.newPrice = data->lNewPrice / 1000.0f;
        self.riseRate = data->lRiseRate / 1000.0f;

        
        NSString *blockCode = [NSString stringWithCString:data->codeInfo.m_cCode encoding:NSASCIIStringEncoding] ;
        if (blockCode.length > 6) {
            blockCode = [blockCode substringToIndex:6];
        }
        
        UUStockModel *blockModel = [[UUDatabaseManager manager] selectStockModelWithCode:blockCode market:UUStockExchangeIDXType];
        self.blockName = blockModel.name;
        self.blockCode = blockCode;
        //领涨股
        self.stockNewPrice = data->lStockNewPrice / 1000.0f;
        self.stockRiseRate = data->lStockRiseRate / 1000.0f;
        NSString *stockCode = [[NSString alloc] initWithCString:data->szStockCode encoding:NSUTF8StringEncoding];
        if (stockCode.length > 6) {
            stockCode = [stockCode substringToIndex:6];
        }
        self.stockCode = stockCode;
        UUStockModel *stockModel = [[UUDatabaseManager manager] selectStockModelWithCode:stockCode market:UUStockExchangeAShareType];
        
        self.stockName = stockModel.name;
        
        self.stockModel = stockModel;
    }
    
    return self;
}

+ (NSArray *)blockModelArrayWithReportBlock:(UUResReportBlock *)reportBlock
{
    NSMutableArray *dataArray = [NSMutableArray array];
    int count = reportBlock->count;
    
    for (NSInteger i = 0; i < count; i++) {
        UUCommReportBlockData data = reportBlock->blockData[i];
        
        UUStockBlockModel *model = [[UUStockBlockModel alloc] initWithReportBlockData:&data];
        
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
