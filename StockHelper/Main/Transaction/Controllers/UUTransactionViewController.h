//
//  UUTransactionViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UUTransactionLogoutView.h"
#import "UUVirtualTransactionView.h"

@interface UUTransactionViewController : BaseViewController<UUVirtualTransactionViewDelegate>
{
    UUTransactionLogoutView *_logoutView;
    UUVirtualTransactionView *_transactionView;

}
@end
