//
//  UUGeniusRankManagerViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/7/16.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUGeniusRankManagerViewController.h"
#import "UUFavourisManagerViewController.h"
#import "UUGeniusRankViewController.h"
@interface UUGeniusRankManagerViewController ()

@end

@implementation UUGeniusRankManagerViewController

- (id)init
{
    NSArray *titles = @[@"稳健王",@"收益王",@"人气王"];
    NSMutableArray *tempViewControllers = [NSMutableArray array];
    for (NSInteger i = 0;i < titles.count; i++) {
        UUGeniusRankViewController *vc = [[UUGeniusRankViewController alloc] initWithTitle:titles[i] type:i];
        [tempViewControllers addObject:vc];
    }
    if (self = [super initWithTitles:titles viewControllers:tempViewControllers]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"牛人榜";
}
@end