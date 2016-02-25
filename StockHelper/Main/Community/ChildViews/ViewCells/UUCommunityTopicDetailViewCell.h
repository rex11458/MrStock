//
//  UUCommunityTopicDetailViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/6/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UURichLabel.h"
@class UUCommunityTopicDetailSubView;
@class UUTopicReplyModel;
@class UUTopicReplySubModel;
@class TQRichTextView;
#define UUCommunityTopicDetailViewCellHeight 80.0f
#define UUCommunityTopicDetailSubViewHeight 70.0f

@interface UUCommunityTopicDetailViewCell : BaseViewCell
{
    UIImageView *_bgImageView;
    UILabel *_nameLabel;
    UILabel *_dateLabel;
}

@property (nonatomic) id target;
@property (nonatomic) SEL userHomeAciton;

@property (nonatomic,strong,readonly) UUCommunityTopicDetailSubView *subView;

@property (nonatomic,strong) UUTopicReplyModel *topicReplyModel;

+ (CGRect)contentBoundsWithText:(NSString *)text;
@end


@interface UUCommunityTopicDetailSubView : UIView
{
    UILabel *_nameLabel;
    UURichLabel*_textView;
}

@property (nonatomic,strong) UUTopicReplySubModel *replySubModel;

@end
