//
//  UUImageScanView.h
//  StockHelper
//
//  Created by LiuRex on 15/6/29.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UUImageScanViewDelegate;
@interface UUImageScanTitleView : UIView
{
    UILabel *_titleLabel;
}

@property (nonatomic,strong) UIButton *deleteButton;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,assign) NSInteger totalCount;

- (id)initWithFrame:(CGRect)frame currentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount;

- (void)setHidden:(BOOL)hidden WithAnimation:(BOOL)animated;


@end



@interface UUImageScanSingleView : UIScrollView<UIScrollViewDelegate>
{
    CGRect _originalFrame;
    UIImageView *_imageView;

    UIButton *_deleteButton;
}

@property (nonatomic,strong) UIImage *image;


- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;

@end


@interface UUImageScanView : UIView <UIScrollViewDelegate>
{
    UIWindow *_window;
    UIImageView *_imageView;
    CGRect _originalFrame;
    UIScrollView *_scrollView;
}

@property (nonatomic,assign) BOOL editing;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,copy,readonly) NSMutableArray *singleViewArray;

@property (nonatomic,strong,readonly) UUImageScanTitleView *titleView;

@property (nonatomic,weak) id<UUImageScanViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame ImageArray:(NSArray *)imageArray currentIndex:(NSInteger)currentIndex;

- (void)show;
- (void)dismiss;

- (void)deleteImageWithIndex:(NSInteger)index;

@end

@protocol UUImageScanViewDelegate <NSObject>

@optional
- (void)deleteImageWithIndex:(NSInteger)index;

@end



