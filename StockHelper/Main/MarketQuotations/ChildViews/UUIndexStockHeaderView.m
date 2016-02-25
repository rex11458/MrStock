//
//  UUIndexStockHeaderView.m
//  StockHelper
//
//  Created by LiuRex on 15/11/11.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUIndexStockHeaderView.h"
#import "UUMarketQuotationView.h"
@implementation UUIndexStockHeaderView

- (instancetype)initWithFrame:(CGRect)frame operation:(void (^)(NSInteger))index
{
    if (self = [super initWithFrame:frame operation:index]) {
        self.backgroundColor = k_BG_COLOR;//[UIColorTools colorWithHexString:@"#F6F6F6" withAlpha:1.0f];
        [self configSubViews];

    }
    return self;
}

- (void)configSubViews
{
    
    _textLabelArray = [NSMutableArray array];
    
    CGFloat labelWidth =  (PHONE_WIDTH - 4 *k_LEFT_MARGIN ) / 3.0f;
    CGFloat labelHeight = 30.0f;
    CGFloat labelY = 80.0f;
    NSArray *titles = @[@"最 高: ",@"最 低: ",@"成交量: ",@"涨家数: ",@"平家数: ",@"跌家数: "];
    NSArray *values = @[@"--",@"--",@"--",@"--",@"--",@"--   "];
    for (NSInteger i = 0; i < 6; i++) {
        CGRect frame = CGRectMake(k_LEFT_MARGIN * 2 + (i%3) * (labelWidth) , labelY + (i/3) * labelHeight, labelWidth, labelHeight);
        UILabel *label = [UIKitHelper labelWithFrame:frame Font:k_SMALL_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
        [_textLabelArray addObject:label];
        label.adjustsFontSizeToFitWidth = YES;
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",titles[i],values[i]]];
        NSRange range = [attString.string rangeOfString:values[i]];
        [attString setAttributes:@{NSFontAttributeName:k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR} range:range];
        label.attributedText = attString;
        [self addSubview:label];
    }
    
    //----
    self.marketQuotationView = [[UUMarketQuotationView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, 150.0f,CGRectGetWidth(self.bounds) - 2 * k_LEFT_MARGIN, VIEW_HEIGHT + UUOptionViewHeight) stockType:1];
    self.marketQuotationView.delegate = self;
    [self addSubview:self.marketQuotationView];
}

#pragma mark - BaeViewDelegate
- (void)baseView:(BaseView *)baseView actionTag:(NSInteger)actionTag value:(id)values
{
    if (self.selectedIndex) {
        
        self.selectedIndex(actionTag);
    }
}

- (void)showLineViewWithIndex:(NSInteger)index
{
    [self.marketQuotationView showViewWithOptionIndex:index];
}

- (void)setStockModel:(UUStockModel *)stockModel
{
    if (stockModel == nil || _indexModel == stockModel) {
        return;
    }
    _indexModel = (UUIndexDetailModel *)stockModel;
    
    [self setIndexModel:_indexModel];
}

- (void)setIndexModel:(UUIndexDetailModel *)indexModel
{
    if (indexModel == nil)return;
    _indexModel = indexModel;
    [self setNeedsDisplay];
    long equalCount = 0;
    if (_indexModel.totalStock2 - _indexModel.raiseCount - _indexModel.fallCount >0) {
        equalCount = _indexModel.totalStock2 - _indexModel.raiseCount - _indexModel.fallCount;
    }
    NSArray *titles = @[@"最 高: ",@"最 低: ",@"成交量: ",@"涨家数: ",@"平家数: ",@"跌家数: "];
    NSArray *values = @[[NSString amountValueWithDouble:_indexModel.maxPrice],
                        [NSString amountValueWithDouble:_indexModel.minPrice],
                        [NSString amountTransformToPrice:_indexModel.amount],
                        [NSString stringWithFormat:@"%ld",_indexModel.raiseCount],
                        [NSString stringWithFormat:@"%ld",equalCount],
                        [NSString stringWithFormat:@"%ld",_indexModel.fallCount]
                        ];
    for (NSInteger i = 0; i < _textLabelArray.count; i++) {
        
        UILabel *label = [_textLabelArray objectAtIndex:i];
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",titles[i],values[i]]];
        NSRange range = [attString.string rangeOfString:values[i]];
        [attString setAttributes:@{NSFontAttributeName:k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR} range:range];
        label.attributedText = attString;
        [self addSubview:label];
    }
}

- (void)drawRect:(CGRect)rect
{
    //当前价格
    NSString *currentPrice = [NSString amountValueWithDouble:_indexModel.newPrice];
    //今开
    NSString *dailyOpen =  [NSString amountValueWithDouble:_indexModel.openPrice];
    //昨收
    NSString *lstClose = [NSString amountValueWithDouble:_indexModel.preClose];
    //成交额
    NSString *money = [NSString amountTransformToPrice:_indexModel.avgPrice];
    //---涨跌幅----
    double upRaiseRate = 0;
    //振幅
    double zhenfu = 0;
    if (_indexModel.preClose != 0) {
        upRaiseRate = (_indexModel.newPrice - _indexModel.preClose) / _indexModel.preClose;
        zhenfu = (_indexModel.maxPrice - _indexModel.minPrice) / _indexModel.preClose * 100;
    }
    
    //涨跌额
    NSString *rateValue = [NSString amountValueWithDouble:_indexModel.newPrice - _indexModel.preClose];
    //涨跌幅
    NSString *rate = [NSString stringWithFormat:@"%.2f%%",upRaiseRate * 100];
    //背景色
    UIColor *color = k_EQUAL_COLOR;
    if (upRaiseRate > 0){
        color = k_UPPER_COLOR;
        
        rateValue = [@"+" stringByAppendingString:rateValue];
        rate = [@"+" stringByAppendingString:rate];
    }else{
        color = k_UNDER_COLOR;
    }
    //振幅
    NSString *zhenfuString = [[NSString amountValueWithDouble:zhenfu] stringByAppendingString:@"%"];
    
    [[UIKitHelper imageWithColor:color] drawInRect:CGRectMake(0,0,CGRectGetWidth(self.bounds), 80)];
    [[UIKitHelper imageWithColor:[UIColorTools colorWithHexString:@"#ffffff" withAlpha:1.0f]] drawInRect:CGRectMake(0,0,CGRectGetWidth(self.bounds), k_TOP_MARGIN * 0.5)];
    [[UIKitHelper imageWithColor:[UIColorTools colorWithHexString:@"#ffffff" withAlpha:1.0f]] drawInRect:CGRectMake(0,80,CGRectGetWidth(self.bounds), 60)];
    
    CGFloat fontSize = 40.0f;
    if (currentPrice.length >= 8) {
        fontSize = 32.0f;
    }
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                                 NSForegroundColorAttributeName : [UIColorTools colorWithHexString:@"#FFFFFF" withAlpha:1.0f]
                                 };
    
    //当前价
    [currentPrice drawInRect:CGRectMake(((CGRectGetWidth(self.bounds) * 0.5 - fontSize * 3.5)) * 0.5, k_TOP_MARGIN , CGRectGetWidth(self.bounds) * 0.5, fontSize) withAttributes:attributes];
    
    fontSize = 12.0f;
    attributes = @{
                   NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                   NSForegroundColorAttributeName : [UIColorTools colorWithHexString:@"#FFFFFF" withAlpha:1.0f]
                   };
    [@"今开" drawInRect:CGRectMake(k_LEFT_MARGIN + CGRectGetWidth(self.bounds) * 0.5, k_TOP_MARGIN + fontSize * 0.5, fontSize * 2.0f, fontSize * 2) withAttributes:attributes];
    
    [@"昨收" drawInRect:CGRectMake(k_LEFT_MARGIN + CGRectGetWidth(self.bounds) * 0.75,k_TOP_MARGIN + fontSize * 0.5,fontSize * 2.0f, fontSize * 2) withAttributes:attributes];
    
    //成交额
    [@"成交额" drawInRect:CGRectMake(k_LEFT_MARGIN + CGRectGetWidth(self.bounds) * 0.5, k_TOP_MARGIN + fontSize * 3,fontSize * 5.0f, fontSize * 2) withAttributes:attributes];
    //振幅
    [@"振幅" drawInRect:CGRectMake(k_LEFT_MARGIN + CGRectGetWidth(self.bounds) * 0.75, k_TOP_MARGIN + fontSize * 3,fontSize * 5.0f, fontSize) withAttributes:attributes];
    
    fontSize = 15.0f;
    attributes = @{
                   NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                   NSForegroundColorAttributeName : [UIColorTools colorWithHexString:@"#FFFFFF" withAlpha:1.0f]
                   };
    //今日开盘价
    [dailyOpen drawInRect:CGRectMake(k_LEFT_MARGIN + CGRectGetWidth(self.bounds) * 0.5, k_TOP_MARGIN * 1.5 + fontSize,fontSize * 5.0f, fontSize) withAttributes:attributes];
    //昨日收盘价
    [lstClose drawInRect:CGRectMake(k_LEFT_MARGIN + CGRectGetWidth(self.bounds) * 0.75, k_TOP_MARGIN * 1.5 + fontSize,fontSize * 5.0f, fontSize) withAttributes:attributes];
    
    //成交额
    [money drawInRect:CGRectMake(k_LEFT_MARGIN + CGRectGetWidth(self.bounds) * 0.5, k_TOP_MARGIN * 1.5 + fontSize * 3,fontSize * 8.0f, fontSize) withAttributes:attributes];
    //振幅
    [zhenfuString drawInRect:CGRectMake(k_LEFT_MARGIN + CGRectGetWidth(self.bounds) * 0.75, k_TOP_MARGIN * 1.5 + fontSize * 3,fontSize * 5.0f, fontSize) withAttributes:attributes];
    
    //涨跌额
    [rateValue drawInRect:CGRectMake(CGRectGetWidth(self.bounds) * 0.25 - fontSize * 3.0f - k_LEFT_MARGIN, k_TOP_MARGIN + fontSize * 3,fontSize * 5.0f, fontSize) withAttributes:attributes];
    
    //涨跌幅
    [rate drawInRect:CGRectMake(CGRectGetWidth(self.bounds) * 0.25 + fontSize * 2.0f - k_LEFT_MARGIN, k_TOP_MARGIN + fontSize * 3,fontSize * 5.0f, fontSize) withAttributes:attributes];
}

@end
