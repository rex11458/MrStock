//
//  UUStockShareTimeView.m
//  StockHelper
//
//  Created by LiuRex on 15/8/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockShareTimeView.h"
#import "UUStockTimeEntity.h"
#import "ColorModel.h"
#define STOCK_SHARE_HOR_MARGIN_COUNT 5   //分时线横向间隔数
#define STOCK_SHARE_VER_MARGIN_COUNT 5   //分时线纵向间隔数

#define VOL_MARGIN_COUNT   4   //成交量横向间隔数

//间隔
#define RIGHT_MARGIN  (self.type?40:0)
#define LEFT_MARGIN   40.0f

//分时线
#define STOCK_SHARE_TOP_MARGIN    20.0f
#define STOCK_SHARE_BOTTOM_MARGIN (CGRectGetHeight(self.bounds) *0.3)
#define STOCK_SHARE_VOL_MARGIN 16.0f

#define MAIN_BOX_HEIGHT CGRectGetHeight(_lineBoxView.frame)
#define STOCK_SHARE_HOR_BOX_MARGIN  (MAIN_BOX_HEIGHT / (float)(STOCK_SHARE_HOR_MARGIN_COUNT - 1))


#define STOCK_SHARE_BOX_WIDTH   (CGRectGetWidth(self.bounds) - LEFT_MARGIN - RIGHT_MARGIN)
#define STOCK_SHARE_BOX_HEIGHT  (CGRectGetHeight(self.bounds) * 0.7 - STOCK_SHARE_TOP_MARGIN)

#define STOCK_SHARE_VER_BOX_MARGIN  (STOCK_SHARE_BOX_WIDTH / (float)(STOCK_SHARE_VER_MARGIN_COUNT - 1))

//分时线的点总数
#define STOCK_SHARE_POINT_COUNT (60 * 4) //每分钟一个点，共240个

////成交量
#define VOL_BOTTOM_MARGIN 0.0f
#define VOL_TOP_MARGIN   (STOCK_SHARE_BOX_HEIGHT + STOCK_SHARE_TOP_MARGIN + STOCK_SHARE_VOL_MARGIN)
#define VOL_BOX_WIDTH    STOCK_SHARE_BOX_WIDTH
#define VOL_BOX_MARGIN  STOCK_SHARE_HOR_BOX_MARGIN

#define VOL_BOX_HEIGHT  (CGRectGetHeight(self.bounds) * 0.3 - STOCK_SHARE_VOL_MARGIN)

@interface UUStockShareTimeView ()
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

@implementation UUStockShareTimeView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)configSubViews
{
    _leftPriceLabelArray = [NSMutableArray array];
    _leftVolLabelArray = [NSMutableArray array];
    [self addGesture];
    
    _moveLineXView = [[UIView alloc] initWithFrame:CGRectZero];
    _moveLineXView.backgroundColor = [UIColor blackColor];
    [self addSubview:_moveLineXView];
    _moveLineYView = [[UIView alloc] initWithFrame:CGRectZero];
    _moveLineYView.backgroundColor = [UIColor blackColor];
    [self addSubview:_moveLineYView];
    _currentDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _currentDateLabel.textAlignment = NSTextAlignmentCenter;
    _currentDateLabel.backgroundColor = [UIColor blackColor];
    _currentDateLabel.textColor = [UIColor whiteColor];
    _currentDateLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_currentDateLabel];
    _currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _currentPriceLabel.backgroundColor = [UIColor blackColor];
    _currentPriceLabel.textColor = [UIColor whiteColor];
    _currentPriceLabel.font = [UIFont systemFontOfSize:12.0f];
    
    _currentPriceLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_currentPriceLabel];
}

#define k_border_color [UIColorTools colorWithHexString:@"#A4A5A7" withAlpha:1.0f].CGColor
- (void)awakeFromNib
{
    _volBoxView.layer.borderWidth = 0.5f;
    _volBoxView.layer.borderColor = k_border_color;
    [self configSubViews];
}

- (void)addGesture
{
    
    //长按
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesAction:)];
    [longPressGes setMinimumPressDuration:0.3f];
    [longPressGes setAllowableMovement:50.0];
    [self addGestureRecognizer:longPressGes];
    
}

- (void)setType:(NSInteger)type
{
    _type = type;
    self.userInteractionEnabled = _type;
    if (_type == 0)
    {
        _lineBGViewConstraint.constant = 0;
    }
    else
    {
        _lineBGViewConstraint.constant = 40;
    }
}

- (void)setStockQuoteEntity:(UUStockQuoteEntity *)stockQuoteEntity
{
    if (stockQuoteEntity == nil || _stockQuoteEntity == stockQuoteEntity) {
        return;
    }
    _stockQuoteEntity = stockQuoteEntity;
    
    _dateLabel.text = _stockQuoteEntity.date;
    
    [self setStockTimeEntityArray:_stockQuoteEntity.stockTimeArray];
}

- (void)setStockTimeEntityArray:(NSArray *)stockTimeEntityArray
{
    if (stockTimeEntityArray == nil || _stockTimeEntityArray == stockTimeEntityArray) {
        return;
    }
    _stockTimeEntityArray = stockTimeEntityArray;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取最大最小值
        [self getMaxValueAndMinValue];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    });
}

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
    for (NSInteger i = 0; i < STOCK_SHARE_HOR_MARGIN_COUNT; i++) {
        CGContextMoveToPoint(context,LEFT_MARGIN, STOCK_SHARE_TOP_MARGIN + i * STOCK_SHARE_HOR_BOX_MARGIN);
        CGContextAddLineToPoint(context,LEFT_MARGIN + STOCK_SHARE_BOX_WIDTH,STOCK_SHARE_TOP_MARGIN + i* STOCK_SHARE_HOR_BOX_MARGIN);
    }
    
    for (NSInteger i = 0; i < STOCK_SHARE_VER_BOX_MARGIN; i++) {
        CGContextMoveToPoint(context,LEFT_MARGIN + i * STOCK_SHARE_VER_BOX_MARGIN, STOCK_SHARE_TOP_MARGIN);
        CGContextAddLineToPoint(context,LEFT_MARGIN + i * STOCK_SHARE_VER_BOX_MARGIN,STOCK_SHARE_TOP_MARGIN + STOCK_SHARE_BOX_HEIGHT);
    }
    CGContextStrokePath(context);
}

- (void)drawStockShareLine
{
    _pointArray = [NSMutableArray array];
    NSInteger pointCount = 4 * 60 + 1;
    CGFloat lineWidth = 1;
    CGFloat margin = STOCK_SHARE_BOX_WIDTH / (((CGFloat)pointCount - 1) * lineWidth);
    CGFloat startPointY =  [self changePriceToPointY:[(UUStockTimeEntity *)[_stockTimeEntityArray firstObject] price]];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context,LEFT_MARGIN, startPointY);
    [_pointArray addObject:NSStringFromCGPoint(CGPointMake(LEFT_MARGIN, startPointY))];
    
  ColorModel *colorModel = [UIColorTools RGBWithHexString:k_SHARE_TIME_COLOR withAlpha:1.0f];
    
    CGContextSetRGBStrokeColor(context, colorModel.R/255.0f,colorModel.G/255.0f,colorModel.B/255.0f, 1);
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
    NSInteger pointCount = 4 * 60 + 1;
    CGFloat lineWidth = 1;
    CGFloat margin = STOCK_SHARE_BOX_WIDTH / (((CGFloat)pointCount - 1) * lineWidth);
    CGFloat startPointY =  [self changePriceToPointY:[(UUStockTimeEntity *)[_stockTimeEntityArray firstObject] avgPrice]];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context,LEFT_MARGIN, startPointY);
    [_avePointArray addObject:NSStringFromCGPoint(CGPointMake(LEFT_MARGIN, startPointY))];
    
    CGContextSetStrokeColorWithColor(context,  [UIColorTools colorWithHexString:K_SHARE_TIME_AVG_COLOR withAlpha:1.0f].CGColor);
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
    NSInteger pointCount = 4 * 60 + 1;
    CGFloat lineWidth = 1;
    CGFloat margin = STOCK_SHARE_BOX_WIDTH / (((CGFloat)pointCount - 1) * lineWidth);
    UUStockTimeEntity *model = [_stockTimeEntityArray firstObject];
    
    CGFloat startPointY = [self changeVolToPointY:model.amount];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    
    ColorModel *colorModel = nil;
    if (model.price  >= _stockQuoteEntity.preClosePrice)
    {
       colorModel = [UIColorTools RGBWithHexString:@"#E81B00" withAlpha:1.0f];
    }
    else
    {
        colorModel = [UIColorTools RGBWithHexString:@"5CD274" withAlpha:1.0f];
    }
    
    CGContextSetRGBStrokeColor(context, colorModel.R/255.0f, colorModel.G/255.0f, colorModel.B/255.0f, 0.8);
    
    CGPoint startPoint = CGPointMake(LEFT_MARGIN, startPointY);
    CGPoint endPoint = CGPointMake(LEFT_MARGIN, VOL_BOX_HEIGHT + VOL_TOP_MARGIN);
    
    const CGPoint points[] = {startPoint,endPoint}; //柱状
    CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    
    for (NSInteger i = 1;i < _stockTimeEntityArray.count;i++) {

        UUStockTimeEntity *model1 = [_stockTimeEntityArray objectAtIndex:i-1];
        UUStockTimeEntity *model2 = [_stockTimeEntityArray objectAtIndex:i];
        
        if (model1.price <= model2.price)
        {
            colorModel = [UIColorTools RGBWithHexString:@"#E81B00" withAlpha:1.0f];
        }
        else
        {
            colorModel = [UIColorTools RGBWithHexString:@"#5CD274" withAlpha:1.0f];
        }
        CGContextSetRGBStrokeColor(context, colorModel.R/255.0f, colorModel.G/255.0f, colorModel.B/255.0f, 0.8);

        CGPoint startPoint = CGPointMake(LEFT_MARGIN + margin * i, [self changeVolToPointY:model2.amount]);
        CGPoint endPoint = CGPointMake(LEFT_MARGIN  + margin *i, VOL_BOX_HEIGHT + VOL_TOP_MARGIN);
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
    if (fabs(maxValue - preClosePrice) >= fabs(minValue - preClosePrice))
    {
        paddingValue = fabs(maxValue - preClosePrice);
        _maxValue = preClosePrice + paddingValue;
        _minValue = preClosePrice - paddingValue;
    }
    else
    {
        paddingValue = fabs(minValue - preClosePrice);
        _minValue = preClosePrice - paddingValue;
        _maxValue = preClosePrice + paddingValue;
    }
    
    double rate = 0;
    if (preClosePrice > 0) {
      rate =  paddingValue / preClosePrice;
    }
    
    NSString *rateString = [NSString stringWithFormat:@"%.2f%%",rate * 100];
    
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        _highestPriceLabel.text = [NSString amountValueWithDouble:_maxValue];
        _lowestPriceLabel.text = [NSString amountValueWithDouble:_minValue];
        _preCloseLabel.text = [NSString amountValueWithDouble:preClosePrice];
        _volLabel.text = [NSString stringWithFormat:@"%.0f",_maxVol];
        
        
        _highestRateLabel.text = [@"+" stringByAppendingString:rateString];
        _lowestRateLabel.text = rateString;

    });
}

//获取到价格所在实际坐标
- (double)changePriceToPointY:(double)price
{
    double priceHeight = _maxValue - _minValue;
    
    if (priceHeight == 0) {
        return STOCK_SHARE_BOX_HEIGHT * 0.5 + STOCK_SHARE_TOP_MARGIN;
    }

    double pointY = (1- (price - _minValue) / priceHeight) * STOCK_SHARE_BOX_HEIGHT + STOCK_SHARE_TOP_MARGIN;
    
    return pointY;
}

//获取到成交量所在实际坐标
- (CGFloat)changeVolToPointY:(CGFloat)price
{
    CGFloat volHeight = _maxVol;
    
    if (volHeight == 0) {
        return VOL_BOX_HEIGHT + VOL_TOP_MARGIN;
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
                _moveLineYView.frame = CGRectMake(point.x,STOCK_SHARE_TOP_MARGIN, 0.5f, STOCK_SHARE_BOX_HEIGHT);

                UUStockTimeEntity *shareModel = [_stockTimeEntityArray objectAtIndex:i];
                
                if ([_delegate respondsToSelector:@selector(shareTimeView:longPress:)]) {
                    [_delegate shareTimeView:self longPress:i];
                }
                _currentPriceLabel.text = [NSString stringWithFormat:@"%.2f",shareModel.price];
                [_currentPriceLabel sizeToFit];
                CGRect frame = _currentPriceLabel.frame;
                frame.size.height = 16.0f;
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
                frame.origin.y = CGRectGetMaxY(_moveLineYView.frame);
                frame.size.height = 16.0f;
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
        if ([_delegate respondsToSelector:@selector(cancelLongPress:)]) {
            [_delegate cancelLongPress:self];
        }
    }
}

@end