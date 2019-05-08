//
//  UULoginView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UULoginView.h"
@implementation UULoginView

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
    
    
    CGFloat loginImageHeight = 145.0f;
    //LOGO
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), loginImageHeight)];
    _logoImageView.image = [UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR];
    [_scrollView addSubview:_logoImageView];
    
    CGFloat textFieldWidth = CGRectGetWidth(self.bounds) - 80.0f;
    CGFloat textFieldHeight = 44.0f;
    NSDictionary *placeHolderAtrubites = @{
                                           NSFontAttributeName : k_MIDDLE_TEXT_FONT,
                                           NSForegroundColorAttributeName : k_MIDDLE_TEXT_COLOR
                                           };
    
    //--  用户名
    _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(40.0f, CGRectGetMaxY(_logoImageView.frame) + k_TOP_MARGIN, textFieldWidth, textFieldHeight)];
    _userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString: @"手机号/邮箱/用户名" attributes:placeHolderAtrubites];
//    _userNameTextField.placeholder = @"手机号/邮箱/用户名";
    _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    _userNameTextField.delegate = self;
    _userNameTextField.returnKeyType = UIReturnKeyDone;
    [_scrollView addSubview:_userNameTextField];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_userNameTextField.frame) - 0.5f, CGRectGetWidth(_userNameTextField.frame), 0.5f)];
    lineView.backgroundColor = k_LINE_COLOR;
    [_userNameTextField addSubview:lineView];
    
    UIImageView *userNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,textFieldHeight, textFieldHeight)];
    userNameImageView.image = [UIImage imageNamed:@"Login_username"];
    userNameImageView.contentMode = UIViewContentModeCenter;
    _userNameTextField.leftView = userNameImageView;
    
    //-- 密码
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_userNameTextField.frame), CGRectGetMaxY(_userNameTextField.frame) + k_TOP_MARGIN, textFieldWidth, textFieldHeight)];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString: @"请输入密码" attributes:placeHolderAtrubites];
    _passwordTextField.delegate = self;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_passwordTextField.frame), CGRectGetMaxY(_passwordTextField.frame) - 0.5f, CGRectGetWidth(_userNameTextField.frame), 0.5f)];
    lineView.backgroundColor = k_LINE_COLOR;
    [_scrollView addSubview:lineView];
    [_scrollView addSubview:_passwordTextField];
    
    UIImageView *pwdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,textFieldHeight, textFieldHeight)];
    pwdImageView.image = [UIImage imageNamed:@"Login_password"];
    pwdImageView.contentMode = UIViewContentModeCenter;
    _passwordTextField.leftView = pwdImageView;
    
    //忘记密码
    CGFloat labelWidth = 80.0f;
    CGFloat labelHeight = 20.0f;
    UILabel *forgotLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(_passwordTextField.frame) - labelWidth,CGRectGetMidY(_passwordTextField.frame) - labelHeight * 0.5,labelWidth, labelHeight) Font:k_MIDDLE_TEXT_FONT textColor:k_NAVIGATION_BAR_COLOR];
    forgotLabel.userInteractionEnabled = YES;
    UIGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPasswordAciton)];
    [forgotLabel addGestureRecognizer:tapGes];
    forgotLabel.textAlignment = NSTextAlignmentRight;
    NSDictionary *attributes = @{
                                 NSFontAttributeName : k_MIDDLE_TEXT_FONT,
                                 NSForegroundColorAttributeName : k_NAVIGATION_BAR_COLOR,
                                 NSUnderlineStyleAttributeName : @(1)
                                 };
    forgotLabel.attributedText = [[NSAttributedString alloc] initWithString:@"忘记密码?" attributes:attributes];

    [_scrollView addSubview:forgotLabel];
    
    CGRect frame = _passwordTextField.frame;
    frame.size.width -= labelWidth;
    _passwordTextField.frame = frame;
    
    //--登录按钮
    CGFloat buttonHeight = 44.0f;
    _loginButton = [UIKitHelper buttonWithFrame:CGRectMake(CGRectGetMinX(_userNameTextField.frame), CGRectGetMaxY(_passwordTextField.frame) + 40.0f, CGRectGetWidth(_userNameTextField.frame), buttonHeight) title:@"登录" titleHexColor:@"ffffff" font:k_BIG_TEXT_FONT];
    [_loginButton setBackgroundImage:[UIKitHelper imageWithColor:k_LINE_COLOR] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateSelected];
    _loginButton.userInteractionEnabled = NO;
    [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _loginButton.layer.cornerRadius =16.0f;
    _loginButton.layer.masksToBounds = YES;
    
    
    [_scrollView addSubview:_loginButton];
    
    

    //----
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds),  CGRectGetMaxY(_loginButton.frame) + k_TOP_MARGIN  * 2);
    _contentSize = _scrollView.contentSize;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSString *)mobile
{
    return _userNameTextField.text;
}

- (NSString *)password
{
    return _passwordTextField.text;
}

#pragma mark - 输入框字符改变
- (void)textFieldDidChange:(NSNotification *)notificaiton
{
    if (_userNameTextField.text.length > 0 && _passwordTextField.text.length > 0) {
        _loginButton.userInteractionEnabled = YES;
        _loginButton.selected = YES;
    }else{
        _loginButton.userInteractionEnabled = NO;
        _loginButton.selected = NO;
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

    CGSize contentSize = _scrollView.contentSize;
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

#pragma mark - 登录
- (void)loginAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
        [self.delegate baseView:self actionTag:UULoginActionTag value:nil];
    }
}

#pragma mark - 注册
- (void)registerAction:(UIButton *)buttion
{
    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
        [self.delegate baseView:self actionTag:UURegisterActionTag value:nil];
    }
}

#pragma mark - 忘记密码
- (void)forgotPasswordAciton
{
    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
        [self.delegate baseView:self actionTag:UUForgotPasswordActionTag value:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
