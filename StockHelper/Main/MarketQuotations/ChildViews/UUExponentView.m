//
//  UUExponentView.m
//  StockHelper
//
//  Created by LiuRex on 15/6/16.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUExponentView.h"

@implementation UUExponentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setIndexDetailModel:(UUIndexDetailModel *)indexDetailModel
{
    if (indexDetailModel == nil || _indexDetailModel == indexDetailModel) {
        return;
    }
    _indexDetailModel = indexDetailModel;
    [self fillData];
}

- (void)fillData
{
    
    NSString *name =_indexDetailModel.name;

    //当前价格
    NSString *price = [NSString amountValueWithDouble:_indexDetailModel.newPrice];

    //---涨跌幅----
    double upRaiseRate = 0;
    if (_indexDetailModel.preClose != 0) {
        upRaiseRate = (_indexDetailModel.newPrice - _indexDetailModel.preClose) / _indexDetailModel.preClose;
    }
    
    //涨跌额
    NSString *markUp = [NSString amountValueWithDouble:_indexDetailModel.newPrice - _indexDetailModel.preClose];
    //涨跌幅
    NSString *limited = [NSString stringWithFormat:@"%.2f%%",upRaiseRate * 100];
    //背景色
   _fillColor = k_EQUAL_COLOR;
    if (upRaiseRate > 0){
        _fillColor = k_UPPER_COLOR;
        
        markUp = [@"+" stringByAppendingString:markUp];
        limited = [@"+" stringByAppendingString:limited];
    }else{
        _fillColor = k_UNDER_COLOR;
    }
    
    _nameLabel.text = name;
    _priceLabel.text = price;
    _rateLabel.text = markUp;
    _rateValueLabel.text = limited;
    
    self.backgroundColor = _fillColor;

}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventTouchUpInside) {
        _target = target;
        _action = action;
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_target respondsToSelector:_action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector: _action withObject: self];//此处是你调用函数的地方
#pragma clang diagnostic pop
    }
}


@end
