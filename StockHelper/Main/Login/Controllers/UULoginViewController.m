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
#import <ShareSDK/ShareSDK.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UUMarketQuationHandler.h"
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


//- (void)loginAction
//{
//    //微博登录
//    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//
//    }];
//    //qq登录
////    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
////
////        NSLog(@"userInfo = %@",[userInfo nickname]);
////        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[userInfo profileImage]]];
////        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
////        [self.view addSubview:imageView];
////        imageView.center = CGPointMake(PHONE_WIDTH * 0.5, PHONE_HEIGHT * 0.5);
////    }];
//}

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
            //同步自选股列表
//            [SVProgressHUD setStatus:@"同步自选股信息..."];
//            [[UUMarketQuationHandler sharedMarkeQuationHandler] getFavourisStockListSuccess:^(NSArray *favStockModelArray) {
//                _successed = YES;
//
//                for (UUFavourisStockModel *favStockModel in favStockModelArray) {
//                    UUStockModel *stockModel = nil;
//                    if (favStockModel.code.length > 6) {
//                        //指数
//                        stockModel = [[UUDatabaseManager manager] selectStockModelWithCode:[favStockModel.code substringToIndex:6] market:UUStockExchangeIDXType];
//                        favStockModel.code = [favStockModel.code substringToIndex:6];
//                    }else{
//                        //个股
//                        stockModel = [[UUDatabaseManager manager] selectStockModelWithCode:favStockModel.code market:UUStockExchangeAShareType];
//                    }
//                    favStockModel.name = stockModel.name;
//                    favStockModel.market = stockModel.market;
//                }
//                BOOL updateSuccess = [[UUDatabaseManager manager] addFavourisList:favStockModelArray];
//
//                if (updateSuccess)
//                {
//                    [[UUDatabaseManager manager] favoriousList:^(NSArray *localFavsStockModelArray) {
//                        if (localFavsStockModelArray.count > 0) {
//                            NSMutableArray *codes = [NSMutableArray array];
//                            for (UUFavourisStockModel *stockModel in localFavsStockModelArray) {
//
//                                NSString *code = stockModel.code;
//                                if (k_IS_INDEX(stockModel.market)) {
//                                    code = [code stringByAppendingString:@".INX"];
//                                }
//                                [codes addObject:stockModel.code];
//                            }
//                            NSString *codeString = [NSString jsonStringWithArray:codes];
//                            codeString = [codeString stringByReplacingOccurrencesOfString:@"[" withString:@""];
//                            codeString = [codeString stringByReplacingOccurrencesOfString:@"]" withString:@""];
//
//                            [[UUMarketQuationHandler sharedMarkeQuationHandler] addFavourisStockWithCodes:codeString pos:0 success:^(id obj) {
//
//                            } failue:^(NSString *errorMessage) {
//
//                            }];
//                        }
//                    }];
//                }
//                else
//                {
////                    [SVProgressHUD showErrorWithStatus:@"自选股同步失败"];
//                }
//
//            } failue:^(NSString *errorMessage) {
////                [SVProgressHUD showErrorWithStatus:@"自选股同步失败"];
//                [SVProgressHUD dismiss];
//                //登录成功返回
//                _successed = YES;
//                if (_success) {
//                    _success();
//                }
//                [self loginSuccessPopViewController];
//            }];
            
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
