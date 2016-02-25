//
//  UUVirtualTansactionSelectViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/7/23.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUVirtualTansactionSelectViewCell.h"

@implementation UUVirtualTansactionSelectViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, UUVirtualTansactionSelectViewCellHeight - 0.5, CGRectGetWidth(self.contentView.frame), 0.5f)];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lineView.backgroundColor = k_LINE_COLOR;
    [self.contentView addSubview:lineView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Stock_list_more"]];
    imageView.center = CGPointMake(CGRectGetWidth(self.contentView.frame) - k_RIGHT_MARGIN * 2 - CGRectGetWidth(imageView.frame), UUVirtualTansactionSelectViewCellHeight * 0.5);
    [self.contentView addSubview:imageView];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _textLabel = [UIKitHelper labelWithFrame:CGRectMake(k_LEFT_MARGIN * 2, 0, 200.0f, UUVirtualTansactionSelectViewCellHeight) Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    
    [self.contentView addSubview:_textLabel];
}

- (void)setText:(NSString *)text
{
    _textLabel.text = text;
}

@end
