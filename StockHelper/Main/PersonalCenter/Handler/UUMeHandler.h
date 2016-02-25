//
//  UUMeHandler.h
//  StockHelper
//
//  Created by LiuRex on 15/8/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseHandler.h"

@interface UUMeHandler : BaseHandler

+ (UUMeHandler *)sharedMeHandler;
/*获取关注列表
 *type	int	Y	0：用户   1：股票  2： 组合
 *start	int	Y	开始（0表示从第一条开始，用于分页，如果start不写，默认为0）
 *count	int	Y	条数，如果count不写或者count=0,都取出所有记录(如果count=0，start不起作用）
 */
- (void)getFocusListWithType:(NSInteger)type pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount success:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *获取粉丝列表
 */
- (void)getFansListWithType:(NSInteger)type pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount success:(SuccessBlock)success failure:(FailueBlock)failure;


/*
 *是否关注该用户
 *userId 被关注着的ID
*/
- (void)isFocusedWithUserId:(NSString *)userId type:(NSInteger)type success:(SuccessBlock)success failure:(FailueBlock)failure;

/*关注*/
- (void)focusWithUserId:(NSString *)userId type:(NSInteger)type success:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *取消关注
 *listId 关注纪录的ID
 */
- (void)cancelFocusWithListId:(NSString *)listId  success:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *签到
 */
- (void)checkInSuccess:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *是否已签到
 */
- (void)isCheckedInSuccess:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *红点提醒
 */
- (void)getRemaindSuccess:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 *  取消红点
 *  取消类型	messageType	传参：1-代表关注消息,0-代表系统通知
 */
- (void)cancelRemaindWithMessageType:(NSInteger)messageType success:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 * 获取我的关注消息列表
 */
- (void)getAttetionListWithPageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize success:(SuccessBlock)success failure:(FailueBlock)failure;

/*
 * 获取系统通知
 */
- (void)getSystemMessageSuccess:(SuccessBlock)success failure:(FailueBlock)failure;





@end
