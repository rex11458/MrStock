//
//  UUVirtualTransactionView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTransactionView.h"
#import "UUTransactionAssetModel.h"
#import "UUTransactionHistoryProfitModel.h"
@implementation UUVirtualTransactionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self configSubViews];
        self.backgroundColor = k_BG_COLOR;
        
    }
    return self;
}

- (void)configSubViews
{
    
    UURemindButton *rankContentButton = [UURemindButton buttonWithType:UIButtonTypeCustom];
    rankContentButton.frame = CGRectMake(k_LEFT_MARGIN, k_TOP_MARGIN, 60.0f, 20.0f);
    _rankContentButton = rankContentButton;
    rankContentButton.titleLabel.font = k_SMALL_TEXT_FONT;
    [rankContentButton setTitleColor:k_MIDDLE_TEXT_COLOR forState:UIControlStateNormal];
    [rankContentButton setTitle:@"收益排名" forState:UIControlStateNormal];
    [self addSubview:rankContentButton];
    
    
    _rankLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(rankContentButton.frame) + k_LEFT_MARGIN * 0.5, k_TOP_MARGIN, 24.0f, 20.0f) Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _rankLabel.text = @"--";
    _rankLabel.textAlignment = NSTextAlignmentCenter;
    _rankLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_rankLabel];
    
    UIImage *image = [UIImage imageNamed:@"arrow_up"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.center = CGPointMake(CGRectGetMaxX(_rankLabel.frame) + k_LEFT_MARGIN*0.5, CGRectGetMidY(_rankLabel.frame));
    [self addSubview:imageView];
    _arrowImageView = imageView;
    
    _totalAssetLabel = [[UULabelView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_rankLabel.frame) + k_TOP_MARGIN, PHONE_WIDTH, 50.0f)];
    
    
    _totalAssetLabel.underAttributes = @{NSFontAttributeName:k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:k_MIDDLE_TEXT_COLOR};
    _totalAssetLabel.upperAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:22.0f],NSForegroundColorAttributeName:k_BIG_TEXT_COLOR};
    _totalAssetLabel.underText = @"总资产";
    _totalAssetLabel.upperText = @"--";
    [self addSubview:_totalAssetLabel];
    
    //总市值，可用金额，冻结金额
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, CGRectGetMaxY(_totalAssetLabel.frame), PHONE_WIDTH - 2 * k_LEFT_MARGIN, 30.0f)];
    bgView.backgroundColor = k_NAVIGATION_BAR_COLOR;
    bgView.layer.cornerRadius = 15.0f;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    
    NSArray *titles = @[@"总市值",@"可用金额",@"冻结金额"];
    CGFloat labelHeight = 30.0f;
    CGFloat labelWidth = (PHONE_WIDTH - 2 * k_LEFT_MARGIN) / (CGFloat)titles.count;
    for (NSInteger i = 0; i < titles.count; i++) {
        UILabel *tempLabel = [UIKitHelper labelWithFrame:CGRectMake(k_LEFT_MARGIN + labelWidth * i, CGRectGetMaxY(bgView.frame), labelWidth, labelHeight) Font:k_SMALL_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.text = titles[i];
        [self addSubview:tempLabel];
        
        UILabel *label = [UIKitHelper labelWithFrame:CGRectMake(labelWidth * i,0, labelWidth, labelHeight) Font:k_MIDDLE_TEXT_FONT textColor:[UIColor whiteColor]];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"--";
        [bgView addSubview:label];
        if (i == 0) {
            _totalMarketValueLabel = label;
        }else if (i == 1){
            _useableValueLabel = label;
        }else{
            _freezeValueLabel = label;
        }
        
        if (i < titles.count - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(labelWidth *(i + 1), 5.0f, 0.5f, 20.0f)];
            line.backgroundColor = [UIColor whiteColor];
            [bgView addSubview:line];
        }
    }
    
    UIView *profitBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame) + 40.0f, PHONE_WIDTH, 38.0f)];
    profitBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:profitBgView];
    //今日盈亏，总盈亏
    _todayProfitLabel = [UIKitHelper labelWithFrame:CGRectMake(0,0,PHONE_WIDTH * 0.5,CGRectGetHeight(profitBgView.frame)) Font:k_MIDDLE_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    _todayProfitLabel.textAlignment = NSTextAlignmentCenter;
    [profitBgView addSubview:_todayProfitLabel];
    
    _totalProfitLabel = [UIKitHelper labelWithFrame:CGRectMake(PHONE_WIDTH * 0.5,0,PHONE_WIDTH * 0.5,CGRectGetHeight(profitBgView.frame)) Font:k_MIDDLE_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    _totalProfitLabel.textAlignment = NSTextAlignmentCenter;
    [profitBgView addSubview:_totalProfitLabel];
    
    NSString *todayProfit = @"--";
    NSString *text = [NSString stringWithFormat:@"今日盈亏   %@",todayProfit];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:todayProfit];
    [attText setAttributes:@{NSFontAttributeName:k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_UPPER_COLOR} range:range];
    _todayProfitLabel.attributedText = attText;
    
    NSString *totalProfit = @"--";
    text = [NSString stringWithFormat:@"总盈亏   %@",totalProfit];
    attText = [[NSMutableAttributedString alloc] initWithString:text];
    range = [text rangeOfString:totalProfit];
    [attText setAttributes:@{NSFontAttributeName:k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_UPPER_COLOR} range:range];
    _totalProfitLabel.attributedText = attText;
 }

- (void)setAssetModel:(UUTransactionAssetModel *)assetModel
{
    if (assetModel == nil || _assetModel == assetModel) {
        return;
    }
    _assetModel = assetModel;
    
    long upRank = _assetModel.rank - _assetModel.beforeRank;
    //显示收益排名红点
    _rankContentButton.showRemind = upRank;
    
    if (upRank < 0) {
        _arrowImageView.image = [UIImage imageNamed:@"arrow_down"];
    }
    
    _totalAssetLabel.upperText = [NSString amountValueWithDouble:_assetModel.rights];
    _rankLabel.text = [@(_assetModel.rank) stringValue];
    _useableValueLabel.text = [NSString amountValueWithDouble:_assetModel.usableBalance];
    _totalMarketValueLabel.text = [NSString amountValueWithDouble:_assetModel.marketValue];
    _freezeValueLabel.text = [NSString amountValueWithDouble:_assetModel.tradeFreeze];
 
    //总盈亏
    _totalProfitLabel.attributedText = [self useableString:_assetModel.profitLoss title:@"总盈亏"];
    //今日盈亏
    _todayProfitLabel.attributedText = [self useableString:_assetModel.dayProfitLoss title:@"今日盈亏"];
}

- (NSAttributedString *)useableString:(double)value title:(NSString *)title
{
    NSString *totalProfit = [NSString amountValueWithDouble:value];
    UIColor *color = k_EQUAL_COLOR;
    if (value > 0) {
        color = k_UPPER_COLOR;
        totalProfit = [@"+" stringByAppendingString:totalProfit];
    }else if (value < 0){
        color = k_UNDER_COLOR;
    }
    NSString *text = [NSString stringWithFormat:@"%@   %@",title,totalProfit];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRange range = [text rangeOfString:totalProfit];
    
    [attText setAttributes:@{NSFontAttributeName:k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:color} range:range];
    
    return attText;
}



- (void)drawRect:(CGRect)rect
{
    
}
@end

#define CIRCLE_RADIUS   2.5f

#define LEFT_WIDTH      40.0f
#define TOP_HEIGHT      30.0f
#define BOTTOM_HEIGHT   20.0f
#define CHAT_WIDTH      (CGRectGetWidth(self.bounds) - LEFT_WIDTH)
#define CHAT_HEIGHT     (CGRectGetHeight(self.bounds) - TOP_HEIGHT - BOTTOM_HEIGHT)

@implementation UUVirtualTransactionChatView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = k_NAVIGATION_BAR_COLOR.CGColor;
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;

        [self addLongPressGesture];

        [self configSubViews];
    }
    return self;
}

- (void)addLongPressGesture
{
        //长按
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesAction:)];
        [longPressGes setMinimumPressDuration:0.3f];
        [longPressGes setAllowableMovement:50.0];
        [self addGestureRecognizer:longPressGes];
}

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

- (void)configSubViews
{
    _circleLayer = [CAShapeLayer layer];
    _circleLayer.fillColor = [UIColor whiteColor].CGColor;
    _circleLayer.strokeColor = k_NAVIGATION_BAR_COLOR.CGColor;
    [self.layer addSublayer:_circleLayer];

    //---总收益
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60.0f, 20.0f);
    button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"transaction_ract"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"transaction_ract"] forState:UIControlStateHighlighted];
    _profitRateLabel = button;
    [self addSubview:_profitRateLabel];
    //时间
    
    _dateLabel = [UIKitHelper labelWithFrame:CGRectMake(LEFT_WIDTH + CHAT_WIDTH - 85,k_TOP_MARGIN,85.0f, 15.0f) Font:[UIFont systemFontOfSize:10.0f] textColor:k_MIDDLE_TEXT_COLOR];
    [self addSubview:_dateLabel];
    
    CGFloat labelWidth = LEFT_WIDTH - 4;
    CGFloat labelHeight = 14.0f;
    CGFloat paddingHeight = CHAT_HEIGHT / 4.0f;
    _leftMaxLabel = [UIKitHelper labelWithFrame:CGRectMake(2,TOP_HEIGHT, labelWidth, labelHeight) Font:k_MIDDLE_TEXT_FONT textColor:k_UPPER_COLOR];
    _leftMaxLabel.textAlignment = NSTextAlignmentCenter;
    _leftMaxLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_leftMaxLabel];
    
    _leftMaxPaddingLabel = [UIKitHelper labelWithFrame:CGRectMake(2,TOP_HEIGHT + paddingHeight - labelHeight*0.5, labelWidth, labelHeight) Font:k_MIDDLE_TEXT_FONT textColor:k_UPPER_COLOR];
    _leftMaxPaddingLabel.textAlignment = NSTextAlignmentCenter;
    _leftMaxPaddingLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_leftMaxPaddingLabel];

    _leftMinLabel = [UIKitHelper labelWithFrame:CGRectMake(2,TOP_HEIGHT + CHAT_HEIGHT - labelHeight, labelWidth, labelHeight) Font:k_MIDDLE_TEXT_FONT textColor:k_UNDER_COLOR];
    _leftMinLabel.adjustsFontSizeToFitWidth = YES;
    _leftMinLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_leftMinLabel];
    
    _leftMinPaddingLabel = [UIKitHelper labelWithFrame:CGRectMake(2,TOP_HEIGHT + CHAT_HEIGHT - labelHeight*0.5 - paddingHeight, labelWidth, labelHeight) Font:k_MIDDLE_TEXT_FONT textColor:k_UNDER_COLOR];
    _leftMinPaddingLabel.adjustsFontSizeToFitWidth = YES;
    
    _leftMinPaddingLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_leftMinPaddingLabel];

    _leftMiddelLabel = [UIKitHelper labelWithFrame:CGRectMake(2,TOP_HEIGHT + CHAT_HEIGHT*0.5 - labelHeight*0.5, labelWidth, labelHeight) Font:k_MIDDLE_TEXT_FONT textColor:k_EQUAL_COLOR];
    _leftMiddelLabel.adjustsFontSizeToFitWidth = YES;

    _leftMiddelLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_leftMiddelLabel];
    
    
    //底部日期显示
    _bottomStartDateLabel = [UIKitHelper labelWithFrame:CGRectMake(LEFT_WIDTH,CGRectGetHeight(self.bounds) - BOTTOM_HEIGHT, 100, BOTTOM_HEIGHT) Font:k_SMALL_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    [self addSubview:_bottomStartDateLabel];
    _bottomEndDateLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 100 - k_RIGHT_MARGIN,CGRectGetHeight(self.bounds) - BOTTOM_HEIGHT, 100, BOTTOM_HEIGHT) Font:k_SMALL_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    _bottomEndDateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_bottomEndDateLabel];
}


- (void)setProfitArray:(NSArray *)profitArray
{
    if (profitArray == nil || profitArray == _profitArray) {
        return;
    }
    _profitArray = profitArray;
    
    //获取到最大最小值
    [self getMaxAndMinValue];
    
    [self fillLeftData];
    
    [self setNeedsDisplay];
}

//获取到最大最小收益
- (void)getMaxAndMinValue
{
    UUTransactionHistoryProfitModel *profitModel = [_profitArray firstObject];
    _maxValue = _minValue = profitModel.profitRate;
    
    [_profitArray enumerateObjectsUsingBlock:^(UUTransactionHistoryProfitModel *profitModel, NSUInteger idx, BOOL *stop) {
        
        if (profitModel.profitRate > _maxValue) {
            _maxValue = profitModel.profitRate;
        }else if (profitModel.profitRate < _minValue){
            _minValue = profitModel.profitRate;
        }
    }];
    
    _maxValue = (fabs(_maxValue) > fabs(_minValue) ? fabs(_maxValue):fabs(_minValue)) * 1.5;
    
    if (_maxValue == 0) {
        _maxValue = 0.01;
    }
    _minValue = -_maxValue;
}

- (void)fillLeftData
{
    _leftMaxLabel.text = [NSString stringWithFormat:@"+%.2f%%",_maxValue*100];
    _leftMaxPaddingLabel.text = [NSString stringWithFormat:@"+%.2f%%",_maxValue*0.5*100];
    _leftMiddelLabel.text = @"0.00%";
    _leftMinPaddingLabel.text = [NSString stringWithFormat:@"%.2f%%",_minValue*0.5*100];
    _leftMinLabel.text = [NSString stringWithFormat:@"%.2f%%",_minValue*100];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextClearRect(ref, rect);
    [[UIKitHelper imageWithColor:[UIColor whiteColor]] drawInRect:rect];
    
    //画框
    [self drawBox];
    
    if (_profitArray == nil || _profitArray.count == 0) {
        return;
    }
    
    [self drawLine];
    
    [self drawTopView];
    
    [self circlePositionCenter:CGPointFromString([_pointArray lastObject])];
}

- (void)drawBox
{
    NSInteger lineHorCount = 5;

    CGFloat lineHorMargin = CHAT_HEIGHT / (CGFloat)(lineHorCount - 1);
    
    [[UIKitHelper imageWithColor:[UIColorTools colorWithHexString:@"F8F8F8" withAlpha:0.8f]] drawInRect:CGRectMake(LEFT_WIDTH, TOP_HEIGHT,CHAT_WIDTH ,CHAT_HEIGHT)];
    
    for(NSInteger i = 0;i < lineHorCount;i++)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.5f);
        CGFloat lengths[] = {2,3};
        CGContextSetLineDash(context, 0, lengths,2);
        CGContextSetStrokeColorWithColor(context, k_LINE_COLOR.CGColor);
        CGContextMoveToPoint(context, LEFT_WIDTH, TOP_HEIGHT + lineHorMargin * i);
        CGContextAddLineToPoint(context,LEFT_WIDTH + CHAT_WIDTH, TOP_HEIGHT + lineHorMargin * i);
        CGContextStrokePath(context);
    }
//    //竖线
    NSInteger lineVerCount = 12;
    CGFloat lineVerMargin = CHAT_WIDTH / (CGFloat)(lineVerCount - 1);
    for(NSInteger i = 0;i < lineVerCount;i++)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.5f);
        CGFloat lengths[] = {2,3};
        CGContextSetLineDash(context, 0, lengths,2);
        CGContextSetStrokeColorWithColor(context, k_LINE_COLOR.CGColor);
        CGContextMoveToPoint(context, LEFT_WIDTH + lineVerMargin * i, TOP_HEIGHT);
        CGContextAddLineToPoint(context,LEFT_WIDTH + lineVerMargin * i, TOP_HEIGHT + CHAT_HEIGHT);
        CGContextStrokePath(context);
    }
}

- (void)drawTopView
{
    //总收益，沪深300
    [[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] drawInRect:CGRectMake(LEFT_WIDTH, k_TOP_MARGIN, 10.0f, 10.0f)];
    
    [[UIKitHelper imageWithColor:k_MIDDLE_TEXT_COLOR] drawInRect:CGRectMake(LEFT_WIDTH + 55.0f, k_TOP_MARGIN, 10.0f, 10.0f)];
    
    //名字
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:10.0f],
                                 NSForegroundColorAttributeName : k_MIDDLE_TEXT_COLOR
                                 };
    [@"总收益" drawInRect:CGRectMake(LEFT_WIDTH + 15.0f,k_TOP_MARGIN,40.0f, 15.0f) withAttributes:attributes];
    [@"沪深" drawInRect:CGRectMake(LEFT_WIDTH + 70,k_TOP_MARGIN,40.0f, 15.0f) withAttributes:attributes];
    
    [@"沪深300:--%" drawInRect:CGRectMake(LEFT_WIDTH + 110.0f,k_TOP_MARGIN,80.0f, 15.0f) withAttributes:attributes];
    
    
    _bottomEndDateLabel.text = [NSString stringWithFormat:@"%@",[[_profitArray lastObject] tradeDate]];
    
    _bottomStartDateLabel.text = [NSString stringWithFormat:@"%@",[[_profitArray firstObject] tradeDate]];

}

- (void)drawLine
{

    _pointArray = [NSMutableArray array];

    NSInteger pointCount = _profitArray.count;
    CGFloat lineWidth = 1.0f;
    
    CGFloat lineMargin = (CHAT_WIDTH - k_RIGHT_MARGIN - pointCount * lineWidth) / ((CGFloat)pointCount - 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGFloat lengths[] = {0,0};
    CGContextSetLineDash(context, 0, lengths,0);

    CGContextSetStrokeColorWithColor(context, k_NAVIGATION_BAR_COLOR.CGColor);
    
    UIBezierPath* fillPath = [UIBezierPath bezierPath];
    [fillPath moveToPoint:CGPointMake(LEFT_WIDTH, TOP_HEIGHT+CHAT_HEIGHT)];
    
    [_profitArray enumerateObjectsUsingBlock:^(UUTransactionHistoryProfitModel *profitModel, NSUInteger idx, BOOL *stop) {
        
        CGFloat pointX = idx *(lineMargin + lineWidth) + LEFT_WIDTH;
        CGFloat pointY = [self transformPriceToPointY:profitModel.profitRate];
        CGPoint point = CGPointMake(pointX, pointY);
        
        [fillPath addLineToPoint:point];
        
        if (idx == 0) {
            CGContextMoveToPoint(context, pointX, pointY);
        }
        else
        {
            CGContextAddLineToPoint(context, pointX, pointY);
        }
        
        [_pointArray addObject:NSStringFromCGPoint(point)];
    }];
    
    [fillPath addLineToPoint:CGPointMake(LEFT_WIDTH + CHAT_WIDTH - k_RIGHT_MARGIN - lineWidth, TOP_HEIGHT + CHAT_HEIGHT)];
    
    CGContextStrokePath(context);
    //区域阴影
    CGContextAddPath(context, fillPath.CGPath);
    CGContextSetLineWidth(context, 0);
    CGContextSetFillColorWithColor(context, [k_NAVIGATION_BAR_COLOR colorWithAlphaComponent:0.25].CGColor);
    CGContextFillPath(context);
    CGContextStrokePath(context);
}

//获取到价格所在实际坐标Y
- (double)transformPriceToPointY:(double)price
{
    double priceHeight = _maxValue - _minValue;
    
    if (priceHeight == 0) {
        return 0;
    }
    
    double pointY = (1- (price - _minValue) / priceHeight) * CHAT_HEIGHT + TOP_HEIGHT;
    
    return pointY;
}

#pragma mark 小圆默认位置
- (void)circlePositionCenter:(CGPoint)point
{
    _path = [UIBezierPath bezierPathWithArcCenter:point radius:CIRCLE_RADIUS startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(360) clockwise:NO];
    _circleLayer.path = _path.CGPath;
    
    if ([_pointArray containsObject:NSStringFromCGPoint(point)]) {
     
        NSInteger index = [_pointArray indexOfObject:NSStringFromCGPoint(point)];

        UUTransactionHistoryProfitModel *profitModel = [_profitArray objectAtIndex:index];
        
        NSString *profit = [NSString stringWithFormat:@"%.2f%%",profitModel.profitRate];
        NSString *temp = [NSString stringWithFormat:@"总收益 %@",profit];
        
        UIColor *color = k_EQUAL_COLOR;
        if ([profit floatValue] > 0) {
            color = k_UPPER_COLOR;
        }else if ([profit floatValue] < 0){
            color = k_UNDER_COLOR;
        }
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:temp];
        [attString setAttributes:@{NSForegroundColorAttributeName:color} range:[temp rangeOfString:profit]];
        [_profitRateLabel setAttributedTitle:attString forState:UIControlStateNormal];
        
        CGRect frame = _profitRateLabel.frame;
        frame.origin.x = point.x - CGRectGetWidth(frame) - k_LEFT_MARGIN * 0.5;
        frame.origin.y = point.y - CGRectGetHeight(frame) - k_TOP_MARGIN * 0.5;
        
        if (point.x - LEFT_WIDTH < CGRectGetWidth(frame)) {
            frame.origin.x = point.x + k_LEFT_MARGIN;
        }
        
        _profitRateLabel.frame = frame;
        
        //时间
        NSString *date = [NSString stringWithFormat:@"日期:%@",[_profitArray[index] tradeDate]];
        _dateLabel.text = date;

        if (!_profitRateLabel.superview) {
            [self addSubview:_profitRateLabel];
        }
    }
}

#pragma mark - 长按手势
- (void)longPressGesAction:(UIGestureRecognizer *)ges
{
    
    CGPoint currentPoint = [ges locationInView:ges.view];
    
    if (ges.state == UIGestureRecognizerStateChanged)
    {
        for (int i = 0; i < _pointArray.count; i++) {
            CGPoint point = CGPointFromString([_pointArray objectAtIndex:i]);
            if (fabs(currentPoint.x - point.x) < 1) {
                [self circlePositionCenter:point];
            }
        }
    }
    else if (ges.state == UIGestureRecognizerStateEnded)
    {
        [self circlePositionCenter:CGPointFromString([_pointArray lastObject])];
    }
}
@end


@implementation UUVirtualTransactionView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = k_BG_COLOR;
        self.alwaysBounceVertical = YES;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _headerView = [[UUVirtualTransactionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), UUVirtualTransactionHeaderViewHeight)];
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_headerView];
    
    _chatView = [[UUVirtualTransactionChatView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, CGRectGetHeight(_headerView.frame) + k_TOP_MARGIN, PHONE_WIDTH - 2 * k_LEFT_MARGIN, UUVirtualTransactionChatViewHeight)];
    [self addSubview:_chatView];
    
    //股票交易详解
    CGFloat buttonWith = 124.0f;
    //股票交易规则
    UIButton *stockDealButton = [UIKitHelper buttonWithFrame:CGRectMake(PHONE_WIDTH - buttonWith - k_LEFT_MARGIN,CGRectGetMaxY(_chatView.frame) ,buttonWith,40.0f) title:@"查看交易分析" titleHexColor:@"474747" font:k_BIG_TEXT_FONT];
    [stockDealButton setBackgroundImage:[UIKitHelper imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [stockDealButton setImage:[UIImage imageNamed:@"transaction_jiaoyifenxi"] forState:UIControlStateNormal];
    [stockDealButton setImage:[UIImage imageNamed:@"transaction_jiaoyifenxi_hilighted"] forState:UIControlStateHighlighted];
    [stockDealButton setTitleColor:k_NAVIGATION_BAR_COLOR forState:UIControlStateHighlighted];

    stockDealButton.tag = 5;
    stockDealButton.imageEdgeInsets = UIEdgeInsetsMake(0, -CGRectGetWidth(stockDealButton.frame) * 0.4, 0, 0);
    stockDealButton.titleEdgeInsets = UIEdgeInsetsMake(0, -CGRectGetWidth(stockDealButton.frame) * 0.3, 0, 0);
    stockDealButton.titleLabel.font = k_MIDDLE_TEXT_FONT;
    [self addSubview:stockDealButton];
    UIImage *tempArrowImage = [UIImage imageNamed:@"Stock_list_more"];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:tempArrowImage];
    tempImageView.center = CGPointMake(CGRectGetWidth(stockDealButton.frame) - tempArrowImage.size.width * 0.5, CGRectGetHeight(stockDealButton.frame) * 0.5);
    [stockDealButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

    [stockDealButton addSubview:tempImageView];
    
    
    //按钮
    [self addSubview:stockDealButton];
    NSArray *titles = @[@"买入",@"卖出",@"撤单",@"持仓",@"查询"];
    NSArray *colors = @[@"ff5c5c",@"5cd27d",@"5dadff",@"d878f0",@"f08c2b"];

//    CGFloat buttonWidth = 46.0f;
//    CGFloat buttonHeight = 46.0f;
    CGFloat buttonViewWidth = PHONE_WIDTH / (CGFloat)titles.count;
//    CGFloat margin = (buttonViewWidth - buttonWidth) * 0.5;

    CGFloat margin = k_LEFT_MARGIN;
    CGFloat buttonWidth = (PHONE_WIDTH - margin * 2 * titles.count) / (CGFloat)titles.count;
    CGFloat buttonHeight = buttonWidth;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        CGRect frame = CGRectMake(margin + i * buttonViewWidth, CGRectGetMaxY(_chatView.frame) + 40.0f, buttonWidth, buttonHeight);
        UIButton *button = [UIKitHelper buttonWithFrame:frame title:titles[i] titleHexColor:@"FFFFFF" font:k_SMALL_TEXT_FONT];
        button.tag = i;
        button.layer.cornerRadius = buttonWidth * 0.5;
        button.layer.masksToBounds = YES;
        [button setBackgroundImage:[UIKitHelper imageWithColor:[UIColorTools colorWithHexString:colors[i] withAlpha:1.0f]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    //股票交易规则
    UIButton *stockRuleDetailButton = [UIKitHelper buttonWithFrame:CGRectMake(0,CGRectGetMaxY(_chatView.frame) + buttonHeight + 50, PHONE_WIDTH, 64.0f) title:@"股票交易规则详解" titleHexColor:@"474747" font:k_BIG_TEXT_FONT];
    stockRuleDetailButton.tag = 6;
    [stockRuleDetailButton setBackgroundImage:[UIKitHelper imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [stockRuleDetailButton setImage:[UIImage imageNamed:@"transaction_jiaoyixingjie"] forState:UIControlStateNormal];
    
    stockRuleDetailButton.imageEdgeInsets = UIEdgeInsetsMake(0, -CGRectGetWidth(stockRuleDetailButton.frame) * 0.5, 0, 0);
    stockRuleDetailButton.titleEdgeInsets = UIEdgeInsetsMake(0, -CGRectGetWidth(stockRuleDetailButton.frame) * 0.4, 0, 0);
    stockRuleDetailButton.titleLabel.font = k_MIDDLE_TEXT_FONT;
    [stockRuleDetailButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

//    [self addSubview:stockRuleDetailButton];

    UIImage *arrowImage = [UIImage imageNamed:@"Stock_list_more"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:arrowImage];
    imageView.center = CGPointMake(PHONE_WIDTH - k_LEFT_MARGIN * 2 - arrowImage.size.width * 0.5, CGRectGetHeight(stockRuleDetailButton.frame) * 0.5);
    [stockRuleDetailButton addSubview:imageView];
    
    self.contentSize = CGSizeMake(PHONE_WIDTH, CGRectGetMaxY(stockRuleDetailButton.frame));
}

- (void)buttonAction:(UIButton *)button
{
    if ([_transactionDelegate respondsToSelector:@selector(transactionView:didSelectedIndex:)]) {
        [_transactionDelegate transactionView:self didSelectedIndex:button.tag];
    }
}

- (void)setAssetModel:(UUTransactionAssetModel *)assetModel
{
    if (assetModel == nil || _assetModel == assetModel) {
        return;
    }
    _assetModel = assetModel;
    _headerView.assetModel = _assetModel;
}
@end


