//
//  UUFillPersonalInfoView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/14.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFillPersonalInfoView.h"
#import "UIImage+Compress.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "GTMBase64.h"
@implementation UUFillPersonalInfoView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = k_BG_COLOR;
        [self configSubViews];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type
{
    if (self = [super initWithFrame:frame]) {
        
        self.type = type;
        [self configSubViews];
    }
    
    return self;
}

- (void)configSubViews
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.backgroundColor = k_BG_COLOR;
    [self addSubview:_scrollView];
    
    CGFloat buttonWidth = 94.0f;
    //头像
    _headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headerImageButton setImage:[UIImage imageNamed:@"Register_headerImage"] forState:UIControlStateNormal];
    _headerImageButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - buttonWidth) * 0.5, 40, buttonWidth, buttonWidth);
    [_headerImageButton addTarget:self action:@selector(headerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_headerImageButton];
    _headerImageButton.layer.cornerRadius = buttonWidth * 0.5;
    _headerImageButton.layer.masksToBounds = YES;

    CGFloat textFieldWidth = CGRectGetWidth(self.bounds) - 80.0f;
    CGFloat textFieldHeight = 44.0f;
    NSDictionary *placeHolderAtrubites = @{
                                           NSFontAttributeName : k_SMALL_TEXT_FONT,
                                           NSForegroundColorAttributeName : k_MIDDLE_TEXT_COLOR
                                           };
    //--  昵称
    _nickNameTextField = [UIKitHelper textFieldWithFrame:CGRectMake(40, CGRectGetMaxY(_headerImageButton.frame) + k_TOP_MARGIN * 2, textFieldWidth, textFieldHeight) placeholder:nil Text:nil leftViewText:@"昵称"];
    _nickNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入6～12位中文字母组合昵称" attributes:placeHolderAtrubites];
    _nickNameTextField.backgroundColor = k_BG_COLOR;
    _nickNameTextField.delegate = self;
    _nickNameTextField.returnKeyType = UIReturnKeyDone;

    [_scrollView addSubview:_nickNameTextField];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_nickNameTextField.frame) - 0.5f, CGRectGetWidth(_nickNameTextField.frame), 0.5f)];
    lineView.backgroundColor = k_LINE_COLOR;
    [_nickNameTextField addSubview:lineView];
    [_scrollView addSubview:_nickNameTextField];
    if (_type == 1) {
     
        //投资理念
        UILabel *mottoLabel = [UIKitHelper labelWithFrame:CGRectZero Font:k_SMALL_TEXT_FONT textColor:k_BIG_TEXT_COLOR];
        [_scrollView addSubview:mottoLabel];
        mottoLabel.text = @"投资理念";
        [mottoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leftMargin.mas_equalTo(_nickNameTextField.mas_leftMargin);
            make.top.mas_equalTo(_nickNameTextField.mas_bottom).with.offset(k_TOP_MARGIN);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(60);
        }];
        
        _mottoTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _mottoTextView.delegate = self;
        _mottoTextView.layer.borderWidth = 1.0f;
        _mottoTextView.layer.cornerRadius = 5.0f;
        _mottoTextView.layer.masksToBounds = YES;
        _mottoTextView.backgroundColor = [UIColor whiteColor];
        _mottoTextView.layer.borderColor = k_LINE_COLOR.CGColor;
        _mottoTextView.returnKeyType = UIReturnKeyDone;
        _mottoTextView.font = k_SMALL_TEXT_FONT;
        
        
        _mottoTextView.text = @"投资的第一条准则是不赔钱;第二条是严格遵守第一条。";
        [_scrollView addSubview:_mottoTextView];
        
        [_mottoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(mottoLabel.mas_right).with.offset(k_LEFT_MARGIN);
            make.top.mas_equalTo(mottoLabel.mas_top);
            make.right.mas_equalTo(_nickNameTextField.mas_right);
            make.height.mas_equalTo(mottoLabel.mas_height);
        }];
        
    }
    
    //提交按钮
    CGFloat doneButtonTopMargin = _type ? 80:20;
    CGFloat buttonHeight = 44.0f;
    _doneButton = [UIKitHelper buttonWithFrame:CGRectMake(40,doneButtonTopMargin +CGRectGetMaxY(_nickNameTextField.frame), PHONE_WIDTH - 80, buttonHeight) title:@"完成" titleHexColor:@"FFFFFF" font:k_BIG_TEXT_FONT];
    [_doneButton setBackgroundImage:[UIKitHelper imageWithColor:k_LINE_COLOR] forState:UIControlStateNormal];
    [_doneButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateSelected];
    [_doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    _doneButton.userInteractionEnabled = _type;
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _doneButton.layer.cornerRadius =16.0f;
    _doneButton.layer.masksToBounds = YES;
    [_scrollView addSubview:_doneButton];

    //----
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetMaxY(_doneButton.frame) + 3 * k_TOP_MARGIN + buttonHeight );

    _contentSize = _scrollView.contentSize;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setUser:(UULoginUser *)user
{
    if (user == nil || _user == user) {
        return;
    }
    _user = user;
    [_headerImageButton sd_setImageWithURL:[NSURL URLWithString:_user.headImg] forState:UIControlStateNormal];
//    _nickNameTextField.text = _user.nickName;
    
}

- (NSString *)nickName
{
    return _nickNameTextField.text;
}

- (NSString *)depict
{
    return _mottoTextView.text;
}

- (NSString *)base64ImageString
{
    UIImage *image = [self.headerImage imageScaledToSize:CGSizeMake(200, 200)];
    
    NSData* imgData = UIImagePNGRepresentation(image);
    if (imgData == nil) {
        imgData = UIImageJPEGRepresentation(image, 1);
    }
    NSString * base64String = [GTMBase64 stringByEncodingData:imgData];
    
    return base64String;
}

- (void)setHeaderImage:(UIImage *)headerImage
{
    if (headerImage == _headerImage) {
        return;
    }
    _headerImage = headerImage;
    [_headerImageButton setImage:_headerImage forState:UIControlStateNormal];
}

#pragma mark - 完成按钮
- (void)doneAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
        [self.delegate baseView:self actionTag:UUDoneButtonActionTag value:nil];
    }
}

- (void)headerButtonAction
{
    if ([self.delegate respondsToSelector:@selector(baseView:actionTag:value:)]) {
        [self.delegate baseView:self actionTag:UUHeaderButtonActionTag value:nil];
    }
}

#pragma mark - 输入框字符改变
- (void)textFieldDidChange:(NSNotification *)notificaiton
{
    if (_nickNameTextField.text.length > 0) {
        _doneButton.userInteractionEnabled = YES;
        _doneButton.selected = YES;
    }else{
        _doneButton.userInteractionEnabled = NO;
        _doneButton.selected = NO;
    }
}

#pragma mark - 键盘通知
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGSize contentSize = _contentSize;
    contentSize.height += keyboardHeight;
    _scrollView.contentSize = contentSize;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGSize contentSize = _contentSize;
    contentSize.height -= keyboardHeight;
    _scrollView.contentSize = contentSize;
}

#pragma mark -  UITextViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    CGFloat Y = CGRectGetMinY(textField.frame);
    //    [_scrollView setContentOffset:CGPointMake(0, Y) animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
