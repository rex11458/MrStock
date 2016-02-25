//
//  UUVirtualTansactionBusinessHeaderView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTansactionBusinessHeaderView.h"
#import "UUDatePickerView.h"
@implementation UUVirtualTansactionBusinessHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = k_BG_COLOR;
        
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

    NSTimeInterval interval = 24 * 60 * 60 * 7; //一周
    NSDate *endDate =  [NSDate date];
    NSTimeInterval interval1970 = endDate.timeIntervalSince1970;
    NSDate * startDate = [[NSDate alloc] initWithTimeIntervalSince1970:interval1970 - interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *startdateString = [dateFormatter stringFromDate:startDate];
    NSString *endDateString = [dateFormatter stringFromDate:endDate];
    

    
    UUDatePickerView *picker = [[UUDatePickerView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, 216.0f) target:self action:@selector(compeletion)];
    [picker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    picker.datePickerMode = UIDatePickerModeDate;
    
    
    CGFloat textFieldHeight = 36.0f;
    CGFloat textFieldWidth = PHONE_WIDTH * 0.31;
    _startDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, k_TOP_MARGIN, textFieldWidth, textFieldHeight)];
    _startDateTextField.layer.borderWidth = 1.0f;
    _startDateTextField.layer.borderColor = k_NAVIGATION_BAR_COLOR.CGColor;
    _startDateTextField.textAlignment = NSTextAlignmentCenter;
    _startDateTextField.textColor = k_MIDDLE_TEXT_COLOR;
    _startDateTextField.font = k_SMALL_TEXT_FONT;
    _startDateTextField.text = @"请选择起始日期";
    _startDateTextField.inputView = picker;
    _startDateTextField.delegate = self;
    
    _startDateTextField.text = startdateString;
    
    [self addSubview:_startDateTextField];
    
    _endDateTextField = [[UITextField alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_startDateTextField.frame) + 26.0f, k_TOP_MARGIN, textFieldWidth, textFieldHeight)];
    _endDateTextField.layer.borderWidth = 1.0f;
    _endDateTextField.layer.borderColor = k_NAVIGATION_BAR_COLOR.CGColor;
    _endDateTextField.textAlignment = NSTextAlignmentCenter;
    _endDateTextField.textColor = k_MIDDLE_TEXT_COLOR;
    _endDateTextField.font = k_SMALL_TEXT_FONT;
    _endDateTextField.delegate = self;
    _endDateTextField.text = @"请选择截止日期";
    _endDateTextField.inputView = picker;
  
    _endDateTextField.text = endDateString;
    [self addSubview:_endDateTextField];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_startDateTextField.frame) + 0.5 * k_LEFT_MARGIN, CGRectGetMidY(_startDateTextField.frame), 16.0f, 1.0f)];
    lineView.backgroundColor = k_BIG_TEXT_COLOR;
    [self addSubview:lineView];
    
    CGFloat buttonWidth = 66.0f;
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(PHONE_WIDTH - buttonWidth - k_RIGHT_MARGIN, CGRectGetMinX(_startDateTextField.frame), buttonWidth, textFieldHeight);
    [searchButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateNormal];
    [searchButton setTitle:@"查询" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchButton.titleLabel.font = k_MIDDLE_TEXT_FONT;
    searchButton.layer.cornerRadius = 5.0f;
    searchButton.layer.masksToBounds = YES;
    [searchButton addTarget:_target action:_action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchButton];
}

- (void)compeletion
{
    [self endEditing:YES];
}

- (NSString *)sartDate
{
    return _startDateTextField.text;
}
- (NSString *)endDate
{
    return _endDateTextField.text;
}

#pragma mark - datePickerValueChanged
- (void)datePickerValueChanged:(UIDatePicker *)pickerView
{
    if (_currentTextField) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        _currentTextField.text = [dateFormatter stringFromDate:pickerView.date];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    return YES;
}

@end
