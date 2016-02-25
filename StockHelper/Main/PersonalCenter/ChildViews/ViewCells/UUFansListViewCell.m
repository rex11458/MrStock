//
//  UUFansListViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/8/6.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFansListViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UUFocusModel.h"
@implementation UUFansListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = k_BG_COLOR;
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN, UUFansListViewCellHeight - 0.5, PHONE_WIDTH - 2 * k_LEFT_MARGIN, 0.5f)];
    lineView.backgroundColor = k_LINE_COLOR;
    [self.contentView addSubview:lineView];
    
    CGFloat imageHeight = 40.0f;
    CGFloat imageWidth = 40.0f;
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN,( UUFansListViewCellHeight - imageHeight) * 0.5, imageWidth, imageHeight)];
    _headerImageView.layer.cornerRadius = imageHeight * 0.5;
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.image = [UIImage imageNamed:@"Me_default_icon"];
    [self.contentView addSubview:_headerImageView];
    
    _textLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + k_LEFT_MARGIN, 0, PHONE_WIDTH - CGRectGetMaxX(_headerImageView.frame) - 2 *k_LEFT_MARGIN, UUFansListViewCellHeight) Font:k_MIDDLE_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _textLabel.numberOfLines = 0;
    [self.contentView addSubview:_textLabel];
}

- (void)setFocusModel:(UUFocusModel *)focusModel
{
    if (focusModel == nil || _focusModel == focusModel) {
        return;
    }
    _focusModel  = focusModel;
    
    [self fillData];
}

- (void)fillData
{
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_focusModel.headImg] placeholderImage:[UIImage imageNamed:@"Me_default_icon"]];
    
    NSString *name = _focusModel.nickName;
    NSString *text = _focusModel.depict;
    NSString *str = [NSString stringWithFormat:@"%@\n%@",name,text];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:text];
    [attString setAttributes:@{NSFontAttributeName:k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:k_MIDDLE_TEXT_COLOR} range:range];
    _textLabel.attributedText = attString;
}

@end
