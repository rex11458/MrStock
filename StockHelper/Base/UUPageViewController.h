//
//  UUPageViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#define UUPageHeaderViewHeight 46.0f

@protocol UUPageHeaderViewDelegate;

@interface UUPageHeaderView : UIView

@property (nonatomic,weak) id<UUPageHeaderViewDelegate> delegate;

@property (nonatomic, copy) NSArray *buttonArray;   // 按钮列表

@property (nonatomic) UIImageView *lineImageView;    //线

@property (nonatomic, copy) NSArray *titles;


- (void)scrollWithButtonIndex:(NSInteger)index;

@end

@protocol UUPageHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(UUPageHeaderView *)headerView didSeletedIndex:(NSInteger)index;





@end@interface UUPageViewController : BaseViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UUPageHeaderViewDelegate>
{
    UIPageViewController *_pageViewController;
    UUPageHeaderView *_headerView;
}

@property (nonatomic,copy) NSArray *viewControllers;

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic) NSInteger currentIndex;

- (id)initWithTitles:(NSArray *)titles viewControllers:(NSArray *)viewControllers;



@end


