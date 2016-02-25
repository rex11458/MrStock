//
//  UUStockModel.m
//  StockHelper
//
//  Created by LiuRex on 15/6/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockModel.h"
#import "pinyin.h"
#import "UUStockDetailModel.h"
#import "UUIndexDetailModel.h"
@implementation UUStockModel


- (id)initWithName:(NSString *)name
              code:(NSString *)code
            pinyin:(NSString *)pinyin
            market:(UUMarketDataType)market
             isFav:(BOOL)isFav
          isRecord:(BOOL)isRecord
{
    if (self = [super init])
    {
        
        self.name = name;
        self.code = code;
        self.pinyin = pinyin;
        self.market = market;
        self.isFav = isFav;
        self.isRecrod = isRecord;
    }
    
    return self;
}

- (NSString *)lstMarktDate
{

    NSMutableString *date = [_lstMarktDate mutableCopy];
    if (date.length == 8) {
        [date insertString:@"-" atIndex:4];
        [date insertString:@"-" atIndex:7];
        _lstMarktDate = date;
    }
    return _lstMarktDate;
}



+ (NSArray *)stockModelArrayWithAtributes:(UUCommAttribute *)attribute
{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    ResMarketInitData *data = (ResMarketInitData *)attribute->cAttribute;

    int marketCount = data->m_nMarketSize;
    
    int m_offset = 0;
    for (int i = 0; i < marketCount; i++) {
        
        OneMarketData *oneData = (OneMarketData *)((char *)data->m_oneMakretData + m_offset);
        
        int CRC_code = oneData->m_biInfo.m_dwCRC;
        
        [[NSUserDefaults standardUserDefaults] setObject:@(CRC_code) forKey:SZ_CRC_CODE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        short m_count = oneData->m_biInfo.m_cCount;
        
        //StockInitInfo偏移量
        int offset = sizeof(StockType) * (m_count - 1);
        
        int m_size =*(short *)((char*)(&oneData->m_nSize) + offset);
        
        // OneMarketData  偏移量
        m_offset += sizeof(OneMarketData) + sizeof(StockInitInfo) * (m_size - 1) + offset;
        
        for (int i = 0; i < m_size; i++) {
            
            StockInitInfo *initInfo = (StockInitInfo *)((char *)oneData->m_pstInfo + offset + i * sizeof(StockInitInfo));
            
            NSString *name = [[NSString stringWithCString:initInfo->m_cStockName encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] lowercaseString];
            NSString *pinyin = [NSString string];
            for (int i = 0; i < name.length; i++) {
                
                unichar tempCh = [name characterAtIndex:i];
                char c = pinyinFirstLetter(tempCh);

                pinyin = [[pinyin stringByAppendingFormat:@"%c",c] uppercaseString];
            }
            
            NSString *code = [NSString stringWithCString:initInfo->m_ciStockCode.m_cCode encoding:NSASCIIStringEncoding];
            
            if (code.length > 6) {
                code = [code substringToIndex:6];
            }

            UUMarketDataType market = initInfo->m_ciStockCode.m_cCodeType;

            //是否为指数 0表示指数
            BOOL isIndex = !k_IS_INDEX(market);

            UUStockModel *stockModel = [[UUStockModel alloc] initWithName:[name uppercaseString] code:code pinyin:pinyin market:market isFav:isIndex isRecord:NO];
            stockModel.lstMarktDate = [NSString stringWithFormat:@"%d",oneData->m_biInfo.m_lDate];
            [dataArray addObject:stockModel];
        }
    }
    return dataArray;
}

+ (instancetype)stockModelWithRealData:(CommRealTimeData *)realData
{
    UUStockModel *stockModel = nil;
    
    UUMarketDataType market = realData->m_ciStockCode.m_cCodeType;
    
    if(k_IS_INDEX(market))
    {
        //指数
        stockModel = [UUIndexDetailModel indexDetailModelWith:realData];
    }
    else
    {
        //A股
        stockModel = [UUStockDetailModel stockDetailModelWithUUStockRealTime:realData];
    }

    return stockModel;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
