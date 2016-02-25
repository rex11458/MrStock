//
//  UUStockDetailFinance.h
//  StockHelper
//
//  Created by LiuRex on 15/11/24.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataSource.h"
#import "UUStockDetailFinanceViewCell.h"
@interface UUStockDetailFinanceDataSource : BaseDataSource
{
    @private
    NSArray *_titleArray;
}
@property (nonatomic,copy) NSString *stockCode;

- (instancetype)initWithStockCode:(NSString *)stockCode;

@end

@interface UUStockDetailFinance : NSObject<UITableViewDelegate>

@end
