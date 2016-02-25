//
//  UUCommunityPublicTopicView.m
//  StockHelper
//
//  Created by LiuRex on 15/6/29.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUCommunityPublicTopicView.h"
#import "UUImageScanView.h"
#import "UUEmotionKeyboard.h"
@interface UUCommunityPublicTopicView ()<UUImageScanViewDelegate,UUCommunityInputAccessoryViewDelegate,UUEmotionKeyboardDelegate>
{
    NSMutableArray *_imageButtonArray;
    UUEmotionKeyboard *_emotionKeyboard;
}
@end

@implementation UUCommunityPublicTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        self.imageArray = [NSMutableArray array];
        _imageButtonArray = [NSMutableArray array];
        self.backgroundColor = k_BG_COLOR;
        self.bounces = YES;
        
        _emotionKeyboard = [UUEmotionKeyboard keyboard];
        _emotionKeyboard.delegate = self;
        
        
        [self configSubViews];

    }
    return self;
}

- (void)configSubViews
{
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.returnKeyType = UIReturnKeySend;
    _textView.delegate = self;
    _emotionKeyboard.inputTextView = _textView;
    
    [_contentView addSubview:_textView];
    _addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"Community_addTopic"];
    _addImageButton.frame = CGRectMake(k_LEFT_MARGIN, CGRectGetMaxY(_textView.frame) - image.size.height,image.size.width,image.size.height);
    [_addImageButton addTarget:self action:@selector(addImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addImageButton setImage:image forState:UIControlStateNormal];
    [_contentView addSubview:_addImageButton];
    
    _reminderLabel = [UIKitHelper labelWithFrame:CGRectMake(k_LEFT_MARGIN, 0, 150.0f, 20.0f) Font:[UIFont systemFontOfSize:10.0f] textColor:[UIColorTools colorWithHexString:@"#ADADAD" withAlpha:1.0f]];
    _reminderLabel.text = @"最多上传4张图片";
    
    [_contentView addSubview:_reminderLabel];
    
    
    _inputAccessoryView = [[UUCommunityInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0,PHONE_WIDTH,UUCommunityInputAccessoryViewHeight)];
    _textView.inputAccessoryView = _inputAccessoryView;
    _inputAccessoryView.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)addImage:(UIImage *)image
{
    if (!image || _image == image) {
        return;
    }
    _image = [image copy];

    [_imageArray addObject:_image];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = _imageArray.count - 1;
    
    [button setImage:_image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = _addImageButton.frame;
    button.frame = frame;
    frame.origin.x += CGRectGetWidth(_addImageButton.frame) + k_LEFT_MARGIN;
    _addImageButton.frame = frame;
    [_contentView addSubview:button];
    [_imageButtonArray addObject:button];
    if (_imageArray.count >= 4) {
        _addImageButton.hidden = YES;
    }
}

- (BOOL)becomeFirstResponder
{
    return [_textView becomeFirstResponder];
}

- (void)imageButtonAction:(UIButton *)button
{
    [_textView resignFirstResponder];
    CGRect frame = button.frame;
    
    
    UUImageScanView *scanView = [[UUImageScanView alloc] initWithFrame:frame ImageArray:_imageArray currentIndex:button.tag];
    scanView.delegate = self;
    [scanView show];
}

//添加图片
- (void)addImageButtonAction:(UIButton *)button
{
    [_textView resignFirstResponder];
    if ([_topicViewDelegate respondsToSelector:@selector(publicTopicViewAddImage:)]) {
        //添加图片
        [_topicViewDelegate publicTopicViewAddImage:self];
    }
}

//删除图片
#pragma mark - UUImageScanViewDelegate
- (void)deleteImageWithIndex:(NSInteger)index
{
    [_imageArray removeObjectAtIndex:index];
    UIButton *button = [_imageButtonArray objectAtIndex:index];
      [button removeFromSuperview];
    
    for (NSInteger i = index + 1; i < _imageButtonArray.count; i++) {
        UIButton *tempButton = [_imageButtonArray objectAtIndex:i];
        CGRect frame = tempButton.frame;
        frame.origin.x -= (CGRectGetWidth(frame) + k_LEFT_MARGIN);
        tempButton.frame = frame;
        tempButton.tag -= 1;
    }
    
    [_imageButtonArray removeObjectAtIndex:index];

    CGRect addImageButtonFrame = _addImageButton.frame;
    addImageButtonFrame.origin.x -= (CGRectGetWidth(addImageButtonFrame) + k_LEFT_MARGIN);
    _addImageButton.frame = addImageButtonFrame;
    if (_imageArray.count < 4) {
        _addImageButton.hidden = NO;
    }

}


- (void)keyboardWillShow:(NSNotification *)notification
{
   CGRect frame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _contentView.frame = CGRectMake(k_LEFT_MARGIN, k_TOP_MARGIN, CGRectGetWidth(self.bounds) - 2 * k_LEFT_MARGIN, CGRectGetHeight(self.bounds) - frame.size.height - k_TOP_MARGIN);
   
    _textView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 2 * k_LEFT_MARGIN, CGRectGetHeight(self.bounds) - frame.size.height - CGRectGetHeight(_addImageButton.frame) -  CGRectGetHeight(_reminderLabel.frame));

    CGRect buttonFrame = _addImageButton.frame;
    buttonFrame.origin.y = CGRectGetHeight(_contentView.frame) - CGRectGetHeight(buttonFrame) - CGRectGetHeight(_reminderLabel.frame);
    _addImageButton.frame = buttonFrame;

    CGRect labelFrame = _reminderLabel.frame;
    labelFrame.origin.y = CGRectGetHeight(_contentView.frame) - CGRectGetHeight(labelFrame);
    _reminderLabel.frame = labelFrame;
    
    
    for (UIButton *button in _imageButtonArray) {
        CGRect frame = button.frame;
        frame.origin.y = buttonFrame.origin.y;
        button.frame = frame;
    }
}

#pragma mark - UUCommunityInputAccessoryViewDelegate
- (void)accessoryView:(UUCommunityInputAccessoryView *)accessoryView didSelectedIndex:(NSInteger)index
{
    if (index == 0) {
        [_textView resignFirstResponder];
        if (accessoryView.keyboardType == 0) {
            _textView.inputView = _emotionKeyboard;
        }
        else if(accessoryView.keyboardType == 1)
        {
            _textView.inputView = nil;

        }
        [_textView becomeFirstResponder];

    }else if (index == 1)
    {
        if ([_topicViewDelegate respondsToSelector:@selector(publicTopicViewAddStock:)]) {
            [_topicViewDelegate publicTopicViewAddStock:self];
        }
    }
}

#pragma mark - UUEmotionKeyboardDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [_textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    //点击了非删除键
    if( [text length] == 0 ) {
        
        if ( range.length > 1 ) {
            
            return YES;
        }
        else {
            
            [_emotionKeyboard deleteEmotion];
            
            return NO;
        }
    }
    else {
        
        return YES;
    }
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}



@end


@implementation UUCommunityInputAccessoryView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self configSubViews];
        self.backgroundColor = k_BG_COLOR;
    }
    return self;
}

- (void)configSubViews
{
    UIImage *emotionImage = [UIImage imageNamed:@"Community_biaoqingxuanze"];

    UIButton *emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emotionButton.tag = 0;
    [emotionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    emotionButton.frame = CGRectMake(0, 0, emotionImage.size.width * 2, emotionImage.size.height * 2);
    [emotionButton setImage:emotionImage forState:UIControlStateNormal];
    [emotionButton setImage:[UIImage imageNamed:@"Community_keyboard"] forState:UIControlStateSelected];
    [self addSubview:emotionButton];
    
    
    UIImage *stockImage = [UIImage imageNamed:@"Community_gupiaoxuanze"];
    UIButton *stockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stockButton.tag = 1;
    stockButton.frame = CGRectMake(CGRectGetMaxX(emotionButton.frame), 0, stockImage.size.width * 2, stockImage.size.height * 2);
    [stockButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [stockButton setImage:stockImage forState:UIControlStateNormal];
    [self addSubview:stockButton];
}

- (void)buttonAction:(UIButton *)button
{
    _keyboardType = button.isSelected;
    button.selected = !button.isSelected;
    if ([_delegate respondsToSelector:@selector(accessoryView:didSelectedIndex:)]) {
        [_delegate accessoryView:self didSelectedIndex:button.tag];
    }
}

@end







