//
//  UUMeHandler.m
//  StockHelper
//
//  Created by LiuRex on 15/8/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUMeHandler.h"
#import "UUNetworkClient.h"
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
