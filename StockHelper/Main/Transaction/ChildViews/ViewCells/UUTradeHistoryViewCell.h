//
//  UUTradeHistoryViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/8/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUTradeHistoryViewCellHeight 170.0f
@class UUTransactionDealModel;
@interface UUTradeHistoryViewCell : BaseViewCell
{
    UIButton *_businessTypeButton;
    UILabel *_stockNameLabel;
}

@property (nonatomic, copy) NSArray *labelViewArray;

@property (nonatomic,strong) UUTransactionDealModel *dealModel;

@end
