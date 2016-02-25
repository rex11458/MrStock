//
//  UUImageScanView.m
//  StockHelper
//
//  Created by LiuRex on 15/6/29.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUImageScanView.h"
#define UUImageScanTitleViewHeight 64.0f
static UUImageScanView *g_scanView;


@implementation UUImageScanTitleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configSubViews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame currentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount
{
    if (self = [self initWithFrame:frame]) {
        self.totalCount = totalCount;
        self.currentIndex = currentIndex;
    }
    
    return self;
}

- (void)configSubViews
{
    _titleLabel = [UIKitHelper labelWithFrame:CGRectZero Font:[UIFont boldSystemFontOfSize:20.0f] textColor:[UIColor whiteColor]];
    [self addSubview:_titleLabel];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"Community_delete_big"];
    [_deleteButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setImage:image forState:UIControlStateNormal];
    _deleteButton.frame = CGRectMake(0, 0, image.size.width, CGRectGetHeight(self.bounds));
    [self addSubview:_deleteButton];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    _titleLabel.text = [NSString stringWithFormat:@"%@/%@",@(_currentIndex + 1),@(_totalCount)];
    [_titleLabel sizeToFit];
}



- (void)layoutSubviews
{
    _titleLabel.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5 + 10);
    _deleteButton.center = CGPointMake(CGRectGetWidth(self.bounds) - k_RIGHT_MARGIN - CGRectGetWidth(_deleteButton.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5 + 10);
}

- (void)setHidden:(BOOL)hidden WithAnimation:(BOOL)animated
{
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = !hidden;
        }];
    }else{
        self.hidden = hidden;
    }
}

- (void)deleteButton:(UIButton *)button
{
    [g_scanView deleteImageWithIndex:_currentIndex];
}

@end

@implementation UUImageScanSingleView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    if (self = [super initWithFrame:frame]) {
        _originalFrame = frame;
        self.bouncesZoom = YES;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 2.0f;
        self.delegate = self;
        self.image = image;
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    if (!image || _image == image) {
        return;
    }
    _image = image;

    _imageView = [[UIImageView alloc] initWithImage:_image];
    _imageView.image = _image;
    [self addSubview:_imageView];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = _imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    //
    _imageView.center = centerPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [g_scanView dismiss];
}

- (void)layoutSubviews
{
    _imageView.center = CGPointMake(PHONE_WIDTH * 0.5, PHONE_HEIGHT * 0.5);
}

@end



@implementation UUImageScanView


- (id)initWithFrame:(CGRect)frame ImageArray:(NSArray *)imageArray currentIndex:(NSInteger)currentIndex;
{
    if (self = [super initWithFrame:frame]) {
        
        g_scanView = self;
        
        self.imageArray = [imageArray mutableCopy];
        self.currentIndex = currentIndex;
        _originalFrame = frame;
        
//        [self configSubViews];
        [self configSubViews];
    }
    return self;
}


- (void)configSubViews
{
    self.frame = CGRectMake(0, 0, PHONE_WIDTH, PHONE_HEIGHT);
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) + k_LEFT_MARGIN, CGRectGetHeight(self.bounds))];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake((PHONE_WIDTH  + k_LEFT_MARGIN) * _imageArray.count, PHONE_HEIGHT);
    _scrollView.contentOffset = CGPointMake((PHONE_WIDTH + k_LEFT_MARGIN ) * _currentIndex, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _titleView = [[UUImageScanTitleView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.bounds) - UUImageScanTitleViewHeight - 50.0f, CGRectGetWidth(self.bounds), UUImageScanTitleViewHeight) currentIndex:_currentIndex totalCount:_imageArray.count];
    [self addSubview:_titleView];
    
    
    _singleViewArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _imageArray.count; i++) {
        UIImage *image = [_imageArray objectAtIndex:i];
        CGRect rect = CGRectMake((PHONE_WIDTH + k_LEFT_MARGIN) * i,0, PHONE_WIDTH, PHONE_HEIGHT);
        UUImageScanSingleView *singleView = [[UUImageScanSingleView alloc] initWithFrame:rect image:image];
        [_scrollView addSubview:singleView];
        [_singleViewArray addObject:singleView];
    }
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    self.titleView.deleteButton.hidden = !editing;
}

- (void)show
{
//    [self configSubViews];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window makeKeyAndVisible];
    [_window addSubview:self];
    _window.backgroundColor = [UIColor clearColor];
    
    UUImageScanSingleView *imageView = [_singleViewArray objectAtIndex:_currentIndex];
    CGRect frame = _originalFrame;
    
    frame.origin.x += _currentIndex * PHONE_WIDTH + k_LEFT_MARGIN;
    imageView.frame = frame;
    CGRect rect = CGRectMake((PHONE_WIDTH + k_LEFT_MARGIN) * _currentIndex,0, PHONE_WIDTH, PHONE_HEIGHT);

    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = rect;
        self.window.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    }completion:^(BOOL finished) {
    }];
}

- (void)dismiss
{
    UUImageScanSingleView *imageView = [_singleViewArray objectAtIndex:_currentIndex];
    CGRect frame = _originalFrame;
    frame.origin.x += _currentIndex * PHONE_WIDTH;
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = _originalFrame;
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        _window = nil;
    }];
}

- (void)deleteImageWithIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(deleteImageWithIndex:)]) {
        [_delegate deleteImageWithIndex:index];
    }
    [self dismiss];
}

#pragma mark - UIScrollViewDelegeate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_titleView setHidden:NO WithAnimation:YES];

    self.currentIndex = scrollView.contentOffset.x / PHONE_WIDTH;
    _titleView.currentIndex = self.currentIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_titleView setHidden:YES WithAnimation:YES];
}

//
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

@end
