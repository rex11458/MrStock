//
//  UUOptionView.h
//  StockHelper
//
//  Created by LiuRex on 15/6/18.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UUOptionViewHeight 30.0f
@protocol UUOptionViewDelegate ;

@interface UUOptionView : UIView

@property (nonatomic,weak) id<UUOptionViewDelegate> delegate;

@property (nonatomic,copy) NSArray *buttonArray;

@property (nonatomic,copy) NSArray *titles;

@property (nonatomic,assign) NSInteger selectedIndex;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles delegate:(id<UUOptionViewDelegate>)delegate;

- (instancetype)initWithTitles:(NSArray *)titles delegate:(id<UUOptionViewDelegate>)delegate;

@end

@protocol UUOptionViewDelegate <NSObject>

@optional
- (void)optionView:(UUOptionView *)optionView didSeletedIndex:(NSInteger)index;

@end