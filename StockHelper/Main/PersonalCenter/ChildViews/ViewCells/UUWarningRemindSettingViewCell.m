//
//  UUWarningRemindSettingViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/8/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUWarningRemindSettingViewCell.h"
#import <Masonry/Masonry.h>
@implementation UUWarningRemindSettingViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _textLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    [self.contentView addSubview:_textLabel];

    
    _switch = UISwitch.new;
    [self.contentView addSubview:_switch];

    _textField = [UITextField new];
    _textField.layer.borderWidth = 0.5f;
    _textField.layer.borderColor = k_LINE_COLOR.CGColor;
    [self.contentView addSubview:_textField];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, UUWarningRemindSettingViewCellHeight));
        make.leftMargin.mas_equalTo(@(30));
    }];
    
    
    [_switch mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-30);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_textLabel.mas_right).with.offset(10);
        make.right.mas_equalTo(_switch.mas_left).with.offset(-10);
        make.height.mas_equalTo(30.0f);
    }];
//

    UIView *line = UIView.new;
    line.backgroundColor = k_LINE_COLOR;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-0.5);
    }];
}

- (void)setTitle:(NSString *)title price:(NSString *)price remind:(BOOL)remind
{
    _textLabel.text = title;
    _textField.text = price;
    _switch.on = remind;
}

- (NSString *)price
{
    return _textField.text;
}

- (void)setHiddenTextField:(BOOL)hiddenTextField
{
    _hiddenTextField = hiddenTextField;
    _textField.hidden = hiddenTextField;
}

@end
