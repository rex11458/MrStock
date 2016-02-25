//
//  UUPersonalPushSettingViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/8/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUPersonalPushSettingViewCellHeight 70.0f
#define k_TITLE @"title"
#define k_SUB_TITLE @"subTitle"
#define k_SETTING_VALUE @"settingValue"
@interface UUPersonalPushSettingViewCell : BaseViewCell
{
    UILabel *_textLabel;
    UISwitch *_control;
    
    id _target;
    SEL _action;
}
@property (nonatomic,strong) NSDictionary *values;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target action:(SEL)action;

@end
