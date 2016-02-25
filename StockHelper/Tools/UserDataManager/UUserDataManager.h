//
//  UUserDataManager.h
//  StockHelper
//
//  Created by LiuRex on 15/7/14.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

//#import <Foundation/Foundation.h>
/*
 状态码	statusCode	相见 返回值
 说明	message	返回说明
 信息如下：
 客户号	customerID	用户主键
 手机号	mobile
 昵称	nickName
 头像地址	headImg
 描述	depict
 邮箱	email
 姓名	name
 性别	sex	0-男、1-女
 邀请人主键	inviter
 邀请码	inviteCode
 邀请人数	inviteNumber
 用户状态	status	0-正常 1-锁定
 注册时间	registerTime
 注销时间	retireTime
 最后登录时间	lastLoginTime
 最后登录IP	lastLoginIP
 来源	markSource
 设备信息	deviceID
 IP地址	ip
 cookie	cookie
 新增字段。
 请求参数现未知，可能会有增加。
 scores
 fansCount
 followCount
 messageCount
 activityCount	
 经验值
 粉丝数量
 关注数量
 消息数量
 活动数量
 */

@interface User : NSObject <NSCoding>

@property (nonatomic, copy) NSString *customerID;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic,strong) NSNumber *scores;
@property (nonatomic, copy) NSString *depict;


@property (nonatomic,strong) NSNumber *fansCount;
@property (nonatomic,strong) NSNumber *followCount;
@property (nonatomic,strong) NSNumber *messageCount;
@property (nonatomic,strong) NSNumber *activityCount;
@property (nonatomic, copy) NSString *name;

@end

@interface UULoginUser : User

//sessionID
@property (nonatomic, copy) NSString *sessionID;
//@property (nonatomic, copy) NSString *customerID;

//-----
@property (nonatomic, copy) NSString *cookie;
@property (nonatomic, copy) NSString *deviceID;
@property (nonatomic, copy) NSString *email;

//@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *inviteCode;
@property (nonatomic, copy) NSString *inviteNumber;
@property (nonatomic, copy) NSString *inviter;

@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *lastLoginIP;
@property (nonatomic, copy) NSString *lastLoginTime;
@property (nonatomic, copy) NSString *markSource;
//@property (nonatomic, copy) NSString *mobile;
//@property (nonatomic, copy) NSString *name;

//@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *registerTime;
@property (nonatomic, copy) NSString *retireTime;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *status;
//
//@property (nonatomic,strong) NSNumber *scores;
//@property (nonatomic,strong) NSNumber *fansCount;
//@property (nonatomic,strong) NSNumber *followCount;
//@property (nonatomic,strong) NSNumber *messageCount;
//@property (nonatomic,strong) NSNumber *activityCount;
@end


@interface UUserDataManager : NSObject

@property (nonatomic,strong) UULoginUser *user;

+ (UUserDataManager *)sharedUserDataManager;

//保存用户登录信息
+ (void)saveUserLoggingInfo;
+ (void)saveUserLogoffInfo;
+ (BOOL)userIsOnLine;
+ (void)saveUserInfo;

@end
