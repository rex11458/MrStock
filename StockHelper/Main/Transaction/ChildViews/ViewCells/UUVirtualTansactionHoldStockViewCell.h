//
//  UUVirtualTansactionHoldStockViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UUVirtualTansactionHoldStockViewCellHeight 90.0f

@class UUTransactionHoldModel;

@protocol UUVirtualTansactionHoldStockViewCellDelegate ;

@interface UUVirtualTansactionHoldStockViewCell : BaseViewCell
{
    UILabel *_stockNameLabel;
    UIView *_buttonView;
    UIView *_bgView;
}

@property (nonatomic, copy) NSArray *labelViewArray;

@property (nonatomic,strong) UUTransactionHoldModel *holdModel;

@property (nonatomic,assign) BOOL hiddenButtonView;

@property (nonatomic,assign) id<UUVirtualTansactionHoldStockViewCellDelegate> delegate;

@end

@protocol UUVirtualTansactionHoldStockViewCellDelegate <NSObject>

@optional
- (void)holdViewCell:(UUVirtualTansactionHoldStockViewCell *)cell operationWithIndex:(NSInteger)index;

@end