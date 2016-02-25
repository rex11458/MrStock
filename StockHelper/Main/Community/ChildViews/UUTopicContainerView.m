//
//  UUTopicContainerView.m
//  StockHelper
//
//  Created by LiuRex on 15/7/7.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTopicContainerView.h"
#import "UUEmotionKeyboard.h"
#import "HPGrowingTextView.h"
#define MaxNumberOfDescriptionChars 140

@interface UUTopicContainerView ()<HPGrowingTextViewDelegate,UUEmotionKeyboardDelegate>{
    UUEmotionKeyboard *_emotionKeyboard;
}
@end

@implementation UUTopicContainerView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = k_LINE_COLOR;
        [self configSubViews];


    }
    return self;
}

- (void)configSubViews
{
    //表情键盘
    _emotionKeyboard = [UUEmotionKeyboard keyboard];
//    _emotionKeyboard.delegate = self;
    
    
    
    CGFloat buttonMargin = 8.0f;
    CGFloat buttonWidth = 46.0f;
    CGFloat buttonHeight = kUUTopicContainerViewHeight -  buttonMargin * 2;
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - buttonMargin - buttonWidth , buttonMargin, buttonWidth, buttonHeight);
    doneBtn.layer.cornerRadius = 5.0f;
    doneBtn.layer.masksToBounds = YES;
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [doneBtn setTitle:@"发送" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColorTools colorWithHexString:@"#474747" withAlpha:1.0f] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:[UIKitHelper imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    
   [self addSubview:doneBtn];

    
    //输入框
    _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(buttonMargin,buttonMargin - 2, CGRectGetMinX(doneBtn.frame) - 2 *buttonMargin, buttonHeight)];
    _textView.isScrollable = NO;
    _emotionKeyboard.inputGrowingTextView = _textView;
//    _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    _textView.layer.cornerRadius = 5.0f;
//    _textView.layer.borderWidth = 0.5f;
//    _textView.internalTextView.delegate = self;
    _textView.minNumberOfLines = 1;
    _textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    _textView.returnKeyType = UIReturnKeyGo; //just as an example
    _textView.font = [UIFont systemFontOfSize:15.0f];
    _textView.delegate = self;
    _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.returnKeyType = UIReturnKeySend;
    _textView.placeholder = @"说点什么吧...";
    _textView.enablesReturnKeyAutomatically = YES;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:_textView];
    
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, PHONE_WIDTH - 72, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:_textView];
    
    
    
    //表情按钮
    UIImage *emotionImage = [UIImage imageNamed:@"Community_biaoqingxuanze"];
    CGFloat emotionButtonWidth = emotionImage.size.width * 2;
    UIButton *emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emotionButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;

    [emotionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    emotionButton.frame = CGRectMake(CGRectGetMaxX(_textView.frame) -  emotionImage.size.width - buttonMargin * 2,(kUUTopicContainerViewHeight - emotionButtonWidth) * 0.5, emotionButtonWidth,emotionButtonWidth);
    [emotionButton setImage:emotionImage forState:UIControlStateNormal];
    [emotionButton setImage:[UIImage imageNamed:@"Community_keyboard"] forState:UIControlStateSelected];
    [self addSubview:emotionButton];
    
    
    _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, emotionImage.size.width + buttonMargin);


    [self addKeyboardNotification];
}

- (BOOL)resignFirstResponder
{
    return [_textView resignFirstResponder];
}

- (void)resignTextView
{
    if ([_delegate respondsToSelector:@selector(containerView:sendMessage:)]) {
        [_delegate containerView:self sendMessage:_textView.text];
    }
    _textView.text = @"";
    [self endEditing:YES];
}

- (BOOL)becomeFirstResponder
{
    
    return [_textView becomeFirstResponder];
}


#pragma mark - 切换键盘
- (void)buttonAction:(UIButton *)button
{
    button.selected = !button.isSelected;
    [_textView resignFirstResponder];
    if (button.isSelected) {
        _textView.internalTextView.inputView = _emotionKeyboard;
    }
    else
    {
        _textView.internalTextView.inputView = nil;
        
    }
    [_textView becomeFirstResponder];

}


#pragma mark - UITextViewDelegate;
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if ([_delegate respondsToSelector:@selector(containerView:sendMessage:)]) {
            [_delegate containerView:self sendMessage:_textView.text];
        }
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



#pragma mark - 添加键盘通知
- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note
{
    
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0,-CGRectGetHeight(keyboardBounds));
        
    }];
}

-(void) keyboardWillHidden:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
    _textView.placeholder = @"说点什么吧...";
    if ([_delegate respondsToSelector:@selector(containerViewResignFirstResponder:)]) {
        [_delegate containerViewResignFirstResponder:self];
    }
}

#pragma mark - HPGrowingTextViewDelegate
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self resignTextView];
    return YES;
}

// 监听文本高度改变
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.frame = r;
}

// 监听文本改变
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView;
{
    
    UITextView *textView = growingTextView.internalTextView;
    
    NSString *toBeString = textView.text;
  UITextInputMode *inputModel = [[UITextInputMode alloc] init];
    NSString *lang = [inputModel primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [textView markedTextRange];
        
        //获取高亮部分
        
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        
        if (!position) {
            
            if (toBeString.length > MaxNumberOfDescriptionChars) {
                
                textView.text = [toBeString substringToIndex:MaxNumberOfDescriptionChars];
                
            }
            
        }
        
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        
        else{
            
            
            
        }
        
    }
    
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    
    else{
        
        if (toBeString.length > MaxNumberOfDescriptionChars) {
            
            textView.text = [toBeString substringToIndex:MaxNumberOfDescriptionChars];
            
        }
        
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


@end

