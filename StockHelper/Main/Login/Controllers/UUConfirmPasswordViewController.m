//
//  UUConfirmPasswordViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUConfirmPasswordViewController.h"
#import "UUConfirmPasswordView.h"
#import "UULoginHandler.h"
#import <SVProgressHUD/SVProgressHUD.h>
@implementation UUConfirmPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"找回密码";
    UUConfirmPasswordView *confirmpwdView = [[UUConfirmPasswordView alloc] initWithFrame:self.view.bounds];
    self.baseView = confirmpwdView;
    _confirmPasswordView = confirmpwdView;
}

#pragma mark - BaseViewDelegate
- (void)baseView:(BaseView *)baseView actionTag:(NSInteger)actionTag value:(id)values
{
    if (actionTag == UUDoneButtonActionTag) {
        [SVProgressHUD showWithStatus:@"正在执行..." maskType:SVProgressHUDMaskTypeBlack];
        [[UULoginHandler sharedLoginHandler] resetPasswordWithMobile:_mobile code:_code newPassword:_confirmPasswordView.newPassword success:^(id obj) {
            [SVProgressHUD dismiss];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
        }];
    }
}
@end
