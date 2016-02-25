//
//  UUStockDetailViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/11/10.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UUPersonalStockDetailViewController.h"
#import "UUStockIdxDetailViewController.h"
#import "UUStockDetailLandspaceView.h"
@class UUStockModel;
@class UUStockCommomHeaderView;

UIKIT_EXTERN NSString *const stockDetailDidLoadSuccessNotificaiton;

@interface UUStockDetailViewController : BaseViewController
{
    @private
    UUStockIdxDetailViewController *_indexViewController;
    UUPersonalStockDetailViewController *_personalViewController;
}
@property (nonatomic,strong) UUStockModel *stockModel;

@property (nonatomic,strong)  UUStockCommomHeaderView *headerView;

@property (nonatomic,strong) UUStockDetailLandspaceView *landspaceView;
@property (nonatomic,strong) UIView  *protraitView;

@property (nonatomic,assign) NSInteger lineIndex;

- (void)loadData;

//是否为自选
@property (nonatomic,assign) BOOL isFav;

+ (UUStockDetailViewController *)g_sharedStockDetailViewController;

- initWithStockModel:(UUStockModel *)stockModel;

- (void)loadKLineWithIndex:(NSInteger)index;
- (void)loadSharePrice;

//股票买入/卖出
- (void)stockBuyingOrSell:(NSInteger)type;
//讨论
- (void)discuss;

@end
