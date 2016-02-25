//
//  UUMeHandler.m
//  StockHelper
//
//  Created by LiuRex on 15/8/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUMeHandler.h"
#import "UUNetworkClient.h"
#import "UUFocusModel.h"
#import "UUAttentionTopicModel.h"
#import "UUAttentionTopicTradeModel.h"
#import "UUSystemMessageModel.h"
@implementation UUMeHandler

static  UUMeHandler *shared = nil;

+ (UUMeHandler *)sharedMeHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

/*获取关注列表*/
- (void)getFocusListWithType:(NSInteger)type pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_FOCUS_LIST_URL;;
    NSDictionary *parmas = [self baseParameters:k_FOCUS_LIST_BODY(type,pageIndex,pageCount)];
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:parmas isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            DLog(@"关注列表 ＝ %@",returnDic);
            
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                
                if ([returnDic[@"data"] isNull]) {
                    failure(@"无数据");

                }
                else
                {
                    NSMutableArray *models = [NSMutableArray array];
                    for (NSInteger i = 0;i < [returnDic[@"data"] count]; i++) {
                        
                        UUFocusModel *model = [[UUFocusModel alloc] initWithDictionary:returnDic[@"data"][i][@"user"] error:nil];
                        [models addObject:model];
                        
                    }
                    success(models);
                }
            }else
            {
                failure(nil);
            }
        }
    }];
}

/*
 *获取粉丝列表
 */
- (void)getFansListWithType:(NSInteger)type pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_FANS_LIST_URL;;
    NSDictionary *parmas = [self baseParameters:k_FANS_LIST_BODY(pageIndex,pageCount)];
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:parmas isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            DLog(@"关注列表 ＝ %@",returnDic);
            
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                
                if ([returnDic[@"data"] isNull]) {
                    failure(@"无数据");
                    
                }
                else
                {
                    NSMutableArray *models = [NSMutableArray array];
                    for (NSInteger i = 0;i < [returnDic[@"data"] count]; i++) {
                        
                        UUFocusModel *model = [[UUFocusModel alloc] initWithDictionary:returnDic[@"data"][i][@"user"] error:nil];
                        [models addObject:model];
                        
                    }
                    success(models);
                }
            }else
            {
                failure(nil);
            }
        }
    }];

}

/*
 *是否关注该用户
 *userId 被关注着的ID
 */

- (void)isFocusedWithUserId:(NSString *)userId type:(NSInteger)type success:(SuccessBlock)success failure:(FailueBlock)failure
{
    if (userId == nil) {
        userId = @"";
    }
    NSString *customUserID = [UUserDataManager sharedUserDataManager].user.customerID;
    
    if (customUserID == nil) {
        customUserID = @"";
    }
    
    NSString *urlString = k_IS_FOCUSED_URL;;
    NSDictionary *params = [self baseParameters:k_IS_FOCUSED_BODY(type,customUserID,userId)];
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                NSNumber *tag = @(-1);
                if (![returnDic[@"data"] isNull]) {
                    tag = returnDic[@"data"];
                }
                
                success(tag);
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];

}

/*关注*/
- (void)focusWithUserId:(NSString *)userId type:(NSInteger)type success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_FOCUS_URL  ;
    
    
    NSDictionary *params = [self baseParameters:k_FOCUS_BODY(type,[UUserDataManager sharedUserDataManager].user.customerID,userId)];
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                
                success(returnDic[@"data"]);
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *取消关注
 *listId 关注纪录的ID
 */
- (void)cancelFocusWithListId:(NSString *)listId  success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_CANCEL_FOCUS_URL    ;
    NSDictionary *params = [self baseParameters:k_CANCEL_FOCUS_BODY(listId)];
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                
                success(returnDic[@"message"]);
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}


/*
 *签到
 */
- (void)checkInSuccess:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_CHECK_IN_URL;
    NSDictionary *params = [self baseParameters:@{}];
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                
                success(returnDic[@"message"]);
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *是否已签到
 */
- (void)isCheckedInSuccess:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_IS_CHECKED_IN_URL;
    NSDictionary *params = [self baseParameters:@{}];
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                BOOL checked = [returnDic[@"data"] boolValue];
                success(@(checked));
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}


/*
 *红点提醒
 */
- (void)getRemaindSuccess:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_USER_REMAIND_URL;
    NSDictionary *params = [self baseParameters:@{}];
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {

                                success(returnDic[@"data"]);
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}


/*
 *  取消红点
 *  取消类型	messageType	传参：1-代表关注消息,0-代表系统通知
 */
- (void)cancelRemaindWithMessageType:(NSInteger)messageType success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_USER_CNACEL_REMAIND_URL;
    NSDictionary *params = [self baseParameters:k_USER_CNACEL_REMAIND_BODY(messageType)];
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                
                success(returnDic[@"data"]);
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 * 获取我的关注消息列表
 */
- (void)getAttetionListWithPageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize success:(SuccessBlock)success failure:(FailueBlock)failure
{    NSString *urlString = k_USER_ATTENTION_LIST_URL;
    NSDictionary *params = [self baseParameters:k_USER_ATTENTION_LIST_BODY(pageNo, pageSize)];
    
    
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                NSMutableArray *m_dataArray = [NSMutableArray array];
                NSArray *dataArray = returnDic[@"data"];
                NSLog(@"dataArray = %@",dataArray);
                [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                  BOOL messageType = [obj[@"messageType"] boolValue];
                    if (!messageType) {
                        UUAttentionTopicModel *topicModel = [[UUAttentionTopicModel alloc] initWithDictionary:obj];
                        [m_dataArray addObject:topicModel];
                    }else{
                        UUAttentionTopicTradeModel *tradeModel = [[UUAttentionTopicTradeModel alloc] initWithDictionary:obj];
                        [m_dataArray addObject:tradeModel];
                    }
                }];
                success([m_dataArray copy]);
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}


/*
 * 获取系统通知
 */
- (void)getSystemMessageSuccess:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_SYSTEM_MESSAGE_URL;
    NSDictionary *params = [self baseParameters:@{}];
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:params isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {

                UUSystemMessageListModel *listModel = [[UUSystemMessageListModel alloc] initWithData:results error:&error];

                success(listModel.data);
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

@end
