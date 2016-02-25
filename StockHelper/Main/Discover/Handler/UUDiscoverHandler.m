//
//  UUDiscoverHandler.m
//  StockHelper
//
//  Created by LiuRex on 15/9/1.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUDiscoverHandler.h"
#import "UUNetworkClient.h"
#import <TMCache/TMCache.h>
#import "UUTradeChanceModel.h"
#import "UUGeniusModel.h"
@implementation UUDiscoverHandler

static  UUDiscoverHandler *shared = nil;
+ (UUDiscoverHandler *)sharedDiscoverHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}


//交易机会
- (void)getTradeChanceSuccess:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *url = k_TRADE_CHANCE_URL;
    
    NSString *key = url;
    if ([UUserDataManager sharedUserDataManager].user.customerID != nil) {
        key = [key stringByAppendingString:[UUserDataManager sharedUserDataManager].user.customerID];
    }
    
   id obj = [[TMCache sharedCache] objectForKey:key];
    
    UUTradeChanceListModel *listModel = [[UUTradeChanceListModel alloc] initWithData:obj error:nil];
    
    if (listModel.statusCode == 0)
    {
        success(listModel.data);
    }
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:nil isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
        }
        else
        {
            UUTradeChanceListModel *listModel = [[UUTradeChanceListModel alloc] initWithData:results error:nil];
            
            if ([listModel.statusCode integerValue] == 0)
            {
                success(listModel.data);
            }
            else
            {
                failure(listModel.message);
            }
        }
    }];
}

/*
 *  牛人榜
 *  type 牛人类型
 *  0-收益王、1-稳健王、2-人气王
 */
- (void)getGeniusListWithType:(NSInteger)type success:(SuccessBlock)success failure:(FailueBlock)failure
{
    /*
     * type参数跟界面UUGeniusType不一致
     */
    if (type == 0) {
        type = 1;
    }else if(type == 1){
        type = 0;
    }
    /*******************/
    NSString *url = k_GENIUS_RANK_LIST_URL;
    NSDictionary *params = k_GENIUS_RANK_LIST_BODY(type);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:url parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
        if (statusType == UURequestUnavailableType)
        {
            DLog(@"%@",NETWORK_UNAVAILABLE_MESSAGE);
        }
        else if (statusType == UURequestErroredType)
        {
            DLog(@"%@",NETWORK_ERROR_MESSAGE);
        }
        else
        {
            UUGeniusListModel *listModel = [[UUGeniusListModel alloc] initWithData:results error:nil];
            success(listModel.data);
        }
    }];
}

@end
