//
//  UUPersonalPushSettingViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/8/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalPushSettingViewCell.h"

@implementation UUPersonalPushSettingViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target action:(SEL)action
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _target = target;
        _action = action;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _textLabel = [UIKitHelper labelWithFrame:CGRectMake(3 * k_LEFT_MARGIN, 0, 200.0f, UUPersonalPushSettingViewCellHeight) Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    [self.contentView addSubview:_textLabel];
    _textLabel.numberOfLines = 2;
    _control = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_control addTarget:_target action:_action forControlEvents:UIControlEventValueChanged];
    _control.center = CGPointMake(PHONE_WIDTH - 50.0f, UUPersonalPushSettingViewCellHeight * 0.5);
    [self.contentView addSubview:_control];
}


- (void)setValues:(NSDictionary *)values
{
    if (values == nil || _values == values) {
        return;
    }
    _values = values;
    
    NSString *text = [values valueForKey:k_TITLE];
    NSString *subText = [values valueForKey:k_SUB_TITLE];
    if (subText.length > 0)
    {
        NSString *value = [NSString stringWithFormat:@"%@\n%@",text,subText];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:value];
        
        NSRange range = [value rangeOfString:@"\n"];
        
        if (range.location != NSNotFound) {
            [attributedString setAttributes:@{NSFontAttributeName :k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:k_MIDDLE_TEXT_COLOR} range:NSMakeRange(range.location + 1, value.length - range.location - 1)];
        }
        _textLabel.attributedText = attributedString;
    }
    else
    {
        _textLabel.text = text;
    }

    _control.on = [[values valueForKey:k_SETTING_VALUE] boolValue];
}

@end
