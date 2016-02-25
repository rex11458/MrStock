//
//  UUTradeHistoryViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/8/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTradeHistoryViewCell.h"
#import "UULabelView.h"
#import "UUTransactionDealModel.h"
#define stockNameHeight 47.0f

@implementation UUTradeHistoryViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _businessTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _businessTypeButton.frame = CGRectMake(k_LEFT_MARGIN, 0, 78.0f, stockNameHeight);
    
    [_businessTypeButton setImage:[UIImage imageNamed:@"business_buy"] forState:UIControlStateNormal];
    [_businessTypeButton setImage:[UIImage imageNamed:@"business_sell"] forState:UIControlStateSelected];
    _businessTypeButton.userInteractionEnabled = NO;
    [_businessTypeButton setTitle:@"买入" forState:UIControlStateNormal];
    [_businessTypeButton setTitle:@"卖出" forState:UIControlStateSelected];
    //    _businessTypeButton.selected = YES;
    _businessTypeButton.titleLabel.font = k_BIG_TEXT_FONT;
    [_businessTypeButton setTitleColor:k_UPPER_COLOR forState:UIControlStateNormal];
    [_businessTypeButton setTitleColor:k_UNDER_COLOR forState:UIControlStateSelected];
    _businessTypeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    _businessTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.contentView addSubview:_businessTypeButton];
    _stockNameLabel = [UIKitHelper labelWithFrame:CGRectMake(k_LEFT_MARGIN + CGRectGetMaxX(_businessTypeButton.frame), 0, 200.0f,stockNameHeight) Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    [self.contentView addSubview:_stockNameLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,stockNameHeight, PHONE_WIDTH - 2 * k_LEFT_MARGIN, 0.5f)];
    line.backgroundColor = k_LINE_COLOR;
    [self.contentView addSubview:line];
    
    NSMutableArray *labelViewArray = [NSMutableArray array];
    NSArray *titles = @[@"成交价格",@"成交数量",@"成交金额",@"盈亏",@"盈亏比例",@"成交时间"];
    
    CGFloat width = (PHONE_WIDTH - 2 * k_LEFT_MARGIN) / 3.0f;
    CGFloat height = (UUTradeHistoryViewCellHeight - k_TOP_MARGIN - stockNameHeight) * 0.5;
    for (NSInteger i = 0; i < titles.count; i++) {
        UULabelView *labelView = [[UULabelView alloc] initWithFrame:CGRectMake((i%3) * width, i/3 *height + stockNameHeight, width, height)];
        labelView.underAttributes = @{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:k_MIDDLE_TEXT_COLOR};
        labelView.upperAttributes = @{NSFontAttributeName : k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR};
        labelView.underText = [titles objectAtIndex:i];
        labelView.upperText = @"--";
        [self.contentView addSubview:labelView];
        [labelViewArray addObject:labelView];
    }
    self.labelViewArray = labelViewArray;

}

- (void)setDealModel:(UUTransactionDealModel *)dealModel
{
    if (dealModel == nil || _dealModel == dealModel) {
        return;
    }
    _dealModel = dealModel;
    [self fillData];
}

- (void)fillData
{
    _stockNameLabel.text = [NSString stringWithFormat:@"%@(%@)",_dealModel.name,_dealModel.code];
    _businessTypeButton.selected = [@(_dealModel.buySell) boolValue];
    
//    resultPrice	Double	成交价格
//    resultAmount	Double	成交数量
//    resultMoney	Double	成交金额
//    resultDate	String	成交日期 yyyy-MM-dd格
    
    NSArray *values = @[
                        [NSString amountValueWithDouble:_dealModel.resultPrice],
                        _dealModel.resultAmount,
                        [NSString amountValueWithDouble:_dealModel.resultMoney],
                        @"",
                        @"",
                        _dealModel.resultDate];
    [self.labelViewArray enumerateObjectsUsingBlock:^(UULabelView *labelView, NSUInteger idx, BOOL *stop) {
        labelView.upperText = values[idx];
    }];
    
}


/*
 *重新设置frame
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.x += k_LEFT_MARGIN;
    //        frame.origin.y += k_TOP_MARGIN;
    frame.size.width -= k_LEFT_MARGIN * 2;
    frame.size.height -= k_TOP_MARGIN;
    [super setFrame:frame];
}

@end
