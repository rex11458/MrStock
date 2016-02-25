//
//  UUVirtualTansactionBuyingView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTansactionBuyingView.h"
#import "UULabelView.h"
#import "UUStockDetailModel.h"
#define RIGHT_PRICE_WIDTH (0.42 *PHONE_WIDTH)
#define RIGHT_PRICE_X (PHONE_WIDTH - RIGHT_PRICE_WIDTH - k_LEFT_MARGIN)
#define LEFT_VIEW_WIDTH (PHONE_WIDTH - RIGHT_PRICE_WIDTH - 3 * k_LEFT_MARGIN)
@implementation UUVirtualTansactionBuyingView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configSubViews];
        _priceDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)configSubViews
{
    //-－股票代码
    CGFloat textFieldHeight = 36.0f;
    _stockCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, k_TOP_MARGIN, LEFT_VIEW_WIDTH, textFieldHeight)];
    _stockCodeTextField.delegate = self;
    _stockCodeTextField.layer.borderColor = k_NAVIGATION_BAR_COLOR.CGColor;
    _stockCodeTextField.layer.borderWidth = 1.0f;
    _stockCodeTextField.textAlignment = NSTextAlignmentCenter;
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, textFieldHeight, textFieldHeight);
    [searchButton setImage:[UIImage imageNamed:@"Nav_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateNormal];
    _stockCodeTextField.rightView = searchButton;
    _stockCodeTextField.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:_stockCodeTextField];
    //--股票名称
    _stockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, CGRectGetMaxY(_stockCodeTextField.frame), LEFT_VIEW_WIDTH, 30.0f)];
    _stockNameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_stockNameLabel];
    
    //股票价格
    _stockPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, CGRectGetMaxY(_stockNameLabel.frame) + k_TOP_MARGIN * 1.5, LEFT_VIEW_WIDTH, textFieldHeight)];
    _stockPriceTextField.textAlignment = NSTextAlignmentCenter;
    _stockPriceTextField.layer.borderColor = k_NAVIGATION_BAR_COLOR.CGColor;
    _stockPriceTextField.layer.borderWidth = 1.0f;

//    _stockPriceTextField.placeholder = @"买入价格";
    _stockPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    NSDictionary *upperAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0f],NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *underAttributes = @{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: [UIColor whiteColor]};

    UULabelView *minusButton = [[UULabelView alloc] initWithFrame:CGRectMake(0, 0, textFieldHeight, textFieldHeight)];
    minusButton.backgroundColor = k_NAVIGATION_BAR_COLOR;
    minusButton.upperAttributes = upperAttributes;
    minusButton.underAttributes =  underAttributes;
    minusButton.upperText = @"—";
    minusButton.underText = @"0.01";
    minusButton.tag = 0;
    [minusButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _stockPriceTextField.leftView = minusButton;
    
    UULabelView *plusButton = [[UULabelView alloc] initWithFrame:CGRectMake(0, 0, textFieldHeight, textFieldHeight)];
    plusButton.backgroundColor = k_NAVIGATION_BAR_COLOR;
    plusButton.upperAttributes = upperAttributes;
    plusButton.underAttributes =  underAttributes;
    plusButton.upperText = @"+";
    plusButton.underText = @"0.01";
    plusButton.tag = 1;
    [plusButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _stockPriceTextField.rightView = plusButton;

    _stockPriceTextField.rightViewMode = UITextFieldViewModeAlways;
    _stockPriceTextField.leftViewMode = UITextFieldViewModeAlways;

    [self addSubview:_stockPriceTextField];
    
    //今日最低最高价格
    //--股票名称
    _lowestPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, CGRectGetMaxY(_stockPriceTextField.frame), LEFT_VIEW_WIDTH * 0.5, 30.0f)];
    _lowestPriceLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_lowestPriceLabel];
    
    _highestPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN + LEFT_VIEW_WIDTH * 0.5, CGRectGetMaxY(_stockPriceTextField.frame), LEFT_VIEW_WIDTH * 0.5, 30.0f)];
    _highestPriceLabel.textAlignment = NSTextAlignmentRight;
    
    _highestPriceLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_highestPriceLabel];
    
    //买入股票数量
    _stockCountTextField = [UIKitHelper textFieldWithFrame:CGRectMake(k_LEFT_MARGIN, CGRectGetMaxY(_lowestPriceLabel.frame) + k_TOP_MARGIN * 2, LEFT_VIEW_WIDTH, textFieldHeight) placeholder:@"" Text:@"" leftViewText:@""];
    _stockCountTextField.layer.borderColor = k_NAVIGATION_BAR_COLOR.CGColor;
    _stockCountTextField.layer.borderWidth = 1.0f;
//    _stockCountTextField.textAlignment = NSTextAlignmentCenter;
    _stockCountTextField.keyboardType = UIKeyboardTypeNumberPad;
    _stockCountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"数量" attributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:k_MIDDLE_TEXT_COLOR}];
    _remainedCountLabel = [UIKitHelper labelWithFrame:CGRectMake(0, 0, 70.0f, textFieldHeight) Font:k_SMALL_TEXT_FONT textColor:nil];
    _remainedCountLabel.textAlignment = NSTextAlignmentRight;
    _remainedCountLabel.adjustsFontSizeToFitWidth = YES;
    _stockCountTextField.rightView = _remainedCountLabel;
    _stockCountTextField.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:_stockCountTextField];
    
    //仓位比
    UIButton *buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLeft.tag = 4;
    buttonLeft.frame = CGRectMake(k_LEFT_MARGIN, CGRectGetMaxY(_stockCountTextField.frame) + k_TOP_MARGIN, textFieldHeight, textFieldHeight);
    buttonLeft.layer.cornerRadius = textFieldHeight * 0.5;
    buttonLeft.layer.masksToBounds = YES;
    [buttonLeft setBackgroundImage:[UIKitHelper imageWithColor:k_MIDDLE_TEXT_COLOR] forState:UIControlStateNormal];
    [buttonLeft setTitle:@"1/4" forState:UIControlStateNormal];
    buttonLeft.titleLabel.font = k_SMALL_TEXT_FONT;
    [buttonLeft addTarget:self action:@selector(stockCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:buttonLeft];
    
    UIButton *buttonCenter = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCenter.tag = 2;
    buttonCenter.frame = CGRectMake(k_LEFT_MARGIN + (LEFT_VIEW_WIDTH - textFieldHeight) * 0.5, CGRectGetMaxY(_stockCountTextField.frame) + k_TOP_MARGIN, textFieldHeight, textFieldHeight);
    buttonCenter.layer.cornerRadius = textFieldHeight * 0.5;
    buttonCenter.layer.masksToBounds = YES;
    [buttonCenter setBackgroundImage:[UIKitHelper imageWithColor:k_MIDDLE_TEXT_COLOR] forState:UIControlStateNormal];
    [buttonCenter setTitle:@"1/2" forState:UIControlStateNormal];
    buttonCenter.titleLabel.font = k_SMALL_TEXT_FONT;
    [buttonCenter addTarget:self action:@selector(stockCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonCenter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:buttonCenter];
   
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.tag = 1;
    buttonRight.frame = CGRectMake(LEFT_VIEW_WIDTH - textFieldHeight + k_LEFT_MARGIN, CGRectGetMaxY(_stockCountTextField.frame) + k_TOP_MARGIN, textFieldHeight, textFieldHeight);
    buttonRight.layer.cornerRadius = textFieldHeight * 0.5;
    buttonRight.layer.masksToBounds = YES;
    [buttonRight setBackgroundImage:[UIKitHelper imageWithColor:k_MIDDLE_TEXT_COLOR] forState:UIControlStateNormal];
    [buttonRight setTitle:@"全部" forState:UIControlStateNormal];
    buttonRight.titleLabel.font = k_SMALL_TEXT_FONT;
    [buttonRight addTarget:self action:@selector(stockCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:buttonRight];
    
    
    //最新价，涨跌幅
    _lstPriceLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _lstPriceLabel.textAlignment = NSTextAlignmentCenter;
    _lstPriceLabel.text = @"最新:--";
    _lstPriceLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_lstPriceLabel];
    _rateLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _rateLabel.textAlignment = NSTextAlignmentCenter;
    _rateLabel.adjustsFontSizeToFitWidth = YES;
    _rateLabel.text = @"涨跌幅:--%";
    [self addSubview:_rateLabel];
    
    //买入按钮
    _buyingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyingButton.frame = CGRectMake(k_LEFT_MARGIN, CGRectGetMaxY(buttonLeft.frame) + k_TOP_MARGIN, LEFT_VIEW_WIDTH, textFieldHeight);
    _buyingButton.layer.cornerRadius = textFieldHeight * 0.5;
    _buyingButton.layer.masksToBounds = YES;
    [_buyingButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateNormal];
    [_buyingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyingButton setTitle:@"买入" forState:UIControlStateNormal];
    [_buyingButton addTarget:self action:@selector(buyingAction:) forControlEvents:UIControlEventTouchUpInside];
    _buyingButton.titleLabel.font = k_BIG_TEXT_FONT;
    [self addSubview:_buyingButton];
    //加载数据
    [self loadData];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChage:) name:UITextFieldTextDidChangeNotification object:_stockPriceTextField];
}

- (void)setDetailModel:(UUStockDetailModel *)detailModel
{
    if (detailModel == nil || _detailModel == detailModel) {
        return;
    }
    _detailModel = detailModel;
    [self loadData];
    NSString *newPrice = [NSString amountValueWithDouble:_detailModel.newPrice];
    double rate = 0;
    if (_detailModel.newPrice != 0 && _detailModel.preClose != 0) {
        rate =  (_detailModel.newPrice - _detailModel.preClose) / _detailModel.preClose * 100;

    }
    NSString *rateString = [NSString amountValueWithDouble:rate];
    
    UIColor *color = k_EQUAL_COLOR;
    if ([rateString doubleValue] > 0) {
        rateString = [NSString stringWithFormat:@"+%@%%",rateString];
        color = k_UPPER_COLOR;

    }else if ([rateString doubleValue] < 0){
        rateString =[NSString stringWithFormat:@"%@%%",rateString];
        color = k_UNDER_COLOR;
    }
//
    NSDictionary *attributes = @{NSFontAttributeName:k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:color};
    NSMutableAttributedString *newPriceAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"最新:%@",newPrice]];
    NSRange range = [newPriceAtt.string rangeOfString:newPrice];
    [newPriceAtt setAttributes:attributes range:range];
    _lstPriceLabel.attributedText = newPriceAtt;
//
    NSMutableAttributedString *rateAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"涨跌幅:%@",rateString]];
     range = [rateAtt.string rangeOfString:rateString];
    [rateAtt setAttributes:attributes range:range];
    _rateLabel.attributedText = rateAtt;
    
    
    //价格
    if (_stockPriceTextField.text.length == 0) {
        _stockPriceTextField.text = newPrice;
    }

    if (_type == 0) {
       
        //可买股数
        [self showUseableCount];
        
    }
 
    [self setNeedsDisplay];
}




- (void)setType:(NSInteger)type
{
    _type = type;
    if (_type)
    {
        [_buyingButton setTitle:@"卖出" forState:UIControlStateNormal];
        [_buyingButton setBackgroundImage:[UIKitHelper imageWithColor:k_UNDER_COLOR] forState:UIControlStateNormal];
    }
    else
    {
        [_buyingButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateNormal];
        [_buyingButton setTitle:@"买入" forState:UIControlStateNormal];
    }
}



- (NSString *)price
{
    return _stockPriceTextField.text;
}

- (void)setStockCode:(NSString *)stockCode
{
    if (stockCode == nil) {
        return;
    }
    _stockCode = [stockCode copy];
    _stockCodeTextField.text = stockCode;
}

- (NSInteger)count
{
    return  [_stockCountTextField.text integerValue];
}

- (void)setStockName:(NSString *)stockName
{
    
    if (stockName.length == 0) {
        return;
    }
    _stockName = [stockName copy];
    
    NSMutableAttributedString *name =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"股票名称：%@",stockName]];

    [name setAttributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: k_MIDDLE_TEXT_COLOR} range:NSMakeRange(0, 5)];
    [name setAttributes:@{NSFontAttributeName : k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName: k_BIG_TEXT_COLOR} range:NSMakeRange(5,name.length - 5)];
    _stockNameLabel.attributedText = name;
    
}



- (void)setUseableValue:(double)useableValue
{
    _useableValue = useableValue;
    
    if (self.type == 1) {
        //可卖
        _useCount = (NSInteger)useableValue;
        NSMutableAttributedString *remaindCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可卖%ld股",(NSInteger)useableValue]];
            [remaindCount setAttributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: k_MIDDLE_TEXT_COLOR} range:NSMakeRange(0, 2)];
            [remaindCount setAttributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: k_UNDER_COLOR} range:NSMakeRange(2,remaindCount.length - 2)];
            _remainedCountLabel.attributedText = remaindCount;
    }
    else
    {
        [self showUseableCount];
    }
}

#pragma mark - 价格变化通知
- (void)textFieldDidChage:(NSNotification *)notification
{
    if (self.type == 0) {
     
        if (notification.object == _stockPriceTextField) {
            [self showUseableCount];
        }
    }
}

- (void)showUseableCount
{
    
    double price = [self.price doubleValue];
    NSInteger useCount = 0;
    if (price != 0) {
        NSInteger value = _useableValue/ price;
        useCount = (value / 100) * 100;
        
    }
    _useCount = useCount;
    //可买
    NSMutableAttributedString *remaindCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可买%ld股",(NSInteger)useCount]];
    [remaindCount setAttributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: k_MIDDLE_TEXT_COLOR} range:NSMakeRange(0, 2)];
    [remaindCount setAttributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: k_UPPER_COLOR} range:NSMakeRange(2,remaindCount.length - 2)];
    _remainedCountLabel.attributedText = remaindCount;
}

#pragma mark - becomingSearch
- (void)becomingSearch
{
    [UIView animateWithDuration:0.25 animations:^{
        
        _stockCodeTextField.frame = CGRectMake(10, 10, CGRectGetWidth(self.bounds) - 20, 36.0f);
    }completion:^(BOOL finished) {
        [_stockCodeTextField becomeFirstResponder];
    }];
}



#pragma mark - stockCountAction
- (void)stockCountAction:(UIButton *)button
{
    NSInteger totalCount = _useCount;
    NSInteger index = button.tag;
    NSInteger currentCount = (totalCount/100) / index * 100;
    _stockCountTextField.text = [@(currentCount) stringValue];
}

#pragma mark - 买入按钮
- (void)buyingAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
        [self.delegate baseView:self actionTag:buyingButtonActionTag value:nil];
    }
}

#pragma mark - buttonAction
- (void)buttonAction:(UULabelView *)button
{
    if (_stockPriceTextField.text != nil) {
        
        CGFloat price = [_stockPriceTextField.text floatValue] + (button.tag ? 0.01:-0.01);
        if (price > 0)
        {
            _stockPriceTextField.text = [NSString stringWithFormat:@"%.2f",price];
        }
        else
        {
            _stockPriceTextField.text = @"0.00";
        }
    }
}

#pragma mark - searchAction
- (void)searchAction:(UIButton *)button
{
    [_stockCodeTextField becomeFirstResponder];
}

- (void)loadData
{
//    NSMutableAttributedString *stockName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"股票名称：%@",_detailModel.name != nil ? _detailModel.name:@"--" ]];
//    
//    if (_detailModel.name != nil)
//    {
//        self.stockName = _detailModel.name;
//    }
//    else
//    {
//        [stockName setAttributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: k_MIDDLE_TEXT_COLOR} range:NSMakeRange(0, 5)];
//        [stockName setAttributes:@{NSFontAttributeName : k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName: k_BIG_TEXT_COLOR} range:NSMakeRange(5,stockName.length - 5)];
//        _stockNameLabel.attributedText = stockName;
//    }

    
    NSString *hPrice = [NSString amountValueWithDouble:_detailModel.preClose * 1.1];
    NSString *lPrice = [NSString amountValueWithDouble:_detailModel.preClose - _detailModel.preClose * 0.1];
    //最低最高价格
    NSMutableAttributedString *lowestPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"跌停%@",[lPrice doubleValue] != 0 ? lPrice:@"--"]];
    [lowestPrice setAttributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: k_MIDDLE_TEXT_COLOR} range:NSMakeRange(0, 2)];
    [lowestPrice setAttributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: k_UNDER_COLOR} range:NSMakeRange(2,lowestPrice.length - 2)];
    _lowestPriceLabel.attributedText = lowestPrice;
    NSMutableAttributedString *highestPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"涨停%@",[hPrice doubleValue] != 0 ? hPrice:@"--"]];
    [highestPrice setAttributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: k_MIDDLE_TEXT_COLOR} range:NSMakeRange(0, 2)];
    [highestPrice setAttributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: k_UPPER_COLOR} range:NSMakeRange(2,highestPrice.length - 2)];
    _highestPriceLabel.attributedText = highestPrice;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _stockCodeTextField) {
        if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
            [self.delegate baseView:self actionTag:stockCodeTextFieldActionTag value:textField.text];
        }
    }
}


- (void)drawRect:(CGRect)rect
{
    [self drawBox];
    
    [self fillData];
}

- (void)drawBox
{
    CGRect rect = self.frame;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, k_MIDDLE_TEXT_COLOR.CGColor);
    CGContextStrokeRect(context, CGRectMake(RIGHT_PRICE_X,k_TOP_MARGIN, RIGHT_PRICE_WIDTH, CGRectGetHeight(rect) - 2 * k_TOP_MARGIN));

    CGFloat lineMargin = 30.0f;
    CGFloat lineY = (CGRectGetHeight(rect) - lineMargin) * 0.5;
    
    CGContextMoveToPoint(context, RIGHT_PRICE_X,lineY);
    CGContextAddLineToPoint(context,CGRectGetWidth(rect) - k_LEFT_MARGIN,lineY);
    
    CGContextMoveToPoint(context,RIGHT_PRICE_X,lineY + lineMargin);
    CGContextAddLineToPoint(context,CGRectGetWidth(rect) - k_LEFT_MARGIN, lineY + lineMargin);

    CGContextStrokePath(context);
}

- (void)fillData
{
    NSArray *sellPriceArray = @[
                                [NSString amountValueWithDouble:_detailModel.sellPrice1],
                                [NSString amountValueWithDouble:_detailModel.sellPrice2],
                                [NSString amountValueWithDouble:_detailModel.sellPrice3],
                                [NSString amountValueWithDouble:_detailModel.sellPrice4],
                                [NSString amountValueWithDouble:_detailModel.sellPrice5]
                                ];
    NSArray *sellAmountArray = @[
                                 [NSString amountValueWithDouble:_detailModel.sellAmount1],
                                 [NSString amountValueWithDouble:_detailModel.sellAmount2],
                                 [NSString amountValueWithDouble:_detailModel.sellAmount3],
                                 [NSString amountValueWithDouble:_detailModel.sellAmount4],
                                 [NSString amountValueWithDouble:_detailModel.sellAmount5]
                                 ];
    NSArray *buyPriceArray =  @[
                                [NSString amountValueWithDouble:_detailModel.buyPrice1],
                                [NSString amountValueWithDouble:_detailModel.buyPrice2],
                                [NSString amountValueWithDouble:_detailModel.buyPrice3],
                                [NSString amountValueWithDouble:_detailModel.buyPrice4],
                                [NSString amountValueWithDouble:_detailModel.buyPrice5]
                                ];
    NSArray *buyAmountArray =  @[
                                [NSString amountValueWithDouble:_detailModel.buyAmount1],
                                [NSString amountValueWithDouble:_detailModel.buyAmount2],
                                [NSString amountValueWithDouble:_detailModel.buyAmount3],
                                [NSString amountValueWithDouble:_detailModel.buyAmount4],
                                [NSString amountValueWithDouble:_detailModel.buyAmount5]
                                ];
    
    
    
    CGFloat lineMargin = 30.0f;

    CGFloat height = (CGRectGetHeight(self.bounds) - lineMargin - k_TOP_MARGIN) * 0.5;
    
    CGFloat cellHeight = height * 0.9 / 5.0f;
    
    CGFloat cellWidth = RIGHT_PRICE_WIDTH / 3.0f;
    
    CGFloat fontSize = 12.0f;

    NSMutableDictionary *attributes = [@{
                                 NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                                 NSForegroundColorAttributeName : k_BIG_TEXT_COLOR
                                 } mutableCopy];
    
    NSMutableDictionary *attributes2 = [@{
                                  NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                                  NSForegroundColorAttributeName : k_NAVIGATION_BAR_COLOR
                                  } mutableCopy];
    
    NSDictionary *attributes3 = @{
                                  NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                                  NSForegroundColorAttributeName : [UIColorTools colorWithHexString:@"#000000" withAlpha:1.0f]
                                  
                                  };
    
    CGFloat X = RIGHT_PRICE_X + 0.5 * k_LEFT_MARGIN;
 
    for (NSInteger i = 0; i < sellPriceArray.count; i++) {
        //卖
        NSString *sellPrice = sellPriceArray[sellPriceArray.count - 1 - i];
        NSString *sellAmount = sellAmountArray[sellAmountArray.count - 1 - i];

        
        if (sellPrice == nil || [sellPrice doubleValue] == 0)
        {
            sellPrice = @"--";
            sellAmount = @"--";
        }
        //价格颜色
       if ([sellPrice doubleValue] < _detailModel.preClose)
       {
           [attributes2 setValue:k_UNDER_COLOR forKey:NSForegroundColorAttributeName];
       }
       else if([sellPrice doubleValue] == _detailModel.preClose)
       {
           [attributes2 setValue:k_EQUAL_COLOR forKey:NSForegroundColorAttributeName];
       }
        CGFloat Y = k_TOP_MARGIN * 2+ cellHeight * i;
        CGRect frame = CGRectMake(RIGHT_PRICE_X,Y,RIGHT_PRICE_WIDTH, fontSize * 2);
        [[NSString stringWithFormat:@"卖%@",@(sellPriceArray.count - i)] drawInRect:CGRectMake(X,Y,cellWidth,fontSize * 2) withAttributes:attributes];

        [sellPrice drawInRect:CGRectMake(X + cellWidth,Y,cellWidth,fontSize * 2) withAttributes:attributes2];
        
        [_priceDictionary setObject:sellPrice forKey:NSStringFromCGRect(frame)];
        [[NSString amountTransformToPrice:[sellAmount doubleValue]] drawInRect:CGRectMake(X+cellWidth * 2,Y,cellWidth,fontSize * 2) withAttributes:attributes3];
        
        //买
        NSString *buyPrice = buyPriceArray[i];
        NSString *buyAmount = buyAmountArray[i];
        if (buyPrice == nil || [buyPrice doubleValue] == 0) {
            buyPrice = @"--";
            buyAmount = @"--";
        }
        //价格颜色
        if ([buyPrice doubleValue] < _detailModel.preClose)
        {
            [attributes2 setValue:k_UNDER_COLOR forKey:NSForegroundColorAttributeName];
        }
        else if([buyPrice doubleValue] == _detailModel.preClose)
        {
            [attributes2 setValue:k_EQUAL_COLOR forKey:NSForegroundColorAttributeName];
        }
        Y += (height + lineMargin) - k_TOP_MARGIN * 0.5;
        frame = CGRectMake(RIGHT_PRICE_X,Y,RIGHT_PRICE_WIDTH, fontSize * 2);;
        [[NSString stringWithFormat:@"买%@",@(i + 1)] drawInRect:CGRectMake(X,Y,cellWidth,fontSize * 2) withAttributes:attributes];
        [buyPrice drawInRect:CGRectMake(X + cellWidth,Y,cellWidth,fontSize * 2) withAttributes:attributes2];
        [_priceDictionary setObject:buyPrice forKey:NSStringFromCGRect(frame)];

        [[NSString amountTransformToPrice:[buyAmount doubleValue]] drawInRect:CGRectMake(X  + cellWidth * 2,Y,cellWidth,fontSize * 2) withAttributes:attributes3];
    }

 }



- (void)layoutSubviews
{
    CGFloat X = RIGHT_PRICE_X;
    CGFloat Y = CGRectGetHeight(self.bounds) * 0.5 - k_TOP_MARGIN * 1.5;
    CGFloat cellWidth = RIGHT_PRICE_WIDTH / 2.0f;
    CGFloat cellHeight = 30.0f;

    _lstPriceLabel.frame = CGRectMake(X, Y, cellWidth, cellHeight);
    _rateLabel.frame = CGRectMake(X + cellWidth, Y, cellWidth, cellHeight);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *frames = [_priceDictionary allKeys];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    [frames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGRect frame = CGRectFromString(obj);
        //283.5,27.5
        if (touchPoint.x < CGRectGetMaxX(frame)
            && touchPoint.x > CGRectGetMinX(frame)
            && touchPoint.y < CGRectGetMaxY(frame)
            && touchPoint.y > CGRectGetMinY(frame))
        {
          NSString *price = [_priceDictionary valueForKey:obj];
            
            _stockPriceTextField.text = price;
            UIImage *image = [UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            _priceSelectedView = button;
            frame.origin.y -= k_TOP_MARGIN * 0.5;
            button.frame = frame;
            button.alpha = 0.5;
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [self addSubview:button];
        }
        
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_priceSelectedView removeFromSuperview];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_priceSelectedView removeFromSuperview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_priceSelectedView removeFromSuperview];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_stockPriceTextField];
}

@end
