//
//  UUStockBlockCollectionViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockBlockCollectionViewCell.h"
#import "UUReportSortStockModel.h"
#import "UUStockBlockModel.h"
@interface UUStockBlockCollectionViewCell ()
{
    UILabel *_blockLabel;           //板块名
    UILabel *_markUpRateLabel;      //涨幅

    UILabel *_stockNameLabel;       //股票名称
    UILabel *_stockRateLabel;       //股票涨跌幅
    
    UILabel *_priceLabel;           //领涨股票价格\排名股票价格
}
@end

@implementation UUStockBlockCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
   
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _blockLabel = [UIKitHelper labelWithFrame:CGRectMake(0, k_TOP_MARGIN, CGRectGetWidth(self.bounds), 14.0f) Font:[UIFont boldSystemFontOfSize:14.0f] textColor:k_BIG_TEXT_COLOR];
    _blockLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_blockLabel];
    
    _markUpRateLabel = [UIKitHelper labelWithFrame:CGRectMake(0, k_TOP_MARGIN + CGRectGetMaxY(_blockLabel.frame), CGRectGetWidth(self.bounds), 18.0f) Font:[UIFont systemFontOfSize:16.0f] textColor:[UIColorTools colorWithHexString:@"#F6102C" withAlpha:1.0f]];
    _markUpRateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_markUpRateLabel];

    
    _priceLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont systemFontOfSize:16.0f] textColor:k_BIG_TEXT_COLOR];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_priceLabel];
    
    //股票名
    _stockNameLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont systemFontOfSize:12.0f] textColor:k_MIDDLE_TEXT_COLOR];
    _stockNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_stockNameLabel];
    
    
    //股票涨跌幅
    _stockRateLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont systemFontOfSize:12.0f] textColor:k_MIDDLE_TEXT_COLOR];
    _stockRateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_stockRateLabel];
}

- (void)setBlockModel:(UUStockBlockModel *)blockModel
{
    if (blockModel == nil) {
        return;
    }
    _blockModel = blockModel;
    
    _stockNameLabel.hidden = NO;
    _stockRateLabel.hidden = NO;
    
    [self fillStockBlockData];
}

- (void)fillStockBlockData
{
    
    _blockLabel.frame = CGRectMake(0, 5, CGRectGetWidth(self.bounds), 20.0f);
    _markUpRateLabel.frame = CGRectMake(0,CGRectGetMaxY(_blockLabel.frame), CGRectGetWidth(self.bounds), 20.0f);
  
    //板块名
    _blockLabel.text = _blockModel.blockName;

    //板块涨跌幅
    double riseRate = _blockModel.riseRate;
    NSString *riseRateString = [NSString  stringWithFormat:@"%.2f%%",riseRate];
    UIColor *blockRateColor = k_EQUAL_COLOR;
    if (riseRate > 0) {
        blockRateColor = k_UPPER_COLOR;
        riseRateString = [@"+" stringByAppendingString:riseRateString];
    }else if (riseRate < 0){
        blockRateColor = k_UNDER_COLOR;
    }
    NSMutableAttributedString *markUpRateString = [[NSMutableAttributedString alloc] initWithString:riseRateString];
    _markUpRateLabel.attributedText = markUpRateString;
    
    //领涨股票名
    _stockNameLabel.text = _blockModel.stockName;
    //领涨股涨跌幅
    double stockRiseRate = _blockModel.stockRiseRate;
    if (_blockModel.stockNewPrice == 0) {
        stockRiseRate = 0;
    }
    NSString *stockRiseRateString = [NSString  stringWithFormat:@"%.2f%%",stockRiseRate];
    UIColor *stockRateColor = k_EQUAL_COLOR;
    if (stockRiseRate > 0){
        stockRateColor = k_UPPER_COLOR;
        stockRiseRateString = [NSString stringWithFormat:@"+%@",stockRiseRateString];
    }else if (stockRiseRate < 0){
        stockRateColor = k_UNDER_COLOR;
    }
    NSMutableAttributedString *stockMarkUpRateString = [[NSMutableAttributedString alloc] initWithString:stockRiseRateString attributes:@{NSForegroundColorAttributeName : stockRateColor}];
    _stockRateLabel.attributedText = stockMarkUpRateString;

    _stockNameLabel.frame = CGRectMake(0, CGRectGetMaxY(_markUpRateLabel.frame), CGRectGetWidth(self.bounds), 15.0f);
    //领涨股价格
    _priceLabel.text = [NSString stringWithFormat:@"%.2f",_blockModel.stockNewPrice];
    _priceLabel.frame = CGRectMake(0, CGRectGetMaxY(_stockNameLabel.frame), CGRectGetWidth(self.bounds) * 0.5, 15.0f);
    _priceLabel.textColor = k_MIDDLE_TEXT_COLOR;
    _priceLabel.font = k_SMALL_TEXT_FONT;
    
    _stockRateLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetMinY(_priceLabel.frame), CGRectGetWidth(self.bounds) * 0.5, 15.0f);
}


- (void)setReportSortStockModel:(UUReportSortStockModel *)reportSortStockModel
{
    if (reportSortStockModel == nil) {
        return;
    }
    _reportSortStockModel = reportSortStockModel;
    
    _stockNameLabel.hidden = YES;
    _stockRateLabel.hidden = YES;
    [self fillStockSortData];
}

- (void)fillStockSortData
{
    _blockLabel.text = [NSString stringWithFormat:@"%@(%@)",_reportSortStockModel.name,_reportSortStockModel.code];
    [_blockLabel sizeToFit];
    CGFloat labelWidth = _blockLabel.bounds.size.width;
    _blockLabel.frame = CGRectMake(2* k_LEFT_MARGIN,0,labelWidth, UUStockBlockViewSortCellHeight);

    double upRaiseRate = _reportSortStockModel.value;
    //换手率和振幅需要乘以十
    if (_indexPath.section > 3) {
        upRaiseRate *= 10;
    }
    
    NSString *rate = [NSString stringWithFormat:@"%.2f%%",upRaiseRate];
    //文字颜色色
    UIColor *color = k_EQUAL_COLOR;
    if (upRaiseRate > 0){
        color = k_UPPER_COLOR;
        
        if (_indexPath.section <=3) {
            rate = [@"+" stringByAppendingString:rate];
        }
    }else if(upRaiseRate < 0){
        color = k_UNDER_COLOR;
    }
    
    NSMutableAttributedString *markUpRateString = [[NSMutableAttributedString alloc] initWithString:rate];
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName : color
                                 };
    
    if (_indexPath.section <=3) {
        [markUpRateString setAttributes:attributes range:NSMakeRange(0, 1)];
    }

    attributes = @{
                   NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                   NSForegroundColorAttributeName : color
                   };
    if (_indexPath.section <=3) {
        [markUpRateString setAttributes:attributes range:NSMakeRange(1,markUpRateString.length - 1)];
    }

    _markUpRateLabel.attributedText = markUpRateString;
    
    [_markUpRateLabel sizeToFit];
     labelWidth = _markUpRateLabel.bounds.size.width;

    _markUpRateLabel.frame = CGRectMake(PHONE_WIDTH - labelWidth - 3 * k_RIGHT_MARGIN, 0,labelWidth,UUStockBlockViewSortCellHeight);
    
    
    _priceLabel.text = [NSString amountValueWithDouble:_reportSortStockModel.newPrice];
    _priceLabel.textColor = k_BIG_TEXT_COLOR;
    _priceLabel.font = k_BIG_TEXT_FONT;
    _priceLabel.frame = CGRectMake(CGRectGetMaxX(_blockLabel.frame), 0, CGRectGetMinX(_markUpRateLabel.frame) - CGRectGetMaxX(_blockLabel.frame), UUStockBlockViewSortCellHeight);
}

@end
