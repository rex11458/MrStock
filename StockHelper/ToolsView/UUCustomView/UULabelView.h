//
//  UULabelView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UULabelView : UIView
{
    id  _target;
    SEL _action;
    
    UILabel *_upperLabel;
    UILabel *_underLabel;
}

@property (nonatomic,strong) NSDictionary *upperAttributes;
@property (nonatomic, copy) NSString *upperText;

@property (nonatomic,strong) NSDictionary *underAttributes;
@property (nonatomic, copy) NSString *underText;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
