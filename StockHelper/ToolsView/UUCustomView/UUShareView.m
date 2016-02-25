//
//  UUShareView.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUShareView.h"
#import "UUTabbar.h"
#import "UUHomeButtonView.h"
#define kMarign 20.0f

@interface UUShareView ()
@property (nonatomic) UIWindow *window;


@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) NSArray *buttonArray;

@property (nonatomic) UIButton *cancelButton;

@end

@implementation UUShareView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configSubViews];
//        self.layer.cornerRadius = 5.0f;
//        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)configSubViews
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.frame), 30.0f)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"分享给好友";
    _titleLabel.textColor = k_BIG_TEXT_COLOR;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    
    NSArray *titles = @[@"微信",@"朋友圈",@"QQ空间",@"微博"];
    NSArray *images = @[@"shared_wx",@"shared_pyq",@"shared_qq",@"shared_wb"];
    NSArray *colors = @[@"09C655",@"7F7F7F",@"F4AF2A",@"FF5C5D"];
    NSArray *tags = @[@(ShareTypeWeixiSession),@(ShareTypeWeixiTimeline),@(ShareTypeQQSpace),@(ShareTypeSinaWeibo)];
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    CGFloat margin = 20.0f;
    CGFloat buttonWidth = (CGRectGetWidth(self.bounds) - (titles.count + 1) * margin) / (CGFloat)titles.count;
    for (int i = 0; i < titles.count;i++) {
        UUHomeButtonView *button = [[UUHomeButtonView alloc] initWithFrame:CGRectZero];
        button.frame = CGRectMake(margin + (buttonWidth+ margin) * i, kMarign/2 + CGRectGetMaxY(_titleLabel.frame), buttonWidth, buttonWidth * 1.5);
        button.tag = [tags[i] integerValue];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:k_MIDDLE_TEXT_COLOR forState:UIControlStateNormal];

        button.titleLabel.font = k_MIDDLE_TEXT_FONT;
        UIColor *color = [UIColorTools colorWithHexString:colors[i] withAlpha:1.0f];
        [button.imageButton setBackgroundImage:[UIKitHelper imageWithColor:color] forState:UIControlStateNormal];
        [buttonArray addObject:button];
        
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGFloat cancelButtonHeight = 40.0f;
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(margin, CGRectGetHeight(self.frame) - cancelButtonHeight - k_BOTTOM_MARGIN, CGRectGetWidth(self.bounds) - 2 * margin, cancelButtonHeight);
    _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    _cancelButton.layer.borderWidth = 0.5f;
    _cancelButton.layer.borderColor = k_NAVIGATION_BAR_COLOR.CGColor;
    _cancelButton.layer.cornerRadius = 5.0f;
    _cancelButton.layer.masksToBounds = YES;
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:k_BIG_TEXT_COLOR forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.5, 0, CGRectGetWidth(_cancelButton.frame), 0.5)];
//    lineView.backgroundColor = k_MIDDLE_TEXT_COLOR;
//    [_cancelButton addSubview:lineView];
}

- (void)buttonAction:(UIButton *)button
{
    [self dismiss];
    ShareType type = (ShareType)button.tag;
    if ([_delegate respondsToSelector:@selector(shareView:shareWithType:)]) {
        [_delegate shareView:self shareWithType:type];
    }
}

- (void)cancelButtonAction:(UIButton *)button
{
    [self dismiss];
}

- (void)show
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self.window addSubview:self];
    self.window.backgroundColor = [UIColor clearColor];
    self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.window.frame));
    [UIView animateWithDuration:0.25 animations:^{
        self.window.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        self.transform = CGAffineTransformIdentity;
    }];
    
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.window addGestureRecognizer:ges];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0,  CGRectGetHeight(self.window.frame));
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.window = nil;
    }];
}



@end
