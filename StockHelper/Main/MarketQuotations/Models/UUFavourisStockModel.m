//
//  UUFavourisStockModel.m
//  StockHelper
//
//  Created by LiuRex on 15/7/27.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFavourisStockModel.h"
#import "UUDatabaseManager.h"
#import <objc/runtime.h>
@implementation UUFavourisStockModel

- (instancetype)initWithName:(NSString *)name code:(NSString *)code market:(UUMarketDataType)market
{
    if (self = [super init]) {
        
        self.name = name;
        self.code = code;
        self.market = market;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
     
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

+ (NSArray *)favourisStockModelWithJsonArray:(NSArray *)array
{
    if ([array isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
    
        UUFavourisStockModel *favStockModel = [[self alloc] initWithDictionary:dic];
        
        UUMarketDataType market = 1;
        if (favStockModel.code.length > 6)
        {
            market = 0;
            favStockModel.code = [favStockModel.code substringToIndex:6];
        }
        
        UUStockModel *stockModel = [[UUDatabaseManager manager] selectStockModelWithCode:favStockModel.code market:market];
        if (stockModel != nil) {
            favStockModel.code = stockModel.code;
            favStockModel.name = stockModel.name;
            favStockModel.market = stockModel.market;
            favStockModel.lstMarktDate = stockModel.lstMarktDate;
            [dataArray addObject:favStockModel];
        }
    }];
    return [dataArray copy];
}

@end
