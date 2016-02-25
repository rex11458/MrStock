//
//  UUVirtualTansactionBusinessViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTansactionBusinessViewCell.h"
#import "UUTransactionDealModel.h"
#import "UUTransactionDelegateModel.h"
#import "UUTransactionModel.h"
#import "UULabelView.h"
#define stockNameHeight 47.0f
@implementation UUVirtualTansactionBusinessViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
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
    NSArray *textArray = @[@"成交价格",@"成交数量",@"成交金额",@"成交时间"];
    CGFloat width = (PHONE_WIDTH - 2 * k_LEFT_MARGIN) / (CGFloat)textArray.count;
    for (NSInteger i = 0; i < textArray.count; i++) {
        UULabelView *labelView = [[UULabelView alloc] initWithFrame:CGRectMake(width * i,stockNameHeight, width, UUVirtualTansactionBusinessViewCellHeight - k_TOP_MARGIN - stockNameHeight)];
        labelView.underAttributes = @{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:k_MIDDLE_TEXT_COLOR};
        labelView.upperAttributes = @{NSFontAttributeName : k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR};
        labelView.underText = [textArray objectAtIndex:i];
        labelView.upperText = @"--";
        [self.contentView addSubview:labelView];
        [labelViewArray addObject:labelView];
    }
    self.labelViewArray = labelViewArray;
    _statusLabel = [UIKitHelper labelWithFrame:CGRectMake(PHONE_WIDTH - (3 * k_LEFT_MARGIN) - 100.0f, 0, 100.0f,stockNameHeight) Font:k_BIG_TEXT_FONT textColor:k_UPPER_COLOR];
    _statusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_statusLabel];
}

- (void)setTransactionModel:(UUTransactionModel *)transactionModel
{
    if (transactionModel == nil) {
        return;
    }
    _transactionModel = transactionModel;
    [self fillData];
}

- (void)fillData
{
    _stockNameLabel.text = _transactionModel.name;

    _businessTypeButton.selected = _transactionModel.buySell;
    
    
    if ([_transactionModel isMemberOfClass:[UUTransactionDelegateModel class]])
    {
            //委托类型
        UUTransactionDelegateModel *delegateModel = (UUTransactionDelegateModel *)_transactionModel;
        NSArray *dataArray = @[delegateModel.matchedAmount,delegateModel.amount,[NSString stringWithFormat:@"%.2f",delegateModel.price],delegateModel.orderTime];
        NSArray *textArray = @[@"成交数量",@"委托数量",@"委托价格",@"委托时间"];

        [_labelViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UULabelView *labelView = (UULabelView *)obj;
            labelView.upperText = dataArray[idx];
            labelView.underText = textArray[idx];
        }];
        /*
         订单状态 0-已委托 1-已成交 2-部分成交 3-部分成交后撤单 4-已撤单
         */
        if (delegateModel.status == 1) {
            _statusLabel.text = @"已成交";
            _statusLabel.textColor = k_MIDDLE_TEXT_COLOR;
        }else if (delegateModel.status == 4){
            _statusLabel.text = @"已撤销";
            _statusLabel.textColor = k_MIDDLE_TEXT_COLOR;
        }else if (delegateModel.status == 0){
            _statusLabel.text = @"进行中";
        }else if (delegateModel.status == 2 || delegateModel.status == 3){
            _statusLabel.text = @"部分成交";
        }
    }
    else if ([_transactionModel isMemberOfClass:[UUTransactionDealModel class]])
    {
        UUTransactionDealModel *dealModel = (UUTransactionDealModel *)_transactionModel;
        
        
        NSString *date = nil;
        if (self.type == UUVirtualTansactionBusinessPastDealType) {
            date = dealModel.resultDate;
        }else{
            date = dealModel.resultTime;
        }
        
        NSArray *dataArray = @[[NSString stringWithFormat:@"%.2f",dealModel.resultPrice],dealModel.resultAmount,[NSString stringWithFormat:@"%.2f",dealModel.resultMoney],date];
        
        [_labelViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UULabelView *labelView = (UULabelView *)obj;
            labelView.upperText = dataArray[idx];
        }];
    }
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

- (void)layoutSubviews
{
    
}

@end
