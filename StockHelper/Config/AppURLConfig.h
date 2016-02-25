//
//  AppURLConfig.h
//  StockHelper
//
//  Created by LiuRex on 15/5/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#ifndef StockHelper_AppURLConfig_h
#define StockHelper_AppURLConfig_h

//sockt请求地址
#define k_SOCKET_HOST @"115.29.32.50"
#define k_socket_PORT 6660

//http请求地址
#define k_BASE_URL  @"http://115.28.183.108/"

#define k_HEADER_SUBJECT_URL @"http://115.28.183.108/head/subject/"
//测试地址
//#define k_BASE_URL  @"http://192.168.1.110:8585/baseweb/"
//测试图片地址
//#define k_IMAGE_BASE_URL @"http://192.168.1.110:8585/img/subject/"
/*-----------------------------行情--------------------------------------*/
/*
 实时行情
 */
//股票列表
#define k_QUOTE_STOCK_QLIST_URL        @"qlist"
//行情查询 PUT请求  stocks：要查询的代码列表，逗号分隔
#define k_QUOTE_STOCKS_INFO_URL @"quote"
#define k_QUOTE_STOCKS_INFO_BODY(stocks) @{@"stocks":stocks}

//行情明细 code:股票代码
#define k_QUOTE_DETAIL_RUL(code) [NSString stringWithFormat:@"quote/detail/%@",code]
//按板块查询
    //blockcode：要查询的板块代码
#define k_QUOTE_BLOCK_INFO_URL(blockcode) [NSString stringWithFormat:@"quote/block/%@",blockcode]
    //blocks：要查询的板块代码列表，逗号分隔
#define k_QUOTE_BLOCK_LIST_URL(blocks) @"block"
//行情排序
    //按涨跌幅排序
    //updown：0-按涨幅排序，1-按跌幅排序
    //count：条数，默认为20条
#define k_QUOTE_STOCK_SORT_UP_DOWN_URL(updown,count) [NSString stringWithFormat:@"sort/updown/%@/%d",updown,count]
    //按换手率查询
    //updown：0-按涨幅排序，1-按跌幅排序
    //count：条数，默认为20条
#define k_QUOTE_STOCK_TURNOVER_RUL(updown,count)  [NSString stringWithFormat:@"sort/turnover/%@/%d",updown,count]
    //按振幅查询
    //updown：0-按涨幅排序，1-按跌幅排序
    //count：条数，默认为20条
#define k_QUOTE_STOCK_AMPLITUDE_RUL(updown,count)  [NSString stringWithFormat:@"sort/amplitude/%@/%d",updown,count]
    //按股价查询
    //updown：0-按涨幅排序，1-按跌幅排序
    //count：条数，默认为20条
#define k_QUOTE_STOCK_PRICE_RUL(updown,count)  [NSString stringWithFormat:@"sort/stockprice/%@/%d",updown,count]
//当日走势
    //code：股票代码
    //lst：最后更新时间，格式hhmm
#define k_STOCK_TREND_URL(code) [NSString stringWithFormat:@"trend/%@",code]
#define k_STOCK_TREND_LISTID_URL(code,listId) [k_STOCK_TREND_URL(code) stringByAppendingString:[NSString stringWithFormat:@"/%@",listId]]
//k线
    //code：股票代码
    //count：取得的最新K线数据条数，为零默认返回60条
//#define k_KLINE_URL(code,count) [NSString stringWithFormat:@"kline/%@/%d",code,count]
#define daily_kLine 6
#define week_kLine  7
#define month_kLine 8
#define k_KLINE_URL(type,code) [NSString stringWithFormat:@"%@/%@",type,code]

//股票复权
    //code：股票代码
    //startDate：起始日期
    //endDate：截止日期
#define k_STOCK_BONUS_URL(code,startDate,endDate) [NSString stringWithFormat:@"bonus/?code={%@}&f={%@}&e={%@}",code,startDate,endDate]

//http://{行情地址}/bonus/?code={code}&f={startDate}&e={endDate}
/*
 http://192.168.3.146:9080/StockDataWeb/info/companyAnnounmtsList.do?stockCode=600094&start=1&count=1000
 
 http://192.168.3.146:9080/StockDataWeb/info/companyAnnounmtsdetail.do?stockCode=600094&announmtID=74773.00000000
*/

/*
 http://192.168.2.12:10020/StockDataWeb/companyFinanceStock/getCompanyInfo.do（查询公司简介信息，参数为：securityCode  参数类型为varchar）;
 http://192.168.2.12:10020/StockDataWeb/companyFinanceStock/getCompanyCashbtaxrmbBySecurityCode.do（查询公司分红方案，参数为：securityCode 参数类型为varchar）;
 http://192.168.2.12:10020/StockDataWeb/companyFinanceStock/getTotalshareBySecurityCode.do（查询股本结构，参数为：securityCode 参数类型为varchar）;
 http://192.168.2.12:10020/StockDataWeb/companyFinanceStock/getShareHolderCirculate.do（查询十大流通股东，参数为：securityCode 参数类型为varchar）;
 http://192.168.2.12:10020/StockDataWeb/companyFinanceStock/getFinanceData.do（查询财务信息，参数为：securityCode 参数类型为varchar）;
 请晓，有问题请联系！
 */

//公司简介信息
#define k_COMPANY_INFOR_URL @"StockDataWeb/companyFinanceStock/getCompanyInfo.do"
#define k_COMPANY_INFOR_BODY(stockCode) @{@"securityCode":stockCode}

//分红
#define k_Cashbtaxrmb_URL  @"StockDataWeb/companyFinanceStock/getCompanyCashbtaxrmbBySecurityCode.do"
#define k_Cashbtaxrmb_BODY(stockCode) @{@"securityCode":stockCode}

//财务信息
#define k_COMMANY_FINANCE_RUL @"StockDataWeb/companyFinanceStock/getFinanceData.do"
#define k_COMMANY_FINANCE_BODY(stockCode) @{@"securityCode":stockCode}

//股本结构
#define k_TOTAL_STOCK_URL @"StockDataWeb/companyFinanceStock/getTotalshareBySecurityCode.do"
#define k_TOTAL_STOCK_BODY(stockCode) @{@"securityCode":stockCode}
//股东
#define k_STOCKHOLDER_URL @"StockDataWeb/companyFinanceStock/getShareHolderCirculate.do"
#define k_STOCKHOLDER_BODY(stockCode) @{@"securityCode":stockCode}

//公告
#define k_COMPANY_NOTICE_LIST_URL(stockCode,pageIndex,pageSize) [NSString stringWithFormat:@"/StockDataWeb/info/companyAnnounmtsList.do?stockCode=%@&start=%ld&count=%ld",stockCode,pageIndex,pageSize]
//公告详情
#define k_COMPANY_NOTICE_DETAIL_URL(stockCode,noticeId) [NSString stringWithFormat:@"/StockDataWeb/info/companyAnnounmtsdetail.do?stockCode=%@&announmtID=%@",stockCode,noticeId]

//分时成交
#define k_TIME_URL(code)                [NSString stringWithFormat:@"timeresult/%@",code]
#define k_TIME_LISTID_URL(code,listId)  [k_TIME_URL(code) stringByAppendingString:[NSString stringWithFormat:@"/%@",listId]]

//分价成交
#define k_PRICE_RESULT_URL(code) [NSString stringWithFormat:@"priceresult/%@",code]
//---------自选---------------------
//自选列表
#define k_FAVOURIS_STOCK_LIST_URL @"baseweb/sim/user/getUserStock.do"
//添加自选
#define k_ADD_FAVOURIS_URL @"baseweb/sim/user/addUserStock.do"
#define k_ADD_FAVOURIS_BODY(code,pos) @{@"code":code,@"pos":pos}
//添加多个自选
#define k_ADD_FAVOURISES_URL @"baseweb/sim/user/addUserStocks.do"
#define k_ADD_FAVOURISES_BODY(codes) @{@"codes":codes}
//修改排序
#define k_UPDATE_POSITION_URL @"baseweb/sim/user/updatePos.do"
#define k_UPDATE_POSITION_BODY(listIDA,pos) @{@"listIDA":listIDA,@"listIDB":listIDB}
//删除自选
#define k_DELETE_FAVOURIS_URL @"baseweb/sim/user/removeUserStock.do"
#define k_DELETE_FAVOURIS_BODY(listID) @{@"listID":listID}


/*-----------------------------交易--------------------------------------*/
//资金信息
#define k_VIRTUAL_TANSACTION_GET_BALANCE_URL @"baseweb/sim/user/getBalance.do"
#define k_VIRTUAL_TANSACTION_GET_BALANCE_BODY @{}

//收益走势
#define k_VIRTUAL_TANSACTION_PROFIT_HISTORY_URL @"baseweb/sim/user/getBalanceHistory.do"
#define k_VIRTUAL_TANSACTION_PROFIT_HISTORY_BODY(userId,startDate,endDate) @{@"userID":userId,@"startDate":startDate,@"endDate":endDate}

//用户持仓
#define k_VIRTUAL_TANSACTION_HOLD_URL @"baseweb/sim/user/getPosition.do"
#define k_VIRTUAL_TANSACTION_HOLD_BODY(code) @{@"code":code}
//历史交易
#define k_VIRTUAL_TRANSACTION_HISTORY_HOLD_URL @"baseweb/sim/user/getPositionHistory.do"
#define k_VIRTUAL_TRANSACTION_HISTORY_HOLD_BODY(userId,code,startDate) @{@"userID":userId,@"code":code,@"startDate":startDate}
//委托交易
#define k_VIRTUAL_TANSACTION_MAKE_DRDER_URL @"baseweb/sim/user/makeOrder.do"
#define k_VIRTUAL_TANSACTION_MAKE_DRDER_BODY(code,buySell,price,amount) @{@"code":code,@"buySell":buySell,@"price":price,@"amount":amount}//@{@"code":code,@"buySell":buySell,@"price":price,@"amount":amount}
//可撤单委托列表
#define k_VIRTUAL_TANSACTION_CANCEL_DRDER_LIST_URL @"baseweb/sim/user/canCancelOrder.do"

//撤销委托
#define k_VIRTUAL_TANSACTION_CANCEL_ORCER_URL @"baseweb/sim/user/cancelOrder.do"
#define k_VIRTUAL_TANSACTION_CANCEL_ORCER_BODY(orderID) @{@"orderID":orderID}
//当日委托
#define k_VIRTUAL_TANSACTION_GET_ORCER_URL @"baseweb/sim/user/getOrder.do"
#define k_VIRTUAL_TANSACTION_GET_ORCER_BODY @{}
//当日成交
#define k_VIRTUAL_TANSACTION_GET_RESULT_URL @"baseweb/sim/user/getResult.do"
#define k_VIRTUAL_TANSACTION_GET_RESULT_BODY @{}
//历史成交
#define k_VIRTUAL_TANSACTION_GET_HISTORY_URL @"baseweb/sim/user/getResultHistory.do"
#define k_VIRTUAL_TANSACTION_GET_HISTORY_BODY(startDate,endDate) @{@"startDate":startDate,@"endDate":endDate}
/*--------------------------------交易机会----------------------------------------------*/
#define k_TRADE_CHANCE_URL @"baseweb/sim/stock/getTradeChance.do"

/*-------------------------------牛人榜----------------------------------*/
#define k_GENIUS_RANK_LIST_URL @"baseweb/sim/stock/getStatistics.do"
#define k_GENIUS_RANK_LIST_BODY(sort) @{@"sort":@(sort)}

/*-----------------------------登录/注册--------------------------------------*/
//获取 验证码
#define k_REGISTER_MOBILE_CODE_URL @"UserWeb/reg/sendMobileCode.do"
#define k_REGISTER_MOBILE_CODE_BODY(mobile) @{@"mobile" : mobile}
//校验 验证码
#define k_VALIDATION_MOBILE_CODE_URL @"UserWeb/reg/verMobileCode.do"
#define k_VALIDATION_MOBILE_CODE_BODY(mobile,code) @{@"mobile" : mobile,@"code":code}

//注册
#define k_REGISTER_URL @"UserWeb/reg/register.do"
#define k_REGISTER_BODY(nickName,password,mobile,code,headImg) @{@"nickName":nickName,@"password":password, @"mobile" : mobile,@"code":code,@"headImg":headImg}

//登录
#define k_LOGIN_URL @"UserWeb/user/login.do"
#define K_LOGIN_BODY(mobile,password) @{@"mobile":mobile,@"password":password}

//获取用户详情
#define k_USER_INFO_URL  @"UserWeb/user/getCustomerMap.do"
#define k_USER_INFO_BODY(sessionID) @{@"sessionID":sessionID}

//退出登录
#define k_LOGOUT_URL @"UserWeb/user/logout.do"
#define k_LOGOUT_BODY(sessionID) @{@"sessionID":sessionID}

//找回密码 发送验证码
#define k_RECOVER_PASSWORD_URL @"UserWeb/find/sendPwdByCode.do"
#define k_RECOVER_PASSWORD_BODY(mobile) @{@"mobile":mobile}

//找回密码 校验验证码
#define k_RECOVER_PASSWORD_VALIDATION_URL @"UserWeb/find/verPwdByCode.do"
#define k_RECOVER_PASSWORD_VALIDATION_BODY(mobile,code) @{@"mobile":mobile,@"code":code}

//找回密码 修改密码
#define k_RECOVER_PASSWORD_MODIFICATION_URL @"UserWeb/find/modifyPwdByCode.do"
#define k_RECOVER_PASSWORD_MODIFICATION_BODY(mobile,code,newPassword) @{@"mobile":mobile,@"code":code,@"newPassword":newPassword}

//修改密码
#define k_PASSWORD_CHANGE_URL @"UserWeb/user/modifyPassword.do"
#define k_PASSWORD_CHANGE_BODY(oldPassword,newPassword) @{@"oldPassword":oldPassword,@"newPassword":newPassword}
//修改用户信息
#define k_MODIFY_USERINFO_URL @"UserWeb/user/modifyUserInfo.do"
#define k_MODIFY_USERINFO_BODY(nickName,depict,headImg) @{@"nickName":nickName,@"depict":depict,@"headImg":headImg}



/*-----------------------------社区--------------------------------------*/
#define k_COMMUNITY_HEADER_URL @"baseweb/community/subject"

//获取栏目列表
//getColumns.do?type=1
#define k_COMMUNITY_COLUMNS_LIST_URL [NSString stringWithFormat:@"%@/getColumns.do",k_COMMUNITY_HEADER_URL]
#define k_COMMUNITY_COLUMNS_LIST_BODY(type) @{@"type":@(type)}
//   115.28.183.108/baseweb/subject/getSubjects.do?pageNo=1&pageSize=10&type=1&relevanceId=r1&status=0
//话题列表
#define k_COMMUNITY_TOPIC_LIST_URL [NSString stringWithFormat:@"%@/getSubjects.do",k_COMMUNITY_HEADER_URL]
#define k_COMMUNITY_TOPIC_LIST_BODY(relevanceId,status,pageNo,pageSize,type) @{@"relevanceId":relevanceId,@"status":@(status),@"pageNo":@(pageNo),@"pageSize":@(pageSize),@"type":@(type)}

//获取话题评论列表
#define k_TOPIC_COMMENT_LIST_URL(subjectId,pageNo,pageSize,isAsc) [NSString stringWithFormat:@"%@/getReplies.do?subjectId=%@&pageNo=%@&pageSize=%@&isAsc=%@",k_COMMUNITY_HEADER_URL,@(subjectId),@(pageNo),@(pageSize),isAsc]
//获取话题点赞列表
#define k_TOPIC_PRAISE_LIST_URL(subjectId,pageNo,pageSize) [NSString stringWithFormat:@"%@/getSupportUsers.do?subjectId=%@&pageNo=%@&pageSize=%@",k_COMMUNITY_HEADER_URL,@(subjectId),@(pageNo),@(pageSize)]

//发表话题
#define k_COMMUNITY_PUBLIC_TOPIC_URL [NSString stringWithFormat:@"%@/send.do",k_COMMUNITY_HEADER_URL]
#define k_COMMUNITY_PUBLIC_TOPIC_BODY(relevanceId,content,images) @{@"relevanceId":relevanceId,@"content":content,@"images":images}
//删除话题
#define k_COMMUNITY_DELETE_TOPIC_URL [NSString stringWithFormat:@"%@/remove.do",k_COMMUNITY_HEADER_URL]
#define k_COMMUNITY_DELETE_TOPIC_BODY(subjectId) @{@"subjectId":@(subjectId)}

//评论话题
#define k_COMMUNITY_REPLY_TOPIC_URL [NSString stringWithFormat:@"%@/reply.do",k_COMMUNITY_HEADER_URL]
#define k_COMMUNITY_REPLY_TOPIC_BODY(subjectId,content,relevanceId) @{@"subjectId":@(subId),@"content":content,@"relevanceId":relevanceId}

//回复某个用户
#define k_COMMUNITY_REPLY_USER_URL [NSString stringWithFormat:@"%@/replyUser.do",k_COMMUNITY_HEADER_URL];
#define k_COMMUNITY_REPLY_USER_BODY(replyId,content,relevanceId) @{@"replyId":@(replyId),@"relevanceId":relevanceId,@"content":content}

//删除自己的某个回复
#define k_COMMUNITY_DELETE_REPLY_URL [NSString stringWithFormat:@"%@/removeReply.do",k_COMMUNITY_HEADER_URL]
#define k_COMMUNITY_DELETE_REPLY_BODY(replyId) @{@"replyId":@(replyId)}

//点赞
#define k_COMMUNITY_PRAISE_TOPIC_URL [NSString stringWithFormat:@"%@/support.do",k_COMMUNITY_HEADER_URL]
#define k_COMMUNITY_PRAISE_TOPIC_BODY(subjectId,isSupport) @{@"subjectId":@(subjectId),@"isSupport":isSupport}
/*----------------------------------------收藏-----------------------------------------------------*/
#define k_COLLECTION_HEADER_URL @"baseweb/community"
//收藏列表
#define k_COLLECTE_LIST_URL  [NSString stringWithFormat:@"%@/collection/list.do",k_COLLECTION_HEADER_URL]
#define k_COLLECTE_LIST_BODY(type,start,count) @{@"type":@(type),@"start":@(start),@"count":@(count)}

//收藏
#define k_COLLECTE_URL  [NSString stringWithFormat:@"%@/collect.do",k_COLLECTION_HEADER_URL]
#define k_COLLECTE_BODY(collect,collected,type) @{@"collect":collect,@"collected":collected,@"type":@(type)}
//是否收藏
#define k_ISCOLLECTED_URL [NSString stringWithFormat:@"%@/collect/isCollected.do",k_COLLECTION_HEADER_URL]
#define k_ISCOLLECTED_BODY(collect,collected,type) @{@"collect":collect,@"collected":collected,@"type":@(type)}
//取消收藏
#define k_CANCEL_COLLECTED_URL  [NSString stringWithFormat:@"%@/collection/list/delete.do",k_COLLECTION_HEADER_URL]
#define k_CANCEL_COLLECTED_BODY(listID) @{@"listID":listID}

//个人发帖和回贴
#define k_USER_TOPIC_LIST_URL [NSString stringWithFormat:@"%@/subject/getUserSubjects.do",k_COLLECTION_HEADER_URL]
#define k_USER_TOPIC_LIST_BODY(userID,contentType,pageNo,pageSize) @{@"userID":userID,@"contentType":@(contentType),@"pageNo":@(pageNo),@"pageSize":@(pageSize)}
/*---------------------------------------关注-------------------------------------------*/
//我关注的列表
#define k_FOCUS_LIST_URL  [NSString stringWithFormat:@"%@/follow/list.do",k_COLLECTION_HEADER_URL]
#define k_FOCUS_LIST_BODY(type,start,count) @{@"type":@(type),@"start":@(start),@"count":@(count)}
/*是否关注*/
#define k_IS_FOCUSED_URL  [NSString stringWithFormat:@"%@/follow/isFollowed.do",k_COLLECTION_HEADER_URL]
#define k_IS_FOCUSED_BODY(type,follow,followed) @{@"type":@(type),@"follow":follow,@"followed":followed}
//关注
#define k_FOCUS_URL  [NSString stringWithFormat:@"%@/follow.do",k_COLLECTION_HEADER_URL]
#define k_FOCUS_BODY(type,follow,followed) @{@"type":@(type),@"follow":follow,@"followed":followed}
//取消关注
#define k_CANCEL_FOCUS_URL  [NSString stringWithFormat:@"%@/follow/list/delete.do",k_COLLECTION_HEADER_URL]
#define k_CANCEL_FOCUS_BODY(listID) @{@"listID":listID}

//我的粉丝列表
#define k_FANS_LIST_URL  [NSString stringWithFormat:@"%@/fans/list.do",k_COLLECTION_HEADER_URL]
#define k_FANS_LIST_BODY(start,count) @{@"start":@(start),@"count":@(count)}

//签到
#define k_CHECK_IN_URL [NSString stringWithFormat:@"%@/checkIn.do",k_COLLECTION_HEADER_URL]
//是否签到
#define k_IS_CHECKED_IN_URL [NSString stringWithFormat:@"%@/isCheckIned.do",k_COLLECTION_HEADER_URL]

//系统消息
#define k_SYSTEM_MESSAGE_URL @"baseweb/interaction/message/getReceiviMessageList.do"

//红点提醒
#define k_USER_REMAIND_URL @"baseweb/interaction/message/messageRedInfo.do"
#define k_USER_REAMIND_BODY @{}

//取消红点
#define k_USER_CNACEL_REMAIND_URL @"/baseweb/interaction/message/cencelMessageRed.do"
#define k_USER_CNACEL_REMAIND_BODY(messageType) @{@"messageType":@(messageType)}

//关注信息列表
#define k_USER_ATTENTION_LIST_URL @"baseweb/interaction/message/attentionMessageList.do"
#define k_USER_ATTENTION_LIST_BODY(pageNo,pageSize) @{@"pageNo":@(pageNo),@"pageSize":@(pageSize)}

#endif
