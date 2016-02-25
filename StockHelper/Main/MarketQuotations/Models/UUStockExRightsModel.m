//
//  UUStockExchangeModel.m
//  StockHelper
//
//  Created by LiuRex on 15/11/3.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockExRightsModel.h"
#import <MTDates/NSDate+MTDates.h>
#import <MTDates/NSDate+MTDates.h>
@implementation UUStockExRightsModel

+ (NSArray *)exRightsModelArrayWithAttribute:(UUCommAttribute *)attribute
{
    UUCommChuquanData *data = (UUCommChuquanData *)attribute->cAttribute;
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < data->count; i++) {
        StructChuquanData chuquan = data->data[i];
        
        UUStockExRightsModel *model = [[UUStockExRightsModel alloc] initWithData:&chuquan];
        [dataArray addObject:model];
    }
    return [dataArray copy];
}

- initWithData:(StructChuquanData *)data
{
    if (self = [super init]) {
        NSTimeInterval sec = data->m_time;
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:sec];
        
       NSTimeInterval s = [date mt_secondsIntoDay];
        
        
        self.m_time =data->m_time - s;
        self.m_fGive = data->m_fGive;
        self.m_fPei = data->m_fPei;
        self.m_fPeiPrice = data->m_fPeiPrice;
        self.m_fProfit = data->m_fProfit;
    }
    return self;
}

@end
