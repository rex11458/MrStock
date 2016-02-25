//
//  UUCommunityHeaderTableViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/30.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUCommunityHeaderTableViewCell.h"

@implementation UUCommunityHeaderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = k_BG_COLOR;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubViews];
    }
    
    return self;
}

- (void)configSubViews
{
    UIImage *image = [UIImage imageNamed:@"Community_ding"];
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, UUCommunityHeaderTableViewCellHeight)];
    _topImageView.image = image;
    _topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_topImageView];
    
    image = [UIImage imageNamed:@"Community_quintessence"];
    _quintessenceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN + CGRectGetMaxX(_topImageView.frame), 0, image.size.width, UUCommunityHeaderTableViewCellHeight)];
    _quintessenceImageView.image = image;
    _quintessenceImageView.contentMode = UIViewContentModeScaleAspectFit;

    [self.contentView addSubview:_quintessenceImageView];
    
    _textLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(_quintessenceImageView.frame) + k_LEFT_MARGIN, 0, CGRectGetWidth(self.bounds) - CGRectGetMaxX(_quintessenceImageView.frame) - 2 * k_LEFT_MARGIN, UUCommunityHeaderTableViewCellHeight) Font:[UIFont boldSystemFontOfSize:14.0f] textColor:k_BIG_TEXT_COLOR];
    _textLabel.text = @"知行合一：牛市未完 出入平安";
    [self.contentView addSubview:_textLabel];
}

/*
 *重新设置frame
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.x += k_LEFT_MARGIN;
    //    frame.origin.y += k_TOP_MARGIN;
    frame.size.width -= k_LEFT_MARGIN * 2;
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context,k_LINE_COLOR.CGColor);
    CGContextMoveToPoint(context, 0, CGRectGetHeight(self.bounds));
    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGContextStrokePath(context);
}

@end
