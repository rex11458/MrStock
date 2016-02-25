//
//  UUIntroductionView.m
//  StockHelper
//
//  Created by LiuRex on 15/9/29.
//  Copyright © 2015年 LiuRex. All rights reserved.
//

#import "UUIntroductionView.h"


@implementation CALayer (Additions)
- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
@end

NSString * const UUIntroductionInfoKey = @"UUIntroductionInfoKey";


@implementation UUIntroductionView


- (instancetype)initWithDelegate:(id<UUIntroductionViewDelegate>)delegate
{
    if (self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds]) {
//        self.backgroundColor = [UIColor blackColor];
        self.delegate = delegate;
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = k_NAVIGATION_BAR_COLOR;
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    _scrollView.delegate = self;
    
    
    [_loginButton setBackgroundImage:[UIKitHelper imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateHighlighted];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];


    [_registerButton setBackgroundImage:[UIKitHelper imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateHighlighted];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    
    [_experienceButton setBackgroundImage:[UIKitHelper imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [_experienceButton setBackgroundImage:[UIKitHelper imageWithColor:k_NAVIGATION_BAR_COLOR] forState:UIControlStateNormal];
    [_experienceButton setTitleColor:k_NAVIGATION_BAR_COLOR forState:UIControlStateHighlighted];

}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];

    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    NSString *newBuildVersion = info[@"CFBundleVersion"];

    [self setLocalVersion:newBuildVersion];
}

- (void)setLocalVersion:(NSString *)version
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:version forKey:UUIntroductionInfoKey];
    [userDefaults synchronize];
}

+ (BOOL)equalVersion
{
    NSString *newVer = [self latestVersion];
    NSString *oldVer = [[NSUserDefaults standardUserDefaults] objectForKey:UUIntroductionInfoKey];
    
    return [newVer isEqualToString:oldVer];
}

+ (NSString *)latestVersion
{
    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    //    info[@"CFBundleShortVersionString"]; //Version
    NSString *newBuildVersion = info[@"CFBundleVersion"]; // Build
    
    return newBuildVersion;
}



- (IBAction)buttonAction:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(introductionView:didSelectedIndex:)]) {
        [self.delegate introductionView:self didSelectedIndex:sender.tag];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(-PHONE_WIDTH, 0);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)pageControlAction:(UIPageControl *)sender {
    
    [_scrollView setContentOffset:CGPointMake(PHONE_WIDTH * sender.currentPage, 0) animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage =  scrollView.contentOffset.x / PHONE_WIDTH;
}

@end
