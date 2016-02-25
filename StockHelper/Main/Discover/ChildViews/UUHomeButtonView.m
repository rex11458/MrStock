//
//  UUHomeButtonView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/21.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUHomeButtonView.h"
#import "UIImage+Compress.h"
@implementation UUHomeButtonView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];

    //    _imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_imageButton];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}


- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
//    _imageView.backgroundColor = 
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    _titleLabel.text = title;
}
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    _titleLabel.textColor = color;
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [_imageButton setImage:image forState:state];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    
    if (controlEvents & UIControlEventTouchUpInside) {
        _target = target;
        _action = action;
    }
}

- (void)buttonAction
{
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self afterDelay:0.0f];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self afterDelay:0.0f];
    }
}

- (void)layoutSubviews
{
    CGFloat precent = 0.65;
    _imageButton.frame = CGRectMake(0, 0, CGRectGetHeight(self.bounds) * precent,  CGRectGetHeight(self.bounds) * precent);
    CGPoint center = _imageButton.center;
    center.x = CGRectGetWidth(self.bounds) * 0.5;
    _imageButton.center = center;
    
    _imageButton.layer.cornerRadius = CGRectGetWidth(_imageButton.frame) * 0.5;
    _imageButton.layer.masksToBounds = YES;
    _titleLabel.frame = CGRectMake(0, CGRectGetMaxY(_imageButton.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) * (1-precent));
}




@end
