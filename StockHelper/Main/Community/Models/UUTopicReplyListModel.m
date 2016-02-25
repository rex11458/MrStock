//
//  UUTopicRepyListModel.m
//  StockHelper
//
//  Created by LiuRex on 15/7/8.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTopicReplyListModel.h"

@implementation UUTopicReplyModel

- (NSString *)createTime
{
    return [_createTime customDateValue];
}

@end

@implementation UUTopicReplyListModel

@end


@implementation UUTopicReplySubModel

- (id)initWithTgtUserId:(NSString *)tgtUserId tgtUserName:(NSString *)tgtUserName tgtContent:(NSString *)tgtContent tgtOrderId:(NSInteger)tgtOrderId
{
    if (self = [super init]) {
        self.tgtUserId = tgtUserId;
        self.tgtContent = tgtContent;
        self.tgtOrderId = tgtOrderId;
        self.tgtUserName = tgtUserName;
    }
    return self;
}

@end