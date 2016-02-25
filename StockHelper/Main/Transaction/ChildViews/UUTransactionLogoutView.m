//
//  UUTransactionLogoutView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTransactionLogoutView.h"

@implementation UUTransactionLogoutView

- (id)initWithFrame:(CGRect)frame login:(void(^)(void))login
{
    if (self = [super initWithFrame:frame]) {
        _login = login;
        self.backgroundColor = k_BG_COLOR;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _loginButton = [UIKitHelper buttonWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 8*k_LEFT_MARGIN, 40.0f) title:@"登录" titleHexColor:@"#ffffff" font:k_BIG_TEXT_FONT];
    _loginButton.layer.cornerRadius = 40 * 0.5;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginButton];
    
}

- (void)layoutSubviews
{
    _loginButton.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
}

#pragma mark - loginAction
- (void)loginAction:(UIButton *)button
{
    if (_login) {
        _login();
    }
}
@end
