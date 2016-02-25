//
//  UUPersonalSettingViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/8/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalSettingViewCell.h"

@implementation UUPersonalSettingViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    _textLabel = [UIKitHelper labelWithFrame:CGRectMake(2 * k_LEFT_MARGIN, 0, 200.f, UUPersonalSettingViewCellHeight) Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    [self.contentView addSubview:_textLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Stock_list_more"]];
    imageView.center = CGPointMake(PHONE_WIDTH - 3 * k_LEFT_MARGIN, UUPersonalSettingViewCellHeight * 0.5);
    [self.contentView addSubview:imageView];
    _arrowImageView = imageView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, UUPersonalSettingViewCellHeight - 0.5, PHONE_WIDTH, 0.5f)];
    lineView.backgroundColor = k_LINE_COLOR;
    [self.contentView addSubview:lineView];
    
}

- (void)setText:(NSString *)text
{
    if (text == nil || _text == text) {
        return;
    }
    _text = text;
    _textLabel.text = _text;
}
@end
