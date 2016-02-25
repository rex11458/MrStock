//
//  UUNetworkClient.m
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUNetworkClient.h"
#import "Reachability.h"
#import <TMCache.h>
#define HTTP_CONTENT @"text/plain"

@implementation UUNetworkClient
- (id)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        _requestMethod = UURequestPOSTMethod;
    }
    return self;
}

- (id)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        _requestMethod = UURequestPOSTMethod;
    }
    return self;
}
+ (UUNetworkClient*)sharedClient
{
    static UUNetworkClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //设置http头
        if (!_sharedClient)
        {
            _sharedClient = [[UUNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:k_BASE_URL] sessionConfiguration:config];
        }
        //xml
        //_sharedClient.responseSerializer = [AFXMLParserResponseSerializer serializer];
        //json
        //十秒超时
        _sharedClient.requestSerializer.timeoutInterval = 10;
        
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain" , nil];
    });
    return _sharedClient;
}

- (void)loadWithRequstMethod:(UURequestMethod)method url:(NSString *)url parameters:(id)parameter isCache:(BOOL)isCache completedBlock:(CompletedBlock)completedBlock
{
    //获取相关缓存
    if (NETWORK_UNAVAILABLE) {
     
        id obj = nil;
        UURequestStatusType type = UURequestUnavailableType;
        if (isCache)
        {
            NSString *key = url;
            if ([UUserDataManager sharedUserDataManager].user.customerID != nil) {
                key = [key stringByAppendingString:[UUserDataManager sharedUserDataManager].user.customerID];
            }
            
            obj = [[TMCache sharedCache] objectForKey:key];
            if (obj) {
                type = UURequestSuccessType;
            }
        }
        completedBlock(obj, type,nil);
    }
    //请求最新数据
    NETWORK_ACTIVITY_INDICATOR_VISIBLIE(YES);
    [self handleWithMethod:method url:url parameters:parameter success:^(id task, id resposeObj) {
        NETWORK_ACTIVITY_INDICATOR_VISIBLIE(NO);
        if ([resposeObj isNull]) return ;
     
        //将数据缓存到本地
        NSString *key = url;
        if ([UUserDataManager sharedUserDataManager].user.customerID != nil) {
            key = [key stringByAppendingString:[UUserDataManager sharedUserDataManager].user.customerID];
        }
        
        if(isCache)  [[TMCache sharedCache] setObject:resposeObj forKey:key];
        
        completedBlock(resposeObj,UURequestSuccessType,nil);
        
    } failure:^(id task, NSError *error) {
        
        NETWORK_ACTIVITY_INDICATOR_VISIBLIE(NO);
        completedBlock(nil,UURequestErroredType,error);
        
    }];
}

/**
 *
 *
 *  @param method       请求方式  POST/GET
 *  @param url          URL字符串
 *  @param isCache      是否缓存
 *  @param success      请求成功后返回
 *  @param failue       请求失败后返回
 */
- (void)handleWithMethod:(UURequestMethod)method url:(NSString *)url parameters:(id)parameters success:(void(^)(id task,id resposeObj))success failure:(void(^)(id task,NSError *error))failue
{
    if (SCREEN_IOS_VS >= 7.0)
    {
        if (method == UURequestGETMethod)
        {
            [self GET:url parameters:nil success:success failure:failue];
        }
        else if(method == UURequestPOSTMethod)
        {
            [self POST:url parameters:parameters success:success failure:failue];
        }
    }else
    {
        NSURL *baseURL = [NSURL URLWithString:k_BASE_URL];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:HTTP_CONTENT]];
        [manager GET:url parameters:nil success:success failure:failue];

        if (method == UURequestGETMethod)
        {
            [manager GET:url parameters:nil success:success failure:failue];
        }
        else if(method == UURequestPOSTMethod)
        {
            [manager POST:url parameters:parameters success:success failure:failue];
        }
    }
}

@end
