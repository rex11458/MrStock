//
//  UUConfirmPasswordView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUConfirmPasswordView.h"

@implementation UUConfirmPasswordView

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
    
    CGFloat textFieldWidth = CGRectGetWidth(self.bounds) - 80.0f;
    CGFloat textFieldHeight = 44.0f;
    NSDictionary *placeHolderAtrubites = @{
                                           NSFontAttributeName : k_MIDDLE_TEXT_FONT,
                                           NSForegroundColorAttributeName : k_MIDDLE_TEXT_COLOR
                                           };
    //密码
    _passwordTextField = [UIKitHelper textFieldWithFrame:CGRectMake(40, 40.0f, textFieldWidth, textFieldHeight) placeholder:nil Text:nil leftViewText:@"新密码"];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入6~23位字母数字符号组合" attributes:placeHolderAtrubites];
    _confirmPasswordTextField.secureTextEntry = YES;
    _passwordTextField.backgroundColor = k_BG_COLOR;
    _passwordTextField.delegate = self;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.secureTextEntry = YES;
    [_scrollView addSubview:_passwordTextField];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_passwordTextField.frame) - 0.5f, CGRectGetWidth(_passwordTextField.frame), 0.5f)];
    lineView.backgroundColor = k_LINE_COLOR;
    [_passwordTextField addSubview:lineView];
    [_scrollView addSubview:_passwordTextField];
    
    //确认
    _confirmPasswordTextField = [UIKitHelper textFieldWithFrame:CGRectMake(40,CGRectGetMaxY(_passwordTextField.frame) + k_TOP_MARGIN * 2, textFieldWidth, textFieldHeight) placeholder:nil Text:nil leftViewText:@"确认密码"];
    
    _confirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString: @"再次确认密码" attributes:placeHolderAtrubites];
    _confirmPasswordTextField.backgroundColor = k_BG_COLOR;
    _confirmPasswordTextField.delegate = self;
    _confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
    _confirmPasswordTextField.secureTextEntry = YES;
    [_scrollView addSubview:_confirmPasswordTextField];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_confirmPasswordTextField.frame) - 0.5f, CGRectGetWidth(_confirmPasswordTextField.frame), 0.5f)];
    lineView.backgroundColor = k_LINE_COLOR;
    [_confirmPasswordTextField addSubview:lineView];
    
    //提交按钮
    CGFloat buttonHeight = 44.0f;
    _doneButton = [UIKitHelper buttonWithFrame:CGRectMake(CGRectGetMinX(_confirmPasswordTextField.frame), CGRectGetMaxY(_confirmPasswordTextField.frame) + 40.0f, CGRectGetWidth(_confirmPasswordTextField.frame), buttonHeight) title:@"设置密码" titleHexColor:@"FFFFFF" font:k_BIG_TEXT_FONT];
    [_doneButton setBackgroundImage:[UIKitHelper imageWithColor:k_LINE_COLOR] forState:UIControlStateNormal];
    [_doneButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateSelected];
    [_doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    _doneButton.userInteractionEnabled = NO;
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _doneButton.layer.cornerRadius =16.0f;
    _doneButton.layer.masksToBounds = YES;
    [_scrollView addSubview:_doneButton];
    
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetMaxY(_doneButton.frame) + 64.0f + k_TOP_MARGIN);
    _contentSize = _scrollView.contentSize;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSString *)newPassword
{
    return _passwordTextField.text;
}

#pragma mark - 设置密码
- (void)doneAction:(UIButton *)buttion
{
    if([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)])
    {
        [self.delegate baseView:self actionTag:UUDoneButtonActionTag value:nil];
    }
}


#pragma mark - 输入框字符改变
- (void)textFieldDidChange:(NSNotification *)notificaiton
{
    if (_passwordTextField.text.length > 0 && _confirmPasswordTextField.text.length > 0) {
        _doneButton.userInteractionEnabled = YES;
        _doneButton.selected = YES;
    }else{
        _doneButton.userInteractionEnabled = NO;
        _doneButton.selected = NO;
    }
}

#pragma mark -  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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


#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



@end
