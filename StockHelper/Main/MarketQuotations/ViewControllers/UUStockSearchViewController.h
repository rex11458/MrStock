//
//  UUStockSearchViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/5/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseHandler.h"
@class UUFavourisStockModel;
@interface UUStockSearchViewController : UIViewController
{
    void(^_addFavSuccess)(UUFavourisStockModel *);
    void(^_deleteFavSuccess)(UUFavourisStockModel *);
}
@property (nonatomic, copy) SuccessBlock success;

- (void)addFavouris:(void(^)(UUFavourisStockModel *))success;
- (void)deleteFavourise:(void(^)(UUFavourisStockModel *))success;

@property (nonatomic) NSInteger type;   //0:自选搜索 1:发表话题选择股票  2:买入卖出搜索

@property (nonatomic) NSInteger pos;

@end
