//
//  UUStockSortViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/11/21.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "BaseViewCell.h"
#import "UUMarketStructs.h"
@class UUReportSortStockModel;
#define UUStockSortViewCellHeight 44.0f
@interface UUStockSortViewCell : BaseViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateLabel;

@property (nonatomic,strong) UUReportSortStockModel *stockModel;

@property (nonatomic,assign) UUMarketRankType type; //type = 1换手率

@end
