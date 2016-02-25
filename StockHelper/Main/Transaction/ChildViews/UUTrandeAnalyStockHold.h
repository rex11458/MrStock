//
//  UUTrandeAnalyStockHold.h
//  StockHelper
//
//  Created by LiuRex on 15/8/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataSource.h"
@interface UUTrandeAnalyStockHoldDataSource : BaseDataSource<UITableViewDataSource>

@property (nonatomic,copy) NSString *userId;


- (instancetype)initWithUserId:(NSString *)userId;

@end

@interface UUTrandeAnalyStockHold : NSObject<UITableViewDelegate>
{
    NSIndexPath *_selectedIndexPath;
}
@end
