 //
//  UULoginViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/6/1.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UULoginViewController.h"
#import "UULoginView.h"
#import "UULoginHandler.h"
#import "UUForgotPasswordViewController.h"
#import "UURegisterViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UUDatabaseManager.h"
#import "UUFavourisStockModel.h"
#import "UUStockModel.h"
@interface UULoginViewController ()
{
    UULoginView *_loginView;
}
@end

@implementation UULoginViewController

- (id)initWithIndex:(NSInteger)index success:(void(^)(void))success failed:(void(^)(void))failed
{
    if (self = [super init]) {
        self.index = index;
        _success = success;
        _failed = failed;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    
    [self configSubViews];
}


- (void)configSubViews
{
    _loginView  = [[UULoginView alloc] initWithFrame:self.view.bounds];
    self.baseView = _loginView;
}

#pragma mark - BaseViewDelegate
- (void)baseView:(BaseView *)baseView actionTag:(NSInteger)actionTag value:(id)values
{
    [_loginView endEditing:YES];
    
    if (actionTag == UUForgotPasswordActionTag)
    {
        //忘记密码
        UUForgotPasswordViewController *forgetPwdVC = [[UUForgotPasswordViewController alloc] init];
        [self.navigationController pushViewController: forgetPwdVC animated:YES];
    }
    else if (actionTag == UURegisterActionTag)
    {
        //注册
        UURegisterViewController *registerVC = [[UURegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
    else if(actionTag == UULoginActionTag)
    {
        [self loginWithMobile:_loginView.mobile password:_loginView.password];
    }
}

- (void)loginWithMobile:(NSString *)mobile password:(NSString *)password
{
    [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeBlack];
    
    [[UULoginHandler sharedLoginHandler] loginWithMobile:mobile password:password success:^(NSString *sessionId) {

        //获取个人资料
//        [SVProgressHUD setStatus:@"正在获取个人资料..."];
        [[UULoginHandler sharedLoginHandler] getUserInfoWithSessionId:sessionId success:^(id obj) {
            [SVProgressHUD dismiss];
            [self loginSuccessPopViewController];
            
            if (_success) {
                _success();
            }
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
            _successed = NO;
        }];
        
    } failure:^(NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];

        _successed = NO;
        
    }];
}

- (void)loginSuccessPopViewController
{
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:_index];
    [self.navigationController popToViewController:vc animated:YES];
}


- (void)backAction
{
    
    if (_failed)
    {
        _failed();
    }
    [super backAction];
}


@end
