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
/*
 * 获取系统通知
 */
- (void)getSystemMessageSuccess:(SuccessBlock)success failure:(FailueBlock)failure;





@end
