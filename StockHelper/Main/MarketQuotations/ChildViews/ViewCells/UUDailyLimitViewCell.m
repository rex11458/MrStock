//
//  UUDailyLimitViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUDailyLimitViewCell.h"
#import "UUReportSortStockModel.h"
#import "UUStockBlockModel.h"
@interface UUDailyLimitViewCell ()
{
    UILabel *_stockNameLabel;    //股票名称
    UILabel *_stockPriceLabel;   //股票价格
    UILabel *_markUpLabel;       //涨跌额
    
}
@end

@implementation UUDailyLimitViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        self.contentView.backgroundColor = [UIColor whiteColor];
        

        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _stockNameLabel = [UIKitHelper labelWithFrame:CGRectMake(19.0f, 0,CGRectGetWidth(self.bounds) * 0.5 - 19.0f, UUDailyLimitViewCellHeight) Font:[UIFont systemFontOfSize:14.0f] textColor:k_BIG_TEXT_COLOR];
    [self.contentView addSubview:_stockNameLabel];
    
    _stockPriceLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetWidth(self.bounds) * 0.5, 0,60.0f, UUDailyLimitViewCellHeight) Font:[UIFont systemFontOfSize:14.0f] textColor:k_BIG_TEXT_COLOR];
    [self.contentView addSubview:_stockPriceLabel];
    
    _markUpLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 100, 0, 100.0f, UUDailyLimitViewCellHeight) Font:[UIFont systemFontOfSize:18.0f] textColor:k_UPPER_COLOR];
    _markUpLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_markUpLabel];
}

- (void)setSortStockModel:(UUReportSortStockModel *)sortStockModel
{
    if (sortStockModel == nil || _sortStockModel == sortStockModel) {
        return;
    }
    
    _sortStockModel = sortStockModel;
    
    NSString *name = _sortStockModel.name;
    NSString *code = _sortStockModel.code;
    double rate = _sortStockModel.value;
    double price = _sortStockModel.newPrice;
    
    
    [self fillDataWithName:name code:code rate:rate price:price];
}

- (void)setBlockModel:(UUStockBlockModel *)blockModel
{
    if (blockModel == nil || _blockModel == blockModel) {
        return;
    }
    _blockModel = blockModel;
    NSString *name = _blockModel.blockName;
    NSString *code = _blockModel.blockCode;
    double rate = _blockModel.riseRate;
    double price = _blockModel.newPrice;
    [self fillDataWithName:name code:code rate:rate price:price];
}


- (void)fillDataWithName:(NSString *)name code:(NSString *)code rate:(double)rateValue price:(double)price
{
    _stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",name,code];
      double upRaiseRate = rateValue;
    //换手率和振幅需要乘以十
    if (_rankType == UUExchangeRateType || _rankType == UUAmplitudeRateType) {
        upRaiseRate *= 10;
    }
    
    NSString *rate = [NSString stringWithFormat:@"%.2f%%",upRaiseRate];
    //文字颜色
    UIColor *color = k_EQUAL_COLOR;
    if (upRaiseRate > 0){
        color = k_UPPER_COLOR;
        
        if (_rankType == UUIncreaseRateType || _rankType == UUDecreaseRateType) {
            rate = [@"+" stringByAppendingString:rate];
        }
    }else if(upRaiseRate < 0){
        color = k_UNDER_COLOR;
    }
    
    NSMutableAttributedString *markUpRateString = [[NSMutableAttributedString alloc] initWithString:rate];
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName : color
                                 };
    if (_rankType == UUIncreaseRateType || _rankType == UUDecreaseRateType) {
        [markUpRateString setAttributes:attributes range:NSMakeRange(0, 1)];
    }
    
    attributes = @{
                   NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                   NSForegroundColorAttributeName : color
                   };
    if (_rankType == UUIncreaseRateType || _rankType == UUDecreaseRateType) {
        [markUpRateString setAttributes:attributes range:NSMakeRange(1,markUpRateString.length - 1)];
    }
    
    _markUpLabel.attributedText = markUpRateString;

    _stockPriceLabel.text = [NSString amountValueWithDouble:price];
}

- (void)layoutSubviews
{
    _stockNameLabel.frame = CGRectMake(19.0f, 0,CGRectGetWidth(self.bounds) * 0.5 - 19.0f, UUDailyLimitViewCellHeight);
    _stockPriceLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.5, 0,60.0f, UUDailyLimitViewCellHeight);
    _markUpLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - 100, 0, 100.0f, UUDailyLimitViewCellHeight);
}

/*
 *重新设置frame
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.x += k_LEFT_MARGIN;
    //    frame.origin.y += k_TOP_MARGIN;
    frame.size.width -= k_LEFT_MARGIN * 2;
    frame.size.height -= 0.5f;
    [super setFrame:frame];
}

@end

@implementation UUDailyLimitViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        self.backgroundColor = k_BG_COLOR;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGFloat fontSize = 12.0f;
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                                 NSForegroundColorAttributeName : k_BIG_TEXT_COLOR
                                 };
    [@"名称代码" drawInRect:CGRectMake(30,(UUDailyLimitViewHeaderViewHeight - fontSize) * 0.5,100,fontSize) withAttributes:attributes];
    
    [@"最新价" drawInRect:CGRectMake(CGRectGetWidth(self.bounds) * 0.5,(UUDailyLimitViewHeaderViewHeight - fontSize) * 0.5,60,fontSize) withAttributes:attributes];

    NSString *title = nil;
    if (_rankType == UUIncreaseRateType) {
        title = @"涨幅";
    }else if (_rankType == UUDecreaseRateType){
        title = @"跌幅";
    }else if (_rankType == UUAmplitudeRateType){
        title = @"振幅";
    }else if (_rankType == UUExchangeRateType){
        title = @"换手率";
    }else if (_rankType == UUHotProfessionType || _rankType == UUConceptType){
        title = @"涨跌幅";
    }
    
    [title drawInRect:CGRectMake(CGRectGetWidth(self.bounds) - 80,(UUDailyLimitViewHeaderViewHeight - fontSize) * 0.5, 100.0f, fontSize) withAttributes:attributes];
}
@end
