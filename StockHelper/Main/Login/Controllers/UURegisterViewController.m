//
//  UURegisterViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UURegisterViewController.h"
#import "UUFillPersonalInfoViewController.h"
#import "UURegisterView.h"
#import "UULoginHandler.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation UURegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
    UURegisterView *registerView = [[UURegisterView alloc] initWithFrame:self.view.bounds];
    self.baseView = registerView;
    _registerView = registerView;
}



#pragma mark - BaseViewDelegate
- (void)baseView:(BaseView *)baseView actionTag:(NSInteger)actionTag value:(id)values
{
    [_registerView endEditing:YES];
    if (actionTag == UURegisterButtonActionTag)
    {
        //验证验证码
        [SVProgressHUD showWithStatus:@"验证验证码" maskType:SVProgressHUDMaskTypeBlack];

        [[UULoginHandler sharedLoginHandler] authenticationWithMobile:_registerView.mobile code:_registerView.code success:^(id obj) {
            UUFillPersonalInfoViewController *fillPersonalInfoVC = [[UUFillPersonalInfoViewController alloc] init];
            fillPersonalInfoVC.mobile = _registerView.mobile;
            fillPersonalInfoVC.password = _registerView.password;
            fillPersonalInfoVC.code = _registerView.code;
            fillPersonalInfoVC.registerType = self.registerType;
            [self.navigationController pushViewController:fillPersonalInfoVC animated:YES];
            [SVProgressHUD dismiss];
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }];
    }
    else if (actionTag == UUGetVerifyCodeButtonActionTag)
    {
        //获取验证码
        [SVProgressHUD showWithStatus:@"获取验证码" maskType:SVProgressHUDMaskTypeBlack];
        
        [[UULoginHandler sharedLoginHandler] getCodeWithMobile:values success:^(NSString *code) {
           
            [_registerView timerBeginFire];
            _registerView.code = code;
            [SVProgressHUD showSuccessWithStatus:@"获取成功!"];
        
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }];
    }
}

@end
