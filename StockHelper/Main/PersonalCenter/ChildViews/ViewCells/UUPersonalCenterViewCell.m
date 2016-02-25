//
//  UUPersonalCenterViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/7/2.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalCenterViewCell.h"

@interface UUPersonalCenterViewCell ()
{
    UIImageView *_imageView;
    UILabel     *_titleLabel;
//    UILabel     *_subTitleLabel;
    UIButton    *_messageRemindButton;
    
}
@end

@implementation UUPersonalCenterViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self configSubViews];
        
    }
    return self;
}

- (void)configSubViews
{
    CGFloat imageWidth = 45.0f;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN * 2,(UUPersonalCenterViewCellHeight - imageWidth) * 0.5, imageWidth, imageWidth)];
    [self.contentView addSubview:_imageView];
    
    _titleLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) + 2 * k_LEFT_MARGIN,0, 200.0f, UUPersonalCenterViewCellHeight) Font:[UIFont boldSystemFontOfSize:16.0f] textColor:k_BIG_TEXT_COLOR];
    [self.contentView addSubview:_titleLabel];
    
//    _subTitleLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) + 2 * k_LEFT_MARGIN, CGRectGetMidY(_imageView.frame), 200.0f, 20.0f) Font:[UIFont boldSystemFontOfSize:12.0f] textColor:[UIColorTools colorWithHexString:@"#adadad" withAlpha:1.0f]];
//    [self.contentView addSubview:_subTitleLabel];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, UUPersonalCenterViewCellHeight - 0.5f, PHONE_WIDTH, 0.5)];
    lineView.backgroundColor = k_LINE_COLOR;//[UIColorTools colorWithHexString:@"#DBDBDB" withAlpha:1.0f];
    [self.contentView addSubview:lineView];
    
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Stock_list_more"]];

    accessoryView.center = CGPointMake(PHONE_WIDTH - k_LEFT_MARGIN * 2 - CGRectGetWidth(accessoryView.frame) * 0.5, UUPersonalCenterViewCellHeight * 0.5);
    accessoryView.tag = 101;
    [self.contentView addSubview:accessoryView];
    
    //消息提醒
    UIImage *remindImage = [UIImage imageNamed:@"Me_message_remaind"];
    CGFloat buttonWidth = remindImage.size.width * 3;
    CGFloat buttonHeight = remindImage.size.height;
    _messageRemindButton = [UIKitHelper buttonWithFrame:CGRectMake(CGRectGetMinX(accessoryView.frame) - buttonWidth, (UUPersonalCenterViewCellHeight - buttonHeight) * 0.5,buttonWidth, buttonHeight) title:@"" titleHexColor:@"#adadad" font:[UIFont systemFontOfSize:14.0f]];
    [_messageRemindButton setImage:remindImage forState:UIControlStateNormal];
    _messageRemindButton.hidden = YES;
    _messageRemindButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);

    [self.contentView addSubview:_messageRemindButton];
}

- (void)setShowRemaind:(BOOL)showRemaind
{
    _showRemaind = showRemaind;
    _messageRemindButton.hidden = !showRemaind;
}


- (void)setDictionary:(NSDictionary *)dictionary
{
    if (_dictionary == dictionary) {
        return;
    }
    _dictionary = dictionary;
    _imageView.image = [UIImage imageNamed:[_dictionary objectForKey:@"k_ICON"]];
    _titleLabel.text = [_dictionary objectForKey:@"k_TITLE"];
}

@end
