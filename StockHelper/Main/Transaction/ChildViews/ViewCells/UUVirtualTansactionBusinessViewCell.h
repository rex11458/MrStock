//
//  UUVirtualTansactionBusinessViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUTransactionModel.h"
#define UUVirtualTansactionBusinessViewCellHeight 110.0f

/*
 //00 当日成交 01当日委托 10历史成交 11历史委托
 */
typedef enum : NSUInteger {
    UUVirtualTansactionBusinessDailyDelegationType   = 0,
    UUVirtualTansactionBusinessDailyDealType         = 1,
    UUVirtualTansactionBusinessPastDealType          = 10,
//    UUVirtualTansactionBusinessPastDelegationType    = 11
} UUVirtualTansactionBusinessType;


@interface UUVirtualTansactionBusinessViewCell : BaseViewCell
{
    UIButton *_businessTypeButton;
    UILabel  *_stockNameLabel;
    UILabel *_statusLabel;
}

@property (nonatomic, copy) NSArray *labelViewArray;

@property (nonatomic,assign) UUVirtualTansactionBusinessType type;

@property (nonatomic,strong) UUTransactionModel *transactionModel;


@end
