//
//  UUVirtualTansactionBusinessHeaderView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUVirtualTansactionBusinessHeaderViewHieght 68.0f
@interface UUVirtualTansactionBusinessHeaderView : UIView<UITextFieldDelegate>
{
    UITextField *_currentTextField;
    UITextField *_startDateTextField;
    UITextField *_endDateTextField;
    
    id _target;
    SEL _action;
}

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

- (NSString *)sartDate;
- (NSString *)endDate;

@end
