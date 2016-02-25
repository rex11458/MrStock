//
//  UURegisterView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"

#define UURegisterButtonActionTag      100
#define UUGetVerifyCodeButtonActionTag 101
@interface UURegisterView : BaseView<UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    CGSize _contentSize;

    UITextField *_phoneTextField;
    UITextField *_verifyTextField;
    
    UITextField *_passwordTextField;
 
    UIButton *_verifyButton;
    UIButton *_registerButton;
    
    
    NSTimer *_timer;                     //定时器
    
    NSTimeInterval _endTime;
}

@property (nonatomic,copy)NSString *code;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic, copy) NSString *password;

- (void)timerBeginFire;

@end
