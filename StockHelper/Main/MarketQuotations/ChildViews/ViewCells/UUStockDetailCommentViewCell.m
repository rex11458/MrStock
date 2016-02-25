//
//  UUStockDetailCommentViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/19.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailCommentViewCell.h"
#import "UUCommunityTopicListModel.h"
#import "TQRichTextView.h"
@implementation UUStockDetailCommentViewCell

- (void)setNormalListModel:(UUCommunityTopicNormalListModel *)normalListModel
{
    if (normalListModel == nil || _normalListModel == normalListModel) {
        return;
    }
    _normalListModel = normalListModel;
    [self fillData];
}

- (void)awakeFromNib
{
    _textView = [[TQRichTextView alloc] initWithFrame:_contentLabel.frame];
    _textView.font = _contentLabel.font;
    //    _textView.delegage = self;
    _textView.backgroundColor = _contentLabel.backgroundColor;
    _textView.textColor = _contentLabel.textColor;
    
    [_contentLabel.superview addSubview:_textView];
}

- (void)fillData
{
        _textView.text = _normalListModel.content;
    
    _dateLabel.text = [NSString stringWithFormat:@"%@,%@",_normalListModel.userName,_normalListModel.createTime];
    
    _praiseButton.selected = _normalListModel.selfIsSupport;
    _commentButton.selected = _normalListModel.selfIsReply;
    
    if (_normalListModel.supportAmount > 0) {
          [_praiseButton setTitle:[@(_normalListModel.supportAmount) stringValue] forState:UIControlStateNormal];
    }
    if (_normalListModel.replyAmount) {
        [_commentButton setTitle:[@(_normalListModel.replyAmount) stringValue] forState:UIControlStateNormal];
    }
}

- (IBAction)buttonAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(viewCell:didSelectedIndex:)]) {
        [_delegate viewCell:self didSelectedIndex:sender.tag];
    }
}

@end
