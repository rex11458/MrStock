//
//  UUTransactionHandler.h
//  StockHelper
//
//  Created by LiuRex on 15/7/29.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseHandler.h"

@interface UUTransactionHandler : BaseHandler
+ (UUTransactionHandler *)sharedTransactionHandler;


/*
 *  资金信息
 */
- (void)getBalanceSuccess:(SuccessBlock)success failure:(FailueBlock)failure;
/*
 *  获取他人资金信息 */
- (void)getBalanceWithUserId:(NSString *)userId Success:(SuccessBlock)success failure:(FailueBlock)failure;


/*
 *  收益走势
 */
- (void)getProfitHistoryWithUserId:(NSString *)userId startDate:(NSString *)startDate endDate:(NSString *)endDate success:(SuccessBlock)success failure:(FailueBlock)failure;


/*
 *  当前用户持仓
 */
- (void)getHoldWithCode:(NSString *)code success:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *查询其他用户持仓
 */
- (void)getHoldWithUserId:(NSString *)userId success:(SuccessBlock)success failure:(FailueBlock)failure;
/*
 *历史持仓
 */
- (void)getHistoryHoldWithUserId:(NSString *)userId success:(SuccessBlock)success failure:(FailueBlock)failure;


/*
 *  委托交易
 *buySell   委托类型：0-买 1-卖
 */
- (void)makeOrderWithCode:(NSString *)code buySell:(NSInteger)buySell price:(double)price amount:(double)amount success:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *撤单列表
 */
- (void)getCancelOrderListSuccess:(SuccessBlock)success failue:(FailueBlock)failure;

/*
 *  撤销委托
 */
- (void)cancelOrderWithOrderID:(NSString *)orderID  success:(SuccessBlock)success failure:(FailueBlock)failure;
/*
 *  当日委托
 */
- (void)getOrderSuccess:(SuccessBlock)success failure:(FailueBlock)failure;
/*
 *  当日成交
 */
- (void)getResultSuccess:(SuccessBlock)success failure:(FailueBlock)failure;
/*
 *  历史成交
 */
- (void)getPositionHistoryStartDate:(NSString *)startDate endDate:(NSString *)endDate success:(SuccessBlock)success
                            failure:(FailueBlock)failure;
/*
 * 获取其他用户的历史成交纪录
 */
- (void)getPositionHistoryWithUserId:(NSString *)userId startDate:(NSString *)startDate endDate:(NSString *)endDate success:(SuccessBlock)success failure:(FailueBlock)failure;





@end
