//
//  UUStockShareView.m
//  StockHelper
//
//  Created by LiuRex on 15/5/13.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockShareView.h"
#import "UUStockTimeEntity.h"
#import "ColorModel.h"
#define STOCK_SHARE_HOR_MARGIN_COUNT 5   //分时线横向间隔数
#define STOCK_SHARE_VER_MARGIN_COUNT 5   //分时线纵向间隔数

#define VOL_MARGIN_COUNT   4   //成交量横向间隔数

//间隔
#define RIGHT_MARGIN  20.0f
#define LEFT_MARGIN   60.0f

//分时线
#define STOCK_SHARE_TOP_MARGIN    10.0f
#define STOCK_SHARE_BOTTOM_MARGIN 20.0f
#define STOCK_SHARE_VOL_MARGIN 0.0f

#define MAIN_BOX_HEIGHT (CGRectGetHeight(self.bounds) - STOCK_SHARE_TOP_MARGIN - STOCK_SHARE_BOTTOM_MARGIN)
#define STOCK_SHARE_HOR_BOX_MARGIN  (MAIN_BOX_HEIGHT / (float)(STOCK_SHARE_HOR_MARGIN_COUNT + VOL_MARGIN_COUNT - 1  - 1))



#define STOCK_SHARE_BOX_WIDTH   (CGRectGetWidth(self.bounds) - LEFT_MARGIN - RIGHT_MARGIN)
#define STOCK_SHARE_BOX_HEIGHT  (STOCK_SHARE_HOR_BOX_MARGIN * (STOCK_SHARE_HOR_MARGIN_COUNT - 1))

#define STOCK_SHARE_VER_BOX_MARGIN  (STOCK_SHARE_BOX_WIDTH / (float)(STOCK_SHARE_VER_MARGIN_COUNT - 1))

//分时线的点总数
#define STOCK_SHARE_POINT_COUNT (60 * 4) //每分钟一个点，共240个


////成交量
#define VOL_BOTTOM_MARGIN 0.0f
#define VOL_TOP_MARGIN   (STOCK_SHARE_BOX_HEIGHT + STOCK_SHARE_TOP_MARGIN)
#define VOL_BOX_WIDTH    STOCK_SHARE_BOX_WIDTH
#define VOL_BOX_MARGIN  STOCK_SHARE_HOR_BOX_MARGIN

#define VOL_BOX_HEIGHT  (STOCK_SHARE_HOR_BOX_MARGIN * (VOL_MARGIN_COUNT - 1))

@interface UUStockShareView ()
{
    NSMutableArray *_leftPriceLabelArray;
    NSMutableArray *_leftVolLabelArray;
    CGFloat _maxValue;
    CGFloat _minValue;
    
    
    CGFloat _maxVol; //当前时间最大成交量
    
    NSMutableArray *_pointArray; //当前 价格
    NSMutableArray *_avePointArray;//平均价格
    
    
    UIView *_moveLineXView; //横向十字线
    UIView *_moveLineYView; //纵向十字线
    UILabel *_currentDateLabel;    //选中的当前时间
    UILabel *_currentPriceLabel;   //选中的当前收盘价
}
@end

@implementation UUStockShareView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _leftPriceLabelArray = [NSMutableArray array];
        _leftVolLabelArray = [NSMutableArray array];
        [self addGesture];
        
        _moveLineXView = [[UIView alloc] initWithFrame:CGRectZero];
        _moveLineXView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_moveLineXView];
        _moveLineYView = [[UIView alloc] initWithFrame:CGRectZero];
        _moveLineYView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_moveLineYView];
        _currentDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _currentDateLabel.textAlignment = NSTextAlignmentCenter;
        _currentDateLabel.backgroundColor = [UIColor grayColor];
        _currentDateLabel.textColor = [UIColor whiteColor];
        _currentDateLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_currentDateLabel];
        _currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _currentPriceLabel.backgroundColor = [UIColor grayColor];
        _currentPriceLabel.textColor = [UIColor whiteColor];
        _currentPriceLabel.font = [UIFont systemFontOfSize:12.0f];
        
        _currentPriceLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_currentPriceLabel];
    }
    return self;
}

- (void)addGesture
{
    //长按
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesAction:)];
    [longPressGes setMinimumPressDuration:0.3f];
    [longPressGes setAllowableMovement:50.0];
    [self addGestureRecognizer:longPressGes];
    
}

- (void)setStockQuoteEntity:(UUStockQuoteEntity *)stockQuoteEntity
{
    if ([stockQuoteEntity isNull] || _stockQuoteEntity == stockQuoteEntity) {
        return;
    }
    _stockQuoteEntity = stockQuoteEntity;
    [self setStockTimeEntityArray:_stockQuoteEntity.stockTimeArray];
}

- (void)setStockTimeEntityArray:(NSArray *)stockTimeEntityArray
{
    if ([stockTimeEntityArray isNull] || _stockTimeEntityArray == stockTimeEntityArray) {
        return;
    }
    _stockTimeEntityArray = stockTimeEntityArray;
    [self getMaxValueAndMinValue];
    [self addLeftPriceLabel];
    [self addDateLabel];
    [self setNeedsDisplay];
}


//- (void)setStockShareModelArray:(UUStockShareModelArray *)stockShareModelArray
//{
//    if ([stockShareModelArray isNull] || _stockShareModelArray == stockShareModelArray) {
//        return;
//    }
//    _stockShareModelArray = stockShareModelArray;
//    [self getMaxValueAndMinValue];
//    [self addLeftPriceLabel];
//    [self addDateLabel];
//    [self setNeedsDisplay];
//}

- (void)drawRect:(CGRect)rect
{
    //－－画图前先清空当前画布
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextClearRect(ref, rect);
    [[UIKitHelper imageWithColor:k_BG_COLOR] drawInRect:rect];
    //    9:30 ~ 15:00  4.5hours * 60 个点
    //画框
    [self drawBox];
    if (_stockTimeEntityArray.count == 0) return;
    //画分时线
    [self drawStockShareLine];
    [self drawAveLine];
    //成交量
    [self drawVol];
}

- (void)drawBox
{
    //－－K线框
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    
    ColorModel *rgb = [UIColorTools RGBWithHexString:@"#A4A5A7" withAlpha:1.0f];
    
    CGContextSetRGBStrokeColor(context, rgb.R / 255.0f, rgb.G / 255.0f, rgb.B / 255.0f, 1.0f);
    for (NSInteger i = 0; i < STOCK_SHARE_HOR_MARGIN_COUNT + VOL_MARGIN_COUNT - 1; i++) {
        CGContextMoveToPoint(context,LEFT_MARGIN, STOCK_SHARE_TOP_MARGIN + i * STOCK_SHARE_HOR_BOX_MARGIN);
        CGContextAddLineToPoint(context,LEFT_MARGIN + STOCK_SHARE_BOX_WIDTH,STOCK_SHARE_TOP_MARGIN + i* STOCK_SHARE_HOR_BOX_MARGIN);
    }
 
    for (NSInteger i = 0; i < STOCK_SHARE_VER_BOX_MARGIN; i++) {
        CGContextMoveToPoint(context,LEFT_MARGIN + i * STOCK_SHARE_VER_BOX_MARGIN, STOCK_SHARE_TOP_MARGIN);
        CGContextAddLineToPoint(context,LEFT_MARGIN + i * STOCK_SHARE_VER_BOX_MARGIN,STOCK_SHARE_TOP_MARGIN + STOCK_SHARE_BOX_HEIGHT + 3 * VOL_BOX_MARGIN);
        
    }

    CGContextStrokePath(context);
}


- (void)drawStockShareLine
{
    _pointArray = [NSMutableArray array];
    NSInteger pointCount = 4 * 60 + 2;
    CGFloat lineWidth = 1;
    CGFloat margin = (STOCK_SHARE_BOX_WIDTH / (CGFloat)pointCount * lineWidth);
    CGFloat startPointY =  [self changePriceToPointY:[(UUStockTimeEntity *)[_stockTimeEntityArray firstObject] price]];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context,LEFT_MARGIN, startPointY);
    [_pointArray addObject:NSStringFromCGPoint(CGPointMake(LEFT_MARGIN, startPointY))];

    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    for (NSInteger i = 1; i < _stockTimeEntityArray.count; i++) {
        CGFloat pointX = LEFT_MARGIN + margin * i;
        CGFloat pointY = [self changePriceToPointY:[(UUStockTimeEntity *)[_stockTimeEntityArray objectAtIndex:i] price]];

        CGContextAddLineToPoint(context,pointX,pointY);
        [_pointArray addObject:NSStringFromCGPoint(CGPointMake(pointX, pointY))];
    }
    CGContextStrokePath(context);
}

- (void)drawAveLine
{
    _avePointArray = [NSMutableArray array];
    NSInteger pointCount = 4 * 60 + 2;
    CGFloat lineWidth = 1;
    CGFloat margin = (STOCK_SHARE_BOX_WIDTH / (CGFloat)pointCount * lineWidth);
    CGFloat startPointY =  [self changePriceToPointY:[(UUStockTimeEntity *)[_stockTimeEntityArray firstObject] avgPrice]];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context,LEFT_MARGIN, startPointY);
    [_pointArray addObject:NSStringFromCGPoint(CGPointMake(LEFT_MARGIN, startPointY))];
    
    CGContextSetRGBStrokeColor(context, 1, 1, 0, 1);
    for (NSInteger i = 0; i < _stockTimeEntityArray.count; i++) {
        CGFloat pointX = LEFT_MARGIN + margin * i;
        CGFloat pointY = [self changePriceToPointY:[(UUStockTimeEntity *)[_stockTimeEntityArray objectAtIndex:i] avgPrice]];
        
        CGContextAddLineToPoint(context,pointX,pointY);
        [_avePointArray addObject:NSStringFromCGPoint(CGPointMake(pointX, pointY))];
    }
    CGContextStrokePath(context);
}



- (void)drawVol
{
    NSInteger pointCount = 4 * 60 + 2;
    CGFloat lineWidth = 1;
    CGFloat margin = (STOCK_SHARE_BOX_WIDTH / (CGFloat)pointCount * lineWidth);
    UUStockTimeEntity *model = [_stockTimeEntityArray firstObject];
    
    CGFloat startPointY = [self changeVolToPointY:model.amount];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);

    if (model.price  > _stockQuoteEntity.preClosePrice)
    {
        CGContextSetRGBStrokeColor(context, 1, 0, 0, 0.8);
    }
    else
    {
        CGContextSetRGBStrokeColor(context, 0, 1, 0, 0.8);
    }
    
    
    CGPoint startPoint = CGPointMake(LEFT_MARGIN, startPointY);
    CGPoint endPoint = CGPointMake(LEFT_MARGIN, VOL_BOX_HEIGHT + VOL_TOP_MARGIN);
    
    const CGPoint points[] = {startPoint,endPoint}; //柱状
    CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）

    
    for (NSInteger i = 0;i < _stockTimeEntityArray.count - 1;i++) {
        UUStockTimeEntity *model1 = [_stockTimeEntityArray objectAtIndex:i];
        UUStockTimeEntity *model2 = [_stockTimeEntityArray objectAtIndex:i + 1];
    
        if (model1.price <= model2.price)
        {
            CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
        }
        else
        {
            CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
        }
        CGPoint startPoint = CGPointMake(LEFT_MARGIN + margin + margin * i, [self changeVolToPointY:model1.amount]);
        CGPoint endPoint = CGPointMake(LEFT_MARGIN + margin + margin *i, VOL_BOX_HEIGHT + VOL_TOP_MARGIN);
        const CGPoint points[] = {startPoint,endPoint}; //柱状
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
        

    }
}

//
- (void)getMaxValueAndMinValue
{
    double maxValue = [(UUStockTimeEntity *)[_stockTimeEntityArray firstObject] price];
    double minValue = maxValue;
    double preClosePrice = _stockQuoteEntity.preClosePrice;
    for (UUStockTimeEntity *timeEntity in _stockTimeEntityArray) {
        if (timeEntity.price > maxValue) {
            maxValue = timeEntity.price;

        }
        
        if (timeEntity.price < minValue) {
            minValue = timeEntity.price;
        }
        if (timeEntity.amount  > _maxVol) {
            _maxVol = timeEntity.amount ;
        }
    }
    CGFloat paddingValue = 0;
    if (fabs(maxValue - preClosePrice) > fabs(minValue - preClosePrice))
    {
        paddingValue = fabs(maxValue - preClosePrice);
        _maxValue = maxValue;
        _minValue = preClosePrice - paddingValue;
    }
    else
    {
        paddingValue = fabs(minValue - preClosePrice);
        _minValue = minValue;
        _maxValue = preClosePrice + paddingValue;
    }
}
//

//添加左侧Label
- (void)addLeftPriceLabel
{
//    //分时线
    for (UIView *view in _leftPriceLabelArray) {
        [view removeFromSuperview];
    }
    
    NSArray *prices = @[
                        [NSString stringWithFormat:@"%.2f",_maxValue],
                        [NSString stringWithFormat:@"%.2f",_stockQuoteEntity.preClosePrice],
                        [NSString stringWithFormat:@"%.2f",_minValue],
                        ];
    NSArray *colors = @[[UIColor redColor],[UIColor blackColor],[UIColor greenColor]];

    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i * STOCK_SHARE_HOR_BOX_MARGIN * 2 + STOCK_SHARE_TOP_MARGIN - 10, LEFT_MARGIN, 20)];
        label.textColor = [colors objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10.0f];
        label.text = [prices objectAtIndex:i];
        [label adjustsFontSizeToFitWidth];
        [self addSubview:label];
        if (i == 2) {
            CGRect frame = label.frame;
            frame.origin.y -= 10;
            label.frame = frame;
        }
        
        [_leftPriceLabelArray addObject:label];
    }
    //成交量
    for (UIView *view in _leftVolLabelArray) {
        [view removeFromSuperview];
    }
    //
    NSInteger volPadding = _maxVol /(double)(VOL_MARGIN_COUNT - 1);
    for (NSInteger i = 0; i < VOL_MARGIN_COUNT; i++) {
        NSString *price = [[NSNumber numberWithInteger:(_maxVol - volPadding * i)] stringValue];
        //        [price drawAtPoint:CGPointMake(0, i * KLINE_BOX_MARGIN + KLINE_TOP_MARGIN - 10) withAttributes:attributes];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i * VOL_BOX_MARGIN + VOL_TOP_MARGIN - 10, LEFT_MARGIN, 20)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10.0f];
        label.text = price;
        [label adjustsFontSizeToFitWidth];
        
        if (i == 0) {
            CGRect frame = label.frame;
            frame.origin.y += 10;
            label.frame = frame;
        }
        if (i != VOL_MARGIN_COUNT - 1)
        {
            [self addSubview:label];
            [_leftVolLabelArray addObject:label];
        }
    }
}

- (void)addDateLabel
{
    NSArray *dateArray = @[@"09:30",@"10:30",@"13:00",@"14:00",@"15:00"];
    for (NSInteger i = 0; i < dateArray.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN + i * STOCK_SHARE_VER_BOX_MARGIN - 25, CGRectGetHeight(self.bounds) - 15,50,20)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10.0f];
        label.text = [dateArray objectAtIndex:i];
        [label adjustsFontSizeToFitWidth];
        [self addSubview:label];
    }

}


//获取到价格所在实际坐标
- (double)changePriceToPointY:(double)price
{
    double priceHeight = _maxValue - _minValue;
    
    if (priceHeight == 0) {
        return 0;
    }
    
    double pointY = (1- (price - _minValue) / priceHeight) * STOCK_SHARE_BOX_HEIGHT + STOCK_SHARE_TOP_MARGIN;
    
    return pointY;
}

//获取到成交量所在实际坐标
- (CGFloat)changeVolToPointY:(CGFloat)price
{
    CGFloat volHeight = _maxVol;
    
    if (volHeight == 0) {
        return 0;
    }
    
    CGFloat pointY = (1- price / volHeight) * VOL_BOX_HEIGHT + VOL_TOP_MARGIN;
    
    return pointY;
}




//
////长按显示十字线
- (void)longPressGesAction:(UIGestureRecognizer *)ges
{
    CGPoint currentPoint = [ges locationInView:ges.view];
    
    if (ges.state == UIGestureRecognizerStateChanged)
    {
        for (int i = 0; i < _pointArray.count; i++) {
            CGPoint point = CGPointFromString([_pointArray objectAtIndex:i]);
            if (fabs(currentPoint.x - point.x) < 1) {

                _moveLineXView.hidden = NO;
                _moveLineYView.hidden = NO;
                _currentDateLabel.hidden = NO;
                _currentPriceLabel.hidden = NO;
                _moveLineXView.frame = CGRectMake(LEFT_MARGIN,point.y, STOCK_SHARE_BOX_WIDTH, 0.5f);
                _moveLineYView.frame = CGRectMake(point.x,STOCK_SHARE_TOP_MARGIN, 0.5F, MAIN_BOX_HEIGHT);
                
                UUStockTimeEntity *shareModel = [_stockTimeEntityArray objectAtIndex:i];
                
                
                _currentPriceLabel.text = [NSString stringWithFormat:@"%.2f",shareModel.price];
                [_currentPriceLabel sizeToFit];
                CGRect frame = _currentPriceLabel.frame;
                if (point.x> STOCK_SHARE_BOX_WIDTH * 0.5 + LEFT_MARGIN)
                {
                    frame.origin.x = LEFT_MARGIN;
                }
                else
                {
                    frame.origin.x = LEFT_MARGIN + STOCK_SHARE_BOX_WIDTH - CGRectGetWidth(frame);
                    
                }
                frame.origin.y = point.y - CGRectGetHeight(frame) * 0.5;
                
                _currentPriceLabel.frame = frame;
                
                _currentDateLabel.text = shareModel.time;
                
                [_currentDateLabel sizeToFit];
                frame = _currentDateLabel.frame;
                frame.origin.x = point.x - CGRectGetWidth(frame) * 0.5;
                frame.origin.y = VOL_BOX_HEIGHT + VOL_TOP_MARGIN + 2.0f;
                _currentDateLabel.frame = frame;
            }
        }
    }
    else if (ges.state == UIGestureRecognizerStateEnded)
    {
        _moveLineXView.hidden = YES;
        _moveLineYView.hidden = YES;
        _currentDateLabel.hidden = YES;
        _currentPriceLabel.hidden = YES;
    }
}

@end
