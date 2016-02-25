//
//  UUCommunityPublicTopicViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/6/29.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
@class UUCommunityTopicNormalListModel;
@interface UUCommunityPublicTopicViewController : BaseViewController
{
    void(^_success)(UUCommunityTopicNormalListModel *);
}
@property (nonatomic, copy) NSString *relevanceId;

- (void)success:(void(^)(UUCommunityTopicNormalListModel *))success;

@end
