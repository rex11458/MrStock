//
//  UUStockListHeaderView.m
//  StockHelper
//
//  Created by LiuRex on 15/6/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockListHeaderView.h"

@implementation UUStockListHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        self.backgroundColor = k_BG_COLOR;//[UIColorTools colorWithHexString:@"#F6F6F6" withAlpha:1.0f];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    if (self = [self initWithFrame:frame]) {
        
        self.titleArray = titleArray;
    }
    
    return self;
}



- (void)setTitleArray:(NSArray *)titleArray
{
    if (_titleArray != titleArray) {
        _titleArray = [titleArray copy];
        
        [self setNeedsDisplay];
    }
}


- (void)drawRect:(CGRect)rect
{
    if (_titleArray.count == 0 || _titleArray == nil) {
        return;
    }
    [[UIKitHelper imageWithColor:k_LINE_COLOR] drawInRect:CGRectMake(0, CGRectGetHeight(rect) - 0.5, CGRectGetWidth(rect), 0.5)];
    

    CGFloat fontSize = 12.0f;
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                                 NSForegroundColorAttributeName : k_BIG_TEXT_COLOR
                                };
    [_titleArray[0] drawInRect:CGRectMake(30,(UUStockListHeaderViewHeight - fontSize) * 0.5,100,fontSize*2) withAttributes:attributes];
    
    if (_titleArray.count < 2) {
        return;
    }
    [_titleArray[1] drawInRect:CGRectMake(CGRectGetWidth(self.bounds) * 0.5,(UUStockListHeaderViewHeight - fontSize) * 0.5,60,fontSize*2) withAttributes:attributes];
    if (_titleArray.count < 3) {
        return;
    }
    [_titleArray[2] drawInRect:CGRectMake(CGRectGetWidth(self.bounds) - 80,(UUStockListHeaderViewHeight - fontSize) * 0.5, 100.0f, fontSize * 2) withAttributes:attributes];
    
}

@end
