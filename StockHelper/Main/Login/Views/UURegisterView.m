//
//  UURegisterView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UURegisterView.h"

@implementation UURegisterView

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
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.backgroundColor = k_BG_COLOR;
    [self addSubview:_scrollView];
    
    CGFloat textFieldWidth = CGRectGetWidth(self.bounds) - 80.0f;
    CGFloat textFieldHeight = 44.0f;
    NSDictionary *placeHolderAtrubites = @{
                                           NSFontAttributeName : k_MIDDLE_TEXT_FONT,
                                           NSForegroundColorAttributeName : k_MIDDLE_TEXT_COLOR
                                           };
    //手机号
    _phoneTextField = [UIKitHelper textFieldWithFrame:CGRectMake(40, 40.0f, textFieldWidth, textFieldHeight) placeholder:nil Text:nil leftViewText:@"手机号"];
    _phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的手机号码" attributes:placeHolderAtrubites];
    _phoneTextField.backgroundColor = k_BG_COLOR;
    _phoneTextField.delegate = self;
    _phoneTextField.returnKeyType = UIReturnKeyDone;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:_phoneTextField];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_phoneTextField.frame) - 0.5f, CGRectGetWidth(_phoneTextField.frame), 0.5f)];
    lineView.backgroundColor = k_LINE_COLOR;
    [_phoneTextField addSubview:lineView];
    [_scrollView addSubview:_phoneTextField];
    
    //验证码
    _verifyTextField = [UIKitHelper textFieldWithFrame:CGRectMake(40,CGRectGetMaxY(_phoneTextField.frame) + k_TOP_MARGIN * 2, textFieldWidth, textFieldHeight) placeholder:nil Text:nil leftViewText:@"验证码"];
    
    _verifyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString: @"请输入验证码" attributes:placeHolderAtrubites];
    _verifyTextField.backgroundColor = k_BG_COLOR;
    _verifyTextField.delegate = self;
    _verifyTextField.returnKeyType = UIReturnKeyDone;
    [_scrollView addSubview:_verifyTextField];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneTextField.frame), CGRectGetMaxY(_verifyTextField.frame) - 0.5f, CGRectGetWidth(_phoneTextField.frame), 0.5f)];
    lineView.backgroundColor = k_LINE_COLOR;
    [_scrollView addSubview:lineView];
    
    //-- 密码
  _passwordTextField=  [UIKitHelper textFieldWithFrame:CGRectMake(CGRectGetMinX(_verifyTextField.frame), CGRectGetMaxY(_verifyTextField.frame) + k_TOP_MARGIN, textFieldWidth, textFieldHeight) placeholder:nil Text:nil leftViewText:@"设置密码"];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString: @"请输入密码" attributes:placeHolderAtrubites];
    _passwordTextField.delegate = self;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.secureTextEntry = YES;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_passwordTextField.frame), CGRectGetMaxY(_passwordTextField.frame) - 0.5f, CGRectGetWidth(_verifyTextField.frame), 0.5f)];
    lineView.backgroundColor = k_LINE_COLOR;
    [_scrollView addSubview:lineView];
    [_scrollView addSubview:_passwordTextField];
    _passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UIImage *image = [UIImage imageNamed:@"Login_pwd_discover"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Login_pwd"] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateSelected];

    button.frame = CGRectMake(0, 0, image.size.width * 2, image.size.height * 2);
    [button addTarget:self action:@selector(passwordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _passwordTextField.rightView =  button;
    
    //获取验证码按钮
    CGFloat labelWidth = 65.0f;
    CGFloat labelHeight = 30.0f;
    //    _phoneTextField = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(_passwordTextField.frame) - labelWidth,CGRectGetMidY(_passwordTextField.frame) - labelHeight * 0.5,labelWidth, labelHeight) Font:k_MIDDLE_TEXT_FONT textColor:k_NAVIGATION_BAR_COLOR];
    
    _verifyButton = [UIKitHelper buttonWithFrame:CGRectMake(CGRectGetMaxX(_passwordTextField.frame) - labelWidth,CGRectGetMidY(_verifyTextField.frame) - labelHeight * 0.5,labelWidth, labelHeight) title:@"获取验证码" titleHexColor:@"FFFFFF" font:k_SMALL_TEXT_FONT];
    [_verifyButton addTarget:self action:@selector(getVerifyCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_verifyButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateNormal];
    _verifyButton.layer.cornerRadius = 5;
    _verifyButton.layer.masksToBounds = YES;
    [_scrollView addSubview:_verifyButton];
    
    CGRect frame = _verifyTextField.frame;
    frame.size.width -= labelWidth;
    _verifyTextField.frame = frame;
    //提交按钮
    CGFloat buttonHeight = 44.0f;
    _registerButton = [UIKitHelper buttonWithFrame:CGRectMake(CGRectGetMinX(_passwordTextField.frame), CGRectGetMaxY(_passwordTextField.frame) + 40.0f, CGRectGetWidth(_phoneTextField.frame), buttonHeight) title:@"下一步" titleHexColor:@"FFFFFF" font:k_BIG_TEXT_FONT];
    [_registerButton setBackgroundImage:[UIKitHelper imageWithColor:k_LINE_COLOR] forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateSelected];
    [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    _registerButton.userInteractionEnabled = NO;
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _registerButton.layer.cornerRadius =16.0f;
    _registerButton.layer.masksToBounds = YES;
    [_scrollView addSubview:_registerButton];

    

    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetMaxY(_registerButton.frame) + 64.0f + k_TOP_MARGIN);
    _contentSize = _scrollView.contentSize;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setCode:(NSString *)code
{
    if (_code == code || code == nil) {
        return;
    }

    _code = [code copy];
    _verifyTextField.text = _code;
}

- (NSString *)mobile
{
    return _phoneTextField.text;
}

- (NSString *)password
{
    return _passwordTextField.text;
}

#pragma mark - 密码可见
- (void)passwordButtonAction:(UIButton *)button
{
    button.selected = !button.isSelected;
    _passwordTextField.secureTextEntry = !button.isSelected;
}

#pragma mark -  注册
- (void)registerAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
        [self.delegate baseView:self actionTag:UURegisterButtonActionTag value:nil];
    }
}

#pragma mark - 获取验证码
- (void)getVerifyCodeAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
        [self.delegate baseView:self actionTag:UUGetVerifyCodeButtonActionTag value:_phoneTextField.text];
    }
    
}

- (void)timerBeginFire
{
    _endTime = 5;
    if (!_timer.isValid) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(counting) userInfo:nil repeats:YES];
        [_timer fire];
        
        _verifyButton.userInteractionEnabled = NO;
        [_verifyButton setBackgroundImage:[UIKitHelper imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    }
}

- (void)counting
{
    NSString *title = @"%.0f";
    
    [_verifyButton setTitle:[NSString stringWithFormat:title,--_endTime] forState:UIControlStateNormal];
    
    if (_endTime == 0)
    {
        [_timer invalidate];
        [_verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateNormal];
        _verifyButton.userInteractionEnabled = YES;
    }
}

#pragma mark - 输入框字符改变
- (void)textFieldDidChange:(NSNotification *)notificaiton
{
    if (_phoneTextField.text.length > 0 && _passwordTextField.text.length > 0 && _verifyTextField.text.length) {
        _registerButton.userInteractionEnabled = YES;
        _registerButton.selected = YES;
    }else{
        _registerButton.userInteractionEnabled = NO;
        _registerButton.selected = NO;
    }
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

#pragma mark -  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    CGFloat Y = CGRectGetMinY(textField.frame);
    //    [_scrollView setContentOffset:CGPointMake(0, Y) animated:YES];
}

//#pragma mark - 注册
//- (void)registerAction:(UIButton *)buttion
//{
//    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
//        [self.delegate baseView:self actionTag:UURegisterActionTag value:nil];
//    }
//}
//
//#pragma mark - 忘记密码
//- (void)forgotPasswordAciton
//{
//    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
//        [self.delegate baseView:self actionTag:UUForgotPasswordActionTag value:nil];
//    }
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
