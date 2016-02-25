//
//  UUVirtualTansactionBuyingView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
#define UUVirtualTansactionBuyingViewHeight 318.0f

#define stockCodeTextFieldActionTag 100
#define buyingButtonActionTag       101
@class UUStockDetailModel;
@interface UUVirtualTansactionBuyingView : BaseView<UITextFieldDelegate>
{
    NSMutableDictionary *_priceDictionary;  //@{price:NSStringFromRect(frame),...}
    UIButton *_priceSelectedView;
    //---股票名称代码----
    UITextField *_stockCodeTextField;
    UILabel     *_stockNameLabel;
    //---股票价格-----
    UITextField *_stockPriceTextField;  //买入价
    UILabel *_lowestPriceLabel;     //跌停价
    UILabel *_highestPriceLabel;    //涨停价
    //------买入股数--------
    UITextField *_stockCountTextField;  //买入数量
    UILabel *_remainedCountLabel;   //可买股数
    
    //最新价，涨跌幅
    UILabel *_lstPriceLabel;
    UILabel *_rateLabel;
    
    //可买卖股数
    NSInteger _useCount;
    //买入按钮
    UIButton *_buyingButton;
}

@property (nonatomic,strong) UUStockDetailModel *detailModel;

//-------

@property (nonatomic, copy) NSString *stockName;

@property (nonatomic, copy) NSString *stockCode;

@property (nonatomic,assign) unsigned short market;

@property (nonatomic,assign) NSInteger count;

@property (nonatomic, copy) NSString *price;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) double useableValue;

- (void)becomingSearch;

@end
