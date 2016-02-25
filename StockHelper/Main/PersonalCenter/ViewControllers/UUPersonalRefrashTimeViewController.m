//
//  UUPersonalFrashTimeViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/4.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUPersonalRefrashTimeViewController.h"
#import "UUPersonalRefreshTimeView.h"
@interface UUPersonalRefrashTimeViewController ()
{
    UUPersonalRefreshTimeView *_refreshTimeView;
}
@end

@implementation UUPersonalRefrashTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"行情刷新设置";
    _refreshTimeView = [[UUPersonalRefreshTimeView alloc] initWithFrame:self.view.bounds];
    _refreshTimeView.seconds = [[[NSUserDefaults standardUserDefaults] objectForKey:UUMarketQuotationTimeInfoKey] integerValue];
    self.baseView = _refreshTimeView;
}


- (void)backAction
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:UUMarketQuotationTimeInfoKey] integerValue] != _refreshTimeView.seconds) {
        [defaults setValue:@(_refreshTimeView.seconds) forKey:UUMarketQuotationTimeInfoKey];
        [defaults synchronize];
    }
    [super backAction];
}

@end
