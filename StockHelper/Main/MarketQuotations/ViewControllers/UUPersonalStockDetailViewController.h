//
//  UUPersonalStockDetailViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/6/17.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UUMarketStructs.h"
#import "UUPersonalStockHeaderView.h"
@class UUStockModel;
@interface UUPersonalStockDetailViewController : BaseViewController

@property (nonatomic,strong) UUStockModel *stockModel;

@property (nonatomic,strong) UUPersonalStockHeaderView *headerView;


@property (nonatomic,assign) BOOL isFav;

@end
