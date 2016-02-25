//
//  UUHomeButtonView.h
//  StockHelper
//
//  Created by LiuRex on 15/7/21.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUHomeButtonView : UIView

@property (nonatomic) id target;
@property (nonatomic) SEL action;

@property (nonatomic,strong,readonly) UIButton *imageButton;
@property (nonatomic,strong,readonly) UILabel *titleLabel;


- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;



@end
