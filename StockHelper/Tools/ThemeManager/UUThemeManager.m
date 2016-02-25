//
//  UUThemeManager.m
//  StockHelper
//
//  Created by LiuRex on 15/6/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUThemeManager.h"

@implementation UUThemeManager

+ (id<UUThemeStyle>)sharedThemeStyle
{
    static id<UUThemeStyle> sharedTheMe = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTheMe = [[UUTheme alloc] init];
    });
    return sharedTheMe;
}
+ (void)customAppAppearance
{
    id<UUThemeStyle> theme = [UUThemeManager sharedThemeStyle];
    
    [[UIApplication sharedApplication] setStatusBarStyle:[theme statusBarStyle]];
    
    //UINavigationBar
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setTitleTextAttributes:[theme navBarTitleStyle]];
    [navigationBarAppearance setBackgroundImage:[theme navBarBackground] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTintColor:[theme tintColor]];
    
    
//    UITabBarItem *bb = [UITabBarItem appearance];
//    [bb setTitleTextAttributes:[theme tabBarTitleStyle] forState:UIControlStateNormal];
//    [bb setTitleTextAttributes:[theme tabBarSelectTitleStyle] forState:UIControlStateSelected];
}


@end


@implementation UUTheme


- (UIStatusBarStyle)statusBarStyle
{
//    if (SCREEN_IOS_VS < 7.0)
//    {
//        return UIStatusBarStyleBlackOpaque;
//    }
//    else
//    {
        return UIStatusBarStyleLightContent;
//    }
}

- (UIImage *)navBarBackground
{
    return [UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR];
    //return [UUPubLogicHelper createImageWithColor:MAIN_COLOR];
}

- (NSDictionary*)navBarTitleStyle
{
    NSShadow *shadow = [[NSShadow alloc] init];
    //shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    //shadow.shadowOffset = CGSizeMake(2, 3);
    
    UIColor *color = [UIColor colorWithWhite:1.0 alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,
                          shadow, NSShadowAttributeName,
                          font, NSFontAttributeName, nil];
    return dict;
}

- (UIColor *)tintColor
{
    return [UIColor colorWithWhite:1.0 alpha:1.0];
}


- (NSDictionary*)tabBarTitleStyle
{
//    NSShadow *shadow = [[NSShadow alloc] init];
//    
//    UIColor *color = [UIColorTools colorFromHexRGB:@"5D5D5D"];
//    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,
//                          shadow, NSShadowAttributeName,
//                          font, NSFontAttributeName, nil];
    return nil;
}

- (NSDictionary*)tabBarSelectTitleStyle
{
//    NSShadow *shadow = [[NSShadow alloc] init];
//    
//    UIColor *color = MAIN_COLOR;
//    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:color,UITextAttributeTextColor,
//                          shadow, NSShadowAttributeName,
//                          font, NSFontAttributeName, nil];
    return nil;
}


@end