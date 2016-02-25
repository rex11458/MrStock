//
//  UUPersonalReplyViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/10/30.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalReplyViewCell.h"
#import "UUPersonalReplyModel.h"
@implementation UUPersonalReplyViewCell


- (void)setReplyModel:(UUPersonalReplyModel *)replyModel
{
    if (replyModel == nil || replyModel == _replyModel) {
        return;
    }
    _replyModel = replyModel;
    [self fillData];
}

- (void)fillData
{
    _replyContentLabel.text = _replyModel.replycontent;
    _topicContentLabel.text = _replyModel.content;
    _nameLabel.text = _replyModel.userName;
}

@end
