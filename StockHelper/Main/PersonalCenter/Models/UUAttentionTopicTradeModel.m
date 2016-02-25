//
//  UUAttentionTopicTradeModel.m
//  StockHelper
//
//  Created by LiuRex on 15/10/29.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUAttentionTopicTradeModel.h"

@implementation UUAttentionTopicTradeModel


- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"userId"]) {
        self.userID = value;
    }
}

@end
