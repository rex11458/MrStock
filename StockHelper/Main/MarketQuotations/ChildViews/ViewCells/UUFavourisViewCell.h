//
//  UUFavourisViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/6/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUFavourisViewCellHeight 46.0f

@class UUFavourisStockModel;

@interface UUFavourisViewCell : BaseViewCell
{
    UILabel *_stockNameLabel;    //股票名称
    UILabel *_stockPriceLabel;   //股票价格
    UILabel *_markUpLabel;       //涨跌额
}

@property (strong, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *markUpLabel;


@property (nonatomic,strong) UUFavourisStockModel *stockModel;

- (void)fillData;

@end
