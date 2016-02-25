//
//  UUSuggestionView.h
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
#import "HPGrowingTextView.h"


#define UUCommitButtionActionTag 100
@interface UUSuggestionView : BaseView<HPGrowingTextViewDelegate>
{
    UIScrollView *_scrollView;
    CGSize _contentSize;
    
    HPGrowingTextView *_textView;
    UIButton *_confirmButton;
}
@end
