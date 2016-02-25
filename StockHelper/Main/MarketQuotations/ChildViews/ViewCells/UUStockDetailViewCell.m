//
//  UUStockDetailViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailViewCell.h"

@interface UUStockDetailViewCell ()
{
    
}
@end

@implementation UUStockDetailViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self configSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configSubViews
{
    
}

- (void)drawRect:(CGRect)rect
{
    CGFloat fontSize = 12.0f;
    NSString *text = @"如期讨论，今天大盘震荡，阳线收盘，明天大盘上涨节奏放缓，后天下调,如期讨论，今天大盘震荡，阳线收明天大盘上涨节奏放缓，后天下调,如期讨论，今天大盘震荡，阳线收盘盘";
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
    
    [@"Roy, 2015-06-12 18:32" drawInRect:CGRectMake(k_LEFT_MARGIN,CGRectGetHeight(self.bounds) - fontSize - k_TOP_MARGIN * 0.5, CGRectGetWidth(self.bounds) * 0.5, fontSize * 2) withAttributes:attributes];
    
    
    //赞
    fontSize = 14.0f;
    attributes = @{
                   NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                   NSForegroundColorAttributeName : [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f]
                   };
    [@"赞" drawInRect:CGRectMake(CGRectGetWidth(self.bounds) - k_LEFT_MARGIN - fontSize,CGRectGetHeight(self.bounds) - fontSize - k_TOP_MARGIN * 0.5 - 2.0f, fontSize, fontSize * 2) withAttributes:attributes];
    
    UIImage *image = [UIImage imageNamed:@"Stock_detail_zan"];
    [image drawInRect:CGRectMake(CGRectGetWidth(self.bounds) - k_LEFT_MARGIN - image.size.width  - fontSize - 2.0f, CGRectGetHeight(self.bounds) - k_BOTTOM_MARGIN * 0.5 - image.size.height, image.size.width, image.size.height)];
    
    //评论
    [@"评论" drawInRect:CGRectMake(CGRectGetWidth(self.bounds) - 2 * k_LEFT_MARGIN - image.size.width  - 3 * fontSize - 2.0f,CGRectGetHeight(self.bounds) - fontSize - k_TOP_MARGIN * 0.5 - 2.0f, fontSize * 2, fontSize*2) withAttributes:attributes];
    
    image = [UIImage imageNamed:@"Stock_detail_pinglun"];
    [image drawInRect:CGRectMake(CGRectGetWidth(self.bounds) - 2 * k_LEFT_MARGIN - image.size.width  - 4 * fontSize - 2 * 2.0f, CGRectGetHeight(self.bounds) - k_BOTTOM_MARGIN * 0.5 - image.size.height, image.size.width, image.size.height)];
    
//
//    
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
