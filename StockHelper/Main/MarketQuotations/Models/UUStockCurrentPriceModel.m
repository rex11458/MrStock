//
//  UUStockCurrentPriceModel.m
//  StockHelper
//
//  Created by LiuRex on 15/8/17.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockCurrentPriceModel.h"

@implementation UUStockCurrentPriceModel


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    
    return self;
}

+ (NSArray *)stockCurrentArrayWithData:(NSData *)data;
{
    NSMutableArray *usefulArray = [NSMutableArray array];
    
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *tempArray = [tempString componentsSeparatedByString:@"\n"];
    if (tempArray == nil || tempArray.count < 3) {
        return nil;
    }
    
    NSArray *keys = [tempArray[1] componentsSeparatedByString:@","];
    for (NSInteger i = 2; i < tempArray.count - 2; i++) {
        NSArray *values = [tempArray[i] componentsSeparatedByString:@","];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
        UUStockCurrentPriceModel *priceModel = [[UUStockCurrentPriceModel alloc] initWithDictionary:dic];
        [usefulArray addObject:priceModel];
    }
    
    return [usefulArray copy];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}



@end
