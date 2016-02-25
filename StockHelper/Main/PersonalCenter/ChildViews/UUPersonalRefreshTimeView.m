//
//  UUPersonalRefreshTimeView.m
//  StockHelper
//
//  Created by LiuRex on 15/8/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalRefreshTimeView.h"

@implementation UUPersonalRefreshTimeView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = k_BG_COLOR;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    UILabel *label = [UIKitHelper labelWithFrame:CGRectMake(40.0f, 40.0f, 200.0f, 30.0f) Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    label.text = @"行情刷新时间设置";
    [self addSubview:label];
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 126.0f, PHONE_WIDTH - 80, 40.0f)];
    _slider.minimumTrackTintColor = k_NAVIGATION_BAR_COLOR;
    _slider.maximumTrackTintColor = k_LINE_COLOR;
    _slider.maximumValue = 100.0f;
    _slider.minimumValue = 1.0f;
    [self addSubview:_slider];
    [_slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _bubbleView = [[UUBubbleView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_slider.frame), CGRectGetMinY(_slider.frame) - 35.0f, 68.0f, 35.0f)];
    _bubbleView.value = self.seconds;
    CGPoint center = _bubbleView.center;
    center.x = CGRectGetMinX(_slider.frame) + 15.0f;
    _bubbleView.center = center;
    [self addSubview:_bubbleView];
}

- (void)setSeconds:(NSInteger)seconds
{
    _seconds = seconds;
    _bubbleView.value = _seconds;
    CGFloat value = (seconds - 5) * 100 / 15.0f;
    
    [_slider setValue:value animated:YES];
    
    CGPoint center = _bubbleView.center;
    CGFloat valueX =  CGRectGetMinX(_slider.frame) + 15.0f + _slider.value * ((CGRectGetWidth(_slider.frame) - 30.0f) / 100.0f);
    center.x = valueX;
    _bubbleView.center = center;
}

- (void)valueChanged:(UISlider *)slider
{
    NSInteger seconds = slider.value/100.0f * 15 + 5;
    
    CGPoint center = _bubbleView.center;
    CGFloat valueX =  CGRectGetMinX(_slider.frame) + 15.0f + slider.value * ((CGRectGetWidth(slider.frame) - 30.0f) / 100.0f);
    center.x = valueX;
    _bubbleView.center = center;
    _bubbleView.value = seconds;
    self.seconds = seconds;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //－－画图前先清空当前画布
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextClearRect(ref, rect);
    
    [[UIKitHelper imageWithColor:k_BG_COLOR] drawInRect:rect];
    
    NSArray *titles = @[@"5秒",@"10秒",@"15秒",@"20秒"];
    
    NSInteger lineCount = titles.count - 1;
    CGFloat startX = 40.0f;
    CGFloat Y = CGRectGetMidY(_slider.frame);
    CGFloat width = CGRectGetWidth(_slider.frame)/(CGFloat)lineCount;

    CGFloat lengthValueX = startX + _slider.value * CGRectGetWidth(_slider.frame)/100.0f;
    
    
    for (NSInteger i = 0; i <= lineCount; i++) {
        if (i == 0) {
            startX += 3;
        }else if (i == lineCount){
            startX -= 6;
        }
        
        CGFloat X = startX + width * i ;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0f);
        UIColor *color;
        
        if (X <= lengthValueX + 15)
        {
            color = k_NAVIGATION_BAR_COLOR;
        }
        else
        {
            color = k_LINE_COLOR;
        }
        
        if ( i == lineCount) {
            if (X < lengthValueX) {
                color = k_NAVIGATION_BAR_COLOR;
            }else{
                color = k_LINE_COLOR;
            }
        }
        
        CGContextSetStrokeColorWithColor(context, color.CGColor);

        CGContextMoveToPoint(context, X, Y);
        CGContextAddLineToPoint(context, X, Y+ k_TOP_MARGIN * 0.5);
        CGContextStrokePath(context);
        
        
        [titles[i] drawInRect:CGRectMake(X - 10.0f, Y + k_TOP_MARGIN, 40.0f, 20.0f) withAttributes:@{NSFontAttributeName : k_SMALL_TEXT_FONT,NSForegroundColorAttributeName: color}];
    }
}

@end

@interface UUBubbleView()
{
    UILabel *_textLabel;
}
@end

@implementation UUBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        _textLabel = [UIKitHelper labelWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) * 0.8) Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setValue:(NSInteger )value
{
    _value = value;
    
    NSString *seconds = [NSString stringWithFormat:@"%ld",_value];
    
    NSString *text = [NSString stringWithFormat:@"%@秒",seconds];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRange range = [text rangeOfString:seconds];
    [attString setAttributes:@{NSFontAttributeName:k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_NAVIGATION_BAR_COLOR} range:range];
    _textLabel.attributedText = attString;
}

- (void)drawRect:(CGRect)rect
{
    [[UIKitHelper imageWithColor:k_BG_COLOR] drawInRect:rect];
    
    CGFloat SQUARE_LENGTH = CGRectGetHeight(rect) * 0.8;
    CGFloat TRIANGLE_LENGTH = CGRectGetHeight(rect) * 0.2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGLineJoin join = kCGLineJoinRound;
    CGContextSetLineJoin(context, join);
    //2.绘制路径（相当于前面创建路径并添加路径到图形上下文两步操作）
    CGContextMoveToPoint(context, 0.5f,0.5f);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - 1.0f, 0.5f);
    CGContextAddLineToPoint(context,  CGRectGetWidth(rect) - 1.0f,SQUARE_LENGTH);
    CGContextAddLineToPoint(context,  CGRectGetWidth(rect) * 0.5 + TRIANGLE_LENGTH,SQUARE_LENGTH);
    CGContextAddLineToPoint(context,CGRectGetWidth(rect) * 0.5,CGRectGetHeight(rect) - 1.0f);
    CGContextAddLineToPoint(context,  CGRectGetWidth(rect) * 0.5 - TRIANGLE_LENGTH,SQUARE_LENGTH);
    CGContextAddLineToPoint(context, 0.5f , SQUARE_LENGTH);
    
    //封闭路径:a.创建一条起点和终点的线,不推荐
    //CGPathAddLineToPoint(path, nil, 20, 50);
    //封闭路径:b.直接调用路径封闭方法
    CGContextClosePath(context);
    
    //3.设置图形上下文属性
    [k_NAVIGATION_BAR_COLOR setStroke];//设置边框颜色
    [[UIColor whiteColor] setFill];//设置填充颜色
    //[[UIColor blueColor]set];//同时设置填充和边框色
    
    //4.绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
