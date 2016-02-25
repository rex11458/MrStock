//
//  UUReportSortStockModel.h
//  StockHelper
//
//  Created by LiuRex on 15/10/28.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockModel.h"

@interface UUReportSortStockModel : UUStockModel

@property (nonatomic,assign) double newPrice;   // 最新价
@property (nonatomic,assign) double value;      //计算值,涨、跌幅需要除以1000，振幅除以100

+ (NSArray *)reportSortStockModelArrayWithAttribute:(UUCommAttribute *)attribute;


@end
