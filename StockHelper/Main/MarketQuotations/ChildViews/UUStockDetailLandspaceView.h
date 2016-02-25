//
//  UUStockDetailLandspaceView.h
//  StockHelper
//
//  Created by LiuRex on 15/6/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
#import "UUStockShareTimeView.h"
#import "UUOptionView.h"
#import "UUKLineView.h"
#import "UUStockTimeEntity.h"
#import "UUStockDetailModel.h"
#import "UUMarketQuotationView.h"
@class UUStockCurrentPriceModel;
@class UUIndexDetailModel;
@class UUStockFinancialModel;
typedef void(^SelectedIndexBlock) (NSInteger);

@interface UUStockDetailLandspaceView : BaseView<UUOptionViewDelegate,UUStockShareTimeViewDelegate,BaseViewDelegate>

@property (nonatomic,copy) SelectedIndexBlock selectedIndex;


@property (nonatomic,assign) NSInteger stockType; //0个股 ，1指数


@property (nonatomic,strong)  UUMarketQuotationView *quotationView;

@property (strong, nonatomic) IBOutlet UILabel *stockNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateLabel;

@property (strong, nonatomic) IBOutlet UILabel *dailyOpenLabel;
@property (strong, nonatomic) IBOutlet UILabel *highestLabel;
@property (strong, nonatomic) IBOutlet UILabel *lstCloseLabel;

@property (strong, nonatomic) IBOutlet UILabel *lowestLabel;
@property (strong, nonatomic) IBOutlet UILabel *exchangeLabel;
@property (strong, nonatomic) IBOutlet UILabel *volLabel;

@property (nonatomic,strong) UUStockQuoteEntity *queotyEntity;
@property (nonatomic,strong) UUStockDetailModel *detailModel;
@property (nonatomic,strong) UUIndexDetailModel *indexModel;

@property (nonatomic,strong) UUStockModel *stockModel;

@property (nonatomic,strong) UUStockFinancialModel *finacialModel;

//复权
@property (nonatomic, copy) ExRights exRights;

@property (nonatomic,copy) NSArray *exRightsArray; //复权信息列表


@property (nonatomic,strong) NSArray *currentPriceModelArray;

- (void)showLineViewWithIndex:(NSInteger)index;



@end
