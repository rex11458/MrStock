//
//  UUDatePickerView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/27.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUDatePickerView.h"

@implementation UUDatePickerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    if (self = [self initWithFrame:frame]) {
        _target = target;
        _action = action;
        [self configSubViews];
    }
    return self;
}


- (void)configSubViews
{
    UIButton *button = [UIKitHelper buttonWithFrame:CGRectMake(PHONE_WIDTH - 70.0f, k_TOP_MARGIN * 0.5, 60.0f, 30.0f) title:@"完成" titleHexColor:@"#ffffff" font:k_MIDDLE_TEXT_FONT];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    [button addTarget:_target action:_action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateNormal];
    [self addSubview:button];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    _datePicker.frame = CGRectMake(0, CGRectGetMaxY(button.frame), PHONE_WIDTH, 216.0f - 30.0f);

    NSDate *nowDate = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:nowDate];
    
    nowDate = [nowDate dateByAddingTimeInterval:interval];
    
    _datePicker.maximumDate = nowDate;

    [self addSubview:_datePicker];
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    _datePickerMode = datePickerMode;
    _datePicker.datePickerMode = _datePickerMode;
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_datePicker addTarget:target action:action forControlEvents:controlEvents];
}

@end
