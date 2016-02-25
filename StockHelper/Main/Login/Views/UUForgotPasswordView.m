//
//  UUForgotPasswrodView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUForgotPasswordView.h"

@implementation UUForgotPasswordView

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

    _verifyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString: @"请输入密码" attributes:placeHolderAtrubites];
    _verifyTextField.backgroundColor = k_BG_COLOR;
    _verifyTextField.delegate = self;
    _verifyTextField.returnKeyType = UIReturnKeyDone;
//    _verifyTextField.secureTextEntry = YES;
    [_scrollView addSubview:_verifyTextField];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneTextField.frame), CGRectGetMaxY(_verifyTextField.frame) - 0.5f, CGRectGetWidth(_phoneTextField.frame), 0.5f)];
    lineView.backgroundColor = k_LINE_COLOR;
    [_scrollView addSubview:lineView];
    
    //获取验证码按钮
    CGFloat labelWidth = 65.0f;
    CGFloat labelHeight = 30.0f;
//    _phoneTextField = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(_passwordTextField.frame) - labelWidth,CGRectGetMidY(_passwordTextField.frame) - labelHeight * 0.5,labelWidth, labelHeight) Font:k_MIDDLE_TEXT_FONT textColor:k_NAVIGATION_BAR_COLOR];
    
    _verifyButton = [UIKitHelper buttonWithFrame:CGRectMake(CGRectGetMaxX(_verifyTextField.frame) - labelWidth,CGRectGetMidY(_verifyTextField.frame) - labelHeight * 0.5,labelWidth, labelHeight) title:@"获取验证码" titleHexColor:@"FFFFFF" font:k_SMALL_TEXT_FONT];
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
    _commitButton = [UIKitHelper buttonWithFrame:CGRectMake(CGRectGetMinX(_verifyTextField.frame), CGRectGetMaxY(_verifyTextField.frame) + 40.0f, CGRectGetWidth(_phoneTextField.frame), buttonHeight) title:@"提交" titleHexColor:@"FFFFFF" font:k_BIG_TEXT_FONT];
    [_commitButton setBackgroundImage:[UIKitHelper imageWithColor:k_LINE_COLOR] forState:UIControlStateNormal];
    [_commitButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateSelected];
    [_commitButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    _commitButton.userInteractionEnabled = NO;
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _commitButton.layer.cornerRadius =16.0f;
    _commitButton.layer.masksToBounds = YES;
    [_scrollView addSubview:_commitButton];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetMaxY(_commitButton.frame) + 64.0f + k_TOP_MARGIN);
    _contentSize = _scrollView.contentSize;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSString *)mobile
{
    return _phoneTextField.text;
}

- (void)setCode:(NSString *)code
{
    if (_code == code) {
        return;
    }
    _code = [code copy];
    _verifyTextField.text = _code;
}

#pragma mark - 输入框字符改变
- (void)textFieldDidChange:(NSNotification *)notificaiton
{
    if (_phoneTextField.text.length > 0 && _verifyTextField.text.length > 0) {
        _commitButton.userInteractionEnabled = YES;
        _commitButton.selected = YES;
    }else{
        _commitButton.userInteractionEnabled = NO;
        _commitButton.selected = NO;
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


#pragma mark - 获取验证码
- (void)getVerifyCodeAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
        [self.delegate baseView:self actionTag:UUGetVerifyCodeActionTag value:nil];
    }
    [self timerBeginFire];
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
