//
//  BaseHandle.h
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.


#import <SVProgressHUD/SVProgressHUD.h>
@class BaseModel;
@interface BaseHandler : NSObject


/**
 *  Handler处理成功时调用的Block
 */
typedef void (^SuccessBlock)(id obj);

/**
 *  Handler处理失败时调用的Block
 */
typedef void (^FailueBlock)(NSString *errorMessage);

- (NSDictionary *)baseParameters:(NSDictionary *)dic;

@end
