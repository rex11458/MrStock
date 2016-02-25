//
//  UUReportSortStockModel.m
//  StockHelper
//
//  Created by LiuRex on 15/10/28.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUReportSortStockModel.h"
#import "UUDatabaseManager.h"
@implementation UUReportSortStockModel

+ (NSArray *)reportSortStockModelArrayWithAttribute:(UUCommAttribute *)attribute
{
    ResUUReportSort *resSort = (ResUUReportSort *)(attribute->cAttribute);
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int index = 0; index < resSort->m_nSize; index++) {
        GeneralSortData *sortData = &resSort->m_prptData[index];
        
        UUReportSortStockModel *model = [[UUReportSortStockModel alloc] init];
        
        NSString *code = [NSString stringWithCString:sortData->m_ciStockCode.m_cCode encoding:NSASCIIStringEncoding];
        if (code.length > 6) {
            code = [code substringToIndex:6];
        }
        
        model.code = code;
        model.market = sortData->m_ciStockCode.m_cCodeType;
        model.newPrice = sortData->m_lNewPrice / 1000.0f;
        model.value = sortData->m_lValue / 1000.0f;
        //从数据库取到股票的名字
        UUStockModel *stockModel = [[UUDatabaseManager manager] selectStockModelWithCode:model.code market:UUStockExchangeAShareType];
        model.name = stockModel.name;
        model.lstMarktDate = stockModel.lstMarktDate;
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
