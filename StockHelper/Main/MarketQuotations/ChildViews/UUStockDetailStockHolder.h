//
//  UUStockDetailStockHolder.h
//  StockHelper
//
//  Created by LiuRex on 15/11/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataSource.h"
@interface UUStockDetailStockHolderDataSource : BaseDataSource
@property (nonatomic, copy) NSString *stockCode;

@property (nonatomic, copy) NSArray *stockholderArray;
@property (nonatomic,copy) NSArray *stockTotalArray;

- (instancetype)initWithStockCode:(NSString *)stockCode;

@end

@interface UUStockDetailStockHolder : NSObject

@end
