//
//  UUPersonalReplyTopicDataSource.h
//  StockHelper
//
//  Created by LiuRex on 15/10/30.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "BaseDataSource.h"

@interface UUPersonalReplyTopicDataSource : BaseDataSource

@property (nonatomic, copy) NSString *userId;

- (instancetype)initWithUserId:(NSString *)userId;

@end
