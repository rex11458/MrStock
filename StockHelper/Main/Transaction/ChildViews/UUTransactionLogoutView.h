//
//  UUTransactionLogoutView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseView.h"

@interface UUTransactionLogoutView : BaseView
{
    UIButton *_loginButton;
    void(^_login)(void);

}

- (id)initWithFrame:(CGRect)frame login:(void(^)(void))login;
@end
