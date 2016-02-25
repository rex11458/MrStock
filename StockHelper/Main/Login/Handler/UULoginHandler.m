//
//  UULoginHandler.m
//  StockHelper
//
//  Created by LiuRex on 15/7/14.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UULoginHandler.h"
#import "UUNetworkClient.h"
#import "UULogicHelper.h"
#import "UUserDataManager.h"
@implementation UULoginHandler

static  UULoginHandler *shared = nil;
+ (UULoginHandler *)sharedLoginHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (NSDictionary *)parameters:(NSDictionary *)dic
{
    NSMutableDictionary *baseBody = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UULogicHelper getUniqueDeviceIdentifie],@"deviceID", nil];
    [baseBody addEntriesFromDictionary:dic];
    return baseBody;
}

/*
 * －－－获取验证码－－－
 *mobile 手机号
 */
- (void)getCodeWithMobile:(NSString *)mobile
                   success:(SuccessBlock)success
                   failure:(FailueBlock)failure
{
    NSString *urlString = k_REGISTER_MOBILE_CODE_URL;
    
    [[UUNetworkClient sharedClient] loadWithRequstMethod:UURequestPOSTMethod url:urlString parameters:[self parameters:k_REGISTER_MOBILE_CODE_BODY(mobile)] isCache:YES completedBlock:^(id results, UURequestStatusType statusType, NSError *error) {
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
                
                success(returnDic[@"data"][@"code"]);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *－－－校验 验证码－－－－
 *手机号	mobile	必填项
 *验证码	code	必填项
 */
- (void)authenticationWithMobile:(NSString *)mobile
                            code:(NSString *)code
                         success:(SuccessBlock)success
                         failure:(FailueBlock)failure
{
    NSString *urlString = k_VALIDATION_MOBILE_CODE_URL;
    NSDictionary *params = [self parameters:k_VALIDATION_MOBILE_CODE_BODY(mobile, code)];
    
    
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
                     failure:(FailueBlock)failure
{
    NSString *urlString = k_REGISTER_URL;
    NSDictionary *params = [self parameters:k_REGISTER_BODY(nickName,password,mobile,code,headImg)];
    
    
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
 *------登录---------
 *手机号	mobile	必填项
 *密码	password	必填项
 */
- (void)loginWithMobile:(NSString *)mobile
               password:(NSString *)password
                success:(SuccessBlock)success
                failure:(FailueBlock)failure
{
    NSString *urlString = k_LOGIN_URL;
    NSDictionary *params = [self parameters:K_LOGIN_BODY(mobile,password)];
    
    
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
            NSString *dataString = [[NSString alloc] initWithData:results encoding:NSUTF8StringEncoding];
            NSLog(@"dataString = %@",dataString);
            
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0) {
                
                success(returnDic[@"data"][@"sessionID"]);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *获取用户详情
 *用户登录凭证，从登录接口获取
 *sessionID	必填项
 */
- (void)getUserInfoWithSessionId:(NSString *)sessionId
                         success:(SuccessBlock)success
                         failure:(FailueBlock)failure
{
    NSString *urlString = k_USER_INFO_URL;
    NSDictionary *params = [self parameters:k_USER_INFO_BODY(sessionId)];
    
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
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0)
            {
                UULoginUser *user = [[UULoginUser alloc] init];
                [user setValuesForKeysWithDictionary:returnDic[@"data"]];
                user.sessionID = [sessionId lowercaseString];
                
                [UUserDataManager sharedUserDataManager].user = user;
                [UUserDataManager saveUserLoggingInfo];
                
                success(user);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *获取其他用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)userId success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_USER_INFO_URL;
    NSDictionary *params = @{@"userID":userId,@"sessionID":@""};
    
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
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0)
            {
                User *user = [[User alloc] init];
                [user setValuesForKeysWithDictionary:returnDic[@"data"]];
                
                success(user);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*
 *－－－退出登录－－－
 */
- (void)logoutWithSessionID:(NSString *)sessionID
                    success:(SuccessBlock)success
                    failure:(FailueBlock)failure
{
    NSString *urlString = k_LOGOUT_URL;
    NSDictionary *params = [self parameters:k_LOGOUT_BODY(sessionID)];
    
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
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0)
            {
                
                success(returnDic[@"message"]);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
            [UUserDataManager saveUserLogoffInfo];

        }
    }];
}

/*
 *－－－找回密码 - h－－－
 */
- (void)recoverPasswordGetVerifyCodeWithMobile:(NSString *)mobile
                                       success:(SuccessBlock)success
                                       failure:(FailueBlock)failure
{
    NSString *urlString = k_RECOVER_PASSWORD_URL;
    NSDictionary *params = [self parameters:k_RECOVER_PASSWORD_BODY(mobile)];
    
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
//            NSLog(@"returnDic = %@",returnDic);
//            
            if ([returnDic[@"statusCode"] floatValue] == 0)
            {
                success(returnDic[@"data"][@"code"]);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}


/*
 *－－－找回密码 － 验证验证码
 */
- (void)recoverPasswordauthenticationWithMobile:(NSString *)mobile
                                           code:(NSString *)code
                                        success:(SuccessBlock)success
                                        failure:(FailueBlock)failure
{
    NSString *urlString = k_RECOVER_PASSWORD_VALIDATION_URL;
    NSDictionary *params = [self parameters:k_RECOVER_PASSWORD_VALIDATION_BODY(mobile, code)];
    
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
            NSLog(@"returnDic = %@",returnDic);

            if ([returnDic[@"statusCode"] floatValue] == 0)
            {
                success(returnDic[@"message"]);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

/*--------找回密码 设置新密码-----------
 *手机号	mobile
 *验证码	code
 */
- (void)resetPasswordWithMobile:(NSString *)mobile
                           code:(NSString *)code
                    newPassword:(NSString *)newPassword
                        success:(SuccessBlock)success
                        failure:(FailueBlock)failure
{
    NSString *urlString = k_RECOVER_PASSWORD_MODIFICATION_URL;
    NSDictionary *params = [self parameters:k_RECOVER_PASSWORD_MODIFICATION_BODY(mobile, code, newPassword)];
    
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
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0)
            {
                success(returnDic[@"message"]);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

//更改密码
- (void)changePasswordWithOldPassword:(NSString *)oldPassword
                          newPassword:(NSString *)newPassword
                              success:(SuccessBlock)success
                              failure:(FailueBlock)failure
{
    NSString *urlString = k_PASSWORD_CHANGE_URL;
    NSDictionary *params = [self baseParameters:[self parameters:k_PASSWORD_CHANGE_BODY(oldPassword, newPassword)]];
    
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
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0)
            {
                success(returnDic[@"message"]);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}
//修改用户信息
- (void)modifyUserInfoWithNickName:(NSString *)nickName depict:(NSString *)depict headImg:(NSString *)headImg success:(SuccessBlock)success failure:(FailueBlock)failure
{
    NSString *urlString = k_MODIFY_USERINFO_URL;
    NSDictionary *params = [self baseParameters:[self parameters:k_MODIFY_USERINFO_BODY(nickName,depict==nil?@"":depict,headImg==nil?@"":headImg)]];
    
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
            NSLog(@"returnDic = %@",returnDic);
            
            if ([returnDic[@"statusCode"] floatValue] == 0)
            {
                success(returnDic[@"message"]);
            }
            else
            {
                failure(returnDic[@"message"]);
            }
        }
    }];
}

@end
