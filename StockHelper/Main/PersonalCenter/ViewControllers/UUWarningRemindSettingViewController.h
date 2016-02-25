//
//  UUWarningRemindSettingViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/8/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.

//  预警提醒设置
#import "BaseViewController.h"
#define UUWarningRemindSettingHeaderViewHeight 72.0f
@interface UUWarningRemindSettingHeaderView : UIView
{
    UILabel *_nameLabel;
    UILabel *_codeLabel;
    UILabel *_priceLabel;
    UILabel *_raiseRateLabel;
    UILabel *_raiseCountLabel;
}
@end


@interface UUWarningRemindSettingViewController : BaseViewController

@end
