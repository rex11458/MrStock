//
//  UUStockDetailViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/6/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UUMarketStructs.h"
#import "UUStockModel.h"
#import "UUIndexStockHeaderView.h"

@interface UUStockIdxDetailViewController : BaseViewController<UUOptionViewDelegate>

@property (nonatomic,strong) UUStockModel *stockModel;

@property (nonatomic,strong) UUIndexStockHeaderView *headerView;

@property (nonatomic,assign) BOOL isFav;


@end
