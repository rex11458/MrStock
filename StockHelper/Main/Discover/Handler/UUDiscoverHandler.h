//
//  UUDiscoverHandler.h
//  StockHelper
//
//  Created by LiuRex on 15/9/1.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseHandler.h"

@interface UUDiscoverHandler : BaseHandler

+ (UUDiscoverHandler *)sharedDiscoverHandler;
//交易机会
- (void)getTradeChanceSuccess:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *  牛人榜
 *  type 牛人类型
 *  0-收益王、1-稳健王、2-人气王
 */
- (void)getGeniusListWithType:(NSInteger)type success:(SuccessBlock)success failure:(FailueBlock)failure;

@end
