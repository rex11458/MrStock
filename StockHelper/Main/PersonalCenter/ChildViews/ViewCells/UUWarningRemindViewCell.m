//
//  UUWarningRemindViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/8/7.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUWarningRemindViewCell.h"

@implementation UUWarningRemindViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = k_BG_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target action:(SEL)action
{
    
    if (self = [self initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _target = target;
        _action = action;
        [self configSubViews];

    }
    return self;
}

- (void)configSubViews
{
    _nameLabel = [UIKitHelper labelWithFrame:CGRectMake(k_LEFT_MARGIN * 2, 0, 200.0f, UUWarningRemindViewCellHeight) Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    [self.contentView addSubview:_nameLabel];
    
    _nameLabel.text = @"汉麻产业(002036)";
    
    UIButton *remindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [remindButton setImage:[UIImage imageNamed:@"fav_remind_selected"] forState:UIControlStateNormal];
    
    remindButton.frame = CGRectMake(PHONE_WIDTH - UUWarningRemindViewCellHeight - k_LEFT_MARGIN, 0, UUWarningRemindViewCellHeight, UUWarningRemindViewCellHeight);
    [remindButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:remindButton];
}

- (void)buttonAction
{
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self afterDelay:0];
    }
}


- (void)drawRect:(CGRect)rect
{
    [[UIKitHelper imageWithColor:[UIColor whiteColor]] drawInRect:CGRectMake(k_LEFT_MARGIN, 0.5f, CGRectGetWidth(rect) - k_LEFT_MARGIN * 2, CGRectGetHeight(rect) - 1.0f)];
}

@end
