//
//  UUConfirmPasswordView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
#define UUDoneButtonActionTag 100
@interface UUConfirmPasswordView : BaseView<UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    CGSize _contentSize;
    
    UITextField *_passwordTextField;
    UITextField *_confirmPasswordTextField;
    UIButton *_doneButton;
}

@property (nonatomic, copy) NSString *newPassword;


@end
