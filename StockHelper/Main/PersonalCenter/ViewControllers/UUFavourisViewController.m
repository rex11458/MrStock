//
//  UUFavourisManagerViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUFavourisViewController.h"
#import "UUFavourisManagerViewController.h"
#import "UUFavTopicViewController.h"
#import "UUFavNewsViewController.h"
#import "UUCommunityHandler.h"
@interface UUFavourisViewController ()
@end

@implementation UUFavourisViewController

- (id)init
{
    NSArray *titles = @[@"帖子",@"资讯公告"];
    NSArray *viewControllers = @[[[UUFavTopicViewController alloc] init],[[UUFavNewsViewController alloc] init]];
    
    if (self = [super initWithTitles:titles viewControllers:viewControllers]) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    [[UUCommunityHandler sharedCommunityHandler] getColletionListWithType:1 start:0 count:10 success:^(id obj) {
        
    } failure:^(NSString *errorMessage) {
        
    }];
}


@end
