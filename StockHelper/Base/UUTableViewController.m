//
//  UUTableViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/5/12.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUTableViewController.h"

@implementation UUTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(SCREEN_IOS_VS >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //
    if (self.navigationController.viewControllers.count > 1)
    {
        UIImage *image = [UIImage imageNamed:@"Nav_back"];
        UIButton *leftBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width * 4, image.size.height)];
        [leftBackButton setImage:image forState:UIControlStateNormal];
        [leftBackButton setTitle:@"返回" forState:UIControlStateNormal];
        leftBackButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        leftBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -18, 0,0);
        leftBackButton.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        [leftBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [leftBackButton setImage:[UIImage imageNamed:@"nav_left_back_h"] forState:UIControlStateHighlighted];
        [leftBackButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackButton];
    }
}

#pragma mark - backAction
- (void)backAction
{
    //    [[LHBNetClinent sharedClient] cancelTasks:1];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
