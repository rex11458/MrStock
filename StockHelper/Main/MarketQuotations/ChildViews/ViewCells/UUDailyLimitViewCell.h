//
//  UUDailyLimitViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/6/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMarketStructs.h"
#define UUDailyLimitViewCellHeight 46.0f

@class UUReportSortStockModel;
@class UUStockBlockModel;
@interface UUDailyLimitViewCell : BaseViewCell


@property (nonatomic,assign) UUMarketRankType rankType;

@property (nonatomic,strong) UUReportSortStockModel *sortStockModel;

@property (nonatomic,strong) UUStockBlockModel *blockModel;

@end


#define UUDailyLimitViewHeaderViewHeight 33.0f
@interface UUDailyLimitViewHeaderView : UIView


@property (nonatomic,assign) UUMarketRankType rankType;


@end
