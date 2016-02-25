//
//  UUStockCurrentPriceModel.h
//  StockHelper
//
//  Created by LiuRex on 15/8/17.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUStockCurrentPriceModel : NSObject

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *money;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


+ (NSArray *)stockCurrentArrayWithData:(NSData *)data;

@end
