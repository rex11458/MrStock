//
//  BaseViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationController+YRBackGesture.h"
#import "BaseView.h"
#import <UMengAnalytics-NO-IDFA/MobClick.h>
@interface BaseViewController ()<UIGestureRecognizerDelegate>
{
    BOOL _showNoData;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    self.navigationItem.backBarButtonItem = item;
//    if (self.navigationController.viewControllers.count > 1)
//    {
////        self.navigationController.enableBackGesture = YES;
//        UIImage *image = [UIImage imageNamed:@"Nav_back"];
//        UIButton *leftBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width * 4, image.size.height)];
//        [leftBackButton setImage:image forState:UIControlStateNormal];
//        [leftBackButton setTitle:@"返回" forState:UIControlStateNormal];
//        leftBackButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
//        leftBackButton.imageEdgeInsets = UIEdgeInsetsMake(10, -18, 0,0);
//        leftBackButton.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
//        [leftBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////        [leftBackButton setImage:[UIImage imageNamed:@"nav_left_back_h"] forState:UIControlStateHighlighted];
//        [leftBackButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackButton];
//    }
//    else
//    {
//        self.navigationController.enableBackGesture = NO;
//    }

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)setBaseView:(BaseView *)baseView
{
    if (_baseView == baseView || baseView == nil) return;
    _baseView = baseView;
    _baseView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _baseView.delegate = self;
    [self.view addSubview:_baseView];
}

//友盟统计
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)showLoading
{
    _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _loadingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_loadingView];

    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    indicatorView.center = CGPointMake(PHONE_WIDTH  * 0.5,PHONE_HEIGHT * 0.5 - 64);
    [indicatorView startAnimating];
    [_loadingView addSubview:indicatorView];

    UILabel *titleLabel = [UIKitHelper labelWithFrame:CGRectMake(0, CGRectGetMaxY(indicatorView.frame)+k_TOP_MARGIN, PHONE_WIDTH, 20.0f) Font:k_MIDDLE_TEXT_FONT textColor:k_MIDDLE_TEXT_COLOR];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text  = k_remainder(@"loading_ reminder");
    [_loadingView addSubview:titleLabel];
}

- (void)stopLoading
{
    [UIView animateWithDuration:1.0f animations:^{
        _loadingView.alpha = 0;
    }completion:^(BOOL finished) {
        [_loadingView removeFromSuperview];
    }];
}

- (BOOL)isLoading
{
    return _loadingView != nil;
}


- (void)showNodataWithTitle:(NSString *)title inView:(UIView *)view
{
    UILabel *noDataView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    noDataView.text = title;
    noDataView.backgroundColor = [UIColor whiteColor];
    noDataView.textAlignment = NSTextAlignmentCenter;
    noDataView.textColor = k_MIDDLE_TEXT_COLOR;
    noDataView.font = k_MIDDLE_TEXT_FONT;
    
    if (view.subviews.count == 0) {
        [view addSubview:noDataView];
    }else{
        [view insertSubview:noDataView atIndex:(view.subviews.count - 1)];
    }
     _showNoData = YES;
}

- (BOOL)isShowNoData
{
    return _showNoData;
}

#pragma mark - backAction
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)dealloc
{

}




@end
