//
//  UUStockDetailCommentViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/6/19.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUStockDetailCommentViewCellHeight 88.0f
#define UUStockDetailCommentViewCellId @"UUStockDetailCommentViewCellId"
@class TQRichTextView;
@class UUCommunityTopicNormalListModel;
@protocol UUStockDetailCommentViewCellDelegate;

@interface UUStockDetailCommentViewCell : BaseViewCell
{
    TQRichTextView *_textView;
}
@property (nonatomic,weak) id<UUStockDetailCommentViewCellDelegate> delegate;

@property (nonatomic,strong) UUCommunityTopicNormalListModel *normalListModel;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *praiseButton;
- (IBAction)buttonAction:(UIButton *)sender;

@end

@protocol UUStockDetailCommentViewCellDelegate <NSObject>

@optional
- (void)viewCell:(UUStockDetailCommentViewCell *)cell didSelectedIndex:(NSInteger)index; // 0评论  1点赞

@end