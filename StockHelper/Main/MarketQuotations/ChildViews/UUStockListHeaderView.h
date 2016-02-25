//
//  UUStockListHeaderView.h
//  StockHelper
//
//  Created by LiuRex on 15/6/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUStockListHeaderViewHeight 33.0f
@interface UUStockListHeaderView : UIView

@property (nonatomic,copy) NSArray *titleArray;


- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

@end
