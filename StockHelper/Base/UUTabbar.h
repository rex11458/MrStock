//
//  UUTabbar.h
//  StockHelper
//
//  Created by LiuRex on 15/6/8.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UUTabbarDelegate ;

@interface UUButton : UIButton


@end


@interface UUTabbarItem : NSObject

@property (nonatomic,copy)   NSString *title;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImage *selectedImage;

@property (nonatomic,strong) UIColor *backgroundColor;



@property (nonatomic,assign,getter=isSelected) BOOL selected;

@property (nonatomic,assign) NSInteger tag;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage backgroundColor:(UIColor *)backgroundColor tag:(NSInteger)tag;

@end

@interface UUTabbar : UIView

@property (nonatomic,copy) NSArray *items;


@property (nonatomic,weak) id<UUTabbarDelegate> delegate;

@property (nonatomic,assign) NSInteger selectedIndex;
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;


@end

@protocol UUTabbarDelegate <NSObject>

@optional
- (void)tabbar:(UUTabbar *)tabbar didSelectedItem:(UUTabbarItem *)tabbarItem;

@end
