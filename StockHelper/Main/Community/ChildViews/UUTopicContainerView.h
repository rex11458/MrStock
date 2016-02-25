//
//  UUTopicContainerView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/7.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPGrowingTextView;
#define kUUTopicContainerViewHeight 46.0f

@protocol UUTopicContainerViewDelegate;

@interface UUTopicContainerView : UIView

@property (nonatomic,weak) id<UUTopicContainerViewDelegate> delegate;

@property (nonatomic,strong,readonly) HPGrowingTextView *textView;


@end

@protocol UUTopicContainerViewDelegate <NSObject>

- (void)containerView:(UUTopicContainerView *)containerView sendMessage:(NSString *)message;
@optional
- (void)containerViewResignFirstResponder:(UUTopicContainerView *)containerView;

@end