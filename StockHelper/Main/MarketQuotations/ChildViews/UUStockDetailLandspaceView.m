//
//  UUStockDetailLandspaceView.m
//  StockHelper
//
//  Created by LiuRex on 15/6/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailLandspaceView.h"
#import "UUStockShareTimeView.h"
#import "UUStockDetailCurrentPriceView.h"
#import <Masonry/Masonry.h>
#import "UUIndexDetailModel.h"
#import "UUStockFinancialModel.h"
@implementation UUStockDetailLandspaceView

- (void)awakeFromNib
{
    [self configSubViews];
}

- (void)configSubViews
{
    _quotationView = [[UUMarketQuotationView alloc] initWithFrame:CGRectZero stockType:_stockType];
    _quotationView.delegate = self;
    _quotationView.stockShareView.delegate = self;

    [self addSubview:_quotationView];

    [_quotationView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(self.mas_leading).with.offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-10);
        make.trailing.mas_equalTo(self.mas_trailing).with.offset(-10);
        make.top.mas_equalTo(_stockNameLabel.mas_bottom);
    }];
}

- (void)setStockType:(NSInteger)stockType
{
    _stockType = stockType;
    
    [self configSubViews];
}

- (void)setExRights:(ExRights)exRights
{
    _exRights = [exRights copy];
    _quotationView.exRights = _exRights;
}

#pragma mark - BaseViewDelegate
- (void)baseView:(BaseView *)baseView actionTag:(NSInteger)actionTag value:(id)values
{
    if (_selectedIndex) {
        _selectedIndex(actionTag);
    }
}

- (void)setQueotyEntity:(UUStockQuoteEntity *)queotyEntity
{
    if (queotyEntity == nil || _queotyEntity == queotyEntity) {
        return;
    }
    _queotyEntity = queotyEntity;
    _quotationView.quoteEntity = queotyEntity;
}

- (void)setCurrentPriceModelArray:(NSArray *)currentPriceModelArray
{
    if (currentPriceModelArray == nil || _currentPriceModelArray == currentPriceModelArray) {
        return;
    }
    _currentPriceModelArray = [currentPriceModelArray copy];
    _quotationView.currentPriceView.priceModelArray = _currentPriceModelArray;
}

- (void)setStockModel:(UUStockModel *)stockModel
{
    if (stockModel == nil) {
        return;
    }
    _stockModel = stockModel;
    if (_stockType == 0) {
        [self setDetailModel:(UUStockDetailModel *)stockModel];
    }else if (_stockType == 1){
        [self setIndexModel:(UUIndexDetailModel *)stockModel];
    }
}

- (void)setDetailModel:(UUStockDetailModel *)detailModel
{
    if (detailModel == nil || _detailModel == detailModel) {
        return;
    }
    _detailModel = detailModel;
    _quotationView.currentPriceView.detailModel = _detailModel;
    [self fillData];
}

- (void)setIndexModel:(UUIndexDetailModel *)indexModel
{
    if (indexModel == nil || _indexModel == indexModel) {
        return;
    }
    
    _indexModel = indexModel;
    [self fillData];
}

- (void)setExRightsArray:(NSArray *)exRightsArray
{
    if (exRightsArray == nil || _exRightsArray == exRightsArray) {
        return;
    }
    _exRightsArray = exRightsArray;
    
    _quotationView.exRightsArray = _exRightsArray;
}

#pragma mark - 财务数据
- (void)setFinacialModel:(UUStockFinancialModel *)finacialModel
{
    if (finacialModel == nil || _finacialModel == finacialModel) {
        return;
    }
    _finacialModel = finacialModel;
    [self fillFinancialData];
    
}
- (void)fillFinancialData
{
    //换手率
    _exchangeLabel.text = [NSString stringWithFormat:@"换手率：%@%%",[NSString amountValueWithDouble:(_detailModel.amount * 100) / (_finacialModel.MQLT) * 100]];

}

// 0表示指数 1表示个股

- (void)fillData
{
    //指数
    // 今开    昨收  振幅
    //涨家数 平家数 跌家数
    
    //个股
    //今开 左收 换手
    //最高 最低 成交
    //股票名称

    if (_stockType == 1)
    {
        NSString *stockName = [NSString stringWithFormat:@"%@\n%@",_indexModel.name,_indexModel.code];
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:stockName attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24.0f],NSForegroundColorAttributeName:k_BIG_TEXT_COLOR}];
        NSRange range = [stockName rangeOfString:_indexModel.code];
        [attString setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f],NSForegroundColorAttributeName:k_MIDDLE_TEXT_COLOR} range:range];
        _stockNameLabel.attributedText = attString;
        
        //今开
        _dailyOpenLabel.text = [NSString stringWithFormat:@"今开：%.2f",_indexModel.openPrice];
        //昨收
        _lstCloseLabel.text = [NSString stringWithFormat:@"昨收：%.2f",_indexModel.preClose];
        //涨家数
        _highestLabel.text = [NSString stringWithFormat:@"涨家数：%ld",_indexModel.raiseCount];
        //平家数
        _lowestLabel.text = [NSString stringWithFormat:@"平家数：--"];
    }else
    {
        NSString *stockName = [NSString stringWithFormat:@"%@\n%@",_detailModel.name,_detailModel.code];
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:stockName attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24.0f],NSForegroundColorAttributeName:k_BIG_TEXT_COLOR}];
        NSRange range = [stockName rangeOfString:_detailModel.code];
        [attString setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f],NSForegroundColorAttributeName:k_MIDDLE_TEXT_COLOR} range:range];
        _stockNameLabel.attributedText = attString;
        
             //今开
        _dailyOpenLabel.text = [NSString stringWithFormat:@"今开：%.2f",_detailModel.openPrice];
        //昨收
        _lstCloseLabel.text = [NSString stringWithFormat:@"昨收：%.2f",_detailModel.preClose];
        //最高
        _highestLabel.text = [NSString stringWithFormat:@"最高：%.2f",_detailModel.maxPrice];
        //最低
        _lowestLabel.text = [NSString stringWithFormat:@"最低：%.2f",_detailModel.minPrice];
    }
    //---
    [self cancelLongPress:nil];
}

- (void)loadCommonDataWithAmount:(double)amount newPrice:(double)price
{
    double newPrice = price;
    double prePrice = 0;
    if (_stockType == 1) {
        prePrice = _indexModel.preClose;
    }else{
        prePrice = _detailModel.preClose;
    }
    
    //股票价格
    //当前价格
    _priceLabel.text = [NSString amountValueWithDouble:newPrice];

    
    double upRaiseRate = 0;
    if (_detailModel.preClose != 0 || _indexModel.preClose != 0) {
        upRaiseRate = (newPrice - prePrice) / prePrice;
    }

    NSString *rateValue = [NSString amountValueWithDouble:newPrice - prePrice];
    NSString *rate = [NSString stringWithFormat:@"%.2f%%",upRaiseRate * 100];
    //背景色
    UIColor *color = k_EQUAL_COLOR;
    if (upRaiseRate > 0){
        color = k_UPPER_COLOR;
        
        rateValue = [@"+" stringByAppendingString:rateValue];
        rate = [@"+" stringByAppendingString:rate];
    }else if(upRaiseRate < 0){
        color = k_UNDER_COLOR;
    }
    _priceLabel.textColor = color;
    _rateLabel.textColor = color;
    _rateValueLabel.textColor = color;
    //涨跌额
    _rateValueLabel.text = rateValue;
    //涨跌幅
    _rateLabel.text = rate;
    
    if (_stockType == 1)
    {
        _volLabel.text = [NSString stringWithFormat:@"跌家数：%ld",_indexModel.fallCount];

    }
    else
    {
        //成交
        _volLabel.text = [NSString stringWithFormat:@"成交：%.0f",_detailModel.amount];
    }
}

- (void)showLineViewWithIndex:(NSInteger)index
{
    [_quotationView showViewWithOptionIndex:index];
}

#pragma mark - UUShareTimeViewDelegate
- (void)shareTimeView:(UUStockShareTimeView *)shareTimeView longPress:(NSInteger)index
{
    UUStockTimeEntity *entity = [shareTimeView.stockTimeEntityArray objectAtIndex:index];
    [self loadCommonDataWithAmount:entity.amount newPrice:entity.price];
}

- (void)cancelLongPress:(UUStockShareTimeView *)shareTimeView
{
    double price = 0;
    if (_stockType == 0) {
        price = _detailModel.newPrice;
    }else{
        price = _indexModel.newPrice;
    }
    
    [self loadCommonDataWithAmount:_detailModel.amount newPrice:price];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
