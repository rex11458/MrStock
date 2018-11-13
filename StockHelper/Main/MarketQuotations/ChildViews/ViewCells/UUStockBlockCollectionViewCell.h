//
//  UUStockBlockCollectionViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/6/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewCell.h"
#define UUStockBlockViewCellHeight 80.0f
#define UUStockBlockViewSortCellHeight 44.0f
#define UUStockBlockSectionViewHeight 33.0f



@class UUReportSortStockModel;
@class UUStockBlockModel;
@interface UUStockBlockCollectionViewCell : BaseCollectionViewCell


@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,strong) UUReportSortStockModel *reportSortStockModel;

@property (nonatomic,strong) UUStockBlockModel *blockModel;

@end
