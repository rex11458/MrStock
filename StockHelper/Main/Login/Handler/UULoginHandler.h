//
//  UULoginHandler.h
//  StockHelper
//
//  Created by LiuRex on 15/7/14.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseHandler.h"

@interface UULoginHandler : BaseHandler

+ (UULoginHandler *)sharedLoginHandler;

/*
 * －－－获取验证码－－－
 *mobile 手机号
 */
- (void)getCodeWithMobile:(NSString *)mobile
                   success:(SuccessBlock)success
                   failure:(FailueBlock)failure;

/*
 *－－－校验 验证码－－－－
 *手机号	mobile	必填项
*验证码	code	必填项
 */
- (void)authenticationWithMobile:(NSString *)mobile
                            code:(NSString *)code
                         success:(SuccessBlock)success
                         failure:(FailueBlock)failure;

/*
 *－－－注册－－－
 *昵称	nickName	必填项
 *密码	password	必填项
 *手机号	mobile	必填项
 *验证码	code	必填项
 *头像	headImg	选填
 */
- (void)registerWithNickName:(NSString *)nickName
                    password:(NSString *)password
                      mobile:(NSString *)mobile
                        code:(NSString *)code
                     headImg:(NSString *)headImg
                     success:(SuccessBlock)success
                     failure:(FailueBlock)failure;
/*
 *------登录---------
 *手机号	mobile	必填项
 *密码	password	必填项
 */
- (void)loginWithMobile:(NSString *)mobile
               password:(NSString *)password
                success:(SuccessBlock)success
                failure:(FailueBlock)failure;

/*
 *获取用户详情
 *用户登录凭证，从登录接口获取
 *sessionID	必填项
 */
- (void)getUserInfoWithSessionId:(NSString *)sessionId
                         success:(SuccessBlock)success
                         failure:(FailueBlock)failure;
/*
 *获取其他用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)userId success:(SuccessBlock)success failure:(FailueBlock)failure;


/*
 *－－－退出登录－－－
 */
- (void)logoutWithSessionID:(NSString *)sessionID
                    success:(SuccessBlock)success
                    failure:(FailueBlock)failure;

/*
 *－－－找回密码 - 获取验证码－－－
 */
- (void)recoverPasswordGetVerifyCodeWithMobile:(NSString *)mobile
                                       success:(SuccessBlock)success
                                       failure:(FailueBlock)failure;


/*
 *－－－找回密码 － 验证验证码
 */
- (void)recoverPasswordauthenticationWithMobile:(NSString *)mobile
                                           code:(NSString *)code
                                        success:(SuccessBlock)success
                                        failure:(FailueBlock)failure;
/*--------找回密码 设置新密码-----------
 *手机号	mobile
 *验证码	code
 */
- (void)resetPasswordWithMobile:(NSString *)mobile
                           code:(NSString *)code
                    newPassword:(NSString *)newPassword
                        success:(SuccessBlock)success
                        failure:(FailueBlock)failure;
//更改密码
- (void)changePasswordWithOldPassword:(NSString *)oldPassword
                          newPassword:(NSString *)newPassword
                              success:(SuccessBlock)success
                              failure:(FailueBlock)failure;

//修改用户信息
- (void)modifyUserInfoWithNickName:(NSString *)nickName depict:(NSString *)depict headImg:(NSString *)headImg success:(SuccessBlock)success failure:(FailueBlock)failure;

@end
