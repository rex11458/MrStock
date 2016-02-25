//
//  UUDiscoverViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/6/10.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"

@class UUDiscoverSectionView;

@protocol UUDiscoverSectionViewDelegate <NSObject>

@optional
- (void)sectionView:(UUDiscoverSectionView *)sectionView didSelectedIndex:(NSInteger)index;

@end
@interface UUDiscoverViewController : BaseViewController<UUDiscoverSectionViewDelegate>

@end

@interface UUDiscoverHeaderView : UIView
{
    UIScrollView *_scrollView;
    UIView *_toolbar;
}
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,strong) UUDiscoverSectionView *sectionView;

@property (nonatomic) CGRect defaultImageFrame;


- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;

@end


@interface UUDiscoverSectionView : UIView

@property (nonatomic,assign) CGRect defaultTitleViewFrame;

@property (nonatomic,assign) CGRect defaultFrame;
@property (nonatomic,assign) CGRect currentFrame;

@property (nonatomic,copy) NSArray *buttonArray;
@property (nonatomic,strong) UIView *titleView;

@property (nonatomic,weak) id<UUDiscoverSectionViewDelegate> delegate;

- (void)layoutSectionViewForScrollViewOffset:(CGPoint)offset;

- (void)layoutSectionViewForScrollViewOffset:(CGPoint)offset headerViewHeight:(CGFloat)height;

@end

