//
//  UUCommunityViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/6/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"

@protocol UUCommunityHeaderViewDelegate;
#define UUCommunityHeaderViewHeight 400.0f

@interface UUCommunityViewController : BaseViewController

@end


@interface UUCommunityHeaderView : UIView


@property (nonatomic,copy) NSArray *columnArray; //

@property (nonatomic,weak) id<UUCommunityHeaderViewDelegate> delegate;

- (CGFloat)height;

@end


@protocol UUCommunityHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(UUCommunityHeaderView *)headerView didSelectedIndex:(NSInteger)index;

@end