//
//  UUPersonalChangePasswordView.h
//  StockHelper
//
//  Created by LiuRex on 15/8/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"
#define UUDoneButtonActionTag 100
@interface UUPersonalChangePasswordView : BaseView<UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    CGSize _contentSize;
    
    UITextField *_oldPasswordTextField;
    UITextField *_newPasswordTextField;
    UITextField *_confirmPasswordTextField;

    UIButton *_doneButton;
}

@property (nonatomic,copy) NSString *oldPassword;
@property (nonatomic, copy) NSString *newPassword;


@end
