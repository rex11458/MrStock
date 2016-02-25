//
//  UUPersonalStockHeaderView.h
//  StockHelper
//
//  Created by LiuRex on 15/11/11.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUStockCommomHeaderView.h"
#import "UUStockDetailPriceView.h"

#define UUPersonalStockDetailHeaderPriceViewHeight 180.0f
#define UUPersonalStockDetailHeaderViewHeight (UUPersonalStockDetailHeaderPriceViewHeight + VIEW_HEIGHT + UUOptionViewHeight * 2 + 15.0f)
@class UUStockDetailModel;
@class UUStockFinancialModel;
@interface UUPersonalStockHeaderView : UUStockCommomHeaderView
{
    @private
    UUStockDetailPriceView *_priceView;

    UUStockDetailModel *_detailModel;
    UUStockFinancialModel *_finacialModel;
}



@end
