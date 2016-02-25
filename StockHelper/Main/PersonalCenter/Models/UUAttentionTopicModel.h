//
//  UUAttentionTopicModel.h
//  StockHelper
//
//  Created by LiuRex on 15/10/29.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUCommunityTopicListModel.h"

@interface UUAttentionTopicModel : UUCommunityTopicNormalListModel

@property (nonatomic,assign) NSInteger orderId;         //

@property (nonatomic,assign) NSInteger messageType;     //类型

- (id)initWithDictionary:(NSDictionary *)dict ;

@end
