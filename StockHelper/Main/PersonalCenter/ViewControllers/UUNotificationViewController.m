//
//  UUNotificationViewController.m
//  StockHelper
//
//  Created by LiuRex on 15/8/5.
//  Copyright (c) 2015年 LiuRex. All rights reserved.
//

#import "UUNotificationViewController.h"
#import "UUSystemMessageViewCell.h"
@interface UUNotificationViewController ()

@end

@implementation UUNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"系统通知";
    
    
    [self.view addSubview:[self m_emptyView]];
}


//自选为空
- (UIView *)m_emptyView
{
    UIView *emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
    emptyView.backgroundColor = k_BG_COLOR;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_none"]];
    imageView.center = CGPointMake(CGRectGetWidth(emptyView.frame) * 0.5, CGRectGetHeight(emptyView.frame) * 0.5 - kNavigationBarHeight - 20);
    imageView.userInteractionEnabled = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [emptyView addSubview:imageView];
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, CGRectGetWidth(emptyView.frame), 20)];
    label.text = @"暂无数据";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [emptyView addSubview:label];
    return emptyView;
}

@end
