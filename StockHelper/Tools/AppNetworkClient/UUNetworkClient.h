//
//  UUNetworkClient.h
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <AFNetworking.h>

typedef enum : NSUInteger {
    UURequestSuccessType,  //请求成功
    UURequestErroredType,        //请求出错
    UURequestUnavailableType     //网络出错
} UURequestStatusType;

typedef enum : NSUInteger {
    UURequestPOSTMethod,
    UURequestGETMethod
} UURequestMethod;

typedef void(^CompletedBlock)(id results,UURequestStatusType statusType,NSError *error);

@interface UUNetworkClient : AFHTTPSessionManager

@property (nonatomic,readonly) UURequestMethod requestMethod;

+ (UUNetworkClient *)sharedClient;

- (void)loadWithRequstMethod:(UURequestMethod)method url:(NSString *)url parameters:(id)parameter isCache:(BOOL)isCache completedBlock:(CompletedBlock)completedBlock;

@end
