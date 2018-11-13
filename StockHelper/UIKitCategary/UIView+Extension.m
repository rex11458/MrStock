//
//  UIView+Extension.m
//  SCFBAppstore
//
//  Created by LiuRex on 2018/10/28.
//  Copyright © 2018年 胡海文. All rights reserved.
//

#import "UIView+Extension.h"
@class SCFBLoadingView;
@implementation UIView (Extension)

+ (UIView *)superviewOfType:(Class)paramSuperviewClass forView:(UIView *)paramView
{
    if (paramView.superview != nil)
    {
        if ([paramView.superview isKindOfClass:paramSuperviewClass])
        {
            return paramView.superview;
        }
        else
        {
            return [self superviewOfType:paramSuperviewClass forView:paramView.superview];
        }
    }
    return nil;
}

@end

static const char LoadingViewKey = '\0';

@implementation UIView (Loading)


- (void)showLoading
{
    SCFBLoadingView *loadingView = self.loadingView;
    if (loadingView == nil) {
        loadingView = [[SCFBLoadingView alloc] initWithFrame:self.bounds];
    }
    //    loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:loadingView];
    [self bringSubviewToFront:loadingView];
    
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    
    [loadingView showLoading];
    objc_setAssociatedObject(self, &LoadingViewKey,
                             loadingView, OBJC_ASSOCIATION_RETAIN);
}


- (void)showLoading:(UIEdgeInsets)insets
{
    [self showLoading];
    SCFBLoadingView *loadingView = self.loadingView;
    
    [loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(insets);
        make.width.equalTo(self).mas_equalTo(-(insets.left + insets.right));
        make.height.equalTo(self).mas_equalTo(-(insets.top + insets.bottom));
    }];
}


- (void)endLoading
{
    SCFBLoadingView *loadingView = self.loadingView;
    [loadingView dismiss];
}

- (BOOL)isLoading
{
    SCFBLoadingView *loadingView = self.loadingView;
    
    return loadingView.isLoading;
}

- (SCFBLoadingView *)loadingView
{
    return objc_getAssociatedObject(self, &LoadingViewKey);
}

@end


@interface SCFBLoadingView ()
//@property (nonatomic) UIImageView *logoImageView; //Logo
@property (nonatomic) UIActivityIndicatorView *activityView; //

@end

@implementation SCFBLoadingView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_activityView];
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
}

- (void)showLoading
{
    _loading = YES;
    [self configSubViews];
    self.alpha = 1;
    [_activityView startAnimating];
}

- (void)dismiss
{
    _loading = NO;
    
    [UIView animateWithDuration:1.0f animations:^{
        
        self.alpha = 0;
        
    }completion:^(BOOL finished) {
        [_activityView stopAnimating];
        [self removeFromSuperview];
    }];
}

@end
