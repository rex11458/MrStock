//
//  UUStockDetailF10InfoView.m
//  StockHelper
//
//  Created by LiuRex on 15/6/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUStockDetailF10Info.h"
#import "UUStockDetailF10CompanyProfileViewCell.h"
#import "UUStockDetailF10CompanyFinanceViewCell.h"
#import "UUStockDetailF10CompanyShareHolderViewCell.h"
#define UUStockDetailF10CompanyShareHolderSectionViewHeight (PHONE_HEIGHT * 0.5)
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation UUStockDetailF10DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"UUStockDetailF10CompanyProfileViewCell";
        
        UUStockDetailF10CompanyProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[UUStockDetailF10CompanyProfileViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        return cell;
    }else if (indexPath.section < 4){
        
        static NSString *cellId = @"UUStockDetailF10CompanyFinanceViewCell";
        
        UUStockDetailF10CompanyFinanceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[UUStockDetailF10CompanyFinanceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        return cell;
  
    }else{
        static NSString *cellId = @"UUStockDetailF10CompanyShareHolderViewCell";
        
        UUStockDetailF10CompanyShareHolderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[UUStockDetailF10CompanyShareHolderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        NSString *hexColorString = indexPath.row %2 ? @"#F000000" : @"#F6F6F6" ;
        
        cell.contentView.backgroundColor = [UIColorTools colorWithHexString:hexColorString withAlpha:1.0f];
        return cell;
    }
}

@end



@interface UUStockDetailF10SectionView ()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation UUStockDetailF10SectionView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(26.0f, 0, 100.0f, 30.0f)];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"简况";
        [self addSubview:titleLabel];
        UUStockDetailF10SectionSubView *subView = [[UUStockDetailF10SectionSubView alloc] initWithFrame:CGRectMake(0, 30.0f, CGRectGetWidth(self.bounds), 44.0f)];
        [self addSubview:subView];
        self.subView = subView;
        
    }
    return self;
}

- (void)layoutSubviews
{
    _titleLabel.frame = CGRectMake(26.0f, 0,200.0f , CGRectGetHeight(self.bounds));
}

@end


@implementation UUStockDetailF10SectionSubView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(26.0f, 0, 100.0f, 44.0f)];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        titleLabel.textColor = k_BIG_TEXT_COLOR;
        titleLabel.text = @"公司简介";
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,6.0f);
    
    CGPoint startPoint = CGPointMake(k_LEFT_MARGIN + 3.0f, (CGRectGetHeight(rect) - 30) * 0.5);
    CGPoint endPoint = CGPointMake(k_LEFT_MARGIN + 3.0f, (CGRectGetHeight(rect) - 30) * 0.5 + 30);
    CGContextSetStrokeColorWithColor(context,[UIColorTools colorWithHexString:@"#FF5C5C" withAlpha:1.0f].CGColor);
    
    const CGPoint points[] = {startPoint,endPoint};
    CGContextStrokeLineSegments(context, points, 2);
    
    CGContextStrokePath(context);
    
    //3.设置图形上下文属性
    //    [[UIColor whiteColor]setStroke];//设置红色边框
    //[[UIColor blueColor]set];//同时设置填充和边框色
}

- (void)layoutSubviews
{
    _titleLabel.frame = CGRectMake(26.0f, 0,200.0f , CGRectGetHeight(self.bounds));
}

@end

@interface UUStockDetailF10CompanyShareHolderSectionView ()
{
    UILabel *_totalLabel;
    UILabel *_circulateLabel;
}
@end

@implementation UUStockDetailF10CompanyShareHolderSectionView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configSubViews];

    }
    return self;
}

- (void)configSubViews
{
    _sectionView = [[UUStockDetailF10SectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 74.0f)];
    [self addSubview:_sectionView];
    
    _subView = [[UUStockDetailF10SectionSubView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 44.0f, CGRectGetWidth(self.bounds), 44.0f)];
    [self addSubview:_subView];
    _outerCircleLayer = [CAShapeLayer layer];
    UIBezierPath *outerCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) * 0.25 + 26, CGRectGetWidth(self.bounds) * 0.25 + 74) radius:self.frame.size.height * 0.25 startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    _outerCircleLayer.path = outerCirclePath.CGPath;
    _outerCircleLayer.lineWidth = 20.0f;
    _outerCircleLayer.fillColor = [UIColor clearColor].CGColor;
    _outerCircleLayer.strokeColor = [UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f].CGColor;
    
    _outerCircleLayer.lineCap     = kCALineCapRound;
    [self.layer addSublayer:_outerCircleLayer];
    
    
    
    UIBezierPath *innerCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) * 0.25 + 26, CGRectGetWidth(self.bounds) * 0.25 + 74.0f) radius:self.frame.size.height * 0.25 - 20.0f startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(90) clockwise:YES];
    _innerCircleLayer = [CAShapeLayer layer];
    _innerCircleLayer.path = innerCirclePath.CGPath;
    _innerCircleLayer.lineWidth = 20.0f;
    _innerCircleLayer.fillColor = [UIColor clearColor].CGColor;
    _innerCircleLayer.strokeColor = [UIColorTools colorWithHexString:@"#FFB401" withAlpha:1.0f].CGColor;
    
    _innerCircleLayer.lineCap     = kCALineCapSquare;
    [self.layer addSublayer:_innerCircleLayer];
    
    _totalLabel = [UIKitHelper labelWithFrame:CGRectMake(200, 150, 100, 40) Font:[UIFont systemFontOfSize:12.0f] textColor:[UIColor blackColor]];
    _totalLabel.text = @"总股本:5.96亿股";
    [self addSubview:_totalLabel];
    _circulateLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont systemFontOfSize:12.0f] textColor:[UIColor blackColor]];
    _circulateLabel.text = @"流通股本:2.96亿股";

    [self addSubview:_circulateLabel];
}

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIKitHelper imageWithColor:[UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f]];
    
    [image drawInRect:CGRectMake(CGRectGetWidth(self.bounds) * 0.5 + 26.0f + k_LEFT_MARGIN,CGRectGetHeight(self.bounds) * 0.5, 10.0f, 10.0f)];
    
    image = [UIKitHelper imageWithColor:[UIColorTools colorWithHexString:@"#FFB401" withAlpha:1.0f]];
    [image drawInRect:CGRectMake(CGRectGetWidth(self.bounds) * 0.5 + 26.0f + k_LEFT_MARGIN,CGRectGetHeight(self.bounds) * 0.5 + 20.0f, 10.0f, 10.0f)];
}

- (void)layoutSubviews
{
    
    
    _totalLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.5 + 26.0f + k_LEFT_MARGIN * 2, CGRectGetHeight(self.bounds) * 0.5 - 5.0f, 150.0f, 20.0f);
    _circulateLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.5 + 26.0f + k_LEFT_MARGIN * 2 , CGRectGetHeight(self.bounds) * 0.5+ 20.0f - 5.0f, 150.0f, 20.0f);
}

@end




@implementation UUStockDetailF10Info

- (id)init
{
    if (self = [super init]) {
        

//
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 2)
    {
        
   UUStockDetailF10SectionView *f10SectionView = [[UUStockDetailF10SectionView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, 74.0f)];
        return f10SectionView;
        
    }else if (section == 4)
    {
        UUStockDetailF10CompanyShareHolderSectionView *holderSectionView = [[UUStockDetailF10CompanyShareHolderSectionView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, UUStockDetailF10CompanyShareHolderSectionViewHeight)];
        return holderSectionView;
    
    }else
    {
        UUStockDetailF10SectionSubView *f10SectionSubView = [[UUStockDetailF10SectionSubView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, 44.0f)];
        return f10SectionSubView;
    }
    


    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < 2) {
        return 74.0f;
    }else if (section == 4)
    {
        return UUStockDetailF10CompanyShareHolderSectionViewHeight;
    }else{
        return 44.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return k_F10INFO_HEIGHT;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 200;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


@end






