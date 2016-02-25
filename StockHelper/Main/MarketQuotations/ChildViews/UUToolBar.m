//
//  UUToolBar.m
//  StockHelper
//
//  Created by LiuRex on 15/6/16.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUToolBar.h"
#import "UUTabbar.h"
@implementation UUToolBar


- (id)initWithFrame:(CGRect)frame items:(NSArray *)items delegate:(id<UUToolBarDelegate>)delegate;
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColorTools colorWithHexString:@"#FFFFFF" withAlpha:1];
        self.layer.shadowOffset = CGSizeMake(0, -5);
        self.layer.shadowColor = [UIColorTools colorWithHexString:@"#CFCFCF" withAlpha:1.0f].CGColor;
        self.layer.shadowOpacity = 0.4;
        CALayer *lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5f);
        lineLayer.backgroundColor = k_LINE_COLOR.CGColor;
        [self.layer addSublayer:lineLayer];
        
        self.items = items;
        self.delegate = delegate;

    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    if (_items != items) {
        _items = [items copy];
        [self configSubViews];
    }
}

- (void)configSubViews
{
    _buttonArray = [NSMutableArray array];
    CGFloat buttonHeight = UUToolBarHeight;
    CGFloat buttonWidth = 60;
    CGFloat firstButtonWidth = CGRectGetWidth(self.bounds) - (_items.count - 1) * buttonWidth - k_LEFT_MARGIN;

    for (NSInteger i = 0; i < _items.count; i++) {
        UUTabbarItem *item = [_items objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat X = firstButtonWidth + (i -1) * buttonWidth + k_LEFT_MARGIN;
        CGFloat _buttonWidth = buttonWidth;
        if (i == 0) {
            X = k_LEFT_MARGIN;
            _buttonWidth = firstButtonWidth;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        
        button.frame = CGRectMake(X, 0, _buttonWidth, buttonHeight);
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setImage:item.image forState:UIControlStateNormal];
        [button setImage:item.selectedImage forState:UIControlStateSelected];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [button setTitleColor:k_BIG_TEXT_COLOR forState:UIControlStateNormal];
        button.tag = i;
        button.selected = item.isSelected;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttonArray addObject:button];
        
        if (i != 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, k_TOP_MARGIN, 0.5, UUToolBarHeight - 2 * k_TOP_MARGIN)];
            line.backgroundColor = k_LINE_COLOR;
            [button addSubview:line];
        }
    }
}

- (void)setSelected:(BOOL)selected Index:(NSInteger)index
{
    if (index < _buttonArray.count) {
        UIButton *button = [_buttonArray objectAtIndex:index];
        button.selected = selected;
    }
}

- (void)setTitle:(NSString *)title index:(NSInteger)index
{
    if (index < _buttonArray.count) {
        UIButton *button = [_buttonArray objectAtIndex:index];
        [button setTitle:title forState:UIControlStateNormal];
    }

}

- (void)buttonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(toolBar:didSeletedIndex:)]) {
        [_delegate toolBar:self didSeletedIndex:button.tag];
    }
}


@end
