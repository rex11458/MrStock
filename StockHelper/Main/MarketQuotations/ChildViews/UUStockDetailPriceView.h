//
//  UUStockDetailPriceView.h
//  StockHelper
//
//  Created by LiuRex on 15/8/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUStockDetailPriceView : UIView

@property (strong, nonatomic) IBOutlet UIView *bgView;                  //背景颜色
@property (strong, nonatomic) IBOutlet UILabel *stockPriceLabel;        //当前价
@property (strong, nonatomic) IBOutlet UILabel *rateValueLabel;         //涨跌额
@property (strong, nonatomic) IBOutlet UILabel *rateLabel;              //涨跌幅
@property (strong, nonatomic) IBOutlet UILabel *dayOpenLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayOpenValueLabel;       //开盘价
@property (strong, nonatomic) IBOutlet UILabel *volLabel;
@property (strong, nonatomic) IBOutlet UILabel *volValueLabel;          //成交量
@property (strong, nonatomic) IBOutlet UILabel *exchangelabel;
@property (strong, nonatomic) IBOutlet UILabel *exchangeValueLabel;     //换手率
@property (strong, nonatomic) IBOutlet UILabel *lstCloseLabel;
@property (strong, nonatomic) IBOutlet UILabel *lstCloseValueLabel;     //昨收

@property (strong, nonatomic) IBOutlet UILabel *highLabel;              //最高价
@property (strong, nonatomic) IBOutlet UILabel *lowLabel;               //最低价
@property (strong, nonatomic) IBOutlet UILabel *totalTradeLabel;        //成交额
@property (strong, nonatomic) IBOutlet UILabel *innerLabel;             //内盘
@property (strong, nonatomic) IBOutlet UILabel *outerLabel;             //外盘
@property (strong, nonatomic) IBOutlet UILabel *totalValueLabel;        //市值
@property (strong, nonatomic) IBOutlet UILabel *earnValueLabel;         //市盈率
@property (strong, nonatomic) IBOutlet UILabel *shackValueLabel;         //振幅
@property (strong, nonatomic) IBOutlet UILabel *flowValueLabel;         //流通市值

@end
