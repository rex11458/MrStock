//
//  UIView+Extension.h
//  SCFBAppstore
//
//  Created by LiuRex on 2018/10/28.
//  Copyright © 2018年 胡海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

// 得到一个期望的View
+ (UIView *)superviewOfType:(Class)paramSuperviewClass forView:(UIView *)paramView;

@end


@interface UIView (Loading)

- (void)showLoading;

- (void)showLoading:(UIEdgeInsets)insets;

- (void)endLoading;
- (BOOL)isLoading;

@end



@interface SCFBLoadingView : UIView

- (void)showLoading;

- (void)dismiss;

@property (nonatomic,assign,getter=isLoading) BOOL loading;

@end
