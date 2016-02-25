//
//  UUCommunityPublicTopicView.h
//  StockHelper
//
//  Created by LiuRex on 15/6/29.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
@class UUCommunityInputAccessoryView;

#define UUCommunityInputAccessoryViewHeight  44.0f

@protocol UUCommunityInputAccessoryViewDelegate;
@protocol UUCommunityPublicTopicViewDelegate;
@interface UUCommunityPublicTopicView : UIScrollView<UITextViewDelegate>
{
//    UITextView *_textView;
    UIButton *_addImageButton;
    UUCommunityInputAccessoryView *_inputAccessoryView;
    UIView *_contentView;
    UILabel *_reminderLabel;
    UIImage *_image;
}

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,weak) id<UUCommunityPublicTopicViewDelegate> topicViewDelegate;

- (void)addImage:(UIImage *)image;

@end




@protocol UUCommunityPublicTopicViewDelegate <NSObject>

@optional
- (void)publicTopicViewAddImage:(UUCommunityPublicTopicView *)publicTopicView;

- (void)publicTopicViewAddStock:(UUCommunityPublicTopicView *)publicTopicView;


@end


@interface UUCommunityInputAccessoryView : UIView

@property (nonatomic,weak) id<UUCommunityInputAccessoryViewDelegate> delegate;

@property (nonatomic,assign) NSInteger keyboardType; // 0 默认键盘  1 表情键盘

@end

//---
@protocol UUCommunityInputAccessoryViewDelegate <NSObject>

@optional
- (void)accessoryView:(UUCommunityInputAccessoryView *)accessoryView didSelectedIndex:(NSInteger)index;// 0 选择表情 1选择股票

@end


