//
//  UUCommunityHandler.m
//  StockHelper
//
//  Created by LiuRex on 15/7/3.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUCommunityHandler.h"
#import "UUNetworkClient.h"
#import "UUCommunityTopicListModel.h"
#import "UUTopicReplyListModel.h"
#import "UUTopicPraiseListModel.h"
#import "UUCommunityColumnsModel.h"
#import "UUserDataManager.h"
@implementation UUCommunityHandler
static  UUCommunityHandler *shared = nil;
+ (UUCommunityHandler *)sharedCommunityHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}




/*
 获取栏目接口：
 getColumns.do?type=1
 type 0全部 1热门
 */
- (void)getCommunityColumnsWithType:(NSInteger)type
                            success:(SuccessBlock)success
                            failure:(FailueBlock)failure
{
    //    sessionID = f6b053a2e77c43d99a0898b606ce6ac3;
//    d73083bcf0c40d2e6fe3dd1ab3f78c9a

    NSString *urlString = k_COMMUNITY_COLUMNS_LIST_URL;

    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:[self baseParameters:k_COMMUNITY_COLUMNS_LIST_BODY(type)] isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
            DLog(@"栏目 ＝ %@",returnDic);
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                NSError *error = nil;
                UUCommunityColumnsListModel *listModel = [[UUCommunityColumnsListModel alloc] initWithDictionary:returnDic[@"data"] error:&error];
                success(listModel);
            }
            else
            {
                failure(nil);
            }
        }
    }];
}

/*
 *      获取话题列表
 *  relevanceId	String Y	关联ID（1热门 2股市大家谈 3新手学堂 4财经杂谈，其它是股票ID）
 *  status	Int	Y	0最新发布 1最新回复 2精华
 *  pageNo	Int	Y	页码
 *  pageSize	Int	Y	条数
 */
- (void)getCommunityTopicListWithRelevanceId:(NSString *)relevanceId
                                      status:(NSInteger)status
                                        type:(NSInteger)type
                                      pageNo:(NSInteger)pageNo
                                    pageSize:(NSInteger)pageSize
                                     success:(SuccessBlock)success
                                     failure:(FailueBlock)failure
{
//    http://192.168.1.110:8585/baseweb/community/subject/getSubjects.do?pageNo=1&pageSize=10&type=1&relevanceId=r1&status=0

    //    /subject/getSubjects.do&relevanceId=r1&status=0&pageNo=1&pageSize=10
    
    if (relevanceId == nil) {
        failure(@"无效的栏目Id");
        return;
    }
    
    NSString *urlString = k_COMMUNITY_TOPIC_LIST_URL;;
    NSDictionary *parmas = [self baseParameters:k_COMMUNITY_TOPIC_LIST_BODY(relevanceId, status, pageNo, pageSize,type)];
//    NSLog(@"话题列表params = %@",parmas);
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
//            DLog(@"话题列表 ＝ %@",returnDic);

            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                UUCommunityTopicListModel *listModel = [[UUCommunityTopicListModel alloc] initWithDictionary:returnDic[@"data"] error:nil];
                success(listModel);
            }else
            {
                failure(nil);
            }
        }
    }];
}


/*     获取话题评论列表
 *subjectId	int	Y	话题ID
 *pageNo	Int	Y	页码
 *pageSize	Int	Y	条数
 */
- (void)getTopicCommentListWithSubjectId:(NSInteger)subjectId
                                  pageNo:(NSInteger)pageNo
                                pageSize:(NSInteger)pageSize
                                 success:(SuccessBlock)success
                                 failure:(FailueBlock)failure
{
    NSString *urlString = k_TOPIC_COMMENT_LIST_URL(subjectId, pageNo, pageSize,@"false");
    
    DLog(@"获取话题评论列表 －－地址 %@",urlString);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestGETMethod url:urlString parameters:nil isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
                NSLog(@"评论列表 = %@",returnDic);
                UUTopicReplyListModel *listModel = [[UUTopicReplyListModel alloc] initWithDictionary:returnDic[@"data"] error:nil];
                success(listModel);
            }else
            {
                failure(nil);
            }
        }
    }];
}

/*      获取点赞用户列表
 *subjectId	int	Y	话题ID
 pageNo	Int	Y	页码
 pageSize	Int	Y	条数
 */
- (void)getTopicPraiseListWithSubjectId:(NSInteger)subjectId
                                 pageNo:(NSInteger)pageNo
                               pageSize:(NSInteger)pageSize
                                success:(SuccessBlock)success
                                failure:(FailueBlock)failure
{
    NSString *urlString = k_TOPIC_PRAISE_LIST_URL(subjectId, pageNo, pageSize);
    
    DLog(@"获取话题评论列表 －－地址 %@",urlString);
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestGETMethod url:urlString parameters:nil isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
                UUTopicPraiseListModel *listModel = [[UUTopicPraiseListModel alloc] initWithDictionary:returnDic[@"data"] error:nil];
                success(listModel);
            }else
            {
                failure(nil);
            }
        }
    }];

}


/*发表话题
 *relevanceId	String	Y	关联ID
 *content	String	Y	内容
 */
- (void)publicTopicWithRelevanceId:(NSString *)relevanceId
                           content:(NSString *)content
                            images:(NSString *)images
                           success:(SuccessBlock)success
                           failure:(FailueBlock)failure
{
    NSString *urlString = k_COMMUNITY_PUBLIC_TOPIC_URL;
    NSDictionary *params = [self baseParameters:k_COMMUNITY_PUBLIC_TOPIC_BODY(relevanceId, content, images)];
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
            NSLog(@"话题发表成功 －－ returnDic = %@",returnDic);
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                success(@"");
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*   删除话题
 *subId	int	Y	话题ID
 *
 */
- (void)deleteTopicWithSubId:(NSInteger)subId
                     success:(SuccessBlock)success
                     failure:(FailueBlock)failure
{
    NSString *urlString = k_COMMUNITY_DELETE_TOPIC_URL;
    NSDictionary *params = [self baseParameters:k_COMMUNITY_DELETE_TOPIC_BODY(subId)];

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
        
                success(nil);
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*  评论话题
 *subId	int	Y	话题ID
 content	String	Y	内容
 */
- (void)commentTopicWithSubId:(NSInteger)subId
                      content:(NSString *)content
                  relevanceId:(NSString *)relevanceId
                      success:(SuccessBlock)success
                      failure:(FailueBlock)failure
{
    NSString *urlString = k_COMMUNITY_REPLY_TOPIC_URL;
    NSDictionary *params = [self baseParameters:k_COMMUNITY_REPLY_TOPIC_BODY(subId, content, relevanceId)];

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
                UUTopicReplyModel *replyModel = [[UUTopicReplyModel alloc] initWithDictionary:returnDic[@"data"][@"replyInfo"] error:nil];
                success(replyModel);
            }else
            {
                failure(returnDic[@"message"]);
            }
            
        }

    }];
}


/* 回复用户
 *replyId	int	Y	回复ID
 *content	String	Y	内容
 */
- (void)replyUserWithReplyId:(NSInteger)replyId
                 relevanceId:(NSString *)relevanceId
                     content:(NSString *)content
                     success:(SuccessBlock)success
                     failure:(FailueBlock)failure;
{
    NSString *urlString = k_COMMUNITY_REPLY_USER_URL;
    NSDictionary *params = [self baseParameters:k_COMMUNITY_REPLY_USER_BODY(replyId, content, relevanceId)];

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
                UUTopicReplyModel *replyModel = [[UUTopicReplyModel alloc] initWithDictionary:returnDic[@"data"][@"replyInfo"] error:nil];
                success(replyModel);
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*  删除回复
 *replyId	int	Y	回复ID
 */
- (void)deleteReplyWithReplyId:(NSInteger)replyId
                       success:(SuccessBlock)success
                       failure:(FailueBlock)failure
{
    NSString *urlString = k_COMMUNITY_DELETE_REPLY_URL;
    NSDictionary *params = [self baseParameters:k_COMMUNITY_DELETE_REPLY_BODY(replyId)];

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



/*      点赞
 *  subjectId	int	Y	话题ID
 */
- (void)praiseTopicWithSubId:(NSInteger)subjectId
                   isSupport:(BOOL)isSupport
                     success:(SuccessBlock)success
                     failure:(FailueBlock)failure
{
    NSString *urlString = k_COMMUNITY_PRAISE_TOPIC_URL;
    
    NSString *param = isSupport ?@"true" : @"false";
    
    NSDictionary *params = [self baseParameters:k_COMMUNITY_PRAISE_TOPIC_BODY(subjectId,param)];
    
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
                UUTopicPraiseModel *listModel = [[UUTopicPraiseModel alloc] initWithDictionary:returnDic[@"data"][@"myInfo"][0] error:nil];
                success(listModel);
            }else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}


/*
 *--------------------收藏-------------------------------
 */
/*收藏*/
- (void)collectWithCollectedID:(NSString *)collectedID
                          type:(NSInteger)type
                       success:(SuccessBlock)success
                       failure:(FailueBlock)failure
{
    NSString *urlString = k_COLLECTE_URL    ;
    
    
    NSDictionary *params = [self baseParameters:k_COLLECTE_BODY([UUserDataManager sharedUserDataManager].user.customerID,collectedID,type)];
    
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
/*是否收藏*/
- (void)isCollected:(NSString *)collectedID
               type:(NSInteger)type
            success:(SuccessBlock)success
            failure:(FailueBlock)failure
{
    NSString *urlString = k_ISCOLLECTED_URL  ;
    NSDictionary *params = [self baseParameters:k_ISCOLLECTED_BODY([UUserDataManager sharedUserDataManager].user.customerID,collectedID, type)];
    
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
/*取消收藏*/
- (void)cancelCollectedListID:(NSString *)listID
                      success:(SuccessBlock)success
                      failure:(FailueBlock)failure
{
    NSString *urlString = k_CANCEL_COLLECTED_URL    ;
    NSDictionary *params = [self baseParameters:k_CANCEL_COLLECTED_BODY(listID)];
    
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
/*收藏列表*/
- (void)getColletionListWithType:(NSInteger)type
                           start:(NSInteger)start
                           count:(NSInteger)count
                         success:(SuccessBlock)success
                         failure:(FailueBlock)failure
{
    NSString *urlString = k_COLLECTE_LIST_URL;
    
    NSDictionary *params = [self baseParameters:k_COLLECTE_LIST_BODY(type,start,count)];
    
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
//            DLog(@"话题列表 ＝ %@",returnDic);
      
            
            if ([returnDic[@"statusCode"] isEqualToString:@"0"]) {
                
                if ([returnDic[@"data"] isKindOfClass:[NSNull class]]) {
                    success(nil);
                    return;
                }
                
                NSMutableArray *models = [NSMutableArray array];
                for (NSInteger i = 0;i < [returnDic[@"data"] count]; i++) {
                    
                    UUCommunityTopicNormalListModel *model = [[UUCommunityTopicNormalListModel alloc] initWithDictionary:returnDic[@"data"][i][@"subject"] error:nil];
                    [models addObject:model];
                    
                }
                success(models);
            
            
            }else
            {
                failure(nil);
            }
        }
    }];
}

@end
