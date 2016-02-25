//
//  UUTabbar.m
//  StockHelper
//
//  Created by LiuRex on 15/6/8.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTabbar.h"
#define BUTTON_IMAGE_TATIO 0.6
@implementation UUButton

- (void)setHighlighted:(BOOL)highlighted{}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat X = 0;
    CGFloat Y = 5;
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat height = CGRectGetHeight(contentRect) * BUTTON_IMAGE_TATIO - 5;
    return CGRectMake(X, Y, width, height);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat X = 0;
    CGFloat Y = CGRectGetHeight(self.imageView.bounds) + 5;
    CGFloat width = CGRectGetWidth(contentRect) ;
    CGFloat height = CGRectGetHeight(contentRect) * (1 - BUTTON_IMAGE_TATIO);
    return CGRectMake(X, Y, width, height);
}


@end

@implementation UUTabbarItem

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag
{
    if (self = [super init]) {
        
        self.title = title;
        self.image = image;
        self.selectedImage = selectedImage;
        self.tag = tag;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage backgroundColor:(UIColor *)backgroundColor tag:(NSInteger)tag
{
    if (self = [super init]) {
        
        self.title = title;
        self.image = image;
        self.selectedImage = selectedImage;
        self.backgroundColor = backgroundColor;
        self.tag = tag;
    }
    return self;

}

@end



@interface UUTabbar ()

@property (nonatomic,copy) NSArray *buttonArray;

@end

@implementation UUTabbar

- (id)initWithFrame:(CGRect)frame
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
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    if (self = [self initWithFrame:frame]) {
        self.items = items;
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    if (items == nil || _items == items) {
        return;
    }
    _items = items;
    [self configSubViews];
}

- (void)configSubViews
{
    CGFloat buttonHeight = k_TABBER_HEIGHT;
    CGFloat buttonWidth = CGRectGetWidth(self.bounds) / (CGFloat)_items.count;
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < _items.count; i++) {
        
        UUTabbarItem *item = [_items objectAtIndex:i];
        
        UUButton *button = [UUButton buttonWithType:UIButtonTypeCustom];
      
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight);
        button.imageView.contentMode = UIViewContentModeCenter;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setImage:item.image forState:UIControlStateNormal];
        [button setImage:item.selectedImage forState:UIControlStateSelected];
        [button setTitleColor:k_BIG_TEXT_COLOR forState:UIControlStateNormal];
        [button setTitleColor:[UIColorTools colorWithHexString:@"#FF5C5D" withAlpha:1] forState:UIControlStateSelected];

        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
        }
        
        [buttonArray addObject:button];
        [self addSubview:button];
    }
    
    _buttonArray = [buttonArray copy];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex || selectedIndex >= self.buttonArray.count) {
        
    }
    _selectedIndex = selectedIndex;
    
    for (UIButton *tempButton in self.buttonArray) {
        tempButton.selected = NO;
    }
    UIButton *button = [self.buttonArray objectAtIndex:selectedIndex];
    button.selected = YES;
}


- (void)buttonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(tabbar:didSelectedItem:)]) {
        [_delegate tabbar:self didSelectedItem:[_items objectAtIndex:button.tag]];
    }
}

@end
