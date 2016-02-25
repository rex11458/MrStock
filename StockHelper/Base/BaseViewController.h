//
//  BaseViewController.h
//  StockHelper
//
//  Created by LiuRex on 15/5/11.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface BaseViewController : UIViewController<BaseViewDelegate>

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,strong) UIView *noDataView;

//@property (nonatomic,strong) UIView *noDataView;


@property (nonatomic,strong) BaseView *baseView;

- (void)backAction;

//加载。。。
- (void)showLoading;
- (void)stopLoading;

- (BOOL)isLoading;
//显示空数据
- (void)showNodataWithTitle:(NSString *)title inView:(UIView *)view ;
- (BOOL)isShowNoData;

@end
