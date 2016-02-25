//
//  UUToolBar.h
//  StockHelper
//
//  Created by LiuRex on 15/6/16.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UUToolBarHeight 40.0f
@class UUTabbarItem;

@protocol  UUToolBarDelegate;
@interface UUToolBar : UIView
{
    @private
    NSMutableArray *_buttonArray;
}

@property (nonatomic,weak) id<UUToolBarDelegate> delegate;

@property (nonatomic,copy) NSArray *items;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items delegate:(id<UUToolBarDelegate>)delegate;

- (void)setSelected:(BOOL)selected Index:(NSInteger)index;

- (void)setTitle:(NSString *)title index:(NSInteger)index;

@end

@protocol  UUToolBarDelegate <NSObject>

@optional
- (void)toolBar:(UUToolBar *)toolBar didSeletedIndex:(NSInteger)index;

@end
