//
//  UUDatePickerView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/27.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUDatePickerView : UIView
{
    UIDatePicker *_datePicker;
    
    id _target;
    SEL _action;
}


@property (nonatomic) UIDatePickerMode datePickerMode; // default is UIDatePickerModeDateAndTime

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
