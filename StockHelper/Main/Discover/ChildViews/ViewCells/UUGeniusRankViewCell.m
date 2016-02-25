//
//  UUGeniusRankViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/7/16.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUGeniusRankViewCell.h"
#import "UUGeniusModel.h"
#import <SDWebImage/UIButton+WebCache.h>
#define USER_INFO_HEIGHT 57.0f
#define USER_PROFIT_INFO_HEIGHT (UUGeniusRankViewCellHeight - USER_INFO_HEIGHT)

#define LEFT_BG_IAMGE_WDITH 84.0f
#define CONTENT_WIDTH  (CGRectGetWidth(self.bounds) - LEFT_BG_IAMGE_WDITH)

@implementation UUGeniusRankViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubViews];
        
        _colors = @[@"F05018",@"F0B544",@"55DCF0",@"DBDBDB"];
        _imageNames = @[@"genius_steady",@"genius_highYield",@"genius_exuberant"];
    }
    return self;
}

- (void)configSubViews
{
    _leftBGImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_leftBGImageView];

    
    
    _rankLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont italicSystemFontOfSize:24.0f] textColor:[UIColor whiteColor]];
    _rankLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_rankLabel];
    
    _nameLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont boldSystemFontOfSize:14.0f] textColor:[UIColor whiteColor]];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = @"";
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_nameLabel];
 
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28.0f, 28.0f)];
    _imageView.backgroundColor = [UIColor whiteColor];
    _imageView.layer.cornerRadius = 28 * 0.5;
    _imageView.layer.masksToBounds = YES;
    _imageView.image = [UIImage imageNamed:@"discover_wjw"];
    [self.contentView addSubview:_imageView];
    
    _headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headImageButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    _headImageButton.layer.cornerRadius = CGRectGetWidth(_headImageButton.frame) * 0.5;
    _headImageButton.layer.masksToBounds = YES;
    _headImageButton.userInteractionEnabled = NO;
//    [_headImageButton setImage:[UIKitHelper imageWithColor:[UIColor purpleColor]] forState:UIControlStateNormal];
    _headImageButton.backgroundColor = [UIColor whiteColor];
    [_headImageButton setImage:[UIImage imageNamed:@"default_headerImage"] forState:UIControlStateNormal];
    [self.contentView addSubview:_headImageButton];
    
    //模拟交易
    _tradeTypeButton = [UIKitHelper buttonWithFrame:CGRectZero title:@"模拟交易" titleHexColor:@"474747" font:k_MIDDLE_TEXT_FONT];
    _tradeTypeButton.imageEdgeInsets = UIEdgeInsetsMake(0,-15, 0, 0);
    _tradeTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    _tradeTypeButton.userInteractionEnabled = NO;
    [_tradeTypeButton setImage:[UIImage imageNamed:@"Me_monijiaoyi"] forState:UIControlStateNormal];
    
    [self.contentView addSubview:_tradeTypeButton];
    //总收益
    _profitContentLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont boldSystemFontOfSize:16.0f] textColor:[UIColorTools colorWithHexString:@"F8102B" withAlpha:1.0f]];
    _profitContentLabel.text = @"--%";
    _profitContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_profitContentLabel];
    
    _profitLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    _profitLabel.text = @"总收益";
    _profitLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_profitLabel];
    
    //日收益，仓位
    _dailyProfitContentLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:[UIColorTools colorWithHexString:@"F8102B" withAlpha:1.0f]];
    _dailyProfitContentLabel.text = @"--%";
    _dailyProfitContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_dailyProfitContentLabel];
    
    _dailyProfitLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _dailyProfitLabel.textAlignment = NSTextAlignmentCenter;
    _dailyProfitLabel.text = @"日收益";
    [self.contentView addSubview:_dailyProfitLabel];
    
    _holdContentLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _holdContentLabel.text = @"--%";
    _holdContentLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:_holdContentLabel];
    
    _holdLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _holdLabel.textAlignment = NSTextAlignmentCenter;
    _holdLabel.text = @"仓位";
    [self.contentView addSubview:_holdLabel];
    
    //胜率，月交易次数
    
    _earnProfitContentLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _earnProfitContentLabel.text = @"0.00%";
    _earnProfitContentLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:_earnProfitContentLabel];
    
    _earnProfitLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _earnProfitLabel.textAlignment = NSTextAlignmentCenter;
    _earnProfitLabel.text = @"胜率";
    [self.contentView addSubview:_earnProfitLabel];
    
    
    _tradeTimesContentlabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _tradeTimesContentlabel.text = @"0";
    _tradeTimesContentlabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_tradeTimesContentlabel];
    
    _tradeTimesLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _tradeTimesLabel.textAlignment = NSTextAlignmentCenter;
    _tradeTimesLabel.text = @"月均交易次数";
    [self.contentView addSubview:_tradeTimesLabel];
    
    //波动率，平均持仓天数
    
    _undulateContentLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _undulateContentLabel.text = @"0.00%";
    _undulateContentLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:_undulateContentLabel];
    
    _undulateLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _undulateLabel.textAlignment = NSTextAlignmentCenter;
    _undulateLabel.text = @"最大回撤率";
    [self.contentView addSubview:_undulateLabel];
    
    
    _holdDateContentLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _holdDateContentLabel.text = @"0";
    _holdDateContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_holdDateContentLabel];
    
    _holdDateLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _holdDateLabel.textAlignment = NSTextAlignmentCenter;
    _holdDateLabel.text = @"平均持股(天)";
    [self.contentView addSubview:_holdDateLabel];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == _indexPath) {
        return;
    }
    _indexPath = indexPath;

    if (_indexPath.row < 3) {
        self.color = [UIColorTools colorWithHexString:_colors[_indexPath.row] withAlpha:1.0f];
    }else{
        self.color = [UIColorTools colorWithHexString:[_colors lastObject] withAlpha:1.0f];
    }
    
    _rankLabel.text = [@(_indexPath.row + 1) stringValue];
    
    NSInteger index = indexPath.row < 3 ? indexPath.row : 3;
    
    NSString *imageName = [[_imageNames objectAtIndex:_type] stringByAppendingString:[NSString stringWithFormat:@"_%@",@(index)]];

    _imageView.image = [UIImage imageNamed:imageName];
    
    _leftBGImageView.image = [UIKitHelper imageWithColor:self.color];

    [self setNeedsDisplay];
}

- (void)setGeniusModel:(UUGeniusModel *)geniusModel
{
    if (geniusModel == nil || _geniusModel == geniusModel) {
        return;
    }
    _geniusModel = geniusModel;
    [self fillData];
}

- (void)fillData
{
    [_headImageButton sd_setImageWithURL:[NSURL URLWithString:_geniusModel.userPic] forState:UIControlStateNormal];
    _nameLabel.text = _geniusModel.userName;
    
    //如果是人气王显示粉丝数
    if (self.type == UUGeniusExuberantType)
    {
        _profitLabel.text = @"粉丝数";
        //粉丝数
        _profitContentLabel.text = [NSString stringWithFormat:@"%ld",_geniusModel.fans];
        //显示总收益
        _dailyProfitLabel.text = @"总收益";
        NSArray *array = [self profitString:_geniusModel.profitRate];
        _dailyProfitContentLabel.text = array[0];
        _dailyProfitContentLabel.textColor = array[1];

    }else
    {
        _profitLabel.text = @"总收益";
        //总收益率
        NSArray *array = [self profitString:_geniusModel.profitRate];
        _profitContentLabel.text = array[0];
        _profitContentLabel.textColor = array[1];
        //日收益
        _dailyProfitLabel.text = @"月收益";
        array = [self profitString:_geniusModel.monthProfit];
        _dailyProfitContentLabel.text = array[0];
        _dailyProfitContentLabel.textColor = array[1];
    }
    
   //胜率
    _earnProfitContentLabel.text =  [NSString stringWithFormat:@"%.0f%%",_geniusModel.winrate * 100];
    //最大回撤率
    _undulateContentLabel.text = [NSString stringWithFormat:@"%.0f%%",_geniusModel.retracement * 100];
    
    //仓位
    _holdContentLabel.text = [NSString stringWithFormat:@"%.0f%%",_geniusModel.position * 100];
    //月均交易次数
    _tradeTimesContentlabel.text = [@(_geniusModel.avgTrade) stringValue];
    //平均持仓天数
    _holdDateContentLabel.text = [@(_geniusModel.avgPosition) stringValue];
}

- (NSArray *)profitString:(CGFloat)profit
{
    //收益
    NSString *profitString = [NSString stringWithFormat:@"%.0f%%",profit * 100];
    UIColor *color = k_EQUAL_COLOR;
    if (profit < 0) {
        color = k_UNDER_COLOR;
    }else if (profit > 0){
        color = k_UPPER_COLOR;
        profitString = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%.0f%%",fabs(profit * 100)]];
    }
    return @[profitString,color];
}

/*
 *重新设置frame
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.x += k_LEFT_MARGIN;
        frame.origin.y += k_TOP_MARGIN * 0.5;
    frame.size.width -= k_LEFT_MARGIN * 2;
    frame.size.height -= k_TOP_MARGIN;
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, k_LINE_COLOR.CGColor);
    CGFloat lengths[] = {10,5};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, 0, USER_INFO_HEIGHT);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), USER_INFO_HEIGHT);
    CGContextStrokePath(context);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _leftBGImageView.frame = CGRectMake(0, 0, LEFT_BG_IAMGE_WDITH, UUGeniusRankViewCellHeight - k_BOTTOM_MARGIN);
    _imageView.frame = CGRectMake(16.0f, 14.0f, 28.0f, 28.0f);
    _rankLabel.frame = CGRectMake(CGRectGetMaxX(_imageView.frame), CGRectGetMinY(_imageView.frame), LEFT_BG_IAMGE_WDITH - CGRectGetMaxX(_imageView.frame), CGRectGetHeight(_imageView.frame));
    
    _nameLabel.frame = CGRectMake(0,UUGeniusRankViewCellHeight - k_TOP_MARGIN - 28.0f, LEFT_BG_IAMGE_WDITH, 28.0f);
    
    _headImageButton.frame = CGRectMake(22,USER_INFO_HEIGHT + k_TOP_MARGIN, 40.0f, 40.0f);
    
    _tradeTypeButton.frame = CGRectMake(k_LEFT_MARGIN + LEFT_BG_IAMGE_WDITH, 0, CONTENT_WIDTH * 0.5, USER_INFO_HEIGHT);
    
    _profitContentLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - CONTENT_WIDTH * 0.25, 0, CONTENT_WIDTH * 0.25, USER_INFO_HEIGHT);
    
    _profitLabel.frame = CGRectMake(CGRectGetMinX(_profitContentLabel.frame) - CONTENT_WIDTH * 0.25, 0, CONTENT_WIDTH * 0.25, USER_INFO_HEIGHT);
    
    CGFloat labelWidth = CONTENT_WIDTH / 3.0f;
    CGFloat labelHeight = 15.0f;
    _dailyProfitContentLabel.frame = CGRectMake(LEFT_BG_IAMGE_WDITH, USER_INFO_HEIGHT + k_TOP_MARGIN * 0.5, labelWidth, labelHeight);
    _dailyProfitLabel.frame = CGRectMake(CGRectGetMinX(_dailyProfitContentLabel.frame), CGRectGetMaxY(_dailyProfitContentLabel.frame), labelWidth, labelHeight);
    
    _holdLabel.frame = CGRectMake(CGRectGetMinX(_dailyProfitContentLabel.frame), UUGeniusRankViewCellHeight - labelHeight - 1.5 * k_TOP_MARGIN, labelWidth, labelHeight);
    _holdContentLabel.frame = CGRectMake(CGRectGetMinX(_dailyProfitContentLabel.frame), CGRectGetMinY(_holdLabel.frame) - labelHeight, labelWidth, labelHeight);
    
    

    _earnProfitContentLabel.frame = CGRectMake(CGRectGetMaxX(_dailyProfitContentLabel.frame), CGRectGetMinY(_dailyProfitContentLabel.frame), labelWidth, labelHeight);
    _earnProfitLabel.frame = CGRectMake(CGRectGetMaxX(_dailyProfitLabel.frame) , CGRectGetMinY(_dailyProfitLabel.frame), labelWidth, labelHeight);
//
    _tradeTimesContentlabel.frame = CGRectMake(CGRectGetMaxX(_dailyProfitContentLabel.frame), CGRectGetMinY(_holdContentLabel.frame), labelWidth, labelHeight);
    _tradeTimesLabel.frame = CGRectMake(CGRectGetMaxX(_holdLabel.frame), CGRectGetMinY(_holdLabel.frame), labelWidth, labelHeight);
    
  
    _undulateContentLabel.frame = CGRectMake(CGRectGetMaxX(_earnProfitContentLabel.frame), CGRectGetMinY(_earnProfitContentLabel.frame), labelWidth, labelHeight);
    _undulateLabel.frame = CGRectMake(CGRectGetMaxX(_earnProfitLabel.frame), CGRectGetMinY(_earnProfitLabel.frame), labelWidth, labelHeight);
    
    _holdDateContentLabel.frame = CGRectMake(CGRectGetMaxX(_tradeTimesContentlabel.frame), CGRectGetMinY(_tradeTimesContentlabel.frame), labelWidth, labelHeight);
    _holdDateLabel.frame = CGRectMake(CGRectGetMaxX(_tradeTimesLabel.frame), CGRectGetMinY(_tradeTimesLabel.frame), labelWidth, labelHeight);
//
}

@end
