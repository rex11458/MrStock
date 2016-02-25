//
//  UURichTextView.h
//  StockHelper
//
//  Created by LiuRex on 15/9/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UURichTextView : UITextView<UITextViewDelegate>
{
    void(^_selectStock)(NSString *);
}
- (instancetype)initWithFrame:(CGRect)frame selectStock:(void(^)(NSString *stockCode))selectStock;

+ (CGRect)boundingRectWithSize:(CGSize)size string:(NSString *)text attributes:(NSDictionary *)attributes;

@end
