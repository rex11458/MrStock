//
//  UUEmotionKeyboard.m
//  StockHelper
//
//  Created by LiuRex on 15/6/30.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUEmotionKeyboard.h"
#import "HPGrowingTextView.h"
static UUEmotionKeyboard *g_keyboard;

#define FACE_COUNT_ALL  83

#define FACE_COUNT_ROW  4

#define FACE_COUNT_CLU  7

#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )

#define FACE_ICON_SIZE  44


@interface UUEmotionKeyboard ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    NSDictionary *_emotionDictionary;
    UIPageControl *_pageControl;
}
@end

@implementation UUEmotionKeyboard

+ (UUEmotionKeyboard *)keyboard
{
    g_keyboard = [[[self class] alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, EMOTION_KEYBOARD_HEIGHT)];

    return g_keyboard;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self configSubViews];
        
        _emotionDictionary = [NSDictionary dictionaryWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"_expression_en"
                                                               ofType:@"plist"]];
    }
    return self;
}

- (void)configSubViews
{
    //表情盘
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, 190)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake((FACE_COUNT_ALL / FACE_COUNT_PAGE + 1) * PHONE_WIDTH, 190);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    
    CGFloat margin = (PHONE_WIDTH - FACE_COUNT_CLU * FACE_ICON_SIZE) / FACE_COUNT_CLU;
    
    for (int i = 0; i < FACE_COUNT_ALL; i++) {
        
        UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        faceButton.tag = i + 1;
        
        [faceButton addTarget:self
                       action:@selector(faceButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
        
        //计算每一个表情按钮的坐标和在哪一屏
        CGFloat X = margin * 0.5 + ((i  % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * (FACE_ICON_SIZE + margin) + (i / FACE_COUNT_PAGE * PHONE_WIDTH);
        CGFloat Y = ((i % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * FACE_ICON_SIZE + 8;
        faceButton.frame = CGRectMake( X, Y, FACE_ICON_SIZE, FACE_ICON_SIZE);
        
        UIImage *image = [[UIImage alloc]  initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%03d", i + 1] ofType:@"png"]];
        
        [faceButton setImage:image
                    forState:UIControlStateNormal];
        
        [_scrollView addSubview:faceButton];
    }
    
    //pageController
    //添加PageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - 100) * 0.5, CGRectGetHeight(_scrollView.bounds), 100, 20)];
    
    [_pageControl addTarget:self
                        action:@selector(pageChange:)
              forControlEvents:UIControlEventValueChanged];
    _pageControl.pageIndicatorTintColor = k_BG_COLOR;
    _pageControl.currentPageIndicatorTintColor = k_NAVIGATION_BAR_COLOR;
    _pageControl.numberOfPages = FACE_COUNT_ALL / FACE_COUNT_PAGE + 1;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
    
    //删除键
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:k_MIDDLE_TEXT_COLOR forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteEmotion) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 40.0f - k_RIGHT_MARGIN, CGRectGetHeight(_scrollView.frame) , 40.0f, 28.0f);
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:deleteButton];
}

- (void)pageChange:(id)sender
{
    [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage * PHONE_WIDTH, 0) animated:YES];
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_pageControl setCurrentPage:scrollView.contentOffset.x / PHONE_WIDTH];
    [_pageControl updateCurrentPageDisplay];
}

//选中表情
- (void)faceButtonAction:(UIButton *)button
{
    NSInteger index = button.tag;
 if (_inputTextView) {
        
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [faceString appendString:[_emotionDictionary objectForKey:[NSString stringWithFormat:@"%03ld", index]]];
        self.inputTextView.text = faceString;
        
        if ([_delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [_delegate textViewDidChange:self.inputTextView];
        }
        self.inputTextView.text = faceString;
    }else if (_inputGrowingTextView){
        
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputGrowingTextView.text];
        [faceString appendString:[_emotionDictionary objectForKey:[NSString stringWithFormat:@"%03ld", index]]];
        self.inputGrowingTextView.text = faceString;
    }
}

//删除表情
- (void)deleteEmotion
{
    NSString *inputString;
    if ( self.inputTextView ) {
        
        inputString = self.inputTextView.text;
    }
    if (self.inputGrowingTextView){
        inputString = self.inputGrowingTextView.text;
    }
    
    if ( inputString.length ) {
        
        NSString *string = nil;
        NSInteger stringLength = inputString.length;
        if ( stringLength >= FACE_NAME_LEN) {
            
            string = [inputString substringFromIndex:stringLength - FACE_NAME_LEN];
            NSRange range = [string rangeOfString:FACE_NAME_HEAD];
            if ( range.location == 0 ) {
                
                string = [inputString substringToIndex:
                          [inputString rangeOfString:FACE_NAME_HEAD
                                             options:NSBackwardsSearch].location];
            }
            else {

                string = [inputString substringToIndex:stringLength - 1];
            }
        }
        else {
            
            string = [inputString substringToIndex:stringLength - 1];
        }
        
        if (self.inputGrowingTextView) {
            
            self.inputGrowingTextView.text = string;
            [_delegate textViewDidChange:self.inputTextView];
        }
        
        if ( self.inputTextView ) {
            
            self.inputTextView.text = string;
            
            [_delegate textViewDidChange:self.inputTextView];
        }
    }
}
@end
