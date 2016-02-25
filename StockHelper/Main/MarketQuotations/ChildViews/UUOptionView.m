//
//  UUOptionView.m
//  StockHelper
//
//  Created by LiuRex on 15/6/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUOptionView.h"


@implementation UUOptionView

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles delegate:(id<UUOptionViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles delegate:(id<UUOptionViewDelegate>)delegate
{
    if (self = [super init]) {
        self.titles = titles;
        self.delegate = delegate;
    }
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    if (titles == nil || _titles == titles) {
        return;
    }
    _titles = titles;
    [self configSubViews];
}

- (void)configSubViews
{
    NSMutableArray *buttonArray = [NSMutableArray array];
    for (int i = 0; i < _titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:k_BIG_TEXT_COLOR forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColorTools colorWithHexString:@"#A4A5A7" withAlpha:1.0f].CGColor;
        [button setTitle:[_titles objectAtIndex:i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIKitHelper imageWithColor:k_BG_COLOR] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateSelected];
        button.tag = i;
        if (i == 0) {
            button.selected = YES;
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [buttonArray addObject:button];
    }
    self.buttonArray = buttonArray;
}

- (void)layoutSubviews
{
    for (NSInteger i = 0; i < _buttonArray.count; i++) {
        UIButton *button = [_buttonArray objectAtIndex:i];
        CGFloat buttonWidth = CGRectGetWidth(self.bounds) / (float)_titles.count;
        CGFloat buttonHeight = CGRectGetHeight(self.bounds);
        CGFloat buttonX = i * buttonWidth;
        button.frame = CGRectMake(buttonX, 0, buttonWidth, buttonHeight);
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    for (UIButton *tempButton in _buttonArray) {
        tempButton.selected = NO;
    }
   
    UIButton *button = [_buttonArray objectAtIndex:selectedIndex];
    button.selected = YES;
    
}

- (void)buttonAction:(UIButton *)button
{
    for (UIButton *tempButton in _buttonArray) {
        tempButton.selected = NO;
    }
    button.selected = YES;
    
    if ([_delegate respondsToSelector:@selector(optionView:didSeletedIndex:)]) {
        [_delegate optionView:self didSeletedIndex:button.tag];
    }
}

@end