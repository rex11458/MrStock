//
//  UUKLineView.m
//  StockHelper
//
//  Created by LiuRex on 15/5/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUKLineView.h"
#import "ColorModel.h"
#import "UUKLineModel.h"
#import <Masonry/Masonry.h>
#import "UUStockExRightsModel.h"
#import <MTDates/NSDate+MTDates.h>

#define KLINE_MARGIN_COUNT 6   //K线横向间隔数
#define VOL_MARGIN_COUNT   3   //成交量横向间隔数

//间隔
#define RIGHT_MARGIN  (self.type ? 85 : 0)
#define LEFT_MARGIN   40.0f

//K线
#define KLINE_TOP_MARGIN    20.0f
#define KLINE_BOTTOM_MARGIN (CGRectGetHeight(self.bounds) * 0.3 - KLINE_TOP_MARGIN)
#define KLINE_VOL_MARGIN 16.0f
#define KLINE_BOX_WIDTH   (CGRectGetWidth(self.bounds) - LEFT_MARGIN - RIGHT_MARGIN)
#define KLINE_BOX_HEIGHT  (CGRectGetHeight(self.bounds)*0.7 - KLINE_TOP_MARGIN)
#define KLINE_BOX_MARGIN  (KLINE_BOX_HEIGHT / (float)(KLINE_MARGIN_COUNT - 1))

//成交量
#define VOL_BOTTOM_MARGIN 0.0f
#define VOL_TOP_MARGIN   (KLINE_BOX_HEIGHT + KLINE_TOP_MARGIN + KLINE_VOL_MARGIN)
#define VOL_BOX_WIDTH    KLINE_BOX_WIDTH
#define VOL_BOX_HEIGHT  (CGRectGetHeight(self.bounds) * 0.3 - KLINE_VOL_MARGIN)
#define VOL_BOX_MARGIN  (VOL_BOX_HEIGHT / (float)(VOL_MARGIN_COUNT - 1))

//可见的K线个数
#define BOX_KLINE_COUNT (KLINE_BOX_WIDTH /(_lineWidth + _lineMargin))

double max_value(double x,double y,double z);
double min_value(double x,double y,double z);


@interface UUKLineView ()
{
    UUStockModelArray *_lineModelArray;
    CGFloat _lineMargin;
    NSInteger _currentIndex;
    
    
    //收盘价最大最小值
    CGFloat _maxValue;
    CGFloat _minValue;
     //成交量最大最小值
    NSInteger _maxVol;
    NSInteger _minVol;
    
    NSMutableArray *_leftPriceLabelArray;
    
    UIView *_moveLineXView; //横向十字线
    UIView *_moveLineYView; //纵向十字线
    UILabel *_currentDateLabel;    //选中的当前时间
    UILabel *_currentClosePriceLabel;   //选中的当前收盘价
    
    NSArray *_inBoxLineModelArray;  //可以见到的所有K线图Model
    
    UUVOLLineView *_volLineView; //VOL
    UUMACDLineView *_macdLineView;  //MACD
    UUKDJLineView *_kdjLineView;   //KDJ
    UURSILineView *_rsiLineView;   //RSI
    NSArray *_idxViewArray;
    
    NSArray *_ma5Array;
    NSArray *_ma10Array;
    NSArray *_ma20Array;
    
    NSArray *_kLineModelArray;
    //复权后的k线列表
    NSArray *_exRightsKLineModelArray;
    //复权类型 0 不复权 ，1 前复权 ，2 后复权
    NSInteger _exRightsType;
    //原始数据
    NSArray *_org_kLineModelArray;
    
}
@end

@implementation UUKLineView

- (NSInteger)boxKLineCount
{
    NSInteger boxCount = KLINE_BOX_WIDTH / (_lineMargin + _lineWidth);
    
    return boxCount;
}


- (void)setLineMargin:(CGFloat)lineMargin
{
    _lineMargin = lineMargin;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    _minVol = 0;
    
    self.lineWidth = 5;
    self.lineMargin = 1;
    _leftPriceLabelArray = [NSMutableArray array];
    
    [self addGestureRecognizer];
    [self configSubViews];
}


- (void)setType:(NSInteger)type
{
    _type = type;
    _lineBGViewTrailingConstraint.constant = _type ? 85 : 0;
    self.userInteractionEnabled = _type;
    _rightButtonView.hidden = !_type;
    [self setNeedsDisplay];

    [_volLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-_lineBGViewTrailingConstraint.constant);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.3).with.offset(-16);
    }];
    
    [_macdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-_lineBGViewTrailingConstraint.constant);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.3).with.offset(-16);
    }];
    
    [_kdjLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-_lineBGViewTrailingConstraint.constant);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.3).with.offset(-16);
    }];
    
    [_rsiLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-_lineBGViewTrailingConstraint.constant);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.3).with.offset(-16);
    }];
}

- (void)configSubViews
{
    _moveLineXView = [[UIView alloc] initWithFrame:CGRectZero];
    _moveLineXView.backgroundColor = [UIColor blackColor];
    [self addSubview:_moveLineXView];
    _moveLineYView = [[UIView alloc] initWithFrame:CGRectZero];
    _moveLineYView.backgroundColor = [UIColor blackColor];
    [self addSubview:_moveLineYView];
    _currentDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _currentDateLabel.textAlignment = NSTextAlignmentCenter;
    _currentDateLabel.backgroundColor = [UIColor grayColor];
    _currentDateLabel.textColor = [UIColor whiteColor];
    _currentDateLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_currentDateLabel];
    _currentClosePriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _currentClosePriceLabel.backgroundColor = [UIColor grayColor];
    _currentClosePriceLabel.textColor = [UIColor whiteColor];
    _currentClosePriceLabel.font = [UIFont systemFontOfSize:12.0f];
    
    _currentClosePriceLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_currentClosePriceLabel];

    UUVOLLineView *volLineView = [[UUVOLLineView alloc] initWithFrame:CGRectZero];
    volLineView.type = self.type;
    [self addSubview:volLineView];
    _volLineView = volLineView;
    
     UUMACDLineView *macdLineView = [[UUMACDLineView alloc] initWithFrame:CGRectZero];
    [self addSubview:macdLineView];
        _macdLineView = macdLineView;
//    //KDJ
    UUKDJLineView *kdjLineView = [[UUKDJLineView alloc] initWithFrame:CGRectZero];
    [self addSubview:kdjLineView];
    _kdjLineView = kdjLineView;
//    RSI
    UURSILineView *rsiLineView = [[UURSILineView alloc] initWithFrame:CGRectZero];
    [self addSubview:rsiLineView];
    _rsiLineView = rsiLineView;

    _idxViewArray = @[_volLineView,_macdLineView,_kdjLineView,_rsiLineView];

    [self idxButtonAction:_idxButtonArray[0]];

}

- (void)addGestureRecognizer
{
    //长按
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesAction:)];
    [longPressGes setMinimumPressDuration:0.3f];
    [longPressGes setAllowableMovement:50.0];
    [self addGestureRecognizer:longPressGes];
    
    //捏合
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesAction:)];
    [self addGestureRecognizer:pinchGes];
    //滑动
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesAction:)];
    [self addGestureRecognizer:panGes];
}

- (void)setKLineModelArray:(NSArray *)kLineModelArray
{
    if ([kLineModelArray isNull]) {
        return;
    }
    _kLineModelArray = [kLineModelArray copy];
    
    _org_kLineModelArray = [[NSArray alloc] initWithArray:_kLineModelArray copyItems:YES];
    [self drawData];
}

- (void)drawData
{
    if (_exRightsType == 0) {
        _kLineModelArray = [_org_kLineModelArray copy];

        
    }else{
        //1前复权,2后复权
        _kLineModelArray = [self exRightedkLineModelArray:_org_kLineModelArray];

    }
    
    if (_kLineModelArray.count <= [self boxKLineCount])
    {
        _currentIndex = 0;
    }
    else
    {
        _currentIndex = _kLineModelArray.count - [self boxKLineCount];
    }
    
    //移动平均数
    NSDictionary *maDictionary = [UUKLineModel maDictionary:_kLineModelArray];
    _ma5Array = [maDictionary objectForKey:MA5_ARRAY];
    _ma10Array = [maDictionary objectForKey:MA10_ARRAY];
    _ma20Array = [maDictionary objectForKey:MA20_ARRAY];
    
    //成交量
    [_volLineView setKLineModelArray:_kLineModelArray];
    //MACD
    [_macdLineView setKLineModelArray:_kLineModelArray];
    //KDJ
    [_kdjLineView setKLineModelArray:_kLineModelArray];
    //RSI
    [_rsiLineView setKLineModelArray:_kLineModelArray];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //－－画图前先清空当前画布
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextClearRect(ref, rect);
    [[UIKitHelper imageWithColor:k_BG_COLOR] drawInRect:rect];
    //画框
    [self drawBox];
    
    if (_kLineModelArray !=nil && _kLineModelArray.count > 0) {
        //画K线
        [self drawKLine];
    }
}
//画框
- (void)drawBox
{
    //－－K线框
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, k_LINE_COLOR.CGColor);
    for (NSInteger i = 0; i < KLINE_MARGIN_COUNT; i++) {
        CGContextMoveToPoint(context,LEFT_MARGIN, KLINE_TOP_MARGIN + i * KLINE_BOX_MARGIN);
        CGContextAddLineToPoint(context,LEFT_MARGIN + KLINE_BOX_WIDTH,KLINE_TOP_MARGIN + i*KLINE_BOX_MARGIN);
    }
    CGContextMoveToPoint(context,LEFT_MARGIN, KLINE_TOP_MARGIN);
    CGContextAddLineToPoint(context,LEFT_MARGIN,KLINE_TOP_MARGIN + KLINE_BOX_HEIGHT);
    
    CGContextMoveToPoint(context,LEFT_MARGIN + KLINE_BOX_WIDTH, KLINE_TOP_MARGIN);
    CGContextAddLineToPoint(context,LEFT_MARGIN + KLINE_BOX_WIDTH,KLINE_TOP_MARGIN + KLINE_BOX_HEIGHT);
    CGContextStrokePath(context);
}

//画K线
- (void)drawKLine
{
    NSArray *lineModelArray = nil;
    
    NSInteger boxKlineCount = [self boxKLineCount];
    
    if (boxKlineCount > _kLineModelArray.count)
    {
        lineModelArray = _kLineModelArray;
    }else
    {
        lineModelArray = [_kLineModelArray subarrayWithRange:NSMakeRange(_currentIndex,boxKlineCount)];
    }
    
    _maxValue = [(UUKLineModel *)[lineModelArray firstObject] highPrice];
    _minValue = [(UUKLineModel *)[lineModelArray firstObject] lowPrice];
 
    //获取最大值
    for (NSInteger i = lineModelArray.count - 1;i > 0; i--)
    {
        UUKLineModel *kLineModel = [lineModelArray objectAtIndex:i];
        if (kLineModel.highPrice > _maxValue) {
            _maxValue = kLineModel.highPrice;
        }
        if (kLineModel.lowPrice < _minValue) {
            _minValue = kLineModel.lowPrice;
        }
    }
    NSArray *ma10Array = [self inBoxMAArrayWith:_ma10Array type:kMA10LineType];
    NSArray *ma20Array = [self inBoxMAArrayWith:_ma20Array type:kMA20LineType];

    NSArray *ma5Array = [self inBoxMAArrayWith:_ma5Array type:kMA5LineType];
    
    for (NSNumber *value in ma5Array) {
        if ([value floatValue] > _maxValue)
            _maxValue = [value floatValue];
        if ([value floatValue] < _minValue) {
            _minValue = [value floatValue];
        }
    }
    
    for (NSNumber *value in ma10Array) {
        if ([value floatValue] > _maxValue)
            _maxValue = [value floatValue];
        if ([value floatValue] < _minValue) {
            _minValue = [value floatValue];
        }
    }
    
    for (NSNumber *value in ma20Array) {
        if ([value floatValue] > _maxValue)
            _maxValue = [value floatValue];
        if ([value floatValue] < _minValue) {
            _minValue = [value floatValue];
        }
    }
    
    [self addLeftPriceLabel];
    UUKLineModel *preLineModel = [lineModelArray firstObject];

    NSMutableArray *closePricePointArray = [NSMutableArray array];
    for (NSInteger i = 0; i < lineModelArray.count; i++)
    {
        UUKLineModel *lineModel = [lineModelArray objectAtIndex:i];
        if (i > 0) {
            preLineModel = [lineModelArray objectAtIndex:i - 1];
        }
        CGFloat pointX = _lineWidth * 0.5 + i * (_lineWidth  + _lineMargin) + LEFT_MARGIN + 1;
        //最高价的坐标Y

        CGFloat highPricePointY = [self changePriceToPointY:lineModel.highPrice];
        //最低价的坐标Y
        CGFloat lowPricePointY = [self changePriceToPointY:lineModel.lowPrice];
        //开盘价坐标Y
        CGFloat openPricePointY = [self changePriceToPointY:lineModel.openPrice];
        //收盘价坐标Y
        CGFloat closePricePointY = [self changePriceToPointY:lineModel.closePrice];
        //        //成交量坐标Y
        //        CGFloat volPointY = [self changeVolToPointY:lineModel.curvol];
        //
        //最高价坐标
        CGPoint highPricePoint = CGPointMake(pointX, highPricePointY);
        //最低价坐标
        CGPoint lowPricePoint = CGPointMake(pointX, lowPricePointY);
        //开盘价坐标
        CGPoint openPricePoint = CGPointMake(pointX, openPricePointY);
        //收盘价坐标
        CGPoint closePricePoint = CGPointMake(pointX, closePricePointY);
        //        //成交量坐标
        //        CGPoint volCurPoint = CGPointMake(pointX, volPointY);
        //        CGPoint volMinPoint = CGPointMake(pointX, VOL_TOP_MARGIN + VOL_BOX_HEIGHT);
        [closePricePointArray addObject:NSStringFromCGPoint(closePricePoint)];
        
        ColorModel *colorModel = nil;
        if (lineModel.openPrice == lineModel.closePrice)
        {
            if (lineModel.openPrice >= preLineModel.closePrice)
            {
                colorModel = [UIColorTools RGBWithHexString:k_UPPER_COLOR_VALUE withAlpha:1.0f];
            }
            else
            {
                colorModel = [UIColorTools RGBWithHexString:k_UNDER_COLOR_VALUE withAlpha:1.0f];
            }
        }
        else  if (lineModel.openPrice < lineModel.closePrice)
        {
            colorModel = [UIColorTools RGBWithHexString:k_UPPER_COLOR_VALUE withAlpha:1.0f];

        }
        else
        {
            colorModel = [UIColorTools RGBWithHexString:k_UNDER_COLOR_VALUE withAlpha:1.0f];
        }
        
        CGFloat longLineWidth = 1.0f;
        if (_lineWidth < 5) {
            longLineWidth = 0.5f;
        }
        
        //绘制K线
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(context, colorModel.R / 255.0f,colorModel.G/255.0f, colorModel.B/255.0f, 1);

        CGContextSetLineWidth(context, longLineWidth);
        const CGPoint points[] = {highPricePoint,lowPricePoint}; //影线
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
        
        
        CGContextSetLineWidth(context,_lineWidth);

        if (openPricePointY == closePricePointY) {
            openPricePoint.y += 1;
        }
        const CGPoint points2[] = {openPricePoint,closePricePoint}; //柱状
        CGContextStrokeLineSegments(context, points2, 2);  // 绘制线段（默认不绘制端点）
        CGContextStrokePath(context);
    }
    
    //绘制移动平均线
    [self drawMALineWithArray:_ma5Array type:(kMA5LineType - 1) lineColor:@"5C95B9"];
    [self drawMALineWithArray:_ma10Array type:(kMA10LineType - 1) lineColor:@"F3B872"];
    [self drawMALineWithArray:_ma20Array type:(kMA20LineType - 1) lineColor:@"CBAAD0"];
//////
//
//    //VOL
    _volLineView.lineWidth = _lineWidth;
    _volLineView.currentIndex = _currentIndex;
    _volLineView.lineMargin = _lineMargin;
    [_volLineView setNeedsDisplay];
//    //MACD
    _macdLineView.lineMargin = _lineMargin;
    [_macdLineView setLineWidth:_lineWidth];
    _macdLineView.currentIndex = _currentIndex;
    [_macdLineView setNeedsDisplay];
//
//    //KDJ
    _kdjLineView.lineMargin = _lineMargin + _lineWidth;
    _kdjLineView.currentIndex = _currentIndex;
    [_kdjLineView setNeedsDisplay];
//    //RSI
    _rsiLineView.lineMargin = _lineMargin + _lineWidth;
    _rsiLineView.currentIndex = _currentIndex;
    [_rsiLineView setNeedsDisplay];
    
    self.closePricePointArray = closePricePointArray;
    _inBoxLineModelArray = [lineModelArray copy];
    
}

/*
 
 */

- (NSArray *)inBoxMAArrayWith:(NSArray *)maArray type:(kMALineType)type
{
    NSArray *tempMAArray = nil;
    NSInteger boxKlineCount = BOX_KLINE_COUNT;
    NSInteger loc;
    NSInteger len;
    
    if (boxKlineCount > _kLineModelArray.count)
    {
        loc = 0;
        len = maArray.count;
    }
    else
    {
        if (_currentIndex < type)
        {
            loc = 0;
            len = boxKlineCount - (type - _currentIndex);
            if (len < 0) {
                len = 0;
            }
        }
        else
        {
            loc = _currentIndex - type;
            len = boxKlineCount;
        }
    }
    
    tempMAArray = [maArray subarrayWithRange:NSMakeRange(loc, len)];
    
    return tempMAArray;
}

- (void)drawMALineWithArray:(NSArray *)maArray type:(kMALineType)type lineColor:(NSString *)hexColorString
{
    NSInteger boxKlineCount = BOX_KLINE_COUNT;
    NSArray *tempMAArray = [self inBoxMAArrayWith:maArray type:type];
    NSInteger index = 0;
    
    if (boxKlineCount > _kLineModelArray.count)
    {
        index = type;
    }
    else
    {
        if (_currentIndex < type)
        {
            index = type - _currentIndex;
        }
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGFloat startPointX = LEFT_MARGIN + (_lineMargin + _lineWidth)*0.5 + index * (_lineMargin + _lineWidth);
   

    CGPoint startPoint = CGPointMake(startPointX, [self changePriceToPointY:[[tempMAArray firstObject] floatValue]]);
    CGContextMoveToPoint(context,startPoint.x,startPoint.y);
    ColorModel *colorModel = [UIColorTools RGBWithHexString:hexColorString withAlpha:1.0f];
    CGContextSetRGBStrokeColor(context, colorModel.R / 255.0f, colorModel.G / 255.0f, colorModel.B / 255.0f, 1);//线条颜色
    
    for (NSInteger i = 0; i < tempMAArray.count; i++)
    {
        CGFloat pointX = (i + index)  * (_lineWidth + _lineMargin )+ LEFT_MARGIN + (_lineMargin + _lineWidth) * 0.5;
        CGFloat pointY = [self changePriceToPointY:[[tempMAArray objectAtIndex:i] floatValue]];
        
        CGContextAddLineToPoint(context,pointX, pointY);
    }
    CGContextStrokePath(context);
}

////取到当前页K线显示的最大最小值
//- (void)getHighestAndLowestPriceWithLineModelArray:(NSArray *)array
//{
//    if ([array isNull] || array.count == 0) {
//        return;
//    }
//    _minValue = [(UUStockModel *)[array lastObject] lowp];
//    _maxValue = [(UUStockModel *)[array lastObject] highp];
//    
//    for (NSInteger i = array.count - 1; i >= 0; i--) {
//        
//        //收盘价最大最小值
//        UUStockModel *lineModel = [array objectAtIndex:i];
//        if (lineModel.highp > _maxValue) {
//            _maxValue = lineModel.highp;
//        }
//        if (lineModel.lowp < _minValue) {
//            _minValue = lineModel.lowp;
//        }
//    }
//    
//    //左侧价格
//    [self addLeftPriceLabel];
//}

//左侧价格
- (void)addLeftPriceLabel
{
    //K线
    for (UIView *view in _leftPriceLabelArray) {
        [view removeFromSuperview];
    }
     CGFloat pricePadding = (_maxValue - _minValue) / (float)(KLINE_MARGIN_COUNT - 1);
    
    for (int i = 0; i < KLINE_MARGIN_COUNT; i++) {
        
        double price = _maxValue - pricePadding * i;

        NSString *priceString = [NSString amountValueWithDouble:price];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i * KLINE_BOX_MARGIN + KLINE_TOP_MARGIN - 10, LEFT_MARGIN, 20)];
        label.textColor = k_BIG_TEXT_COLOR;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10.0f];
        label.text = priceString;
        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
        [_leftPriceLabelArray addObject:label];
    }
}

////5，10，20日平均价
//- (CGFloat)averageOfMAType:(kMALineType)type withLineModelArray:(NSArray *)array
//{
//    CGFloat sum = 0;
//    for (UUStockModel *lineModel in array)
//    {
//        sum += lineModel.preclose;
//    }
//    
//    return (sum / type);
//}


//获取到价格所在实际坐标
- (CGFloat)changePriceToPointY:(CGFloat)price
{
    CGFloat priceHeight = _maxValue - _minValue;
    
    if (priceHeight == 0) {
        return 0;
    }
    
    CGFloat pointY = (1- (price - _minValue) / priceHeight) * KLINE_BOX_HEIGHT + KLINE_TOP_MARGIN;
    
    return pointY;
}


//长按显示十字线
- (void)longPressGesAction:(UIGestureRecognizer *)ges
{
    CGPoint point = [ges locationInView:ges.view];

    if (ges.state == UIGestureRecognizerStateChanged)
    {
        for (int i = 0; i < _closePricePointArray.count; i++) {
            NSString *pointString = [_closePricePointArray objectAtIndex:i];
            
            if (fabs(point.x - CGPointFromString(pointString).x) < (_lineWidth + _lineMargin)) {
                
                UUKLineModel *lineModel = [_inBoxLineModelArray objectAtIndex:i];
                
                _moveLineXView.hidden = NO;
                _moveLineYView.hidden = NO;
                _currentDateLabel.hidden = NO;
                _currentClosePriceLabel.hidden = NO;
                _moveLineYView.frame = CGRectMake(CGPointFromString(pointString).x,KLINE_TOP_MARGIN, 0.5, KLINE_BOX_HEIGHT);
                _moveLineXView.frame = CGRectMake(LEFT_MARGIN,CGPointFromString(pointString).y, KLINE_BOX_WIDTH, 0.5f);
                _currentClosePriceLabel.text = [NSString amountValueWithDouble:lineModel.closePrice];
                [_currentClosePriceLabel sizeToFit];
                CGRect frame = _currentClosePriceLabel.frame;
                if (CGPointFromString(pointString).x > KLINE_BOX_WIDTH * 0.5 + LEFT_MARGIN)
                {
                    frame.origin.x = LEFT_MARGIN;
                }
                else
                {
                    frame.origin.x = LEFT_MARGIN + KLINE_BOX_WIDTH - CGRectGetWidth(frame);
                    
                }
                frame.origin.y = CGPointFromString(pointString).y - CGRectGetHeight(frame) * 0.5;
                
                _currentClosePriceLabel.frame = frame;
                
                _currentDateLabel.text = lineModel.time;
                [_currentDateLabel sizeToFit];
                frame = _currentDateLabel.frame;
                frame.origin.x = CGPointFromString(pointString).x - CGRectGetWidth(frame) * 0.5;
                frame.origin.y = VOL_TOP_MARGIN - 16.0f;
                _currentDateLabel.frame = frame;
            }
        }
    }
    else if (ges.state == UIGestureRecognizerStateEnded)
    {
        _moveLineXView.hidden = YES;
        _moveLineYView.hidden = YES;
        _currentDateLabel.hidden = YES;
        _currentClosePriceLabel.hidden = YES;
    }
}

//手势捏合
- (void)pinchGesAction:(UIPinchGestureRecognizer *)ges
{
    if (ges.state== UIGestureRecognizerStateChanged)
    {
        self.lineWidth =  ges.scale >1 ? self.lineWidth + 0.5 : self.lineWidth - 0.5;
        
        if (_kLineModelArray.count <= [self boxKLineCount])
        {
            _currentIndex = 0;
        }
        else
        {
            _currentIndex = _kLineModelArray.count - [self boxKLineCount];
        }
        [self updateSelf];
    }
}

- (void)updateSelf
{
    if (self.lineWidth > 20)
        self.lineWidth = 20;
    if (self.lineWidth<1)
        self.lineWidth = 1;
    
    [self setNeedsDisplay];
}

//滑动
- (void)panGesAction:(UIPanGestureRecognizer *)ges
{
    NSInteger boxCount = BOX_KLINE_COUNT;
    if (ges.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [ges translationInView:ges.view];

        
        NSInteger index = _currentIndex;
      
        //移动个数
//        = point.x / (_lineWidth + _lineMargin);

        if (point.x <0)
        {
            index += 1;
        }else
        {
            index -= 1;
        }
   
        if (index <0 || index > _kLineModelArray.count - boxCount) {
            return;
        }
        _currentIndex = index;
        [self setNeedsDisplay];
        
        [ges setTranslation:CGPointZero inView:ges.view];
    }
}

#pragma mark - 指标切换
- (IBAction)idxButtonAction:(UIButton *)sender {
    
    for (UIButton *tempButton in _idxButtonArray) {
        tempButton.selected = NO;
    }
    sender.selected = YES;
    for (UIView *tempView in _idxViewArray) {
        tempView.hidden = YES;
    }
    [[_idxViewArray objectAtIndex:sender.tag] setHidden:NO];
}

#pragma mark - 复权/不复权
- (IBAction)buttonAction:(UIButton *)sender {
    
    for (UIButton *button in _buttonArray) {
        button.userInteractionEnabled = YES;
        button.selected = NO;
    }
    sender.userInteractionEnabled = NO;
    sender.selected = YES;
    
    _exRightsType = sender.tag;
    
    if (sender.tag == 0) {
        if (_kLineModelArray != nil) {
            [self drawData];
        }
    }else{
        if (_exrights) {
            _exrights(sender.tag);
        }
    }
}

#pragma mark - 复权计算
- (void)setExRightsArray:(NSArray *)exRightsArray
{
    if (exRightsArray == nil || _exRightsArray == exRightsArray) {
        return;
    }
    _exRightsArray = exRightsArray;

    [self drawData];
}


- (NSArray *)exRightedkLineModelArray:(NSArray *)kLineModelArray
{
    NSArray *temkLineModelArray = [[NSArray alloc] initWithArray:kLineModelArray copyItems:YES];
    
    //前复权：复权后价格=[(复权前价格-现金红利)+配(新)股价格×流通股份变动比例]÷(1+流通股份变动比例)
    //后复权：复权后价格=复权前价格×(1+流通股份变动比例)+现金红利
    
    for (NSInteger i = _exRightsArray.count - 1; i >= 0; i--) {
        UUStockExRightsModel *model = [_exRightsArray objectAtIndex:i];
        
        [temkLineModelArray enumerateObjectsUsingBlock:^(UUKLineModel *kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSTimeInterval sec_since_1970 = [[NSDate mt_dateFromString:kLineModel.time usingFormat:@"yyyyMMdd"] timeIntervalSince1970];
            
            BOOL ret = NO;
            if (_exRightsType == 1) {
                ret = sec_since_1970 < model.m_time;
            }else if(_exRightsType == 2){
                ret = sec_since_1970 >= model.m_time;
            }
            
            if (ret) {
                
                kLineModel.openPrice = [self exExightsValue:kLineModel.openPrice WithExRightsModel:model];
                kLineModel.highPrice =  [self exExightsValue:kLineModel.highPrice WithExRightsModel:model];
                kLineModel.lowPrice =  [self exExightsValue:kLineModel.lowPrice WithExRightsModel:model];
                kLineModel.closePrice =  [self exExightsValue:kLineModel.closePrice WithExRightsModel:model];
            }
        }];
    }

    
    return [temkLineModelArray copy];
}

- (double)exExightsValue:(double)value WithExRightsModel:(UUStockExRightsModel *)model
{
    double returnValue = 0;
    
    float			m_fGive = model.m_fGive;	    // 每股送
    float			m_fPei = model.m_fPei;	       	// 每股配
    float			m_fPeiPrice = model.m_fPeiPrice;	// 配股价,仅当 m_fPei!=0.0f 时有效
    float			m_fProfit = model.m_fProfit;	    // 每股红利
    double propotion = m_fPei + m_fGive; //流通比例

    if (_exRightsType == 1) {
        //前复权
        returnValue = ((value - m_fProfit) + m_fPeiPrice * propotion) / (1 + propotion);
        
    }else if(_exRightsType == 2){
        //后复权
        returnValue = value * (1 + propotion) + m_fProfit;
    }
    return returnValue;
}

@end

@interface UUVOLLineView()
{
    NSArray *_kLineModelArray;
    CGFloat _lineMargin;
    CGFloat _lineWidth;
    NSInteger _currentIndex;
}

@property (nonatomic) CGFloat maxValue;
@property (nonatomic) CGFloat minValue;

@property (nonatomic,strong) UILabel *maxValueLabel;
@property (nonatomic,strong) UILabel *middleValueLabel;

@end

@implementation UUVOLLineView

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
    _maxValueLabel = [UILabel new];
    _maxValueLabel.adjustsFontSizeToFitWidth = YES;
    _maxValueLabel.backgroundColor = [UIColor clearColor];
    _maxValueLabel.font = k_SMALL_TEXT_FONT;
    _maxValueLabel.textColor = k_BIG_TEXT_COLOR;
    _maxValueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_maxValueLabel];
    _middleValueLabel = [UILabel new];
    _middleValueLabel.adjustsFontSizeToFitWidth = YES;
    _middleValueLabel.backgroundColor = [UIColor clearColor];
    _middleValueLabel.font = k_SMALL_TEXT_FONT;
    _middleValueLabel.textAlignment = NSTextAlignmentCenter;
    _middleValueLabel.textColor = k_BIG_TEXT_COLOR;

    [self addSubview:_middleValueLabel];
    
    [_maxValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(self.mas_leading);
        make.width.mas_equalTo(40);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(14);
    }];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
}

-  (void)setLineMargin:(CGFloat)lineMargin
{
    _lineMargin = lineMargin;
}

- (void)setKLineModelArray:(NSArray *)kLineModelArray
{
    if ([kLineModelArray isNull] || _kLineModelArray == kLineModelArray) {
        return;
    }
    _kLineModelArray = kLineModelArray;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (_kLineModelArray.count == 0) return;
    //－－画图前先清空当前画布
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextClearRect(ref, rect);
    
    [[UIKitHelper imageWithColor:k_BG_COLOR] drawInRect:rect];

    //画框框
    [self drawBox];
    //画线
    [self drawVOLLine];
    //添加坐标值
}

//取到当前页成交量显示的最大最小值
- (void)getHighestAndLowestPriceWithLineModelArray:(NSArray *)array
{
    _minValue = 0;
    _maxValue = [(UUKLineModel *)[array firstObject] amount];

    //    成交量最大最小值
    for (NSInteger i = array.count - 1; i > 0; i--) {
        UUKLineModel *stockModel = [array objectAtIndex:i];
        CGFloat vol_max = stockModel.amount;

        if  (_maxValue< vol_max)
        {
            _maxValue = vol_max;
        }
    }
    //左侧价格
    _maxValueLabel.text = [NSString stringWithFormat:@"%.0f",_maxValue];
    _middleValueLabel.text = [NSString stringWithFormat:@"%.0f",_maxValue * 0.5];
}

//获取到值所在实际坐标
- (CGFloat)changeValueToPointY:(CGFloat)value
{
    CGFloat priceHeight = _maxValue - _minValue;
    
    if (priceHeight == 0) {
        return 0;
    }
    
    CGFloat pointY = (1- (value - _minValue) / priceHeight) * CGRectGetHeight(self.bounds);
    
    return pointY;
}

- (void)drawBox
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, k_LINE_COLOR.CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextAddRect(context, CGRectMake(LEFT_MARGIN,0,VOL_BOX_WIDTH,CGRectGetHeight(self.bounds)));
    CGContextMoveToPoint(context,LEFT_MARGIN,CGRectGetHeight(self.bounds) * 0.5);
    CGContextAddLineToPoint(context,VOL_BOX_WIDTH + LEFT_MARGIN, CGRectGetHeight(self.bounds) * 0.5);
    CGContextStrokePath(context);
}

- (void)drawVOLLine
{
    NSArray *lineModelArray = nil;
    
    NSInteger boxKlineCount = BOX_KLINE_COUNT;
    
    if (boxKlineCount > _kLineModelArray.count)
    {
        lineModelArray = _kLineModelArray;
    }else
    {
        lineModelArray = [_kLineModelArray subarrayWithRange:NSMakeRange(_currentIndex,boxKlineCount)];
    }
    
    [self getHighestAndLowestPriceWithLineModelArray:lineModelArray];
    UUKLineModel *lineModel2 = [lineModelArray firstObject];
    for (NSInteger i = 0; i < lineModelArray.count; i++)
    {
        UUKLineModel *lineModel = [lineModelArray objectAtIndex:i];
        if (i > 0)
        {
            lineModel2 = [lineModelArray objectAtIndex:i - 1];
        }
        CGFloat pointX = (_lineWidth + _lineMargin) * 0.5 + i * (_lineWidth  + _lineMargin) + LEFT_MARGIN + 1;
     
        //        //成交量坐标Y
        CGFloat volPointY = [self changeValueToPointY:lineModel.amount];
     
        //        //成交量坐标
        CGPoint volCurPoint = CGPointMake(pointX, volPointY);
        CGPoint volMinPoint = CGPointMake(pointX, CGRectGetHeight(self.bounds));
        
        UIColor *color = nil;
        if (lineModel.openPrice == lineModel.closePrice)
        {
            if (lineModel.openPrice >= lineModel2.closePrice)
            {
                color = k_UPPER_COLOR;
            }else
            {
                color = k_UNDER_COLOR;
            }
        }
        else if (lineModel.openPrice < lineModel.closePrice)
        {
            color = k_UPPER_COLOR;
        }
        else
        {
            color = k_UNDER_COLOR;
        }
        
        CGFloat longLineWidth = 1.0f;
        if (_lineWidth < 5) {
            longLineWidth = 0.5f;
        }
        //
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, _lineWidth);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        
        if (volMinPoint.y - volCurPoint.y < 1) {
            volCurPoint.y -= 1;
        }
        
        //绘制成交量
        const CGPoint points3[] = {volMinPoint,volCurPoint}; //柱状
        CGContextStrokeLineSegments(context, points3, 2);  // 绘制线段（默认不绘制端点）
    }
}


@end

@interface UUMACDLineView ()
{
    NSArray *_kLineModelArray;
    CGFloat _lineMargin;
    CGFloat _lineWidth;
    NSInteger _currentIndex;
}

@property (nonatomic, copy) NSArray *DEAArray;
@property (nonatomic, copy) NSArray *DIFArray;
@property (nonatomic, copy) NSArray *MACDArray;
@property (nonatomic,assign) CGFloat maxValue;
@property (nonatomic,assign) CGFloat minValue;

@end

@implementation UUMACDLineView

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
}



-  (void)setLineMargin:(CGFloat)lineMargin
{
    _lineMargin = lineMargin;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _lineMargin = 6;
    }
    return self;
}

- (void)setKLineModelArray:(NSArray *)kLineModelArray
{
    if ([kLineModelArray isNull] || _kLineModelArray == kLineModelArray) {
        return;
    }
    _kLineModelArray = kLineModelArray;
//    转化为MACD指标值
    NSDictionary *dic = [UUKLineModel macdDictionary:_kLineModelArray];
    
    _DEAArray = [dic objectForKey:DEA_ARRAY];
    _DIFArray = [dic objectForKey:DIF_ARRAY];
    _MACDArray = [dic objectForKey:MACD_ARRAY];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (_kLineModelArray.count == 0) return;

    //－－画图前先清空当前画布
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextClearRect(ref, rect);
    [[UIKitHelper imageWithColor:k_BG_COLOR] drawInRect:rect];

    //画框框
    [self drawBox];

    
    //画线
    [self drawMACDLine];
    //添加坐标值
    [self addLeftValue];
}

- (void)addLeftValue
{
    NSArray *values = @[[@(_maxValue) stringValue],[@(0) stringValue],[@(_minValue) stringValue]];
    
    for (NSInteger i = 0; i < values.count; i++) {
        NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont systemFontOfSize:10.0f],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
        [[values objectAtIndex:i] drawAtPoint:CGPointMake(LEFT_MARGIN * 0.5 ,i * CGRectGetHeight(self.bounds) * 0.5 +(i == 0 ?0:-10)) withAttributes:attributes];
    }
}


- (void)drawBox
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, k_LINE_COLOR.CGColor);
    CGContextSetLineWidth(context, 1.5f);
    CGContextAddRect(context, CGRectMake(LEFT_MARGIN,0,VOL_BOX_WIDTH,CGRectGetHeight(self.bounds)));
    CGContextMoveToPoint(context,LEFT_MARGIN,CGRectGetHeight(self.bounds) * 0.5);
    CGContextAddLineToPoint(context,VOL_BOX_WIDTH + LEFT_MARGIN, CGRectGetHeight(self.bounds) * 0.5);
    CGContextStrokePath(context);
}


- (void)drawMACDLine
{
   
    NSInteger lineCount = VOL_BOX_WIDTH / (_lineWidth + _lineMargin);
    NSArray *DEAArray = nil;
    NSArray *DIFArray = nil;
    NSArray *MACDArray = nil;
    if (_DEAArray.count < lineCount)
    {
        DEAArray = _DEAArray;
        DIFArray = _DIFArray;
        MACDArray = _MACDArray;
    }
    else
    {
        NSInteger loc = _currentIndex;
        if (loc < 0 ) {
            loc = 0;
        }
        
        DEAArray = [_DEAArray subarrayWithRange:NSMakeRange(loc, lineCount)];
        DIFArray = [_DIFArray subarrayWithRange:NSMakeRange(loc, lineCount)];
        MACDArray = [_MACDArray subarrayWithRange:NSMakeRange(loc, lineCount)];
    }
    
    double dea_max = 0;
    double dif_max = 0;
    double macd_max = 0;
    double maxValue = 0;
    for (NSInteger i = 0; i < DEAArray.count; i++) {
        dea_max = [[DEAArray objectAtIndex:i] doubleValue];
        dif_max = [[DIFArray objectAtIndex:i] doubleValue];
        macd_max = [[MACDArray objectAtIndex:i] doubleValue];
        
        double temp_maxValue = max_value(fabs(dea_max),fabs(dif_max),fabs(macd_max));
        
        if (temp_maxValue > maxValue) {
            maxValue = temp_maxValue;
        }
    }
    _maxValue = maxValue;
    _minValue = -_maxValue;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
//    //DEA
    CGPoint startPoint = CGPointMake(LEFT_MARGIN + (_lineMargin + _lineWidth)*0.5, [self changeValueToPointY:[[DEAArray firstObject] floatValue]]);
    CGContextMoveToPoint(context,startPoint.x,startPoint.y);
    //62ebe3
    CGContextSetStrokeColorWithColor(context, [UIColorTools colorWithHexString:@"#62ebe3" withAlpha:1.0f].CGColor);
    for (NSInteger i = 1; i < DEAArray.count; i++)
    {
        CGFloat pointX = i * (_lineMargin + _lineWidth) + LEFT_MARGIN + (_lineMargin + _lineWidth) * 0.5;
        CGFloat pointY = [self changeValueToPointY:[[DEAArray objectAtIndex:i] floatValue]];
        
        CGContextAddLineToPoint(context,pointX, pointY);
    }
    CGContextStrokePath(context);

    //EFI
    context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    startPoint = CGPointMake(LEFT_MARGIN + (_lineMargin + _lineWidth)*0.5, [self changeValueToPointY:[[DIFArray firstObject] floatValue]]);
    CGContextMoveToPoint(context,startPoint.x,startPoint.y);
    //e47f47
    CGContextSetStrokeColorWithColor(context, [UIColorTools colorWithHexString:@"#e47f47" withAlpha:1.0f].CGColor);

    for (NSInteger i = 1; i < DIFArray.count; i++) {
        CGFloat pointX = i * (_lineMargin + _lineWidth) + LEFT_MARGIN + (_lineMargin + _lineWidth) * 0.5;
        CGFloat pointY = [self changeValueToPointY:[[DIFArray objectAtIndex:i] floatValue]];
        
        CGContextAddLineToPoint(context,pointX, pointY);
    }
    CGContextStrokePath(context);
    //MACD
    context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    for (NSInteger i = 0; i < MACDArray.count; i++) {

        CGFloat pointX = i * (_lineMargin + _lineWidth) + LEFT_MARGIN + (_lineMargin + _lineWidth) * 0.5;
        CGFloat pointY = [self changeValueToPointY:[[MACDArray objectAtIndex:i] floatValue]];
        if ([[MACDArray objectAtIndex:i] floatValue] > 0) {
            
            CGContextSetStrokeColorWithColor(context, k_UPPER_COLOR.CGColor);

        }else{
            CGContextSetStrokeColorWithColor(context, k_UNDER_COLOR.CGColor);

        }
        
        CGPoint startPoint = CGPointMake(pointX, CGRectGetHeight(self.bounds) * 0.5);
        CGPoint endPoint = CGPointMake(pointX, pointY);
        const CGPoint points[] = {startPoint,endPoint}; //影线
        CGContextStrokeLineSegments(context, points, 2);
    }
    CGContextStrokePath(context);

}

//获取到价格所在实际坐标
- (CGFloat)changeValueToPointY:(CGFloat)value
{
    CGFloat priceHeight = _maxValue - _minValue;
    
    if (priceHeight == 0) {
        return 0;
    }
    
    CGFloat pointY = (1- (value - _minValue) / priceHeight) * CGRectGetHeight(self.bounds);
    
    return pointY;
}


@end


@interface UUKDJLineView ()
{
    NSArray *_kLineModelArray;
    CGFloat _lineMargin;
    CGFloat _lineWidth;
    NSInteger _currentIndex;
}

@property (nonatomic, copy) NSArray *KArray;
@property (nonatomic, copy) NSArray *DArray;
@property (nonatomic, copy) NSArray *JArray;

@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;

@end

@implementation UUKDJLineView

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
}


-  (void)setLineMargin:(CGFloat)lineMargin
{
    _lineMargin = lineMargin;
}

- (void)setKLineModelArray:(NSArray *)kLineModelArray
{
    if ([kLineModelArray isNull] || _kLineModelArray == kLineModelArray) {
        return;
    }
    _kLineModelArray = kLineModelArray;
    _KArray = [[UUKLineModel kdjDataDictionary:_kLineModelArray] objectForKey:K_ARRAY];
    _DArray = [[UUKLineModel kdjDataDictionary:_kLineModelArray] objectForKey:D_ARRAY];
    _JArray = [[UUKLineModel kdjDataDictionary:_kLineModelArray] objectForKey:J_ARRAY];
}

//- (void)setLineModelArray:(UUStockModelArray *)lineModelArray
//{
//    if (lineModelArray == nil || _lineModelArray == lineModelArray) return;
//    _lineModelArray = lineModelArray;
// 
//    _KArray = [[_lineModelArray kdjDataDictionary] objectForKey:K_ARRAY];
//    _DArray = [[_lineModelArray kdjDataDictionary] objectForKey:D_ARRAY];
//    _JArray = [[_lineModelArray kdjDataDictionary] objectForKey:J_ARRAY];
//    
//    [self setNeedsDisplay];
//}

- (void)drawRect:(CGRect)rect
{
    //－－画图前先清空当前画布
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextClearRect(ref, rect);
    [[UIKitHelper imageWithColor:k_BG_COLOR] drawInRect:rect];

    //画框框
    [self drawBox];
    
    if (_kLineModelArray.count == 0 || _kLineModelArray == nil) return;

    //画线
    [self drawKDJLine];
    //添加坐标值
    [self addLeftValue];
    
    
}

- (void)drawBox
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, k_LINE_COLOR.CGColor);
    CGContextSetLineWidth(context, 1.5f);
    CGContextAddRect(context, CGRectMake(LEFT_MARGIN,0,VOL_BOX_WIDTH,CGRectGetHeight(self.bounds)));
    CGContextStrokePath(context);
}

- (void)drawKDJLine
{
    NSInteger lineCount = VOL_BOX_WIDTH / _lineMargin;
    NSArray *KArray = nil;
    NSArray *DArray = nil;
    NSArray *JArray = nil;
    if (_KArray.count < lineCount)
    {
        KArray = _KArray;
        DArray = _DArray;
        JArray = _JArray;
    }
    else
    {
        NSInteger loc = _currentIndex;
        if (loc < 0) {
            loc = 0;
        }
        
        KArray = [_KArray subarrayWithRange:NSMakeRange(loc, lineCount)];
        DArray = [_DArray subarrayWithRange:NSMakeRange(loc, lineCount)];
        JArray = [_JArray subarrayWithRange:NSMakeRange(loc, lineCount)];
    }
    
    
    double k_value = 0;
    double d_value = 0;
    double j_value = 0;
    double maxValue = 0;
    double minValue = 0;
    for (NSInteger i = 0; i < KArray.count; i++) {
        k_value = [[KArray objectAtIndex:i] floatValue];
        d_value = [[DArray objectAtIndex:i] floatValue];
        j_value = [[JArray objectAtIndex:i] floatValue];
        
        double temp_maxValue = max_value(k_value,d_value,j_value);
        double temp_minValue = min_value(k_value,d_value,j_value);
        if (temp_maxValue > maxValue) {
            maxValue = temp_maxValue;
        }
        if (temp_minValue < minValue) {
            minValue = temp_minValue;
        }
    }
    _maxValue = maxValue;
    _minValue = minValue;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    //K
    CGPoint startPoint = CGPointMake(LEFT_MARGIN + (_lineMargin + _lineWidth)*0.5, [self changeValueToPointY:[[KArray firstObject] floatValue]]);
    CGContextMoveToPoint(context,startPoint.x,startPoint.y);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);//线条颜色
    
    for (NSInteger i = 1; i < KArray.count; i++)
    {
        CGFloat pointX = i * _lineMargin + LEFT_MARGIN + (_lineMargin + _lineWidth) * 0.5;
        CGFloat pointY = [self changeValueToPointY:[[KArray objectAtIndex:i] floatValue]];
        
        CGContextAddLineToPoint(context,pointX, pointY);
        
    }
    CGContextStrokePath(context);
    
    //D
    context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    startPoint = CGPointMake(LEFT_MARGIN + (_lineMargin + _lineWidth)*0.5, [self changeValueToPointY:[[DArray firstObject] floatValue]]);
    CGContextMoveToPoint(context,startPoint.x,startPoint.y);
    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);//线条颜色
    
    for (NSInteger i = 1; i < DArray.count; i++) {
        CGFloat pointX = i * _lineMargin + LEFT_MARGIN + (_lineMargin + _lineWidth) * 0.5;
        CGFloat pointY = [self changeValueToPointY:[[DArray objectAtIndex:i] floatValue]];
        
        CGContextAddLineToPoint(context,pointX, pointY);
        
    }
    CGContextStrokePath(context);
    
    //J
    context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);//线条颜色
    startPoint = CGPointMake(LEFT_MARGIN + (_lineMargin + _lineWidth)*0.5, [self changeValueToPointY:[[JArray firstObject] floatValue]]);
    CGContextMoveToPoint(context,startPoint.x,startPoint.y);

    for (NSInteger i = 0; i < JArray.count; i++) {
        
        CGFloat pointX = i * _lineMargin + LEFT_MARGIN + (_lineMargin + _lineWidth) * 0.5;
        CGFloat pointY = [self changeValueToPointY:[[JArray objectAtIndex:i] floatValue]];
        CGContextAddLineToPoint(context,pointX, pointY);
    }
    CGContextStrokePath(context);

}

- (void)addLeftValue
{
    NSArray *values = @[[@(_maxValue) stringValue]];
    
    for (NSInteger i = 0; i < values.count; i++) {
        NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont systemFontOfSize:10.0f],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
        [[values objectAtIndex:i] drawAtPoint:CGPointMake(LEFT_MARGIN * 0.5 ,i * CGRectGetHeight(self.bounds) * 0.5 +(i == 0 ?0:-10)) withAttributes:attributes];
    }
}



//获取到值所在实际坐标
- (CGFloat)changeValueToPointY:(CGFloat)value
{
    CGFloat priceHeight = _maxValue - _minValue;
    
    if (priceHeight == 0) {
        return 0;
    }
    
    CGFloat pointY = (1- (value - _minValue) / priceHeight) * CGRectGetHeight(self.bounds);
    
    return pointY;
}
@end
@interface UURSILineView ()
{
    NSArray *_kLineModelArray;
    CGFloat _lineMargin;
    CGFloat _lineWidth;
    NSInteger _currentIndex;
}

@property (nonatomic) CGFloat maxValue;
@property (nonatomic) CGFloat minValue;

@property (nonatomic,copy) NSArray *RSI6Array;
@property (nonatomic, copy) NSArray *RSI12Array;
@property (nonatomic, copy) NSArray *RSI24Array;

@end

@implementation UURSILineView

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
}

-  (void)setLineMargin:(CGFloat)lineMargin
{
    _lineMargin = lineMargin;
}

- (void)setKLineModelArray:(NSArray *)kLineModelArray
{
    if ([kLineModelArray isNull] || _kLineModelArray == kLineModelArray) {
        return;
    }
    _kLineModelArray = kLineModelArray;
    
    NSDictionary *rsiDic = [UUKLineModel rsiDataDictionary:_kLineModelArray];
    _RSI6Array = [rsiDic objectForKey:RSI6_ARRAY];
    _RSI12Array = [rsiDic objectForKey:RSI12_ARRAY];
    _RSI24Array = [rsiDic objectForKey:RSI24_ARRAY];

    
    [self setNeedsDisplay];
}

//
//- (void)setLineModelArray:(UUStockModelArray *)lineModelArray
//{
//    if (lineModelArray == nil || _lineModelArray == lineModelArray) return;
//    _lineModelArray = lineModelArray;
//   
//    _RSI6Array = [[_lineModelArray rsiDataDictionary] objectForKey:RSI6_ARRAY];
//    _RSI12Array = [[_lineModelArray rsiDataDictionary] objectForKey:RSI12_ARRAY];
//    _RSI24Array = [[_lineModelArray rsiDataDictionary] objectForKey:RSI24_ARRAY];
//
//    [self setNeedsDisplay];
//}

- (void)drawRect:(CGRect)rect
{
    //－－画图前先清空当前画布
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextClearRect(ref, rect);
    [[UIKitHelper imageWithColor:k_BG_COLOR] drawInRect:rect];

    _maxValue = 100;
    _minValue = 0;
    
    //画框框
    [self drawBox];
    if (_kLineModelArray.count == 0) return;

    
    //画线
    [self drawRSILine];
    //添加坐标值
    [self addLeftValue];
    
    
}



- (void)drawBox
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, k_LINE_COLOR.CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextAddRect(context, CGRectMake(LEFT_MARGIN,0,VOL_BOX_WIDTH,CGRectGetHeight(self.bounds)));
    CGContextStrokePath(context);
}

- (void)drawRSILine
{

    [self drawRSILineWithArray:_RSI6Array type:(RSI_N1 - 1) lineColor:@"87C2FF"];
    [self drawRSILineWithArray:_RSI12Array type:(RSI_N2 - 1) lineColor:@"FF4D84"];
    [self drawRSILineWithArray:_RSI24Array type:(RSI_N3 - 1) lineColor:@"B374E3"];
}


- (void)drawRSILineWithArray:(NSArray *)rsiArray type:(NSInteger)type lineColor:(NSString *)hexColorString
{
    NSArray *tempRSIArray = nil;
    NSInteger boxKlineCount = BOX_KLINE_COUNT;
    NSInteger loc = 0;
    NSInteger len = 0;
    NSInteger index = 0;
    
    if (boxKlineCount > _kLineModelArray.count)
    {
        loc = 0;
        len = rsiArray.count;
        index = type;
    }
    else
    {
        if (_currentIndex < type)
        {
            loc = 0;
            len = boxKlineCount - (type - _currentIndex);
            if (len < 0) {
                len = 0;
            }
            index = type - _currentIndex;
        }
        else
        {
            loc = _currentIndex - type;
            len = boxKlineCount;
        }
    }
    
    tempRSIArray = [rsiArray subarrayWithRange:NSMakeRange(loc, len)];
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGFloat startPointX = LEFT_MARGIN + (_lineMargin + _lineWidth)*0.5 + index * (_lineMargin + _lineWidth);

    CGPoint startPoint = CGPointMake(startPointX, [self changeValueToPointY:[[tempRSIArray firstObject] floatValue]]);

    CGContextMoveToPoint(context,startPoint.x,startPoint.y);
    ColorModel *colorModel = [UIColorTools RGBWithHexString:hexColorString withAlpha:1.0f];
    CGContextSetRGBStrokeColor(context, colorModel.R / 255.0f, colorModel.G / 255.0f, colorModel.B / 255.0f, 1);//线条颜色
    
    for (NSInteger i = 1; i < tempRSIArray.count; i++)
    {
        CGFloat pointX = (i + index)  * _lineMargin + LEFT_MARGIN + (_lineMargin + _lineWidth) * 0.5;
        CGFloat pointY = [self changeValueToPointY:[[tempRSIArray objectAtIndex:i] floatValue]];
        
        CGContextAddLineToPoint(context,pointX, pointY);
        
    }
    CGContextStrokePath(context);
}


- (void)addLeftValue
{
    NSArray *values = @[[@(_maxValue) stringValue],[@(50) stringValue],[@(_minValue) stringValue]];
    
    for (NSInteger i = 0; i < values.count; i++) {
        NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont systemFontOfSize:10.0f],
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
        [[values objectAtIndex:i] drawAtPoint:CGPointMake(LEFT_MARGIN * 0.5 ,i * CGRectGetHeight(self.bounds) * 0.5 +(i == 0 ?0:-10)) withAttributes:attributes];
    }
}


//获取到值所在实际坐标
- (CGFloat)changeValueToPointY:(CGFloat)value
{
    CGFloat priceHeight = _maxValue - _minValue;
    
    if (priceHeight == 0) {
        return 0;
    }
    
    CGFloat pointY = (1- (value - _minValue) / priceHeight) * CGRectGetHeight(self.bounds);
    
    return pointY;
}

@end

double max_value(double x,double y,double z)
{
    double temp = x > y ? x : y;
    return temp > z ? temp : z;
}


double min_value(double x,double y,double z)
{
    double temp = x < y ? x : y;
    return temp < z ? temp : z;
}

