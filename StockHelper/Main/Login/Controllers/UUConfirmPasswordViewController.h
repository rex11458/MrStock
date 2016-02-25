//
//  UUConfirmPasswordViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/7/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
@class UUConfirmPasswordView;
@interface UUConfirmPasswordViewController : BaseViewController
{
    UUConfirmPasswordView *_confirmPasswordView;
}
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *code;

@end
