//
//  UUAttentionTopicTradeModel.h
//  StockHelper
//
//  Created by LiuRex on 15/10/29.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUTradeChanceModel.h"

@interface UUAttentionTopicTradeModel : UUTradeChanceModel

- (id)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,assign) NSInteger messageType;


@property (nonatomic,assign) NSInteger orderId;

@end
