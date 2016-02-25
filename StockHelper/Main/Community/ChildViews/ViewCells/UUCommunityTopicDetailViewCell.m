//
//  UUCommunityTopicDetailViewCell.m
//  StockHelper
//
//  Created by LiuRex on 15/6/26.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//
#import "UUCommunityTopicDetailViewCell.h"
#import "UUTopicReplyListModel.h"
#import "UURichLabel.h"
#import <SDWebImage/UIButton+WebCache.h>
#define k_FONT_SIZE 14.0f
#define k_IMAGE_WIDHT 40.0f
#define k_TEXT_WIDTH (PHONE_WIDTH - k_LEFT_MARGIN * 6 - k_IMAGE_WIDHT)

@interface UUCommunityTopicDetailViewCell ()
{
    UIButton *_headerImageButton;    //头像
    
    
    UILabel *_floorLabel;//楼层
    
    UURichLabel *_textView;
}
@end

@implementation UUCommunityTopicDetailViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
     
        
        [self configSubViews];
        
    }
    return self;
}

- (void)configSubViews
{
    _bgImageView = [[UIImageView alloc] initWithImage:[UIKitHelper imageWithColor:[UIColor whiteColor]]];
    [self.contentView addSubview:_bgImageView];
    
    _headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerImageButton.frame = CGRectMake(2 * k_LEFT_MARGIN, k_TOP_MARGIN, k_IMAGE_WIDHT, k_IMAGE_WIDHT);
    _headerImageButton.layer.cornerRadius = k_IMAGE_WIDHT * 0.5f;
    _headerImageButton.layer.masksToBounds = YES;
    [_headerImageButton setImage:[UIImage imageNamed:@"default_headerImage"] forState:UIControlStateNormal];
    _headerImageButton.contentMode = UIViewContentModeScaleAspectFit;
    [_headerImageButton addTarget:self action:@selector(headerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_headerImageButton];

    _nameLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMaxX(_headerImageButton.frame) + k_LEFT_MARGIN,_headerImageButton.center.y - 10.0f,200, 20.0f) Font:k_MIDDLE_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
    _nameLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:_nameLabel];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerButtonAction)];
    [_nameLabel addGestureRecognizer:tapGes];
    _dateLabel = [UIKitHelper labelWithFrame:CGRectMake(PHONE_WIDTH - 150 - 2 *k_RIGHT_MARGIN ,_headerImageButton.center.y - 10.0f,150, 20.0f) Font:k_SMALL_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_dateLabel];
    
    
    _floorLabel = [UIKitHelper labelWithFrame:CGRectMake(CGRectGetMinX(_headerImageButton.frame), CGRectGetMaxY(_headerImageButton.frame) + k_TOP_MARGIN, CGRectGetWidth(_headerImageButton.bounds), 20.0f) Font:[UIFont systemFontOfSize:14.0f] textColor:[UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f]];
    _floorLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_floorLabel];
    
    _subView = [[UUCommunityTopicDetailSubView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_subView];
    
    _textView = [[UURichLabel alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN * 3 + k_IMAGE_WIDHT,2 * k_TOP_MARGIN +k_IMAGE_WIDHT,k_TEXT_WIDTH, 0) ];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = k_MIDDLE_TEXT_FONT;
    _textView.textColor = k_BIG_TEXT_COLOR;
    _textView.numberOfLines = 0;
    [self.contentView addSubview:_textView];
}

- (void)setTopicReplyModel:(UUTopicReplyModel *)topicReplyModel
{
    if (topicReplyModel == nil && _topicReplyModel == topicReplyModel) {
        return;
    }
    _topicReplyModel = topicReplyModel;
    [self fillData];
}


- (void)fillData
{
    _nameLabel.text = _topicReplyModel.userName;
    _dateLabel.text = _topicReplyModel.createTime;
    [_headerImageButton sd_setImageWithURL:[NSURL URLWithString:_topicReplyModel.userPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_headerImage"]];

    _floorLabel.text = [NSString stringWithFormat:@"%@楼",(_topicReplyModel.orderId)];

    _textView.text = _topicReplyModel.content;
    
    CGRect bounds = [UUCommunityTopicDetailViewCell contentBoundsWithText:_topicReplyModel.content];
    CGRect frame = _textView.frame;
    frame.size.height = bounds.size.height;
    _textView.frame = frame;
    
    _subView.hidden = !_topicReplyModel.tgtUserId.length;
    
    _subView.replySubModel = [[UUTopicReplySubModel alloc] initWithTgtUserId:_topicReplyModel.tgtUserId tgtUserName:_topicReplyModel.tgtUserName tgtContent:_topicReplyModel.tgtContent tgtOrderId:_topicReplyModel.tgtOrderId];
}

- (void)headerButtonAction
{
    if ([_target respondsToSelector:_userHomeAciton]) {
        [_target performSelector:_userHomeAciton withObject:self afterDelay:0];
    }
}

+ (CGRect)contentBoundsWithText:(NSString *)text
{
    if (text == nil) {
        return CGRectZero;
    }
    CGRect bounds = [UURichLabel boundingRectWithSize:CGSizeMake(k_TEXT_WIDTH, MAXFLOAT) string:text attributes:@{NSFontAttributeName:k_MIDDLE_TEXT_FONT}];
    return bounds;
}

- (void)layoutSubviews
{
    _bgImageView.frame = CGRectMake(k_LEFT_MARGIN, k_TOP_MARGIN * 0.5, PHONE_WIDTH - 2 * k_LEFT_MARGIN, CGRectGetHeight(self.bounds) - k_TOP_MARGIN);
    _subView.frame = CGRectMake(k_LEFT_MARGIN * 2 + k_IMAGE_WIDHT, CGRectGetHeight(self.bounds) - 80,k_TEXT_WIDTH, 70.0f);
}
@end

@implementation UUCommunityTopicDetailSubView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = k_BG_COLOR;//[UIColorTools colorWithHexString:@"#DBDBDB" withAlpha:1.0f];
       _nameLabel = [UIKitHelper labelWithFrame:CGRectMake(k_LEFT_MARGIN, k_TOP_MARGIN * 0.5,200, 20.0f) Font:k_SMALL_TEXT_FONT textColor:nil];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:_nameLabel];
        
        _textView = [[UURichLabel alloc] initWithFrame:CGRectMake(k_LEFT_MARGIN,CGRectGetMaxY(_nameLabel.frame) + k_TOP_MARGIN * 0.5, CGRectGetWidth(frame) - 2 * k_LEFT_MARGIN, 30.0f)];
        _textView.font = [UIFont systemFontOfSize:12.0f];
        _textView.numberOfLines = 0;
//        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _textView.backgroundColor = [UIColor clearColor];
        [self addSubview:_textView];
    }
    return self;
}

- (void)setReplySubModel:(UUTopicReplySubModel *)replySubModel
{
    if (replySubModel == nil || _replySubModel == replySubModel) {
        return;
    }
    _replySubModel = replySubModel;
    _textView.text = _replySubModel.tgtContent;
    NSString *floor = [NSString stringWithFormat:@"(%@楼)",@(_replySubModel.tgtOrderId)];
    NSString *text = [NSString stringWithFormat:@"@%@  ",_replySubModel.tgtUserName];
    text = [text stringByAppendingString:floor];
    //内容
    NSDictionary *attributes = @{
                                 NSFontAttributeName :k_SMALL_TEXT_FONT,
                                 NSForegroundColorAttributeName :[UIColorTools colorWithHexString:k_STOCK_LINK_COLOR withAlpha:1]
                                 };
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    NSRange range = [text rangeOfString:floor];
    [attString setAttributes:@{NSFontAttributeName:k_SMALL_TEXT_FONT,NSForegroundColorAttributeName:k_BIG_TEXT_COLOR} range:range];
    _nameLabel.attributedText = attString;
}

- (void)layoutSubviews
{
    _textView.frame = CGRectMake(k_LEFT_MARGIN,CGRectGetMaxY(_nameLabel.frame) + k_TOP_MARGIN * 0.5, CGRectGetWidth(self.bounds) - 2 * k_LEFT_MARGIN, 30.0f);
}
@end

