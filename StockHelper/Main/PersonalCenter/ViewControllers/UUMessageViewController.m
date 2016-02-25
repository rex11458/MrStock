//
//  UUMessageViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUMessageViewController.h"
#import "UUAttentionViewController.h"
#import "UURemindViewController.h"
#import "UUNotificationViewController.h"
@interface UUMessageViewController ()

@end

@implementation UUMessageViewController

- (id)init
{
    NSArray *titles = @[@"关注",@"系统通知"];
    NSArray *viewControllers = @[
                                 [[UUAttentionViewController alloc] init],
//                                 [[UURemindViewController alloc] init],
                                 [[UUNotificationViewController alloc] init]
                                 ];
    if (self = [super initWithTitles:titles viewControllers:viewControllers]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息中心";
    self.view.backgroundColor = k_BG_COLOR;
}

@end
