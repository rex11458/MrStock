//
//  UUFavourisManagerViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/6/22.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"

@protocol UUFavourisManagerHeaderViewDelegate;

@interface UUFavourisManagerHeaderView : UIView

@property (nonatomic,weak) id<UUFavourisManagerHeaderViewDelegate> delegate;

@property (nonatomic, copy) NSArray *buttonArray;   // 按钮列表

@property (nonatomic) UIImageView *lineImageView;    //线

@property (nonatomic, copy) NSArray *titles;


- (void)scrollWithButtonIndex:(NSInteger)index;

@end


@interface UUFavourisManagerViewController : BaseViewController


@property (nonatomic,copy) NSArray *viewControllers;

@property (nonatomic,assign,getter=isEditing) BOOL editing;

- (id)initWithViewControllers:(NSArray *)viewControllers;

@end


@protocol UUFavourisManagerHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(UUFavourisManagerHeaderView *)headerView didSeletedIndex:(NSInteger)index;

@end