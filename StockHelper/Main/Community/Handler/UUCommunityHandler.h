//
//  UUCommunityHandler.h
//  StockHelper
//
//  Created by LiuRex on 15/7/3.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseHandler.h"

@interface UUCommunityHandler : BaseHandler

+ (UUCommunityHandler *)sharedCommunityHandler;


/*
 获取栏目接口：
 getColumns.do?type=1
 type 0全部 1热门
 */
- (void)getCommunityColumnsWithType:(NSInteger)type
                             success:(SuccessBlock)success
                             failure:(FailueBlock)failure;

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
                                     failure:(FailueBlock)failure;

/*     获取话题评论列表
 *subjectId	int	Y	话题ID
 *pageNo	Int	Y	页码
 *pageSize	Int	Y	条数
 */
- (void)getTopicCommentListWithSubjectId:(NSInteger)subjectId
                                  pageNo:(NSInteger)pageNo
                                pageSize:(NSInteger)pageSize
                                 success:(SuccessBlock)success
                                 failure:(FailueBlock)failure;

/*      获取点赞用户列表
 *subjectId	int	Y	话题ID
 pageNo	Int	Y	页码
 pageSize	Int	Y	条数
 */
- (void)getTopicPraiseListWithSubjectId:(NSInteger)subjectId
                                  pageNo:(NSInteger)pageNo
                                pageSize:(NSInteger)pageSize
                                 success:(SuccessBlock)success
                                 failure:(FailueBlock)failure;
/*      发表话题
 *  relevanceId	String	Y	关联ID
 *  content	String	Y	
 *内容发帖接口已调整为16进制传输，参数名为images，以jsonarray形式传输例：
 ...&images=["111","222"]
 */
- (void)publicTopicWithRelevanceId:(NSString *)relevanceId
                           content:(NSString *)content
                            images:(NSString *)images
                           success:(SuccessBlock)success
                           failure:(FailueBlock)failure;

/*      删除话题
 *  subId	int	Y	话题ID
 *
 */
- (void)deleteTopicWithSubId:(NSInteger)subId
                     success:(SuccessBlock)success
                     failure:(FailueBlock)failure;

/*      评论话题
 *  subId	int	Y	话题ID
 *  content	String	Y	内容
 *  relevanceId 关联栏目ID
 */
- (void)commentTopicWithSubId:(NSInteger)subId
                      content:(NSString *)content
                  relevanceId:(NSString *)relevanceId
                      success:(SuccessBlock)success
                      failure:(FailueBlock)failure;

/*      回复用户
 *  replyId	int	Y	回复ID
     relevanceId
 *  content	String	Y	内容
 */
- (void)replyUserWithReplyId:(NSInteger)replyId
                 relevanceId:(NSString *)relevanceId
                  content:(NSString *)content
                  success:(SuccessBlock)success
                  failure:(FailueBlock)failure;

/*      删除回复
 *  replyId	int	Y	回复ID
 */
- (void)deleteReplyWithReplyId:(NSInteger)replyId
                       success:(SuccessBlock)success
                       failure:(FailueBlock)failure;

/*      点赞
 *  subjectId	int	Y	话题ID
 *  isSupport  是否点赞  传字符串 "true"和"false"
 */
- (void)praiseTopicWithSubId:(NSInteger)subjectId
                   isSupport:(BOOL)isSupport
                     success:(SuccessBlock)success
                     failure:(FailueBlock)failure;

/*
 *--------------------收藏-------------------------------
 */
/*收藏*/
- (void)collectWithCollectedID:(NSString *)collectedID
                          type:(NSInteger)type
                       success:(SuccessBlock)success
                       failure:(FailueBlock)failure;
/*是否收藏*/
- (void)isCollected:(NSString *)collectedID
               type:(NSInteger)type
            success:(SuccessBlock)success
            failure:(FailueBlock)failure;
/*取消收藏*/
- (void)cancelCollectedListID:(NSString *)listID
                      success:(SuccessBlock)success
                      failure:(FailueBlock)failure;
/*收藏列表*/
- (void)getColletionListWithType:(NSInteger)type
                           start:(NSInteger)start
                           count:(NSInteger)count
                         success:(SuccessBlock)success
                         failure:(FailueBlock)failure;
/*
 *  获取某个人的发帖和回贴
 *  contentType	传参:1代表他的发表的话题 0代表他的回贴和话题
 *
 */

- (void)getTopicListWithUserID:(NSString *)userID contentType:(NSInteger)contentType pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize success:(SuccessBlock)success failure:(FailueBlock)failure;



@end
