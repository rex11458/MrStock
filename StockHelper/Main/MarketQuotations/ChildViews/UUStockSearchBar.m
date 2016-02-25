//
//  UUStockSearchView.m
//  StockHelper
//
//  Created by LiuRex on 15/5/15.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockSearchBar.h"
#import "UUStockKeyboard.h"
@interface UUStockSearchBar ()<UUStockKeyboardDelegate,UITextFieldDelegate>

@property (nonatomic) UITextField *searchTextField;

@property (nonatomic) UIButton *searchButton;

@property (nonatomic) NSMutableArray *textArray;

@end

@implementation UUStockSearchBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _textArray = [NSMutableArray array];

        [self configSubViews];
    
    }
    return self;
}

- (void)configSubViews
{
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) - CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds))];
    
    NSString *placeholder =  @"请输入股票代码/拼音首字母";
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                                 NSForegroundColorAttributeName : [UIColor whiteColor]
                                 };
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:attributes];
    _searchTextField.attributedPlaceholder = attributedPlaceholder;
    _searchTextField.backgroundColor = [UIColor clearColor];
    _searchTextField.textColor = [UIColor whiteColor];
    _searchTextField.delegate = self;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.layer.borderColor = [UIColor clearColor].CGColor;
    _searchTextField.font=[UIFont boldSystemFontOfSize:14.0f];
    UUStockKeyboard *keyboard = [UUStockKeyboard  keyboardWithType:UUStockNumberKeyboardType];
    keyboard.delegate = self;
    _searchTextField.inputView = keyboard;
    [self addSubview:_searchTextField];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetHeight(self.bounds), 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds));
    [_searchButton setImage:[UIImage imageNamed:@"Nav_search"] forState:UIControlStateNormal];
    [self addSubview:_searchButton];
}

- (void)keyboard:(UUStockKeyboard *)keyboard didSelectedIndex:(NSInteger)index withValue:(id)value
{
    if ([value isEqualToString:@"收起"])
    {
        //收起键盘
        [self endEditing:YES];
        return;
        
    }
    else if ([value isEqualToString:@"删除"])
    {
        //回删
        if (_textArray.count > 0) {
            [_textArray removeLastObject];
        }
    }
    else if([value isEqualToString:@"上证"])
    {
        if ([_delegate respondsToSelector:@selector(SSMarketAction:)]) {
            [_delegate SSMarketAction:self];
        }
        
        //上证
        return;

    }
    else if([value isEqualToString:@"深证"])
    {
        if ([_delegate respondsToSelector:@selector(SZMarketAction:)]) {
            [_delegate SZMarketAction:self];
        }
        //深圳
        return;
    }
    else if ([value isEqualToString:@"搜索"])
    {
        //搜索
        return;
    }else
    {
        if (_searchTextField.text.length < 6) {
            if (value !=nil) {
                [_textArray addObject:value];
            }
        }
    }
    _searchTextField.text = [_textArray componentsJoinedByString:@""];
    if ([_delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [_delegate searchBar:self textDidChange:_searchTextField.text];
    }
}

- (BOOL)becomeFirstResponder
{
    return [_searchTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [_textArray removeAllObjects];
    return YES;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, [UIColorTools colorWithHexString:@"#FFFFFF" withAlpha:1.0f].CGColor);
    CGContextMoveToPoint(context, 0, CGRectGetHeight(rect) - 0.5f);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect),CGRectGetHeight(self.bounds) - 0.5f);
    CGContextStrokePath(context);
}


@end
