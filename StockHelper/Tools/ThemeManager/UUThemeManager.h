//
//  UUThemeManager.h
//  StockHelper
//
//  Created by LiuRex on 15/6/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UUThemeStyle <NSObject>

/**
 *  状态栏
 *
 */
- (UIStatusBarStyle)statusBarStyle;

/**
 *  navBar背景图片
 *
 */
- (UIImage *)navBarBackground;

/**
 *  navBar Title字体样式
 *
 */
- (NSDictionary*)navBarTitleStyle;


/**
 *  navBar Tint
 *
 */
- (UIColor *)tintColor;



/**
 *  navBar Tint
 *
 */
- (NSDictionary*)tabBarTitleStyle;

- (NSDictionary*)tabBarSelectTitleStyle;



@end

@interface UUThemeManager : NSObject

+ (id<UUThemeStyle>)sharedThemeStyle;

+ (void)customAppAppearance;

@end




@interface UUTheme : NSObject   <UUThemeStyle>

@end