//
//  UUMarketQuotationView.m
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUMarketQuotationView.h"
#import "UUOptionView.h"
#import "UUKLineView.h"
#import "UUStockShareTimeView.h"
#import "UUStockTimeEntity.h"
#import "UUStockDetailCurrentPriceView.h"
#import <Masonry/Masonry.h>
#import "UUKLineModel.h"
@interface UUMarketQuotationView ()<UUOptionViewDelegate>
{
    UUOptionView *_optionView;
    NSArray *_subViews;
}
@end

@implementation UUMarketQuotationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configSubViews];
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColorTools colorWithHexString:@"#A4A5A7" withAlpha:1.0f].CGColor;
        self.layer.borderWidth = 0.5f;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame stockType:(NSInteger)stockType
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColorTools colorWithHexString:@"#A4A5A7" withAlpha:1.0f].CGColor;
        self.layer.borderWidth = 0.5f;
        self.stockType = stockType;
        
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    NSArray *titles = @[@"分时",@"盘口",@"日K",@"周K",@"月K"];
    if (_stockType == 1) {
        titles = @[@"分时",@"日K",@"周K",@"月K"];
    }
    UUOptionView *optionView = [[UUOptionView alloc] initWithFrame:CGRectZero titles:titles delegate:self];
    [self addSubview:optionView];
    _optionView = optionView;
    [_optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top).with.offset(0);
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.height.mas_equalTo(UUOptionViewHeight);
    }];
    
    
    _stockShareView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUStockShareTimeView class]) owner:self options:nil] firstObject];
    
    [self addSubview:_stockShareView];
    [_stockShareView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top).with.offset(UUOptionViewHeight);
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];

    
    _kLineView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUKLineView class]) owner:self options:nil] firstObject];
    [self addSubview:_kLineView];
    [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top).with.offset(UUOptionViewHeight);
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    _subViews = @[_stockShareView,_kLineView];
    
    //{{0, 30}, {548, 274}}
    if (_stockType == 0) {
        _currentPriceView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UUStockDetailCurrentPriceView class]) owner:self options:nil] firstObject];
        [self addSubview:_currentPriceView];
        [_currentPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.mas_top).with.offset(UUOptionViewHeight);
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.bottom.mas_equalTo(self.mas_bottom);
            
        }];
        
        
        _subViews = @[_stockShareView,_currentPriceView,_kLineView];
    }
    [self showViewWithOptionIndex:0];
}

- (void)setType:(NSInteger)type
{
    _type = type;
    _stockShareView.type = _type;
    _kLineView.type = _type;
}

//复权
- (void)setExRights:(ExRights)exRights
{
    _exRights = [exRights copy];
    _kLineView.exrights = _exRights;
}

- (void)setExRightsArray:(NSArray *)exRightsArray
{
    if (_exRightsArray == exRightsArray || exRightsArray == nil) {
        return;
    }
    _exRightsArray = exRightsArray;
    _kLineView.exRightsArray = _exRightsArray;
}

- (void)setKLineModelArray:(NSArray *)kLineModelArray
{
    if ([kLineModelArray isNull] || _kLineModelArray == kLineModelArray) {
        return;
    }
    
    _kLineModelArray = [kLineModelArray copy];

    _kLineView.kLineModelArray = _kLineModelArray;
}

- (void)setQuoteEntity:(UUStockQuoteEntity *)quoteEntity
{
    if (quoteEntity == nil || _quoteEntity == quoteEntity) {
        return;
    }
    _quoteEntity = quoteEntity;
    _stockShareView.stockQuoteEntity = _quoteEntity;
}

- (void)setDetailModel:(UUStockDetailModel *)detailModel
{
    if (detailModel == nil || _detailModel == detailModel) {
        return;
    }
    _detailModel = detailModel;
    _currentPriceView.detailModel = _detailModel;
}


#pragma mark - UUOptionViewDelegate
- (void)optionView:(UUOptionView *)optionView didSeletedIndex:(NSInteger)index
{
    [self showViewWithOptionIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
        [self.delegate baseView:self actionTag:index value:nil];
    }
}

- (void)showViewWithOptionIndex:(NSInteger)index
{
    _optionView.selectedIndex = index;
    for (UIView *tempView in _subViews) {
        
        tempView.hidden = YES;
    }
    
    if (_stockType == 0) {
        if (index < 3) {
            UIView *view = [_subViews objectAtIndex:index];
            view.hidden = NO;
        }else{
            _kLineView.hidden = NO;
        }
    }else if (_stockType == 1){
        if (index == 0) {
            UIView *view = [_subViews objectAtIndex:index];
            view.hidden = NO;
        }else{
            _kLineView.hidden = NO;
        }
    }
}

@end


