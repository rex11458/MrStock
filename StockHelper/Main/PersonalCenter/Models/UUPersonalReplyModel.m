//
//  UUPersonalReplyModel.m
//  StockHelper
//
//  Created by LiuRex on 15/10/30.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalReplyModel.h"

@implementation UUPersonalReplyModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+ (NSArray *)replyModelArrayWithDictionary:(NSDictionary *)dic
{
    NSArray *jsonArray = dic[@"data"];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *dic in jsonArray) {
        
        UUPersonalReplyModel *replyModel = [[UUPersonalReplyModel alloc] initWithDictionary:dic];
        [dataArray addObject:replyModel];

    }
    
    return [dataArray copy];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
