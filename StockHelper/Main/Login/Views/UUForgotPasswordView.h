//
//  UUForgotPasswrodView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
#define UUCommitButtionActionTag 100
#define UUGetVerifyCodeActionTag 101
@interface UUForgotPasswordView : BaseView<UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    CGSize _contentSize;

    UITextField *_phoneTextField;
    UITextField *_verifyTextField;
    UIButton *_verifyButton;
    UIButton *_commitButton;
    
    
    NSTimer *_timer;                     //定时器
    
    NSTimeInterval _endTime;

}


@property (nonatomic,copy) NSString *mobile;

@property (nonatomic, copy) NSString *code;



@end
