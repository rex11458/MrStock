//
//  UURegisterViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
@class UURegisterView;
@interface UURegisterViewController : BaseViewController
{
    UURegisterView *_registerView;
}

//registerType = 1 从引导页进入注册页面   ，0 从登陆页进入注册页面
@property (nonatomic,assign) NSInteger registerType;

@end
