//
//  UURemindViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UURemindViewCell.h"

@implementation UURemindViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubViews];
        
    }
    return self;
}

- (void)configSubViews
{
    UIImage *image = [UIImage imageNamed:@"fav_remind_selected"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 16.0f, image.size.width, image.size.height)];
    imageView.image = image;
    [self.contentView addSubview:imageView];
    
    
    _nameLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + k_LEFT_MARGIN, 16.0f, 200.0f, 20.0f) Font:k_BIG_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
   
    _nameLabel.text = @"张江高科(600876)";
    
    [self.contentView addSubview:_nameLabel];
    
    
    
    _textLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + k_LEFT_MARGIN, UURemindViewCellHeight - 36.0f, 250.0f, 20.0f) Font:k_MIDDLE_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    NSString *text = @"18.8";
    NSString *str = [NSString stringWithFormat: @"该股价上涨到%@元了",text];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:str];
    [attString setAttributes:@{NSFontAttributeName:k_MIDDLE_TEXT_FONT,NSForegroundColorAttributeName:k_UPPER_COLOR} range:[str rangeOfString:text]];
    _textLabel.attributedText = attString;
    [self.contentView addSubview:_textLabel];
    
    _dateLabel = [UIKitHelper labelWithFrame:CGRectMake(PHONE_WIDTH - 270.0f, CGRectGetMinY(_textLabel.frame), 250.0f, 20.0f) Font:k_SMALL_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.text = @"2015-7-18 11:34";
    [self.contentView addSubview:_dateLabel];
}


/*
 *重新设置frame
 */
- (void)setFrame:(CGRect)frame
{
//    frame.origin.x += k_LEFT_MARGIN;
//    //    frame.origin.y += k_TOP_MARGIN;
//    frame.size.width -= k_LEFT_MARGIN * 2;
    frame.size.height -= k_TOP_MARGIN;
    [super setFrame:frame];
}

@end
