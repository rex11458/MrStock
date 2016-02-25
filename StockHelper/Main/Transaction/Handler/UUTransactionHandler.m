//
//  UUTransactionHandler.m
//  StockHelper
//
//  Created by LiuRex on 15/7/29.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTransactionHandler.h"
#import "UUNetworkClient.h"
#import "UUTransactionDelegateModel.h"
#import "UUTransactionDealModel.h"
#import "UUTransactionHoldModel.h"
#import "UUTransactionAssetModel.h"
#import "UUTransactionHistoryProfitModel.h"
@implementation UUTransactionHandler
static  UUTransactionHandler *shared = nil;
+ (UUTransactionHandler *)sharedTransactionHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

/*
 *  资金信息
 */
- (void)getBalanceSuccess:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_VIRTUAL_TANSACTION_GET_BALANCE_URL;
    NSDictionary *params =  [self baseParameters:k_VIRTUAL_TANSACTION_GET_BALANCE_BODY];
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            DLog(@"资金信息 = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                
                UUTransactionAssetModel *assetModel = [[UUTransactionAssetModel alloc] initWithDictionary:returnDic[@"data"] error:nil];
                
                success(assetModel);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *  获取他人资金信息 */
- (void)getBalanceWithUserId:(NSString *)userId Success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_VIRTUAL_TANSACTION_GET_BALANCE_URL;
    NSDictionary *params =  @{@"userID":userId.length ? userId:@""};
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            DLog(@"资金信息 = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                
                UUTransactionAssetModel *assetModel = [[UUTransactionAssetModel alloc] initWithDictionary:returnDic[@"data"] error:nil];
                
                success(assetModel);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *  收益走势
 */
- (void)getProfitHistoryWithUserId:(NSString *)userId startDate:(NSString *)startDate endDate:(NSString *)endDate success:(SuccessBlock)success failure:(FailueBlock)failure
{
    if (userId == nil) {
        failure(@"用户代码不能为空");
        return;
    }
    
    NSString *urlString = k_VIRTUAL_TANSACTION_PROFIT_HISTORY_URL;
    NSDictionary *params =  k_VIRTUAL_TANSACTION_PROFIT_HISTORY_BODY(userId, startDate, endDate);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            DLog(@"收益走势 = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {

                UUTransactionHistoryProfitListModel *listModel = [[UUTransactionHistoryProfitListModel alloc] initWithDictionary:returnDic error:nil];
                success(listModel.data);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *  用户持仓
 */
- (void)getHoldWithCode:(NSString *)code success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_VIRTUAL_TANSACTION_HOLD_URL;
    NSDictionary *params =  [self baseParameters:k_VIRTUAL_TANSACTION_HOLD_BODY(code)];
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                NSError *error = nil;
                UUTransactionHoldListModel *listModel = [[UUTransactionHoldListModel alloc] initWithDictionary:returnDic error:&error];
                if (listModel.data != nil && listModel.data.count > 0) {
                    success(listModel.data);
                }
                else
                {
                    failure(@"没有该股票持仓");
                }
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *查询其他用户持仓
 */
- (void)getHoldWithUserId:(NSString *)userId success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_VIRTUAL_TANSACTION_HOLD_URL;
    NSDictionary *params =  @{@"userID":userId ? userId:@"",@"code":@""};
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                NSError *error = nil;
                UUTransactionHoldListModel *listModel = [[UUTransactionHoldListModel alloc] initWithDictionary:returnDic error:&error];
                if (listModel.data != nil && listModel.data.count > 0) {
                    success(listModel.data);
                }
                else
                {
                    failure(@"没有该股票持仓");
                }
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *历史持仓
 */
- (void)getHistoryHoldWithUserId:(NSString *)userId success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_VIRTUAL_TRANSACTION_HISTORY_HOLD_URL;
    NSDictionary *params =  k_VIRTUAL_TRANSACTION_HISTORY_HOLD_BODY(userId, @"", @"");
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                NSError *error = nil;
                UUTransactionHoldListModel *listModel = [[UUTransactionHoldListModel alloc] initWithDictionary:returnDic error:&error];
                if (listModel.data != nil && listModel.data.count > 0) {
                    success(listModel.data);
                }
                else
                {
                    failure(@"没有该股票持仓");
                }
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *  委托交易
*buySell   委托类型：0-买 1-卖
*/
- (void)makeOrderWithCode:(NSString *)code buySell:(NSInteger)buySell price:(double)price amount:(double)amount success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_VIRTUAL_TANSACTION_MAKE_DRDER_URL;
    NSString *p = [NSString stringWithFormat:@"%.2f",price];
    NSDictionary *params =  [self baseParameters:k_VIRTUAL_TANSACTION_MAKE_DRDER_BODY(code,@(buySell),p,@(amount))];
    NSLog(@"委托买卖params == %@",params);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"returnDic = %@",returnDic);
        
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                
                success(returnDic[@"message"]);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}


/*
 *撤单列表
 */
- (void)getCancelOrderListSuccess:(SuccessBlock)success failue:(FailueBlock)failure
{
    NSString *urlString = k_VIRTUAL_TANSACTION_CANCEL_DRDER_LIST_URL;
    NSDictionary *params =  [self baseParameters:@{}];
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                
                
                UUTransactionListDelegateModel *listModel = [[UUTransactionListDelegateModel alloc] initWithDictionary:returnDic error:nil];
                
                success(listModel.data);
            }
            else
            {
                failure(returnDic[@"message"]);
            }

        }
    }];
}


/*
 *  撤销委托
 */
- (void)cancelOrderWithOrderID:(NSString *)orderID  success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_VIRTUAL_TANSACTION_CANCEL_ORCER_URL;
    NSDictionary *params =  [self baseParameters:k_VIRTUAL_TANSACTION_CANCEL_ORCER_BODY(orderID)];
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                
                success(returnDic[@"message"]);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *  当日委托
 */
- (void)getOrderSuccess:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_VIRTUAL_TANSACTION_GET_ORCER_URL;
    NSDictionary *params =  [self baseParameters:k_VIRTUAL_TANSACTION_GET_ORCER_BODY];
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                
                
                UUTransactionListDelegateModel *listModel = [[UUTransactionListDelegateModel alloc] initWithDictionary:returnDic error:nil];
                
                success(listModel.data);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *  当日成交
 */
- (void)getResultSuccess:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_VIRTUAL_TANSACTION_GET_RESULT_URL;
    NSDictionary *params =  [self baseParameters:k_VIRTUAL_TANSACTION_GET_RESULT_BODY];
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                UUTransactionListDealModel *listModel = [[UUTransactionListDealModel alloc] initWithDictionary:returnDic error:nil];
                
                success(listModel.data);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *  历史成交
 */
- (void)getPositionHistoryStartDate:(NSString *)startDate endDate:(NSString *)endDate success:(SuccessBlock )success
                            failure:(FailueBlock)failure
{
    NSString *urlString = k_VIRTUAL_TANSACTION_GET_HISTORY_URL;
    NSDictionary *params =  [self baseParameters:k_VIRTUAL_TANSACTION_GET_HISTORY_BODY(startDate, endDate)];
    NSLog(@"历史成交 ＝ %@",params);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                UUTransactionListDealModel *listModel = [[UUTransactionListDealModel alloc] initWithDictionary:returnDic error:nil];
                
                success(listModel.data);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 * 获取其他用户的历史成交纪录
 */

- (void)getPositionHistoryWithUserId:(NSString *)userId startDate:(NSString *)startDate endDate:(NSString *)endDate success:(SuccessBlock)success failure:(FailueBlock)failure
{
    
    NSString *urlString = k_VIRTUAL_TANSACTION_GET_HISTORY_URL;
    NSDictionary *params =  @{@"startDate":startDate,@"endDate":endDate,@"userID":userId};
    NSLog(@"历史成交 ＝ %@",params);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:NO completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
            failure(NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
            failure(NETWORK_ERROR_MESSAGE);
        }
        else
        {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                UUTransactionListDealModel *listModel = [[UUTransactionListDealModel alloc] initWithDictionary:returnDic error:nil];
                
                success(listModel.data);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

@end
