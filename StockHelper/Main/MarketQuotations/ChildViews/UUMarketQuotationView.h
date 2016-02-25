//
//  UUMarketQuotationView.h
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
#import "UUKLineView.h"
#import "UUStockDetailCurrentPriceView.h"
@class UUStockShareTimeView;
@class UUStockModelArray;
@class UUStockShareModelArray;
@class UUStockQuoteEntity;
@class UUStockDetailCurrentPriceView;
@class UUStockDetailModel;
#define VIEW_WIDTH  (PHONE_WIDTH - 2* k_LEFT_MARGIN)
#define VIEW_HEIGHT (VIEW_WIDTH * 0.65)

@interface UUMarketQuotationView : BaseView

@property (nonatomic,readonly,strong) UUKLineView *kLineView;
@property (nonatomic,copy) UUStockModelArray *stockModelArray;  //K线

@property (nonatomic,readonly,strong) UUStockShareTimeView *stockShareView;
@property (nonatomic,copy) UUStockShareModelArray *stockShareModelArray;//分时

@property (nonatomic,strong)UUStockDetailCurrentPriceView *currentPriceView;

- (void)showViewWithOptionIndex:(NSInteger)index;

//---K线-----
@property (nonatomic,copy) NSArray *kLineModelArray;

//分时
@property (nonatomic,strong) UUStockQuoteEntity *quoteEntity;
@property (nonatomic,copy,readonly) NSArray *stockTimeEntityArray;

//盘口
@property (nonatomic,strong) UUStockDetailModel *detailModel;

@property (nonatomic,assign) NSInteger type; //0 竖屏 1 横屏

//复权
@property (nonatomic, copy) ExRights exRights;

@property (nonatomic, copy) NSArray *exRightsArray;


@property (nonatomic,assign) NSInteger stockType; //0 个股 ，1 指数

- (instancetype)initWithFrame:(CGRect)frame stockType:(NSInteger)stockType;


@end
