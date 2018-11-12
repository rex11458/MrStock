//
//  UULabelView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UULabelView.h"

@implementation UULabelView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _upperLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _upperLabel.adjustsFontSizeToFitWidth = YES;

    _upperLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_upperLabel];

    
    _underLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _underLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_underLabel];
}

- (void)setUpperText:(NSString *)upperText
{
    if(!upperText) return;
    _upperLabel.attributedText = [[NSAttributedString alloc] initWithString:upperText attributes:_upperAttributes];
}

- (void)setUnderText:(NSString *)underText
{
    if(!underText) return;

    _underLabel.attributedText = [[NSAttributedString alloc] initWithString:underText attributes:_underAttributes];
}

- (void)layoutSubviews
{
    _upperLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) * 0.65);
    _underLabel.frame = CGRectMake(0,CGRectGetHeight(self.bounds) * 0.5, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)*0.35);
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents & UIControlEventTouchUpInside) {
        _target = target;
        _action = action;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:self afterDelay:0.0f];
    }else{
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
}

@end
