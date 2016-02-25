//
//  UUSuggestionView.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUSuggestionView.h"

@implementation UUSuggestionView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = k_BG_COLOR;
        
        [self configSubViews];
        
    }
    return self;
}

- (void)configSubViews
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = k_BG_COLOR;
    _scrollView.alwaysBounceVertical = YES;
    [self addSubview:_scrollView];
    
    
    
    CGFloat textViewHeight = 235.0f;
    _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN,k_TOP_MARGIN,PHONE_WIDTH - 2 * k_LEFT_MARGIN,textViewHeight)];
    _textView.placeholder = @"亲,您的建议是我们持续改善产品最大的动力!";
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.cornerRadius = 5.0f;
    _textView.layer.borderWidth = 0.5f;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.layer.borderColor = k_LINE_COLOR.CGColor;
    [_scrollView addSubview:_textView];
    
    
    //提交按钮
    CGFloat buttonHeight = 44.0f;
    _confirmButton = [UIKitHelper buttonWithFrame:CGRectMake(CGRectGetMinX(_textView.frame) + k_LEFT_MARGIN * 3, CGRectGetMaxY(_textView.frame) + 40.0f, CGRectGetWidth(_textView.frame) - 6 * k_LEFT_MARGIN, buttonHeight) title:@"提交反馈" titleHexColor:@"FFFFFF" font:k_BIG_TEXT_FONT];
    [_confirmButton setBackgroundImage:[UIKitHelper imageWithColor:k_LINE_COLOR] forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateSelected];
    [_confirmButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.userInteractionEnabled = NO;
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _confirmButton.layer.cornerRadius =16.0f;
    _confirmButton.layer.masksToBounds = YES;
    [_scrollView addSubview:_confirmButton];
    
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetMaxY(_confirmButton.frame) + 64.0f + k_TOP_MARGIN);
    _contentSize = _scrollView.contentSize;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.text.length > 0) {
        _confirmButton.userInteractionEnabled = YES;
        _confirmButton.selected = YES;
    }else{
        _confirmButton.userInteractionEnabled = NO;
        _confirmButton.selected = NO;
    }
}
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self endEditing:YES];
    return YES;
}

#pragma mark - 键盘通知
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGSize contentSize = _contentSize;
    contentSize.height += keyboardHeight;
    _scrollView.contentSize = contentSize;
    
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGSize contentSize = _contentSize;
    contentSize.height -= keyboardHeight;
    _scrollView.contentSize = contentSize;
}


#pragma mark - 提交
- (void)commitAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
        [self.delegate baseView:self actionTag:UUCommitButtionActionTag value:nil];
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
