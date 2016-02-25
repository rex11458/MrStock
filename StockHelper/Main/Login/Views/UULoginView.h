//
//  UULoginView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
#define UUForgotPasswordActionTag 100
#define UURegisterActionTag       101
#define UULoginActionTag          102
@interface UULoginView : BaseView<UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    CGSize _contentSize;
    UIImageView *_logoImageView;
    UITextField *_userNameTextField;
    UITextField *_passwordTextField;
    UIButton *_loginButton;
    UIButton *_registerButton;
}


@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;


@end
