//
//  UUEmotionKeyboard.h
//  StockHelper
//
//  Created by LiuRex on 15/6/30.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define EMOTION_KEYBOARD_HEIGHT 219.0f
@class HPGrowingTextView;
@protocol UUEmotionKeyboardDelegate;
@interface UUEmotionKeyboard : UIView

+ (UUEmotionKeyboard *)keyboard;

#define FACE_NAME_HEAD  @"["
#define FACE_MARK_L   @"["
#define FACE_MARK_R   @"]"
// 表情转义字符的长度（ /s占2个长度，xxx占3个长度，共5个长度 ）
#define FACE_NAME_LEN   5

//@property (nonatomic, strong) UITextField *inputTextField;

@property (nonatomic, strong) UITextView *inputTextView;

@property (nonatomic, strong) HPGrowingTextView *inputGrowingTextView;

@property (nonatomic,weak) id<UUEmotionKeyboardDelegate> delegate;

- (void)deleteEmotion;

@end

@protocol UUEmotionKeyboardDelegate <NSObject>

@optional
- (void)textViewDidChange:(UITextView *)textView;

@end