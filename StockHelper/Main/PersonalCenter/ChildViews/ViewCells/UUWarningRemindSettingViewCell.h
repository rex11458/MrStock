//
//  UUWarningRemindSettingViewCell.h
//  StockHelper
//
//  Created by LiuRex on 15/8/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UUWarningRemindSettingViewCellHeight 70.0f

@interface UUWarningRemindSettingViewCell : UITableViewCell
{
    UILabel *_textLabel;
    UISwitch *_switch;
    UITextField *_textField;
}

@property (nonatomic) BOOL hiddenTextField;

@property (nonatomic,copy) NSString *price;

@property (nonatomic,assign,getter=isRemind) BOOL remind;

- (void)setTitle:(NSString *)title price:(NSString *)price remind:(BOOL)remind;

@end
