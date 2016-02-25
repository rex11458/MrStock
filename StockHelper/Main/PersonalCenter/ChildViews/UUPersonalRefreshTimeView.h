//
//  UUPersonalRefreshTimeView.h
//  StockHelper
//
//  Created by LiuRex on 15/8/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
@class UUBubbleView;
@interface UUPersonalRefreshTimeView : BaseView
{
    UISlider *_slider;
    UUBubbleView *_bubbleView;
}
@property (nonatomic,assign) NSInteger seconds;

@end



@interface UUBubbleView : UIView

@property (nonatomic,assign) NSInteger value;

@end

