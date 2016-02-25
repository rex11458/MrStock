//
//  UUForgotPasswordViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUForgotPasswordViewController.h"
#import "UUConfirmPasswordViewController.h"
#import "UUForgotPasswordView.h"
#import "UULoginHandler.h"
#import <SVProgressHUD/SVProgressHUD.h>
@implementation UUForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"找回密码";
    UUForgotPasswordView *forgotPasswordView = [[UUForgotPasswordView alloc] initWithFrame:self.view.bounds];
    self.baseView = forgotPasswordView;
    _forgotPasswordView = forgotPasswordView;
}


#pragma mark - BaseViewDelegate
- (void)baseView:(BaseView *)baseView actionTag:(NSInteger)actionTag value:(id)values
{
    if(actionTag == UUGetVerifyCodeActionTag )
    {
        //获取验证码
        [SVProgressHUD showWithStatus:@"获取验证码..." maskType:SVProgressHUDMaskTypeBlack];
        [[UULoginHandler sharedLoginHandler] recoverPasswordGetVerifyCodeWithMobile:_forgotPasswordView.mobile success:^(NSString *code) {
            _forgotPasswordView.code = code;
            [SVProgressHUD dismiss];
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
        }];
    }
    if (actionTag == UUCommitButtionActionTag)
    {
        [SVProgressHUD showWithStatus:@"正在验证..." maskType:SVProgressHUDMaskTypeBlack];
        
        [[UULoginHandler sharedLoginHandler] recoverPasswordauthenticationWithMobile:_forgotPasswordView.mobile code:_forgotPasswordView.code success:^(id obj) {
            UUConfirmPasswordViewController *confirmPwdVC = [[UUConfirmPasswordViewController alloc] init];
            confirmPwdVC.mobile = _forgotPasswordView.mobile;
            confirmPwdVC.code = _forgotPasswordView.code;
            [self.navigationController pushViewController:confirmPwdVC animated:YES];
            [SVProgressHUD dismiss];
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
        }];
 
        
    }
}
@end
