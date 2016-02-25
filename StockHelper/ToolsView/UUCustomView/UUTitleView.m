//
//  UUTitleView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTitleView.h"

@implementation UUTitleView

- (id)initWithFrame:(CGRect)frame selectedIndex:(void(^)(NSInteger))selectedIndex
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.backgroundColor = [UIColor clearColor];
        
        self.selectedIndex = selectedIndex;
        
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray
{
    if (!titleArray || _titleArray == titleArray) {
        return;
    }
    _titleArray = [titleArray copy];
    [self configSubViews];
    
    
}

- (void)configSubViews
{
    _buttonArray = [NSMutableArray array];
    CGFloat buttonWidth = CGRectGetWidth(self.bounds) / (CGFloat)_titleArray.count;
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, CGRectGetHeight(self.bounds));
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        button.tag = i;
        [button setTitle:[_titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIKitHelper imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        [button setTitleColor:k_NAVIGATION_BAR_COLOR forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttonArray addObject:button];
        
        if (i == 0) {
            button.selected = YES;
        }else{
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * buttonWidth, 0, 1.0f, CGRectGetHeight(self.bounds))];
            lineView.backgroundColor = [UIColor whiteColor];
            [self addSubview:lineView];
        }
    }
}

- (void)buttonAction:(UIButton *)button
{
    for (UIButton *tempButton in _buttonArray) {
        tempButton.selected = NO;
    }
    button.selected = YES;
    
    if (self.selectedIndex) {
        _selectedIndex(button.tag);
    }
}

@end
