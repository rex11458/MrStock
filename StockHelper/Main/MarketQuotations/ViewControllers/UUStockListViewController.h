//
//  UUStockListViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/5/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
@protocol UUStockBlockSectionViewDelegate;
@protocol UUStockBlockHeaderViewDelegate;
@class UUExponentView;
@interface UUStockListViewController : BaseViewController
{
    UIActivityIndicatorView *_indicator;
}
@property (nonatomic, copy) void(^loadDataCompeleted)(void);
+ (UUStockListViewController *)sharedUUStockListViewController;

- (void)loadData;

@end

@interface UUStockBlockSectionView : UICollectionReusableView

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,copy) NSString *title;


@property (nonatomic,weak) id<UUStockBlockSectionViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title index:(NSInteger)index;

@end

//SectionView
@protocol UUStockBlockSectionViewDelegate <NSObject>

@optional
- (void)sectionViewDidSeletedMore:(UUStockBlockSectionView *)sectionView;

@end

@interface UUStockBlockHeaderView : UIView
{
    UIButton *_newStockButton;      //新股日历
    UIButton *_dailyListedButton;   //今日上市
    UIScrollView *_scrollView;
    NSMutableArray *_exponentViewArray;
}

@property (nonatomic,copy) NSArray *indexDataArray;

@property (nonatomic,weak) id<UUStockBlockHeaderViewDelegate> delegate;

@end

@protocol UUStockBlockHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(UUStockBlockHeaderView *)headerView didSelectedView:(UUExponentView *)view;

@end

