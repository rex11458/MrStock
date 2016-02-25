//
//  BaseHandle.m
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseHandler.h"

@implementation BaseHandler


- (NSDictionary *)baseParameters:(NSDictionary *)dic
{
    NSMutableDictionary *baseBody = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UUserDataManager sharedUserDataManager].user.customerID,@"userID",[[UUserDataManager sharedUserDataManager].user.sessionID lowercaseString],@"sessionID",nil];
    [baseBody addEntriesFromDictionary:dic];
    return baseBody;
}
@end
