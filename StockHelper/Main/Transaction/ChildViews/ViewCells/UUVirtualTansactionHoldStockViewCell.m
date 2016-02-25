//
//  UUVirtualTansactionHoldStockViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTansactionHoldStockViewCell.h"
#import "UULabelView.h"
#import "UUTransactionHoldModel.h"
@implementation UUVirtualTansactionHoldStockViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = k_BG_COLOR;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, k_TOP_MARGIN * 0.5, PHONE_WIDTH - 2 * k_LEFT_MARGIN, UUVirtualTansactionHoldStockViewCellHeight - k_TOP_MARGIN)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    _bgView = bgView;
    
    _stockNameLabel = [UIKitHelper labelWithFrame:CGRectMake(k_LEFT_MARGIN * 2, 0, 200.0f,30.0f) Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    [self.contentView addSubview:_stockNameLabel];
    NSMutableArray *labelViewArray = [NSMutableArray array];
    NSArray *textArray = @[@"市值",@"最新价",@"成本价",@"盈亏",@"数量"];
    CGFloat width = (PHONE_WIDTH - 2 * k_LEFT_MARGIN) / (CGFloat)textArray.count;
    for (NSInteger i = 0; i < textArray.count; i++) {
        UULabelView *labelView = [[UULabelView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN + width * i, CGRectGetMaxY(_stockNameLabel.frame), width, UUVirtualTansactionHoldStockViewCellHeight - k_TOP_MARGIN - CGRectGetHeight(_stockNameLabel.frame))];
        labelView.underAttributes = @{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:k_MIDDLE_TEXT_COLOR};
        labelView.upperAttributes = @{NSFontAttributeName : k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR};
        labelView.underText = [textArray objectAtIndex:i];
        labelView.upperText = @"--";
        [self.contentView addSubview:labelView];
        [labelViewArray addObject:labelView];
    }
    self.labelViewArray = labelViewArray;
//    
    _buttonView = [[UIView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, UUVirtualTansactionHoldStockViewCellHeight, PHONE_WIDTH - 2 * k_LEFT_MARGIN, 40.0f)];
    _buttonView.hidden = YES;
    _buttonView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_buttonView];
    
    NSArray *titles = @[@"买入",@"卖出",@"详情"];
    NSArray *colors = @[k_UPPER_COLOR,k_UNDER_COLOR,k_EQUAL_COLOR];
    
    CGFloat buttonWidth = (PHONE_WIDTH - 2 * k_LEFT_MARGIN - (titles.count + 1) * k_LEFT_MARGIN * 0.5) / (CGFloat)titles.count;
    CGFloat buttonX = k_LEFT_MARGIN * 0.5f;
    CGFloat buttonHeight = 40.0f;
    for (NSInteger i = 0; i < titles.count; i++) {
//        buttonX += (buttonWidth + k_LEFT_MARGIN * 0.5) * i;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(buttonX + (buttonWidth + k_LEFT_MARGIN * 0.5) * i, 0, buttonWidth, buttonHeight);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIKitHelper imageWithColor:k_BG_COLOR] forState:UIControlStateNormal];
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[colors objectAtIndex:i] forState:UIControlStateNormal];
        [_buttonView addSubview:button];
    }
}

- (void)setHiddenButtonView:(BOOL)hiddenButtonView
{
    _hiddenButtonView = hiddenButtonView;
    
    [UIView animateWithDuration:0.25 animations:^{
        _buttonView.alpha = !_hiddenButtonView;
    }];
    
    _buttonView.hidden = hiddenButtonView;
}

- (void)setHoldModel:(UUTransactionHoldModel *)holdModel
{
    if (holdModel == nil) {
        return;
    }
    _holdModel = holdModel;
    [self fillData];
}

- (void)fillData
{
    _stockNameLabel.text  = [_holdModel.name stringByAppendingFormat:@"(%@)",_holdModel.code];

    /*
     code	String	股票代码
     name	String	股票名称
     amount	Double	持仓量
     price	Double	持仓均价
     newPrice	Double	最新价
     tradeFreeze	Double	交易冻结量
     amountToday	Double	今日持仓量
     marketValue	Double	股票市值
     profitLoss	Double	盈亏
     rank	Long	交易排名
     */
    
    NSArray *datas = @[[NSString stringWithFormat:@"%.2f",_holdModel.marketValue],[NSString stringWithFormat:@"%.2f",_holdModel.newPrice],[NSString stringWithFormat:@"%.2f",_holdModel.price],[NSString stringWithFormat:@"%.2f",_holdModel.profitLoss],[@(_holdModel.amount) stringValue]];
    
    [_labelViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UULabelView *labelView = (UULabelView *)obj;

        if (idx == 3) {
            double profit = [datas[idx] floatValue];
        
            UIColor *textColor = nil;
            
            if (profit > 0)
            {
                textColor = k_UPPER_COLOR;
            }
            else if (profit == 0)
            {
                textColor = k_EQUAL_COLOR;
            }
            else
            {
                textColor = k_UNDER_COLOR;
            }
            labelView.upperAttributes = @{NSFontAttributeName : k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:textColor};
        }else
        {
            labelView.upperAttributes = @{NSFontAttributeName : k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR};
        }
        labelView.upperText = datas[idx];
    }];
}

#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(holdViewCell:operationWithIndex:)]) {
        [_delegate holdViewCell:self operationWithIndex:button.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgView.frame = CGRectMake(k_LEFT_MARGIN, k_TOP_MARGIN * 0.5, CGRectGetWidth(self.bounds) - 2 * k_LEFT_MARGIN, CGRectGetHeight(self.bounds) - k_TOP_MARGIN);
}

/*
 *重新设置frame
 */
//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.x = k_LEFT_MARGIN;
////        frame.origin.y += k_TOP_MARGIN;
//    frame.size.width = PHONE_WIDTH - k_LEFT_MARGIN * 2;
//    frame.size.height -= k_TOP_MARGIN;
//    [super setFrame:frame];
//}
@end
