//
//  UUStockCommomHeaderView.m
//  StockHelper
//
//  Created by LiuRex on 15/11/11.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockCommomHeaderView.h"

@implementation UUStockCommomHeaderView

- (instancetype)initWithFrame:(CGRect)frame operation:(void(^)(NSInteger))index
{
    if (self = [super initWithFrame:frame]) {
        _selectedIndex = [index copy];
    }
    return self;
}
- (void)showLineViewWithIndex:(NSInteger)index
{
   
}

@end
