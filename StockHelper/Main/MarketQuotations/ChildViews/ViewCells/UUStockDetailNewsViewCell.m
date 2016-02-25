//
//  UUStockDetailNewsViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailNewsViewCell.h"
#import "UUStockDetailNoticeModel.h"
@implementation UUStockDetailNewsViewCell

- (void)setNoticeModel:(UUStockDetailNoticeModel *)noticeModel
{
    if (noticeModel != nil && _noticeModel != noticeModel) {
        _noticeModel = noticeModel;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGFloat fontSize = 12.0f;
    NSString *text = _noticeModel.announmtTitle;
    //名字
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                                 NSForegroundColorAttributeName : k_BIG_TEXT_COLOR
                                 };
    
    [text drawInRect:CGRectMake(k_LEFT_MARGIN, k_TOP_MARGIN * 0.5, CGRectGetWidth(self.bounds) - 2 * k_LEFT_MARGIN, 30.0f) withAttributes:attributes];
    
    attributes = @{
                   NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                   NSForegroundColorAttributeName : [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f]
                   };
    NSString *subTitle = [NSString stringWithFormat:@"%@",_noticeModel.publishDate];
    [subTitle drawInRect:CGRectMake(k_LEFT_MARGIN,CGRectGetHeight(self.bounds) - fontSize - k_TOP_MARGIN * 0.5, CGRectGetWidth(self.bounds) * 0.5, fontSize * 2) withAttributes:attributes];
}

/*
 *重新设置frame
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.x += k_LEFT_MARGIN;
    //    frame.origin.y += k_TOP_MARGIN;
    frame.size.width -= k_LEFT_MARGIN * 2;
    frame.size.height -= k_TOP_MARGIN;
    [super setFrame:frame];
}
@end
