//
//  UUStockDetailShortBrief.h
//  StockHelper
//
//  Created by LiuRex on 15/11/25.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseDataSource.h"
@interface UUStockDetailShortBriefDataSource : BaseDataSource
{
    
}

@property (nonatomic, copy) NSString *stockCode;

- (instancetype)initWithStockCode:(NSString *)stockCode;

@end



@interface UUStockDetailShortBrief : NSObject<UITableViewDelegate>

@end
