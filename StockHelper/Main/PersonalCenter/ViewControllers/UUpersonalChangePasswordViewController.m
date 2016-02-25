//
//  UUpersonalChangePasswordViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUpersonalChangePasswordViewController.h"
#import "UUPersonalChangePasswordView.h"
#import "UULoginHandler.h"
@interface UUpersonalChangePasswordViewController ()
{
    UUPersonalChangePasswordView *_changePasswordView;
}
@end

@implementation UUpersonalChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    
    _changePasswordView = [[UUPersonalChangePasswordView alloc] initWithFrame:self.view.bounds];
    
    self.baseView = _changePasswordView;;

}

#pragma mark - BaseViewDelegate
- (void)baseView:(BaseView *)baseView actionTag:(NSInteger)actionTag value:(id)values
{
    [_changePasswordView endEditing:YES];
    if (actionTag == UUDoneButtonActionTag) {
        [SVProgressHUD showWithStatus:@"正在执行..." maskType:SVProgressHUDMaskTypeBlack];
        [[UULoginHandler sharedLoginHandler] changePasswordWithOldPassword:_changePasswordView.oldPassword newPassword:_changePasswordView.newPassword success:^(id obj) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *errorMessage) {
           
            [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
            
        }];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
