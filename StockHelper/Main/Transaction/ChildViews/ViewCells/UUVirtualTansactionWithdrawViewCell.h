//
//  UUVirtualTansactionWithdrawViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/8/6.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UUTransactionDelegateModel;

#define UUVirtualTansactionWithdrawViewCellHeight 155.0f


@interface UUVirtualTansactionWithdrawViewCell : BaseViewCell
{
    UIButton    *_businessTypeButton;
    UILabel     *_stockNameLabel;
    UILabel     *_statusLabel;
    UIButton    *_withdrawButton;
    
    id          _target;
    SEL         _action;
}

@property (nonatomic, copy) NSArray *labelViewArray;


@property (nonatomic,strong) UUTransactionDelegateModel *transactionModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target action:(SEL)action;

@end
