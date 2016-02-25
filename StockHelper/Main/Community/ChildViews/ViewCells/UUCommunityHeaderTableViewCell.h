//
//  UUCommunityHeaderTableViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/6/30.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UUCommunityTopicTopListModel;
#define UUCommunityHeaderTableViewCellHeight 48.0f
@interface UUCommunityHeaderTableViewCell : BaseViewCell
{
    UIImageView *_topImageView;             //顶
    UIImageView *_quintessenceImageView;    //精华
    UILabel *_textLabel;
}


@property (nonatomic,strong) UUCommunityTopicTopListModel *topListModel;

@end
