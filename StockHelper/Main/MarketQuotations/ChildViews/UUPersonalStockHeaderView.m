//
//  UUPersonalStockHeaderView.m
//  StockHelper
//
//  Created by LiuRex on 15/11/11.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalStockHeaderView.h"
#import "UUMarketQuotationView.h"
#import "UUStockDetailModel.h"
#import "UUStockFinancialModel.h"



@implementation UUPersonalStockHeaderView

- (instancetype)initWithFrame:(CGRect)frame operation:(void(^)(NSInteger))index
{
    if (self = [super initWithFrame:frame operation:index]) {
        self.backgroundColor = k_BG_COLOR;
        [self configSubViews];

    }
    return self;
}

- (UILabel *)labelWithFont:(UIFont *)font
{
    UILabel *label = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont boldSystemFontOfSize:40.0f] textColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"--";
    [self addSubview:label];
    return label;
}

- (void)configSubViews
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"UUStockDetailPriceView" owner:self options:nil];
    
    UUStockDetailPriceView *priceView = [nibs firstObject];
    [self addSubview:priceView];
    _priceView = priceView;
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(180);
    }];
    //-----
    self.marketQuotationView = [[UUMarketQuotationView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, UUPersonalStockDetailHeaderPriceViewHeight,CGRectGetWidth(self.bounds) - 2 * k_LEFT_MARGIN, VIEW_HEIGHT + UUOptionViewHeight)];
    self.marketQuotationView.type = 0;
    self.marketQuotationView.delegate = self;
    [self addSubview:self.marketQuotationView];
}

- (void)showLineViewWithIndex:(NSInteger)index
{
    [self.marketQuotationView showViewWithOptionIndex:index];
}
#pragma mark - 数据填充
- (void)setStockModel:(UUStockModel *)stockModel
{
    if (stockModel == nil ) {
        return;
    }
    _detailModel = (UUStockDetailModel*)stockModel;
    
    [self setDetailModel:_detailModel];
}


- (void)setDetailModel:(UUStockDetailModel *)detailModel
{
    self.marketQuotationView.currentPriceView.detailModel = _detailModel;
    [self fillData];
    
    if (_finacialModel != nil) {
        [self setFinacialModel:_finacialModel];
    }
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

#pragma mark - BaeViewDelegate
- (void)baseView:(BaseView *)baseView actionTag:(NSInteger)actionTag value:(id)values
{
    if (self.selectedIndex) {
        self.selectedIndex(actionTag);
    }
}

- (void)fillFinancialData
{
    //市值
    _priceView.totalValueLabel.attributedText = [self attributeStringWithTitle:@"市 值：" value:(_finacialModel.ZGB * _detailModel.newPrice)];
    //市盈率
    double value = [[NSString amountValueWithDouble:_detailModel.newPrice / _finacialModel.MGSY] doubleValue];
    _priceView.earnValueLabel.attributedText = [self usefulAttributeStringTextWithoutDot:@"市盈率：" withValue:value];
    
    //流动市值
    _priceView.flowValueLabel.attributedText = [self attributeStringWithTitle:@"流动市值：" value:_finacialModel.MQLT * _detailModel.newPrice];
    
    //换手率
    _priceView.exchangeValueLabel.text = [NSString stringWithFormat:@"%@%%",[NSString amountValueWithDouble:(_detailModel.amount * 100) / (_finacialModel.MQLT) * 100]];
}

- (NSAttributedString *)attributeStringWithTitle:(NSString *)title value:(double)value
{
    NSString *money = [NSString amountTransformToPrice:value];
    money = [title stringByAppendingString:money];
    
    NSDictionary *attributes = @{NSFontAttributeName:k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR};
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:money];
    NSRange range = [money rangeOfString:[money substringFromIndex:title.length]];
    [attString setAttributes:attributes range:range];
    
    return attString;
}


- (void)fillData
{
    //当前价格
    
    if (_detailModel.newPrice == 0) {
        _priceView.stockPriceLabel.text = @"停牌";
        return;
    }
    
    _priceView.stockPriceLabel.text = [NSString amountValueWithDouble:_detailModel.newPrice];
    
    double upRaiseRate = 0;
    double zhenfu = 0;
    
    if (_detailModel.preClose != 0 && _detailModel.newPrice != 0) {
        upRaiseRate = (_detailModel.newPrice - _detailModel.preClose) / _detailModel.preClose;
        zhenfu = (_detailModel.maxPrice - _detailModel.minPrice) / _detailModel.preClose * 100;
    }
    
    NSString *rateValue = [NSString amountValueWithDouble:_detailModel.newPrice - _detailModel.preClose];
    NSString *rate = [NSString stringWithFormat:@"%.2f%%",upRaiseRate * 100];
    //背景色
    if (upRaiseRate == 0) {
        _priceView.bgView.backgroundColor = k_EQUAL_COLOR;
    }else if (upRaiseRate > 0){
        _priceView.bgView.backgroundColor = k_UPPER_COLOR;
        
        rateValue = [@"+" stringByAppendingString:rateValue];
        rate = [@"+" stringByAppendingString:rate];
    }else{
        _priceView.bgView.backgroundColor = k_UNDER_COLOR;
    }
    //涨跌额
    _priceView.rateValueLabel.text = rateValue;
    //涨跌幅
    _priceView.rateLabel.text = rate;
    //今开
    _priceView.dayOpenValueLabel.text = [NSString amountValueWithDouble:_detailModel.openPrice];
    //左收
    _priceView.lstCloseValueLabel.text = [NSString amountValueWithDouble:_detailModel.preClose];
    //成交量
    _priceView.volValueLabel.text = [NSString amountTransformToPrice:_detailModel.amount];
    
    //最高
    _priceView.highLabel.attributedText = [self usefulAttributeStringText:@"最高：" withValue:_detailModel.maxPrice];
    //最低
    _priceView.lowLabel.attributedText = [self usefulAttributeStringText:@"最低：" withValue:_detailModel.minPrice];
    //成交额
    //    _priceView.totalTradeLabel.adjustsFontSizeToFitWidth = YES;
    NSString *money = [NSString amountTransformToPrice:_detailModel.money];
    money = [@"成交额：" stringByAppendingString:money];
    NSDictionary *attributes = @{NSFontAttributeName:k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR};
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:money];
    NSRange range = [money rangeOfString:[money substringFromIndex:4]];
    [attString setAttributes:attributes range:range];
    
    _priceView.totalTradeLabel.attributedText = attString;
    //内盘
    _priceView.innerLabel.attributedText = [self usefulAttributeStringTextWithoutDot:@"内盘：" withValue:_detailModel.inside];
    //外盘
    _priceView.outerLabel.attributedText = [self usefulAttributeStringTextWithoutDot:@"外盘：" withValue:_detailModel.outside];
    //振幅
    NSString *shackValue = [NSString stringWithFormat:@"振幅：%.2f%%",zhenfu];
    attributes = @{NSFontAttributeName:k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR};
    attString = [[NSMutableAttributedString alloc] initWithString:shackValue];
    range = [shackValue rangeOfString:[shackValue substringFromIndex:3]];
    [attString setAttributes:attributes range:range];
    _priceView.shackValueLabel.attributedText = attString;
}

- (NSAttributedString *)usefulAttributeStringTextWithoutDot:(NSString *)str withValue:(double)value
{
    if (str == nil) {
        return nil;
    }
    NSDictionary *attributes = @{NSFontAttributeName:k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR};
    NSString *high = [NSString amountTransformToPrice:value];
    NSString *text = [str stringByAppendingString:high];
    NSRange range = [text rangeOfString:high];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attString setAttributes:attributes range:range];
    
    return [attString copy];
}

- (NSAttributedString *)usefulAttributeStringText:(NSString *)str withValue:(double)value
{
    if (str == nil) {
        return nil;
    }
    NSDictionary *attributes = @{NSFontAttributeName:k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR};
    NSString *high = [NSString amountValueWithDouble:value];
    NSString *text = [str stringByAppendingString:[NSString amountValueWithDouble:value]];
    NSRange range = [text rangeOfString:high];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attString setAttributes:attributes range:range];
    
    return [attString copy];
}

@end
