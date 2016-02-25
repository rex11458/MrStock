//
//  UUCommunityViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUCommunityViewCell.h"
#import "TQRichTextView.h"
#import "UUCommunityTopicListModel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UURichLabel.h"
#define USER_INFO_HEIGHT 58.0f
#define TRADE_INFO_HEIGHT 78.0f

@interface UUCommunityViewCell ()

@end

@implementation UUCommunityViewCell


- (void)setNormalListModel:(UUCommunityTopicNormalListModel *)normalListModel
{
    if (normalListModel == nil) {
        return;
    }
    _normalListModel = normalListModel;
   
    [self fillData];
    
    [self setNeedsDisplay];
}

- (void)fillData
{
    [_headerImage sd_setImageWithURL:[NSURL  URLWithString:_normalListModel.userPic] forState:UIControlStateNormal placeholderImage:[UIKitHelper imageWithColor:[UIColor purpleColor]]];
    
    _contentLabel.text = _normalListModel.content;
    [_nameButton setTitle:_normalListModel.userName forState:UIControlStateNormal];
    _fansLabel.text = [NSString stringWithFormat:@"粉丝：%ld",_normalListModel.fansAmount];
    _dateLabel.text = _normalListModel.createTime;
    //是否精华帖
    _essentialImage.hidden = ![_normalListModel.level boolValue];
    
    [_praiseButton setTitle:[[NSNumber numberWithInteger:_normalListModel.supportAmount] stringValue] forState:UIControlStateNormal];
    [_commentButton setTitle:[[NSNumber numberWithInteger:_normalListModel.replyAmount] stringValue] forState:UIControlStateNormal];
    
    _praiseButton.selected = _normalListModel.selfIsSupport;
    _commentButton.selected = _normalListModel.selfIsReply;
}

- (IBAction)userHomeAction:(id)sender {
    if ([_target respondsToSelector:_userHomeAction]) {
            [_target performSelector:_userHomeAction withObject:self afterDelay:0.0f];
        }
}
@end
